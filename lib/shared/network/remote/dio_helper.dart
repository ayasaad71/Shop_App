import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio ;

  static init()
  {
    dio = Dio(
        BaseOptions(
          baseUrl: 'https://student.valuxapps.com/api/',
          receiveDataWhenStatusError: true,
          headers: {
            'Content-Type':'application/json'
          },
        )
    );
  }
  static Future<Response> getData ({
    required String url ,
    Map<String,dynamic>? query,
    String lang = 'en',
    String? token,
  }) async
  {
    dio.options.headers = {
      'lang' : lang,
      'Authorization' : token
    };

    return await dio.get(url , queryParameters: query,);
  }

  static Map<String, dynamic> getHeaders(lang, token) => {
    'lang': lang,
    'Authorization': token ?? '',
    'Content-Type': 'application/json',
  };

  static Future<Response> postData ({
    required String url ,
    required Map<String,dynamic> data,
    Map<String,dynamic>? query,
    String lang = 'ar',
    String? token,
    Map<String,dynamic>? headers,
})
    async{

    dio.options.headers = getHeaders(lang, token);
    // dio.options.headers = {
    //     'lang' : lang,
    //    // 'Authorization' : token        مينفعش يبقى فى توكين فى اللوجن
    //   };

      return await dio.post(
          url,
          data: data,
          queryParameters: query,

      );
}

}