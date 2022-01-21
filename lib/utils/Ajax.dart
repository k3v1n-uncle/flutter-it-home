// import 'dart:io';
//
// import 'package:dio/adapter.dart';
// import 'package:dio/dio.dart';
// import 'package:it_home_flutter/utils/api.dart';
//
// class HttpUtil {
//   static HttpUtil instance = getInstance();
//   Dio dio = Dio();
//
//   BaseOptions options = BaseOptions();
//
//   static HttpUtil getInstance() {
//     print('getInstance');
//     if (instance == null) {
//       instance = new HttpUtil();
//     }
//     return instance;
//   }
//
//   HttpUtil() {
//     (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//         (client) {
//       client.badCertificateCallback = (cert, host, port) {
//         return true;
//       };
//     };
//     print('dio赋值');
//     // 或者通过传递一个 `options`来创建dio实例
//     options = BaseOptions(
//       // 请求基地址,可以包含子路径，如: "https://www.google.com/api/".
//       baseUrl: Api.baseUrl,
//       //连接服务器超时时间，单位是毫秒.
//       connectTimeout: 10000,
//
//       ///  响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，
//       ///  [Dio] 将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常.
//       ///  注意: 这并不是接收数据的总时限.
//       receiveTimeout: 3000,
//       headers: {
//         // "token": token,
//         "Cookie":
//             "navColor=; nightMode=1; Hm_lvt_f2d5cbe611513efcf95b7f62b934c619=1640321474,1640581042,1641353010,1642393414; Hm_lvt_cfebe79b2c367c4b89b285f412bf9867=1642492699,1642638620,1642647129,1642653069; Hm_lpvt_cfebe79b2c367c4b89b285f412bf9867=1642653132; Hm_lpvt_f2d5cbe611513efcf95b7f62b934c619=1642653133",
//         "user-agent":
//             'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36',
//       },
//       contentType: Headers.formUrlEncodedContentType,
//     );
//     dio = new Dio(options);
//   }
//
//   get(url, {data, options, cancelToken}) async {
//     print('get请求启动! url：$url ,body: $data');
//     Response? response;
//     try {
//       response = await dio.get(
//         url,
//         queryParameters: data,
//         cancelToken: cancelToken,
//       );
//       print('get请求成功!response.data：${response.data}');
//     } on DioError catch (e) {
//       if (CancelToken.isCancel(e)) {
//         print('get请求取消! ' + e.message);
//       }
//       print('get请求发生错误：$e');
//     }
//     return response!.data;
//   }
//
//   post(url, {data, options, cancelToken}) async {
//     print('post请求启动! url：$url ,body: $data');
//     Response? response;
//     try {
//       response = await dio.post(
//         url,
//         data: data,
//         cancelToken: cancelToken,
//       );
//       print('post请求成功!response.data：${response.data}');
//     } on DioError catch (e) {
//       if (CancelToken.isCancel(e)) {
//         print('post请求取消! ' + e.message);
//       }
//       print('post请求发生错误：$e');
//     }
//     return response!.data;
//   }
// }

//Ajax工具
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

//import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:it_home_flutter/utils/api.dart';

enum HTTP_METHOD { GET, POST }

class Ajax {
  //仅用在无需判断权限的AJAX请求上
  static Future doAjax(
      {required uri,
      required BuildContext context,
      HTTP_METHOD method = HTTP_METHOD.GET,
      required Function callBack,
      paramMap = const {},
      json = false,
      headers = const {}}) async {
    Dio _dio = Dio();
    DefaultHttpClientAdapter httpClient =
        _dio.httpClientAdapter as DefaultHttpClientAdapter;
    httpClient.onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };

    ///Connectivity
//    var connectivityResult = await (Connectivity().checkConnectivity());
//    if (connectivityResult == ConnectivityResult.mobile) {
//      print('当前使用流量');
//    } else if (connectivityResult == ConnectivityResult.wifi) {
//      print('当前使用wifi');
//    } else if (connectivityResult == ConnectivityResult.none) {
//      showFlutterToast('当前无网络连接，请稍后再试', 2);
//      return;
//    }

    var transParamMap = {};
    var data;

    paramMap.forEach((key, value) {
      if (value == 'null' || value == null) {
        value = '';
      }
      transParamMap.putIfAbsent(key.toString(), () => value);
    });

    Random random = Random();
    var randInt = random.nextInt(999999);
    paramMap = transParamMap;

    _dio.options.baseUrl = Api.baseUrl;
    _dio.options.connectTimeout = 35000; //5s
    _dio.options.receiveTimeout = 30000;

    Response response;
    try {
      if (method == HTTP_METHOD.GET) {
        var baselocalUrl = Api.baseUrl + uri + '?randInt=$randInt';
        transParamMap.forEach((key, value) {
          baselocalUrl += '&' + key + '=' + value.toString();
        });
        print(baselocalUrl);
        print('1414123');

        response = await _dio.get(
          baselocalUrl,
          queryParameters: {},
          // options: Options(),
        );

        data = response.data.runtimeType == String
            ? jsonDecode(response.data)
            : response.data;
        print('asdfa');
        print(data);
      } else {
        var baselocalUrl = Api.baseUrl + uri;
        response = await _dio.post(
          uri,
          data: transParamMap,
          options: Options(
            headers: {
              // "token": token,
              // "user-agent": 'Dart/2.7 ($systemType OS $deviceModel)',
            },
            contentType: json
                ? "application/json;charset=UTF-8"
                : "application/x-www-form-urlencoded",
          ),
        );
        data = response.data.runtimeType == String
            ? jsonDecode(response.data)
            : response.data;
        print(baselocalUrl);
        print(response.data);
      }

      callBack(response, data);
    } on DioError catch (e) {
      return e;
    }
  }
}

pageTo(context, widget) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) {
      return widget;
    },
  ));
}

pageBack(context) {
  Navigator.of(context).pop();
}
