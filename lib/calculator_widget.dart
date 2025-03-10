import 'package:coc_calculater/model/damage_model.dart';
import 'package:coc_calculater/state/provider.dart';
import 'package:coc_calculater/ui/damage_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculatorWidget extends ConsumerStatefulWidget {
  const CalculatorWidget({super.key});

  @override
  ConsumerState<CalculatorWidget> createState() => _CalculatorState();
}

class _CalculatorState extends ConsumerState<CalculatorWidget> {
  late final List<DamageModel> models;

  @override
  void initState() {
    super.initState();

    models = ref.read(damageModelProvider);
  }

  @override
  Widget build(BuildContext context) {
    final totalDamage = ref.watch(totalConstantDamageProvider);

    return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.grey.shade200.withAlpha(250),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(children: [
            Text('Constant Damage',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            SizedBox(
                height: 310,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: models.length,
                    itemBuilder: (context, index) =>
                        DamageCard(model: models[index]))),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total :', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(width: 8),
                Image.asset('assets/Damage.webp', width: 24, height: 24),
                const SizedBox(width: 8),
                Text(totalDamage.toString(),
                    style: Theme.of(context).textTheme.titleLarge)
              ],
            )
          ]),
        ));
  }
}
