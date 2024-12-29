import 'package:coc_calculater/model/damages_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DamagesCard extends ConsumerWidget {
  final DamagesModel damagesModel;
  final StateNotifierProvider<DamagesCardNotifier, DamagesCardState>
      damagesCardProvider;

  DamagesCard({required this.damagesModel, required this.damagesCardProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(damagesCardProvider.notifier);

    throw UnimplementedError();
  }
}

class DamagesCardState {
  final DamagesModel model;
  final int level;
  final int count;

  DamagesCardState({required this.model, this.level = 1, this.count = 1});

  DamagesCardState copyWith({int? level, int? count}) {
    return DamagesCardState(
        level: level ?? this.level, count: count ?? this.count, model: model);
  }
}

class DamagesCardNotifier extends StateNotifier<DamagesCardState> {
  DamagesCardNotifier(DamagesModel model)
      : super(DamagesCardState(model: model));

  void incLevel() {
    if (state.level < state.model.damage.length) {
      state = state.copyWith(level: state.level + 1);
    }
  }

  void decLevel() {
    if (state.level > 1) {
      state = state.copyWith(level: state.level - 1);
    }
  }

  void incCount() {
    if (state.count < state.model.max) {
      state = state.copyWith(count: state.count + 1);
    }
  }

  void decCount() {
    if (state.count > 0) {
      state = state.copyWith(count: state.count - 1);
    }
  }
}
