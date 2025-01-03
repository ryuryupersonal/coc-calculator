import 'package:coc_calculater/model/defense_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DefenseDataGridSource extends DataGridSource {
  final List<DefenseModel> rawRowsData;
  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  int _quakeLevel;
  set quakeLevel(int value) {
    _quakeLevel = value;
    dataGridRows = _makeDataGridRows();
    notifyListeners();
  }

  double get _quakeRatio => [0.855, 0.83, 0.79, 0.75, 0.71][_quakeLevel - 1];

  int _constDamage;
  set constDamage(int value) {
    _constDamage = value;
    dataGridRows = _makeDataGridRows();
    notifyListeners();
  }

  int _hpC(int hp) => hp - _constDamage;
  int _hpQC(int hp) => (hp * _quakeRatio).toInt() - _constDamage ;
  int _hpQQC(int hp) => ((hp * _quakeRatio).toInt() * _quakeRatio).toInt() - _constDamage;
  

  DefenseDataGridSource({
    required this.rawRowsData,
    required int quakeLevel,
    required int constDamage
  })
  : _quakeLevel = quakeLevel,
    _constDamage = constDamage
  {
    dataGridRows = _makeDataGridRows();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        if (dataCell.columnName == 'th' || dataCell.columnName == 'hp') {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerRight,
            child: Text(
              dataCell.value.toString(),
              overflow: TextOverflow.ellipsis,
            )
          );
        } else if (dataCell.columnName == 'hpC' || dataCell.columnName == 'hpQC' || dataCell.columnName == 'hpQQC') {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerRight,
            child: Text(
              dataCell.value.toString(),
              style: TextStyle(
                color: dataCell.value >= 0 ? Colors.red : Colors.indigoAccent
              ),
              overflow: TextOverflow.ellipsis,
            )
          );
        } else if (dataCell.columnName == 'display') {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              dataCell.value.toString(),
              overflow: TextOverflow.ellipsis,
            )
          );
        }
        return const Text('error');
      }).toList()
    );
  }

  final _impDefenseList = [
      'Town Hall',
      'Firespitter',
      'Multi-Archer Tower',
      'Ricochet Cannon',
      'Monolith',
      'Scattershot',
      'Inferno Tower',
      'X-Bow',
      'Clan Castle'
    ];

  void addImpDefenseFilter() {
    for (var defense in _impDefenseList) {
      addFilter(
        'defense',
        FilterCondition(
          type: FilterType.equals,
          value: defense
        ));
    }
  }

  void removeImpDefenseFilter() {
    clearFilters(columnName: 'Defense');
  }

  List<DataGridRow> _makeDataGridRows() => rawRowsData.map<DataGridRow>(
    (data) => DataGridRow(
      cells: [
        DataGridCell(columnName: 'defense', value: data.defense), //for filter only
        DataGridCell<int>(columnName: 'th', value: data.th),
        DataGridCell<String>(columnName: 'display', value: data.display),
        DataGridCell<int>(columnName: 'hp', value: data.hp),
        DataGridCell(columnName: 'hpC', value: _hpC(data.hp)),
        DataGridCell(columnName: 'hpQC', value: _hpQC(data.hp)),
        DataGridCell(columnName: 'hpQQC', value: _hpQQC(data.hp)),
      ],
    ),
  ).toList();
}