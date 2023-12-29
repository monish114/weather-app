import 'location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

const apiKey = '844db34d6f353304adf2cc8d0b2de928';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    var url = '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric';
    NetworkHelper networkHelper = NetworkHelper(url);
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getlocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        "$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric");

    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  String getWeatherCondition(var condition) {
    if (condition == 'Rain') {
      return 'RAINING';
    } else if (condition == 'Rain') {
      return 'RAINING';
    } else if (condition == 'Thunderstorm') {
      return 'THUNDERSTORM';
    } else if (condition == 'Snow') {
      return 'SNOWING️';
    } else if (condition == 'Haze') {
      return 'HAZE';
    } else if (condition == 'Clear') {
      return 'CLEAR';
    } else if (condition == 'Clouds') {
      return 'CLOUDY';
    } else {
      return 'ENTER CORRECT LOCATION';
    }
  }
}

class NetworkHelper {
  NetworkHelper(this.url);
  final String url;

  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String newData = response.body;
      print(newData);

      var decodedData = jsonDecode(newData);
      return decodedData;
    } else {
      print(response.statusCode);
    }
  }
}
