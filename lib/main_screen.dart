import 'package:flutter/material.dart';
import 'constant.dart';
import 'climate.dart';
import 'search_screen.dart';
import 'main.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather, this.networkHelper});
  final locationWeather;
  final networkHelper;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int? temp;
  String? weatherCondition;
  String? cityName;
  String? weatherMessage;

  @override
  void initState() {
    super.initState();
    updateUi(widget.locationWeather);
  }

  void updateUi(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temp = 0;
        weatherCondition = 'error';
        weatherMessage = 'Unable to get weather data';
        cityName = '';
        return;
      }
      double temperature = weatherData['main']['temp'];
      temp = temperature.toInt();
      var condition = weatherData['weather'][0]['main'];
      cityName = weatherData['name'];
      weatherCondition = weather.getWeatherCondition(condition);
      if (hc05Device != null) {
        sendDataToArduino(hc05Device, condition);
      } else {
        print("BluetoothDevice is null. Unable to send data to Arduino.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () async {
                    var typedName = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CityScreen();
                        },
                      ),
                    );
                    if (typedName != null) {
                      var weatherData = await weather.getCityWeather(typedName);
                      updateUi(weatherData);
                    }
                  },
                  child: Icon(
                    Icons.location_on,
                    color: Colors.greenAccent,
                    size: 70.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temp°C',
                      style: kTempStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25.0),
                child: Text(
                  "$weatherCondition In $cityName!",
                  textAlign: TextAlign.right,
                  style: kMessageStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "🔴 for clear, 🔷 for rain and snow,💚 for Haze,🔴 and 🔷 for cloudy, 🔷 and 💚 for thunderstorm ",
                  textAlign: TextAlign.right,
                  style: kMessageStyle1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
