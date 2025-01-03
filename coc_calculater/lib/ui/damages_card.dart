import 'package:coc_calculater/model/damage_model.dart';
import 'package:coc_calculater/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DamageCard extends ConsumerWidget {
  final DamageModel model;

  // modelがあるのでstate.modelは使わないほうがいい。
  const DamageCard({super.key, required this.model});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = damageCardNotifierProvider(model);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

      return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.only(top: 30, bottom: 20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                offset: Offset(5, 5),
                color: Colors.grey
              )
            ]
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Image.asset(
                  model.img,
                  width: 64,
                  height: 64
                ),

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
                      onPressed: () => notifier.decLevel(),
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
                      onPressed: () => notifier.incLevel(),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => notifier.decCount(),
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
                      onPressed: () => notifier.incCount(),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Damage.webp',
                      width: 16,
                      height: 16
                    ),

                    const SizedBox(width: 6),
                    
                    Text(
                      (state.damage).toString(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.red
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
      );
  }
}

class DamagesCardState {
  final DamageModel model;
  final int level;
  final int count;

  final int damage;

  DamagesCardState({required this.model, this.level = 1, this.count = 0})
    : damage = model.damage[level - 1] * count;

  DamagesCardState copyWith({int? level, int? count}) {
    return DamagesCardState(
        level: level ?? this.level, count: count ?? this.count, model: model);
  }
}

class DamagesCardNotifier extends StateNotifier<DamagesCardState> {
  DamagesCardNotifier(DamageModel model)
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
