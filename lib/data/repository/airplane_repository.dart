import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/airplane_model.dart';

class AirplaneRepository {
  final String apiUrl = 'https://ki7pfnbeq7.execute-api.us-east-2.amazonaws.com/Prod/airplanes';

  Future<List<Airplane>> getAirplanes() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Airplane.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load airplanes');
    }
  }

  Future<void> createAirplane(Airplane airplane) async {
    final requestBody = json.encode({
      // No incluyas el campo 'id' si está vacío
      'modelo': airplane.modelo,
      'fabricante': airplane.fabricante,
      'capacidad': airplane.capacidad,
      'rango': airplane.rango,
    });

    print('Request body: $requestBody');

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBody,
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create airplane');
    }
  }




  Future<void> updateAirplane(Airplane airplane) async {
    final response = await http.put(
      Uri.parse('$apiUrl/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(airplane.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update airplane');
    }
  }

  Future<void> deleteAirplane(String id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete airplane');
    }
  }
}
