import 'package:flutter/material.dart';

import '../../products/products_screen.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  // 검색 결과를 저장하기 위한 상태 변수를 선언합니다. 실제 애플리케이션에서는 이 부분을 검색 결과 리스트로 활용할 수 있습니다.
  String _searchResult = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            _searchResult = value;
          });
        },
        onFieldSubmitted: (value) {
          print("검색 완료: $_searchResult");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductsScreen(prdNm: _searchResult),
            ),
          );
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).secondaryHeaderColor.withOpacity(0.1),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          border: searchOutlineInputBorder,
          focusedBorder: searchOutlineInputBorder,
          enabledBorder: searchOutlineInputBorder,
          hintText: "Search product",
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}

const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);