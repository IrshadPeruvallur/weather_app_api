class WeatherModel {
  String? clouds;
  double? temp;
  double? tempMax;
  double? tempMin;
  int? sunrise;
  int? sunset;
  String? name;

  WeatherModel(
      {this.clouds,
      this.temp,
      this.tempMax,
      this.tempMin,
      this.sunrise,
      this.sunset,
      this.name});

  WeatherModel.fromJson(Map<String, dynamic> json) {
    if (json['weather'] != null && json['weather'].isNotEmpty) {
      clouds = json['weather'][0]['main'];
    }

    name = json['name'];

    if (json['main'] != null) {
      temp = json['main']['temp']?.toDouble();
      tempMax = json['main']['temp_max']?.toDouble();
      tempMin = json['main']['temp_min']?.toDouble();
    }

    sunrise = json['sys']['sunrise'];
    sunset = json['sys']['sunset'];
  }
}
