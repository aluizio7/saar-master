import 'package:flutter/material.dart';
import 'package:saar/Pages/start.dart';
import 'package:saar/embrapa_api/models.dart';
import 'package:saar/embrapa_api/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> verificarEArmazenarLista() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? culturasSalvas = prefs.getStringList("culturas");

    if (culturasSalvas == null) {
      final List<Cultura> novasCulturas = await EmbrapAPI.fetchCulturas();

      final List<Map<String, dynamic>> listaJson = novasCulturas.map((obj) => obj.toJson()).toList();
      await prefs.setString('culturas', listaJson.toString());
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amigo Agricultor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Start(),
    );
  }
}