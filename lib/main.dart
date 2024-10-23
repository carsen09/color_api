// main.dart
import 'package:flutter/material.dart';
import 'color_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<ColorSchemeData> futureColorScheme;
  final TextEditingController _colorCodeController = TextEditingController();
  final ColorSchemeService colorSchemeService = ColorSchemeService();

  @override
  void initState() {
    super.initState();
    futureColorScheme = colorSchemeService.fetchColorScheme('D93B37');
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
                    futureColorScheme =
                        colorSchemeService.fetchColorScheme(_colorCodeController.text);
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
