import 'package:coc_calculater/model/damage_model.dart';
import 'package:coc_calculater/state/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DamageCard extends ConsumerWidget {
  final DamageModel model;

  const DamageCard({super.key, required this.model});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = damageCardNotifierProvider(model);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    return SizedBox(
        width: 200,
        height: 300,
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: Stack(children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      if (!state.isMinCount)
                        const BoxShadow(
                            blurRadius: 6,
                            offset: Offset(4, 2),
                            color: Colors.grey)
                    ]),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(children: [
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 20),
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Image.asset(model.img, width: 64, height: 64),
                            const SizedBox(height: 14),
                            Text(
                              model.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_ios),
                                  onPressed: state.isMinLevel
                                      ? null
                                      : () => notifier.decLevel(),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 24,
                                  child: Center(
                                    child: Text(
                                      'Lv ${state.level.toString()}',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios),
                                  onPressed: state.isMaxLevel
                                      ? null
                                      : () => notifier.incLevel(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_ios),
                                  onPressed: state.isMinCount
                                      ? null
                                      : () => notifier.decCount(),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 24,
                                  child: Center(
                                    child: Text(
                                      'x ${state.count.toString()}',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios),
                                  onPressed: state.isMaxCount
                                      ? null
                                      : () => notifier.incCount(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/Damage.webp',
                                    width: 16, height: 16),
                                const SizedBox(width: 6),
                                Text(
                                  (state.damage).toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(color: Colors.red),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state.isMinCount)
                      IgnorePointer(
                          child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.grey.shade600.withAlpha(60))),
                  ])),
            ])));
  }
}

class DamagesCardState {
  final DamageModel model;
  final int level;
  final int count;

  final bool isMaxLevel;
  final bool isMinLevel;
  final bool isMaxCount;
  final bool isMinCount;

  final int damage;

  DamagesCardState({required this.model, this.level = 1, this.count = 0})
      : isMaxLevel = (level == model.damage.length),
        isMinLevel = (level == 1),
        isMaxCount = (count == model.max),
        isMinCount = (count == 0),
        damage = model.damage[level - 1] * count;

  DamagesCardState copyWith({int? level, int? count}) {
    return DamagesCardState(
        level: level ?? this.level, count: count ?? this.count, model: model);
  }
}

class DamagesCardNotifier extends StateNotifier<DamagesCardState> {
  DamagesCardNotifier(DamageModel model)
      : super(DamagesCardState(model: model, level: model.damage.length));

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
