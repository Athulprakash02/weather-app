import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:weatherapp/core/constants.dart';
import 'package:weatherapp/domain/api_end_points.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/presentation/widgets/weather_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _cityController = TextEditingController();
  Constants _constants = Constants();
  String location = "London";
  String weatherIcon = 'heavycloudy.png';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = '';

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  String currentWeatherStatus = '';

  //ApiCall
  String searchWeatherAPI =
      "http://api.weatherapi.com/v1/forecast.json?key=" + apiKey + "&days=7&q=";
  void fetchWeatherData(String searchText) async {
    print("keri");
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherAPI + searchText));

      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? 'No data');

      var locationData = weatherData["location"];
      var currentWeather = weatherData["current"];

      setState(() {
        location = getShortLocationName(locationData["name"]);
        var parsedDate = DateTime.parse(locationData["localtime"].toString());
        var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
        var currentDate = newDate;
        

        //updatedWeather

        currentWeatherStatus = currentWeather["condition"]["text"];
       
        weatherIcon =
            currentWeatherStatus.replaceAll(' ', '').toLowerCase() + ".png";
        temperature = currentWeather["temp_c"].toInt();
       
        windSpeed = currentWeather["wind_kph"].toInt();
        humidity = currentWeather["humidity"].toInt();
        cloud = currentWeather["cloud"].toInt();
        

        // forcast data
        dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
      });
    } catch (e) {
      //debugPrint(e);
    }
  }

//function to return first two names of string location

  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");

    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return wordList[0] + " " + wordList[1];
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }

  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: SystemUiOverlay.values);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: size.height * .15,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 70,
                      child: Divider(
                        thickness: 3.5,
                        color: _constants.primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onChanged: (value) {
                        fetchWeatherData(value);
                      },
                      controller: _cityController,
                      autofocus: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: _constants.primaryColor,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () => _cityController.clear(),
                            child: Icon(
                              Icons.close,
                              color: _constants.primaryColor,
                            ),
                          ),
                          hintText: "Search city eg: London",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _constants.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  
                  width: size.width,
                  // height: size.height,
                  padding: const EdgeInsets.only( left: 10, right: 10),
                  color: _constants.primaryColor.withOpacity(.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        height: size.height * .6,
                        decoration: BoxDecoration(
                            gradient: _constants.linearGradientBlue,
                            boxShadow: [
                              BoxShadow(
                                color: _constants.primaryColor.withOpacity(.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              )
                            ],
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Image.asset(
                                //   "assets/menu.png",
                                //   width: 40,
                                //   height: 40,
                                // ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/pin.png",
                                      width: 20,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      location,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    
                                  ],
                                ),
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(10),
                                //   child: Image.asset(
                                //     "assets/profile.png",
                                //     width: 40,
                                //     height: 40,
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 160,
                              child: Image.asset("assets/" + weatherIcon),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    temperature.toString(),
                                    style: TextStyle(
                                        fontSize: 80,
                                        fontWeight: FontWeight.bold,
                                        foreground: Paint()
                                          ..shader = _constants.shader),
                                  ),
                                ),
                                Text(
                                  'o',
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..shader = _constants.shader),
                                ),
                              ],
                            ),
                            Text(
                              currentWeatherStatus,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              currentDate,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Divider(
                                color: Colors.white70,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WeatherItem(
                                    value: windSpeed.toInt(),
                                    unit: ' Km/h',
                                    imageUrl: 'assets/windspeed.png',
                                  ),
                                  WeatherItem(
                                    value: humidity.toInt(),
                                    unit: '%',
                                    imageUrl: 'assets/humidity.png',
                                  ),
                                  WeatherItem(
                                    value: cloud.toInt(),
                                    unit: '%',
                                    imageUrl: 'assets/cloud.png',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        height: size.height * .20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Today',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                
                              ],
                            ),
                            SizedBox(
                              height: 110,
                              child: ListView.builder(
                                itemCount: hourlyWeatherForecast.length,
                                // itemCount: ,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  String currentTime =
                                      DateFormat('HH:mm:ss').format(DateTime.now());
                                  String CurrentHour = currentTime.substring(0, 2);
                    
                                  String forecastTime = hourlyWeatherForecast[index]
                                          ["time"]
                                      .substring(11, 16);
                                  String forecastHour = hourlyWeatherForecast[index]
                                          ["time"]
                                      .substring(11, 13);
                    
                                  String forecastWeatherName =
                                      hourlyWeatherForecast[index]["condition"]
                                          ["text"];
                                  String forecastWeatherIcon = forecastWeatherName
                                          .replaceAll(' ', '')
                                          .toLowerCase() +
                                      ".png";
                    
                                  String forecastTemperature =
                                      hourlyWeatherForecast[index]["temp_c"]
                                          .toString();
                                  return Container(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    margin: const EdgeInsets.only(right: 20),
                                    width: 65,
                                    decoration: BoxDecoration(
                                        color: CurrentHour == forecastHour
                                            ? Colors.white
                                            : _constants.primaryColor,
                                        borderRadius:
                                            const BorderRadius.all(Radius.circular(50)),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(0, 1),
                                            blurRadius: 5,
                                            color: _constants.primaryColor
                                                .withOpacity(.2),
                                          )
                                        ]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          forecastTime,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/' + forecastWeatherIcon,
                                          width: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              forecastTemperature + "\u00B0",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
