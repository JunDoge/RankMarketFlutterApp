import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:shop_app/repository/user/UserRepository.dart';

import '../../models/user/ChatUsrAddrs.dart';

// MapScreen 클래스는 StatefulWidget을 상속받아, 상태를 가진 위젯을 생성합니다.
class MapScreen extends StatefulWidget {
  final ChatUsrAddrs chatUsrAddrs;
  final String usr_id;
  final chatMapUrl;
  final Function(LatLng) onLocationSelected;

  MapScreen({Key? key,
    required this.chatUsrAddrs,
    required this.onLocationSelected,
    required this.usr_id,
    required this.chatMapUrl})
      : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin<MapScreen> {
  @override
  bool get wantKeepAlive => true;
  LatLng? latLng1;
  LatLng? latLng2;
  LatLng? midPoint;
  late KakaoMapController mapController;
  Set<Marker> markers = {};
  Map<String, String> markerInfo = {};

  @override
  void initState() {
    super.initState();
    // initState 내부에서 비동기 작업을 수행하기 위해 Future.delayed를 사용합니다.
    initializeMap();
  }

  Future<void> initializeMap() async {
    try {
      latLng1 =
      await convertAddressToLatLng(widget.chatUsrAddrs.response[0].buyer);
      latLng2 =
      await convertAddressToLatLng(widget.chatUsrAddrs.response[0].seller);
      setState(() {
        // 두 좌표의 중간점을 계산하여 midPoint를 설정합니다.
        midPoint = getMidPoint(latLng1!, latLng2!);
      });
    } catch (e) {
      print("주소 변환 오류: $e");
    }
  }

  // 두 좌표 사이의 중간 지점을 반환하는 함수입니다.
  LatLng getMidPoint(LatLng latLng1, LatLng latLng2) {
    return LatLng(
      (latLng1.latitude + latLng2.latitude) / 2,
      (latLng1.longitude + latLng2.longitude) / 2,
    );
  }

  // 주소를 위도와 경도로 변환하는 함수입니다. Kakao API를 사용합니다.
  Future<LatLng> convertAddressToLatLng(String address) async {
    final String kakaoApiKey = "b2a3b873d0d58055ba5b7ef3e327aae0";
    final headers = {'Authorization': 'KakaoAK $kakaoApiKey'};
    final queryParameters = {
      'query': address,
    };
    final uri = Uri.https(
        'dapi.kakao.com', '/v2/local/search/address.json', queryParameters);

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['documents'].isEmpty) {
        throw Exception("주소를 변환할 수 없습니다.");
      }
      final document = jsonResponse['documents'][0];
      final latitude = double.parse(document['address']['y']);
      final longitude = double.parse(document['address']['x']);
      return LatLng(latitude, longitude);
    } else {
      throw Exception("주소 변환 실패: ${response.body}");
    }
  }

  // 특정 카테고리의 장소를 검색하여 지도에 표시하는 함수입니다.
  Future<void> searchPlacesByCategory(String categoryCode,
      LatLng center) async {
    String kakaoApiKey = "b2a3b873d0d58055ba5b7ef3e327aae0";
    var headers = {
      'Authorization': 'KakaoAK $kakaoApiKey',
    };
    var response = await http.get(
      Uri.parse(
          'https://dapi.kakao.com/v2/local/search/category.json?category_group_code=$categoryCode&x=${center
              .longitude}&y=${center.latitude}&radius=5000'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List places = jsonResponse['documents'];

      setState(() {
        markers.clear();
        markerInfo.clear();
        for (var place in places) {
          final markerId = UniqueKey().toString();
          markers.add(
            Marker(
              markerId: markerId,
              latLng:
              LatLng(double.parse(place['y']), double.parse(place['x'])),
              width: 30,
              height: 44,
              offsetX: 15,
              offsetY: 44,
              onTap: () =>
                  _showPlaceInfoDialogWithDateTimePicker(
                      place['place_name'], markerId),
              infoWindowContent:
              '<div style="padding:15px;">${place['place_name']}</div>',
              infoWindowFirstShow: true,
            ),
          );
          markerInfo[markerId] = place['place_name'];
        }
      });
    } else {
      print('장소를 불러오는데 실패했습니다');
    }
  }

  void _showPlaceInfoDialogWithDateTimePicker(String placeName,
      String markerId) {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();
    LatLng selectedPlace; // 선택된 장소의 좌표를 저장할 변수

    // 마커 정보에서 선택된 장소의 좌표를 찾습니다.
    final place = markers.firstWhere((marker) => marker.markerId == markerId);
    selectedPlace = place.latLng;

    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop();
              return false;
            },
            child: StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text("장소 정보 및 날짜/시간 설정"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text("장소: $placeName"),
                        ListTile(
                          title: Text(
                              "날짜 선택: ${DateFormat('yyyy년 MM월 dd일').format(
                                  selectedDate)}"),
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2025),
                            );
                            if (pickedDate != null &&
                                pickedDate != selectedDate) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                        ),
                        ListTile(
                          title: Text("시간 선택: ${selectedTime.format(context)}"),
                          onTap: () async {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                            );
                            if (pickedTime != null &&
                                pickedTime != selectedTime) {
                              setState(() {
                                selectedTime = pickedTime;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("닫기"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("카카오맵에서 열기"),
                      onPressed: () async {
                        // 카카오맵 URL 생성
                        UserRepository userRepository = UserRepository(Dio());
                        const storage = FlutterSecureStorage();
                        String? token = await storage.read(key: "token");
                        String usr_id = widget.usr_id;
                        print(
                            "buyer Id :  ${widget.chatUsrAddrs.response[0]
                                .buyer_id}");
                        if (widget.chatUsrAddrs.response[0].buyer_id != null) {
                          usr_id = widget.chatUsrAddrs.response[0].buyer_id!;
                        }
                        await userRepository.delDtmSave(
                            token!,
                            widget.chatUsrAddrs.response[0].prd_id,
                            selectedPlace.latitude.toString(),
                            selectedPlace.longitude.toString(),
                            DateFormat('yyMMdd HH:mm')
                                .format(selectedDate)
                                .toString(),
                            usr_id);
                        final String mapUrl =
                            "https://map.kakao.com/link/map/$placeName,${selectedPlace
                            .latitude},${selectedPlace.longitude}";

                        setState(() {
                          widget.chatMapUrl(mapUrl, DateFormat('yy-MM-dd HH:mm')
                              .format(selectedDate)
                              .toString()
                          );
                        });
                        Navigator.pop(context);

                      },
                    ),
                  ],
                );
              },
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: midPoint != null
          ? KakaoMap(
        onMapCreated: (controller) {
          mapController = controller;
          // 지도가 생성되면, 설정된 중간점을 기준으로 주변 장소를 검색합니다.
          print("중간 지점 좌표: $midPoint");
          searchPlacesByCategory("CE7", midPoint!);
        },
        markers: markers.toList(), // 지도에 표시할 마커를 설정합니다.
        center: midPoint, // 지도의 중심점을 설정합니다.
        onMarkerTap: (markerId, latLng, zoomLevel) {
          // 마커를 탭했을 때 호출되는 콜백 함수입니다.
          if (markerInfo.containsKey(markerId)) {
            _showPlaceInfoDialogWithDateTimePicker(
                markerInfo[markerId]!, markerId);
          }
        },
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
