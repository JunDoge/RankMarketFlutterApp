import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shop_app/models/product/Popular.dart';
import 'package:shop_app/models/product/ProductDetail.dart';
import 'package:shop_app/models/product/Products.dart';

import '../../models/product/Mosts.dart';
import '../../models/product/RankingChecks.dart';

part 'ProductRepository.g.dart';

@RestApi(baseUrl: 'http://1.251.115.6:8089')
abstract class ProductRepository {

  factory ProductRepository(Dio dio, {String? baseUrl}) = _ProductRepository;



  @GET('/products/{endPoint}')
  Future<Products> getProduct(@Path("endPoint") int endPoint,@Header("Authorization")  String? token, @Query("prdNm") String? prdNm);


  @GET('/main/popular')
  Future<Populars> getPopular();

  @GET('/product/detail/{prdId}')
  Future<ProductDetails> getProductDetail(@Path('prdId') int prdId);

  @GET('/main/recently')
  Future<Mosts> getMosts();

  @POST("/product/bidding")
  Future<void> bidSave(@Query("prd_id") int prd_id, @Query("ieastPrice") int ieast_price,
      @Query("high_price") int high_price, @Header("Authorization") String token);




  @POST("/rankingCheck")
  @MultiPart()
  Future<RankingChecks> rankingCheck(@Header("Authorization") String token,  @Body() FormData formData);

  @POST("/product/add")
  @MultiPart()
  Future<void> upload(@Header("Authorization") String token,@Body() FormData formData);
  
  @POST("/mypage/bidend")
  Future<void> bidEnd(@Header("Authorization") String token,@Query("prd_id") int prd_id);

  @DELETE("/prdmgmt/del")
  Future<void> prdDel(@Header("Authorization") String token,@Query("prd_id") int prd_id);

  @PUT("/product/update")
  Future<void> prdUpdate(@Header("Authorization") String token,@Body() FormData formData);

}