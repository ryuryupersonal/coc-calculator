import 'dart:convert';

import 'package:coc_calculater/model/damages_model.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final damagesProvider = FutureProvider<List<DamagesModel>>((ref) async {
  String jsonString = await rootBundle.loadString('data/damages.json');
  List<dynamic> jsonList = jsonDecode(jsonString);

  return jsonList.map((json) => DamagesModel.fromJson(json)).toList();
});
