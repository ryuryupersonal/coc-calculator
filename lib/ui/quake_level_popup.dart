import 'package:coc_calculater/state/const.dart';
import 'package:flutter/material.dart';

class QuakeLevelPopup extends StatefulWidget {
  final int initialLevel;
  final Function(int) onOK;
  final Function() onCancel;

  const QuakeLevelPopup(
      {super.key,
      required this.initialLevel,
      required this.onOK,
      required this.onCancel});

  @override
  State<QuakeLevelPopup> createState() => _QuakeLevelPopupState();
}

class _QuakeLevelPopupState extends State<QuakeLevelPopup> {
  late int selectedLevel;

  @override
  void initState() {
    super.initState();

    selectedLevel = widget.initialLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          width: 270,
          padding: const EdgeInsets.only(top: 10, bottom: 12),
          decoration:
              BoxDecoration(color: Colors.grey.shade100, boxShadow: const [
            BoxShadow(blurRadius: 5, offset: Offset(2, 2), color: Colors.grey)
          ]),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemExtent: 40,
                    itemCount: earthquakeMap.length,
                    itemBuilder: (_, index) {
                      return _createRadioRow(index + 1);
                    }),
              ),
              const Divider(),
              const SizedBox(height: 4),
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                        onPressed: () => widget.onOK(selectedLevel),
                        child: const SizedBox(
                            width: 50, child: Center(child: Text("OK")))),
                    const SizedBox(width: 10),
                    FilledButton(
                        onPressed: () => widget.onCancel(),
                        child: const SizedBox(
                            width: 50, child: Center(child: Text("Cancel"))))
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _createRadioRow(int level) {
    return SizedBox(
        height: 40,
        child: MaterialButton(
            onPressed: () {
              if (selectedLevel != level) {
                setState(() {
                  selectedLevel = level;
                });
              }
            },
            child: Row(
              children: [
                SizedBox(
                    width: 24,
                    height: 24,
                    child: IgnorePointer(
                        child: Radio(
                            value: level,
                            groupValue: selectedLevel,
                            onChanged: (_) {}))),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(
                  'Earthquake Lv $level',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ))
              ],
            )));
  }
}
