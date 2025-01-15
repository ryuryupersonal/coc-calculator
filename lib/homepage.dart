import 'package:coc_calculater/calculator_widget.dart';
import 'package:coc_calculater/defense_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Stack(children: [
      Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/Background.webp"), fit: BoxFit.cover),
        ),
      ),
      SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          height: 72,
          color: Colors.blueGrey.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const SizedBox(width: 28),
                Text("COC Calculator",
                    style: Theme.of(context).textTheme.headlineSmall)
              ]),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     TextButton(
              //         style: TextButton.styleFrom(
              //             overlayColor: Colors.transparent),
              //         onPressed: () {},
              //         child: const Text("Settings",
              //             style: TextStyle(color: Colors.black, fontSize: 20))),
              //     const SizedBox(width: 36)
              //   ],
              // )
            ],
          ),
        ),
        const CalculatorWidget(),
        const DefenseTableWidget()
      ]))
    ]));
  }
}
