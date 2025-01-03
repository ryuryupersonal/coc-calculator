import 'package:coc_calculater/model/damage_model.dart';
import 'package:coc_calculater/model/defense_model.dart';
import 'package:coc_calculater/ui/damages_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Return a List of DamageModel from JSON data
final damageModelProvider = Provider<List<DamageModel>>((ref) => []);

// Return a List of DefenseModel from JSON data
final defenseModelProvider = Provider<List<DefenseModel>>((ref) => []);

// Exposing the Constant Damage Card's UI Parameters
final damageCardNotifierProvider = StateNotifierProvider.family<DamagesCardNotifier, DamagesCardState, DamageModel>(
  (ref, model) => (DamagesCardNotifier(model)),
);
