import 'dart:async';
import 'dart:math';

import 'package:coc_calculater/model/defense_model.dart';
import 'package:coc_calculater/state/const.dart';
import 'package:coc_calculater/state/provider.dart';
import 'package:coc_calculater/table/defense_table_source.dart';
import 'package:coc_calculater/table/table_operation.dart';
import 'package:coc_calculater/ui/th_filter_popup.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DefenseTableWidget extends ConsumerStatefulWidget {
  const DefenseTableWidget({super.key});

  @override
  ConsumerState<DefenseTableWidget> createState() => _DefenseTableState();
}

class _DefenseTableState extends ConsumerState<DefenseTableWidget> {
  late final List<DefenseModel> models;
  late final TableOperation tableOperation;
  late final DefenseTableSource tableSource;

  bool defenseFilter = false; // changeable
  late final Set<String> defenseFilterCondition; // unchangeable

  final GlobalKey _thFilterIconKey = GlobalKey();

  bool thFilter = true; // unchangeable
  late final Set<int> thFilterCondition; // changeable

  late SortOrder hpSortCondition; // changeable

  @override
  void initState() {
    super.initState();

    models = ref.read(defenseModelProvider);
    tableOperation = TableOperation(500);
    tableSource = DefenseTableSource(source: [], quakeLevel: 5, constDamage: 0);

    defenseFilterCondition = impDefenseSet;
    thFilterCondition = Set<int>.from(allThSet); // all Town Hall
    hpSortCondition = SortOrder.noSort;
  }

  @override
  Widget build(BuildContext context) {
    final operatedModels = tableOperation.apply(models);
    tableSource.quakeLevel = ref.watch(quakeLevelProvider);
    tableSource.constDamage = ref.watch(totalConstantDamageProvider);
    tableSource.source = operatedModels;

    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      padding: const EdgeInsets.only(top: 30, bottom: 30),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20)
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),

        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                const Spacer(),

                Expanded(
                  child: Center(
                    child: Text(
                      'Result',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: [
                      Text(
                        "Show only important defenses",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),

                      const SizedBox(width: 8),

                      Checkbox(
                        value: defenseFilter,
                        onChanged: (isChecked) {
                          if (isChecked != null && isChecked != defenseFilter) {
                            setState(() {
                              defenseFilter = isChecked;
                              defenseFilter
                                ? tableOperation.addFilter("defenseFilter", filterByDefense(FilterConditionEquals(values: defenseFilterCondition)))
                                : tableOperation.removeFilter("defenseFilter");
                            });
                          }
                      }),
                      
                      const SizedBox(width: 16),
                    ],
                  )
                )
              ]
            ),

            const SizedBox(height: 20),
            
            SfDataGrid(
              source: tableSource,
              shrinkWrapRows: true,
              columnWidthMode: ColumnWidthMode.fill,
              headerGridLinesVisibility: GridLinesVisibility.both,
              gridLinesVisibility: GridLinesVisibility.both,
              highlightRowOnHover: false,

              columns: <GridColumn>[
                GridColumn(
                  columnName: 'th',

                  label: Container(
                    color: Colors.indigo.shade100,
                    padding: const EdgeInsets.only(left: 16, right: 8),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Town Hall',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(width: 4),

                        IconButton(
                          key: _thFilterIconKey,
                          icon: const Icon(Icons.filter_alt_outlined),
                          onPressed: () async {
                            Set<int>? result = await _showHpFilterPopup(initialCondition: thFilterCondition);
                            if (result != null) {
                              setState(() {
                                thFilterCondition.clear();
                                thFilterCondition.addAll(result);

                                tableOperation.addFilter("thFilter", filterByTh(FilterConditionEquals(values: thFilterCondition)));
                              });
                            }
                          }
                        )
                      ],
                    )
                  ),
                ),

                GridColumn(
                  columnName: 'defense',
                  label: Container(
                    color: Colors.indigo.shade100,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Defense',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    )
                  ),
                )
                ,
                GridColumn(
                  columnName: 'hp',

                  label: Container(
                    color: Colors.indigo.shade100,
                    padding: const EdgeInsets.only(left: 16, right: 8),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Hitpoints',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(width: 4),

                        IconButton(
                          icon: Icon(
                            (hpSortCondition == SortOrder.noSort)
                              ? Icons.sort
                              : (hpSortCondition == SortOrder.descending)
                                ? Icons.arrow_downward
                                : Icons.arrow_upward
                          ),
                          onPressed: () {
                            setState(() {
                              _toggleHpSortCondition();
                              tableOperation.setSort(sortByHp(hpSortCondition));
                            });
                          }
                        )
                      ],
                    )
                  ),
                ),

                GridColumn(
                  columnName: 'hpC',
                  label: Container(
                    color: Colors.indigo.shade100,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerRight,
                    child: const Text(
                      '0 Quake',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    )
                  ),
                ),

                GridColumn(
                  columnName: 'hpQC',
                  label: Container(
                    color: Colors.indigo.shade100,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerRight,
                    child: const Text(
                      '1 Quake',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    )
                  ),
                ),

                GridColumn(
                  columnName: 'hpQQC',
                  label: Container(
                    color: Colors.indigo.shade100,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerRight,
                    child: const Text(
                      '2 Quake',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    )
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }

  Future<Set<int>?> _showHpFilterPopup({required Set<int> initialCondition}) async {
    final RenderBox iconRenderBox = _thFilterIconKey.currentContext!.findRenderObject() as RenderBox;
    final Offset iconPosition = iconRenderBox.localToGlobal(Offset.zero);
    final Size iconSize = iconRenderBox.size;

    final Size viewPortSize = MediaQuery.of(context).size;

    final completer = Completer<Set<int>?>();

    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) =>Stack(
        children: [
          ModalBarrier(
            onDismiss: () {
              completer.complete(null);
              overlayEntry.remove();
            }
          ),
          Positioned(
            left: iconPosition.dx + iconSize.width,
            top: min(iconPosition.dy, viewPortSize.height - 500),
            child: ThFilterPopup(
              initialCondition: initialCondition,
              onOK: (result) {
                completer.complete(result);
                overlayEntry.remove();
              },
              onCancel: () {
                completer.complete(null);
                overlayEntry.remove();
              }
            )
          )
        ],
      )
      
    );

    overlayState.insert(overlayEntry);

    return completer.future;
  }

  void _toggleHpSortCondition() {
    hpSortCondition = (hpSortCondition == SortOrder.noSort)
      ? SortOrder.descending
      : (hpSortCondition == SortOrder.descending)
        ? SortOrder.ascending
        : SortOrder.noSort;
  }
}