import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_api/services/location_provider.dart';
import 'package:weather_app_api/services/weather_service_provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final formattedDateAndDay =
      DateFormat('MMMM, dd ,EEEE').format(DateTime.now());

  final formattedTime = DateFormat('hh:mm a').format(DateTime.now());

  final List colorTheme = [Colors.white, Colors.black];

  @override
  void initState() {
    super.initState();
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.determinePsition().then((_) {
      if (locationProvider.currentLocationName != null) {
        var city = locationProvider.currentLocationName!.locality;
        if (city != null) {
          Provider.of<WeatherServiceProvider>(context, listen: false)
              .fetchWeatherDataByCity(city);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<LocationProvider>(builder: (context, value, child) {
                String locationName =
                    value.currentLocationName?.locality ?? 'Unknown Location';
                return WidgetText(
                  locationName,
                  clr: colorTheme[0],
                  fz: 22,
                  fw: FontWeight.w800,
                );
              }),
              WidgetText(formattedDateAndDay,
                  fz: 15, fw: FontWeight.w400, clr: colorTheme[0]),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          )
        ],
      ),
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/image/cloudy.jpg'),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 80, left: 50, right: 50),
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Consumer<WeatherServiceProvider>(
                  builder: (context, value, child) {
                return Column(
                  children: [
                    WidgetText(
                        '${value.weather!.main!.temp!.toInt().toString()}°c ',
                        clr: colorTheme[0],
                        fz: 70,
                        fw: FontWeight.w200),
                    WidgetText(value.weather!.weather![0].main.toString(),
                        clr: colorTheme[0], fz: 20, fw: FontWeight.w900),
                    WidgetText(formattedTime,
                        clr: colorTheme[0], fz: 16, fw: FontWeight.w500),
                    // WidgetText(value.weather!.main!.tempMax.toString()),
                    // WidgetText(value.weather!.main!.tempMin.toString())
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
                  return Column(
                    children: [
                      Row(
                        children: [
                          TempIconWidget(
                              'assets/image/Thermometer_icon.png',
                              "Max Temp",
                              '${value.weather!.main!.tempMax!.toInt().toString()}\u00b0c')
                        ],
                      )
                    ],
                  );
                }),
              )
            ],
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

  Widget TempIconWidget(imagePath, IconName, value) {
    return Row(
      children: [
        Image(
          image: AssetImage(imagePath),
          width: 20,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            WidgetText(
              IconName,
              fw: FontWeight.w700,
            ),
            WidgetText(value),
          ],
        )
      ],
    );
  }
}
