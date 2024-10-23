// color_scheme_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ColorSchemeService {
  Future<ColorSchemeData> fetchColorScheme(String colorCode) async {
    final response = await http.get(Uri.parse(
        'https://www.thecolorapi.com/scheme?hex=$colorCode&format=json'));

    if (response.statusCode == 200) {
      return ColorSchemeData.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load color scheme data');
    }
  }
}

class ColorSchemeData {
  final List<ColorData> colors;

  ColorSchemeData({required this.colors});

  factory ColorSchemeData.fromJson(Map<String, dynamic> json) {
    var colorList = json['colors'] as List;
    List<ColorData> colorScheme =
        colorList.map((color) => ColorData.fromJson(color)).toList();

    return ColorSchemeData(colors: colorScheme);
  }
}

class ColorData {
  final String hex;
  final String name;

  ColorData({required this.hex, required this.name});

  factory ColorData.fromJson(Map<String, dynamic> json) {
    return ColorData(
      hex: json['hex']['value'] as String,
      name: json['name']['value'] as String,
    );
  }
}
