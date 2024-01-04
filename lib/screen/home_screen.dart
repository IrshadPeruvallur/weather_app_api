import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_api/controller/home_provider.dart';
import 'package:weather_app_api/services/location_provider.dart';
import 'package:weather_app_api/services/weather_service_provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dateAndDay = DateFormat('MMMM, dd ,EEEE').format(DateTime.now());
  final time = DateFormat('hh:mm a').format(DateTime.now());
  final List colorTheme = [Colors.white, Colors.black];
  TextEditingController searchController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   final locationProvider =
  //       Provider.of<LocationProvider>(context, listen: false);
  //   locationProvider.determinePsition().then((_) {
  //     if (locationProvider.currentLocationName != null) {
  //       var city = locationProvider.currentLocationName!.locality;
  //       if (city != null) {
  //         Provider.of<WeatherServiceProvider>(context, listen: false)
  //             .fetchWeatherDataByCity(city);
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Consumer<HomeProvier>(builder: (context, value, child) {
            return TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_on, color: Colors.white),
                hintText: "Search City",
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            );
          }),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: IconButton(
                onPressed: () {
                  final getPrd = Provider.of<WeatherServiceProvider>(context,
                      listen: false);
                  getPrd.fetchWeatherDataByCity(searchController.text);
                },
                icon: Icon(Icons.search)),
          )
        ],
      ),
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/image/background02.jpg'),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 80, left: 50, right: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                ),
                Consumer2<LocationProvider, WeatherServiceProvider>(
                    builder: (context, location, weather, child) {
                  String locationName = weather.weather!.name!.isNotEmpty
                      ? weather.weather!.name.toString()
                      : location.currentLocationName?.locality ??
                          'Unknown Location';
                  return WidgetText(
                    locationName,
                    clr: colorTheme[0],
                    fz: 22,
                    fw: FontWeight.w800,
                  );
                }),
                WidgetText(dateAndDay,
                    fz: 15, fw: FontWeight.w400, clr: colorTheme[0]),
                Consumer<WeatherServiceProvider>(
                    builder: (context, value, child) {
                  return Column(
                    children: [
                      WidgetText(
                          '${value.weather?.main?.temp?.toInt().toString() ?? "N/A"}°c ',
                          clr: colorTheme[0],
                          fz: 80,
                          fw: FontWeight.w200),
                      WidgetText(
                          value.weather?.weather?[0].main.toString() ?? 'N/A ',
                          clr: colorTheme[0],
                          fz: 20,
                          fw: FontWeight.w900),
                      WidgetText(time,
                          clr: colorTheme[0], fz: 16, fw: FontWeight.w500),
                    ],
                  );
                }),
                SizedBox(
                  height: size.height * .1,
                ),
                Container(
                  height: size.height * .2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(92, 255, 255, 255),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Consumer<WeatherServiceProvider>(
                      builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TempIconWidget(
                                  imageSize: 20,
                                  'assets/image/Thermometer_icon.png',
                                  "Max Temp",
                                  '${value.weather?.main?.tempMax?.toInt().toString() ?? 'N/A '}\u00b0c'),
                              TempIconWidget(
                                imageSize: 25,
                                'assets/image/Thermometer_icon 2.png',
                                "Max Temp",
                                '${value.weather?.main?.tempMin?.toInt() ?? 'N/A'}\u00b0c',
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TempIconWidget(
                                imageSize: 30,
                                'assets/image/sun.png',
                                "Sunrise",
                                value.weather != null
                                    ? DateFormat('hh:mm').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            value.weather!.sys!.sunrise! *
                                                1000))
                                    : 'N/A',
                              ),
                              TempIconWidget(
                                imageSize: 35,
                                'assets/image/moon.png',
                                "Sunset",
                                value.weather != null
                                    ? DateFormat('hh:mm').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            value.weather!.sys!.sunset! * 1000))
                                    : 'N/A',
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget WidgetText(String data, {Color? clr, double? fz, FontWeight? fw}) {
    return Text(
      data,
      style: TextStyle(
        color: clr,
        fontSize: fz,
        fontWeight: fw,
      ),
    );
  }

  Widget TempIconWidget(imagePath, IconName, value, {double? imageSize}) {
    return Row(
      children: [
        Image(
          image: AssetImage(imagePath),
          width: imageSize,
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            WidgetText(
              IconName,
              fw: FontWeight.w700,
            ),
            WidgetText(value, fz: 20, fw: FontWeight.w700),
          ],
        )
      ],
    );
  }
}
