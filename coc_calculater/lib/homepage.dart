import 'package:coc_calculater/calculator_widget.dart';
import 'package:coc_calculater/defense_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('COC Calculator'),
        backgroundColor: Colors.white,
        elevation: 2,
      ),

      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            CalculatorWidget(),
            DefenseTableWidget()
          ]
        )
      )
    );
  }
}
