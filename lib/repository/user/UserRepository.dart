import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shop_app/models/user/BidHistorys.dart';
import 'package:shop_app/models/user/UserToken.dart';

import '../../models/user/ChatMassages.dart';
import '../../models/user/ChatRooms.dart';
import '../../models/user/ChatUsrAddrs.dart';
import '../../models/user/PayHistorys.dart';
import '../../models/user/PrdMgmts.dart';
import '../../models/user/ReviewHistorys.dart';
import '../../models/user/RptHistorys.dart';
import '../../models/user/UsrInfos.dart';
import '../../models/user/WinHistorys.dart';
import '../../models/user/WishHistorys.dart';

part 'UserRepository.g.dart';

@RestApi(baseUrl: 'http://1.251.115.6:8089')
abstract class UserRepository {
  factory UserRepository(Dio dio, {String? baseUrl}) = _UserRepository;

  @POST('/oauth/mobile/login')
  Future<UserToken> getUser(@Field() String mail,@Field() String token);

  @GET('/mypage/bidhistory')
  Future<BidHistorys> getBidHistory(@Header("Authorization") String token);

  @GET('/mypage/wishList')
  Future<WishHistorys> getWishHistory(@Header("Authorization") String token);
  
  @GET('/mypage/prdmgmt')
  Future<PrdMgmts> getPrdMgmts(@Header("Authorization") String token);

  @GET('/mypage/winhistory')
  Future<WinHistorys> getWinHistorys(@Header("Authorization") String token);

  @GET('/mypage/payhistory')
  Future<PayHistorys> getPayHistorys(@Header("Authorization") String token, @Query("status") int status);

  @GET('/mypage/report')
  Future<RptHistorys> getRptHistorys(@Header("Authorization") String token);

  @GET('/mypage/chatroom')
  Future<ChatRooms> getChatRooms(@Header("Authorization") String token);

  @GET('/mypage/myReview')
  Future<ReviewHistorys> getMyReviewHistorys(@Header("Authorization") String token);

  @GET('/mypage/prdReview')
  Future<ReviewHistorys> getBuyerReviewHistorys(@Header("Authorization") String token);
  
  @GET('/chatroom/addmessage')
  Future<ChatMassages> getChatMessages(@Header("Authorization") String token, @Query("pageNum") int pageNum,@Query("chat_id") String chat_id);
  
  @POST('/mypage/usrInfo')
  Future<UsrInfos> getUsrInfo(@Header("Authorization") String token);
  
  @GET('/chatroom/addr')
  Future<ChatUsrAddrs> getChatUsrAddrs(@Header("Authorization") String token, @Query("chat_id") String chat_id);

  @POST('/reload/accessToken')
  Future<UserToken> getToken(@Header("Authorization") String token);
  // 여기 위에까지 usrViewController에 있는 url들임 + ResponseDto에 맞게 model들도 다 만들어 놨음 ㅇㅅㅇ v

  @POST("/validation/phone")
  Future<bool> validatePhone(@Header("Authorization") String token, @Query("ph_num") String phone_number);


  @POST("/validation/code")
  Future<bool> validatePhoneCode(@Header("Authorization") String token, @Query("ph_code") String ph_code, @Query("ph_num") String phone_number);

  @POST("/signup")
  Future<UserToken> signUp(@Query("mail") String mail, @Query("usr_nm") String usr_nm, @Query("bdate") String bdate, @Query("ph_num") String ph_num,
      @Query("pst_addr") String pst_addr, @Query("rd_addr") String rd_addr, @Query("det_addr") String? det_addr,@Header("Authorization") String token, @Query("device_token") String deviceToken);

  @POST("/mypage/report")
  Future<void> reportSave(@Query("rpt_id") String report_id,@Query("rpt_des") String des,@Query("prd_id")  int prd_id,@Header("Authorization") String token);

  @POST("/mypage/addReview")
  Future<void> reviewSave(@Query("rate_scr") int rate, @Query("revDes") String des, @Query("prd_id") int prd_id,@Header("Authorization") String token);

  @POST("/payment")
  Future<void> paySave(@Query("prd_id") List<int> prd_id, @Query("pay_prc") List<int> prd_price, @Query("title") String title, @Header("Authorization") String token);

  @POST("/mypage/usrUpdate")
  Future<void> usrUpdate(@Query("updateColumn") List<String> updateColumn, @Query("updateValue") List<String> updateValue, @Header("Authorization") String token);

  @DELETE("/oauth/usr/delete")
  Future<void> usrDelete(@Header("Authorization") String token);

  @GET("/changeToWishList")
  Future<void> changeWish(@Header("Authorization") String token, @Query("prdId") List<int> prdId);

  @POST("/add/delDtm")
  Future<void> delDtmSave(@Header("Authorization") String token, @Query("prd_id") int prd_id,
      @Query("lat") String lat, @Query("lng") String lng,@Query("dl_time") String dl_time, @Query("usr_id") String usr_id );
  
  @POST("/mypage/bidDel")
  Future<void> bidDel(@Header("Authorization") String token, @Query("prd_ids") List<int> prd_id);
  
  @POST("/mypage/reportDel")
  Future<void> rptCancle(@Header("Authorization") String token, @Query("rpt_id")List<int> rpt_id);
  @POST("/mypage/reviewDel")
  Future<void> reviewDelete(@Query("prd_id")List<int> prd_id,@Header("Authorization") String token);

}
