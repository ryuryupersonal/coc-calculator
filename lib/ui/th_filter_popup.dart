import 'package:coc_calculater/state/const.dart';
import 'package:flutter/material.dart';

class ThFilterPopup extends StatefulWidget {
  final Set<int> initialCondition;
  final Function(Set<int>) onOK;
  final Function() onCancel;

  const ThFilterPopup({super.key, required this.initialCondition, required this.onOK, required this.onCancel});

  @override
  State<ThFilterPopup> createState() => _ThFilterPopupState();
}

class _ThFilterPopupState extends State<ThFilterPopup> {
  late final Set<int> condition;

  late bool allSelected;
  late bool allUnselected;

  @override
  void initState() {
    super.initState();

    condition = Set<int>.from(widget.initialCondition);
  }

  @override
  Widget build(BuildContext context) {
    allSelected = condition.containsAll(allThSet);
    allUnselected = condition.isEmpty;
    
    return Material(
      child: Container(
        width: 270,
        padding: const EdgeInsets.only(top: 10, bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              offset: Offset(2, 2),
              color: Colors.grey
            )
          ]
        ),

        child: Column(
          children: [
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: MaterialButton(
                onPressed: () {
                  if (allSelected) {
                    setState(() {
                      condition.clear();
                    });
                    return;
                  } else {
                    setState(() {
                      condition.clear();
                      condition.addAll(allThSet);
                    });
                    return;
                  }
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: IgnorePointer(
                        child: Checkbox(
                          tristate: true,
                          value: allSelected
                            ? true
                            : allUnselected
                              ? false
                              : null,
                          onChanged: (_) {}
                        )
                      )
                    ),
                    
                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        "Select All",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    )
                  ],
                )
              )
            ),

            const Divider(indent: 8.0, endIndent: 8.0),

            Container(
              height: 360,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                itemCount: 17,
                itemBuilder: (_, index) {
                  return _createCheckboxRow(index + 1);
                },
              )
            ),

            const Divider(indent: 0, endIndent: 0),

            const SizedBox(height: 4.0),

            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () => widget.onOK(condition),
                    child: const SizedBox(
                      width: 50,
                      child: Center(
                        child: Text("OK")
                      )
                    )
                  ),

                  const SizedBox(width: 10),

                  FilledButton(
                    onPressed: () => widget.onCancel(),
                    child: const SizedBox(
                      width: 50,
                      child: Center(
                        child: Text("Cancel")
                      )
                    )
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }

  Widget _createCheckboxRow(int th) {
    return SizedBox(
      height: 40,
      child: MaterialButton(
        onPressed: () {
          setState(() {
            if (!condition.remove(th)) condition.add(th);
          });
        },
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: IgnorePointer(
                child: Checkbox(
                  value: condition.contains(th),
                  onChanged: (_) {}
                )
              )
            ),
            
            const SizedBox(width: 12),

            Expanded(
              child: Text(
                'Town Hall $th',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              )
            )
          ],
        )
      )
    );
    
  }
}

