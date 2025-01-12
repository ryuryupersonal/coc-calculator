import 'package:coc_calculater/model/damage_model.dart';
import 'package:coc_calculater/model/defense_model.dart';
import 'package:coc_calculater/ui/damage_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// final additionalContextProvider = StateProvider((ref) => AdditionalContext());

// Return a List of DamageModel from JSON data
final damageModelProvider = Provider<List<DamageModel>>((ref) => []);

// Return a List of DefenseModel from JSON data
final defenseModelProvider = Provider<List<DefenseModel>>((ref) => []);

// Exposing the Constant Damage Card's UI Parameters
final damageCardNotifierProvider = StateNotifierProvider.family<DamagesCardNotifier, DamagesCardState, DamageModel>(
  (ref, model) => (DamagesCardNotifier(model)),
);

final quakeLevelProvider = StateProvider<int>((ref) => 5);

final totalConstantDamageProvider = Provider<int>((ref) {
  final damageModels = ref.watch(damageModelProvider);

  return damageModels.fold<int>(0, (sum, model) => sum + ref.watch(damageCardNotifierProvider(model)).damage);
});