import 'dart:convert';
import 'package:http/http.dart' as http;

class ColorSchemeService {
  Future<ColorData> fetchColorByCode(String colorCode) async {
    final response = await http.get(
        Uri.parse('https://www.thecolorapi.com/id?hex=$colorCode&format=json')); // URL untuk mencari berdasarkan kode warna

    if (response.statusCode == 200) {
      return ColorData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load color');
    }
  }
}

class ColorData {
  final String hex;
  final String name;

  ColorData({required this.hex, required this.name});

  factory ColorData.fromJson(Map<String, dynamic> json) {
    return ColorData(
      hex: json['hex']['value'] as String, // Mendapatkan kode warna hex
      name: json['name']['value'] as String, // Mendapatkan nama warna
    );
  }
}
