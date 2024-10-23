import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<ColorSchemeData> fetchColorScheme(String colorCode) async {
  final response = await http.get(Uri.parse(
      'https://www.thecolorapi.com/scheme?hex=$colorCode&format=json'));

  if (response.statusCode == 200) {
    // Jika respon sukses (statusCode 200), parsing JSON
    return ColorSchemeData.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // Jika gagal mendapatkan data, lemparkan exception
    throw Exception('Failed to load color scheme data');
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

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<ColorSchemeData> futureColorScheme;
  final TextEditingController _colorCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inisialisasi dengan kode warna default (misal: D93B37)
    futureColorScheme = fetchColorScheme('D93B37');
  }

  @override
  void dispose() {
    _colorCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Scheme Fetch Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Color Scheme Fetch Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _colorCodeController,
                decoration: const InputDecoration(
                  labelText: 'Enter Hex Color Code (without #)',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    futureColorScheme = fetchColorScheme(_colorCodeController.text);
                  });
                },
                child: const Text('Fetch Color Scheme'),
              ),
              Expanded(
                child: FutureBuilder<ColorSchemeData>(
                  future: futureColorScheme,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.colors.length,
                        itemBuilder: (context, index) {
                          final colorData = snapshot.data!.colors[index];
                          return ListTile(
                            title: Text(colorData.name),
                            subtitle: Text(colorData.hex),
                            leading: Container(
                              width: 50,
                              height: 50,
                              color: Color(
                                  int.parse(colorData.hex.replaceAll('#', '0xff'))),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // Jika masih loading, tampilkan indikator loading
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
