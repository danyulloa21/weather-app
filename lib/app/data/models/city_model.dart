class CityModel {
  final String name;
  final double lat;
  final double lon;

  CityModel({required this.name, required this.lat, required this.lon});

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    name: json['nombre'],
    lat: json['latitud'],
    lon: json['longitud'],
  );

  Map<String, dynamic> toJson() => {
    'nombre': name,
    'latitud': lat,
    'longitud': lon,
  };
}
