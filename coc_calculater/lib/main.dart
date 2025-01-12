import 'dart:convert';

import 'package:coc_calculater/homepage.dart';
import 'package:coc_calculater/model/damage_model.dart';
import 'package:coc_calculater/model/defense_model.dart';
import 'package:coc_calculater/state/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  List<DamageModel> damageModels = await loadDamageModels();
  List<DefenseModel> defenseModels = await loadDefenseModels();

  runApp(
    ProviderScope(
      overrides: [
        damageModelProvider.overrideWith((ref) => damageModels),
        defenseModelProvider.overrideWith((ref) => defenseModels)
      ],
      child: const MyApp()
    ),
  );
}

Future<List<DamageModel>> loadDamageModels() async {
  String jsonString = await rootBundle.loadString('data/damages.json');
  List<dynamic> jsonList = jsonDecode(jsonString);

  return jsonList.map((json) => DamageModel.fromJson(json)).toList();
}

Future<List<DefenseModel>> loadDefenseModels() async {
  String jsonString = await rootBundle.loadString('data/defenses.json');
  List<dynamic> jsonList = jsonDecode(jsonString);

  return jsonList.map((json) => DefenseModel.fromJson(json)).toList();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
