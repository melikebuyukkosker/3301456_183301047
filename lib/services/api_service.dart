import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService{
  static Future getWeatherDataByCity(String city) async{
    return await http.get(Uri.parse("https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=$city"), headers: {
      HttpHeaders.authorizationHeader: 'apikey 0vHQTvkloVzoa3gXRHBQao:1k8JRIvQ0BBz6pVoh5NFUY',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
  }
}