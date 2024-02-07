import 'dart:convert';
import 'dart:io';
import 'package:c0nnect/helper/api_urls.dart';
import 'package:c0nnect/helper/shared_prefs.dart';
import 'package:c0nnect/model/category_model.dart';
import 'package:c0nnect/model/events_model.dart';
import 'package:c0nnect/model/login_model.dart';
import 'package:dio/dio.dart';


class LoginRepo {



  Future<CategoryModel> getCategoryData(params) async {
    var dio = Dio();
    Response response = await dio.get(
      ApiUrls.categories,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
      queryParameters: params
    );
    CategoryModel categoryModel = CategoryModel.fromJson(
        jsonDecode(response.toString()));
    print('API RESPONSE CATEGORY : ${response.toString()}');
    return categoryModel;
  }


  Future<LoginModel> postUserLogin(params) async {
    FormData formData = FormData.fromMap(params);

    var dio = Dio();
    Response response = await dio.post(
        ApiUrls.login,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: formData
    );
    LoginModel loginModel = LoginModel.fromJson(jsonDecode(response.toString()));
    print('API RESPONSE LOGIN : ${response.toString()}');
    return loginModel;
  }

  Future<LoginModel> loginCheck(params) async {

    var dio = Dio();
    Response response = await dio.post(
        ApiUrls.loginCheck,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
        }),
        data: params
    );
    LoginModel loginModel = LoginModel.fromJson(jsonDecode(response.toString()));
    print('API RESPONSE LOGIN CHECK : ${response.toString()}');
    return loginModel;
  }





}
