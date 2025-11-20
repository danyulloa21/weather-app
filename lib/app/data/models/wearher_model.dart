/// Modelo simple para el clima actual en una ciudad
class WeatherModel {
  /// Temperatura a 2m en °C
  final double temperatura;

  /// Humedad relativa en %
  final double humedad;

  /// Índice de símbolo de clima (Meteomatics weather_symbol_1h:idx)
  final int symbolCode;

  /// Fecha/hora del dato en UTC
  final DateTime dateTime;

  WeatherModel({
    required this.temperatura,
    required this.humedad,
    required this.symbolCode,
    required this.dateTime,
  });

  /// Crea el modelo desde el JSON bruto de Meteomatics
  factory WeatherModel.fromMeteomaticsJson(Map<String, dynamic> json) {
    // data es una lista de parámetros
    final List<dynamic> data = json['data'] as List<dynamic>;

    double? tempC;
    double? humidity;
    int? symbolCode;
    DateTime? dateTime;

    // Helper para extraer el primer valor de un parámetro específico
    T? extractValue<T>(String parameterName) {
      final param = data.firstWhere(
        (e) => e['parameter'] == parameterName,
        orElse: () => null,
      );

      if (param == null) return null;

      final coords = param['coordinates'] as List<dynamic>?;
      if (coords == null || coords.isEmpty) return null;

      final dates = coords.first['dates'] as List<dynamic>?;
      if (dates == null || dates.isEmpty) return null;

      final firstDate = dates.first as Map<String, dynamic>;

      // Guardamos la fecha solo una vez (la primera que encontremos)
      if (dateTime == null && firstDate['date'] != null) {
        dateTime = DateTime.parse(firstDate['date'] as String).toUtc();
      }

      return firstDate['value'] as T?;
    }

    tempC = extractValue<double>('t_2m:C');
    humidity = extractValue<double>('relative_humidity_2m:p');
    // value llega como num (double), pero lo queremos int
    final symbolValue = extractValue<num>('weather_symbol_1h:idx');
    if (symbolValue != null) {
      symbolCode = symbolValue.toInt();
    }

    if (tempC == null ||
        humidity == null ||
        symbolCode == null ||
        dateTime == null) {
      throw Exception('Respuesta de Meteomatics incompleta: $json');
    }

    return WeatherModel(
      temperatura: tempC,
      humedad: humidity,
      symbolCode: symbolCode,
      dateTime: dateTime!,
    );
  }

  /// Helper para formatear temperatura bonito
  String get temperatureLabel => '${temperatura.toStringAsFixed(1)} °C';

  /// Helper para formatear humedad
  String get humidityLabel => '${humedad.toStringAsFixed(0)} %';

  /// Puedes mapear el symbolCode a una descripción
  String get description {
    // Mapeo básico de ejemplo, ajusta con la tabla de Meteomatics
    if (symbolCode == 1) return 'Despejado';
    if (symbolCode == 2) return 'Mayormente despejado';
    if (symbolCode == 3) return 'Parcialmente nublado';
    if (symbolCode == 4) return 'Nublado';
    if (symbolCode == 5) return 'Lluvia ligera';
    if (symbolCode == 6) return 'Lluvia';
    // ...
    return 'Clima desconocido';
  }

  @override
  String toString() {
    return 'WeatherModel(temperatura: $temperatura, humedad: $humedad, symbolCode: $symbolCode, dateTime: $dateTime)';
  }
}
