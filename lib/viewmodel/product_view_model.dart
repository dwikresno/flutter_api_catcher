import 'package:flutter/material.dart';
import 'package:flutter_api_catcher/const/const_api_path.dart';
import 'package:flutter_api_catcher/model/product/product_model.dart';
import 'package:flutter_api_catcher/service/service_dio.dart';

class ProductViewModel with ChangeNotifier {
  Future<ProductModel> getDataProduct({required BuildContext context}) async {
    var response = await configDio(
      endPoint: urlEndpoint,
      path: pathProduct,
      context: context,
    );

    return ProductModel.fromJson(response!.data);
  }
}
