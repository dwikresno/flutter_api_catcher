import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_catcher/model/api_method_model.dart';
import 'package:flutter_api_catcher/viewmodel/global_view_model.dart';
import 'package:provider/provider.dart';

Future<Response?> configDio({
  @required endPoint,
  APImethod mode = APImethod.get,
  path,
  param,
  token,
  savePath,
  required BuildContext context,
  tokenType = "token",
}) async {
  Response? response;
  try {
    var options = BaseOptions(
      baseUrl: endPoint,
      headers: {
        HttpHeaders.contentTypeHeader: Headers.jsonContentType,
      },
      connectTimeout: 7000,
      receiveTimeout: 10000,
      followRedirects: false,
      validateStatus: (status) {
        print("trace status code ${status}");
        return true;
      },
    );
    var dio = Dio(options);
    // dio.interceptors.add(LogInterceptor(responseBody: true));
    dio.interceptors.add(Provider.of<GlobalViewModel>(context, listen: false)
        .alice
        .getDioInterceptor());
    if (mode == APImethod.get) {
      response = await dio.get(path, queryParameters: param);
    } else if (mode == APImethod.post) {
      response = await dio.post(path, data: param);
    } else if (mode == APImethod.put) {
      response = await dio.put(path, data: param);
    } else if (mode == APImethod.patch) {
      response = await dio.patch(path, data: param);
    } else if (mode == APImethod.delete) {
      response = await dio.delete(path, data: param);
    } else if (mode == APImethod.download) {
      response = await dio.download(endPoint, savePath);
    }

    if (response!.statusCode! >= 300) {
      print('configDio Dio error server!');
      response = null;
    }
  } on DioError catch (e) {
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
    if (e.response != null) {
      response = e.response;
      print('configDio Dio error!');
      print('configDio STATUS: ${e.response?.statusCode}');
      print('configDio DATA: ${e.response?.data}');
      print('configDio HEADERS: ${e.response?.headers}');
    } else {
      // Error due to setting up or sending the request
      print('configDio Error sending request!');
      print(e.message);
    }
  }
  return response;
}
