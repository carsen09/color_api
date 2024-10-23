import 'package:flutter/material.dart';
import 'color_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<ColorData> futureColorByCode;
  final TextEditingController _colorCodeController = TextEditingController(); // Controller untuk input kode warna
  final ColorSchemeService colorSchemeService = ColorSchemeService();

  @override
  void initState() {
    super.initState();
    // Inisialisasi dengan warna default
    futureColorByCode = colorSchemeService.fetchColorByCode('D93B37'); // Default color: red
  }

  @override
  void dispose() {
    _colorCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color API Search by Hex Code',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Search Color by Hex Code'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _colorCodeController,
                decoration: const InputDecoration(
                  labelText: 'Enter Hex Color Code (without #)', // Input label
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Ambil warna berdasarkan kode yang dimasukkan oleh pengguna
                    futureColorByCode = colorSchemeService
                        .fetchColorByCode(_colorCodeController.text); 
                  });
                },
                child: const Text('Search Color'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<ColorData>(
                  future: futureColorByCode,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final colorData = snapshot.data!;

                      // Parse hex code to Flutter Color
                      String hexCode = colorData.hex.replaceAll('#', '');
                      Color color = Color(int.parse('0xff$hexCode'));

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            color: color, // Display the searched color
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Color Name: ${colorData.name}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Hex Code: ${colorData.hex}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

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
