import 'package:coc_calculater/model/defense_model.dart';
import 'package:coc_calculater/state/const.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DefenseTableSource extends DataGridSource {
  List<DefenseModel> _source;

  set source(List<DefenseModel> value) {
    if (_source != value) {
      _source = value;
      _rows = _makeRows(_source);
      notifyListeners();
    }
  }

  List<DataGridRow> _rows = [];

  @override
  List<DataGridRow> get rows => _rows;

  String _display(String defense, int level) => '$defense (Lv $level)';

  int _quakeLevel;
  set quakeLevel(int value) {
    if (value != _quakeLevel) {
      _quakeLevel = value;
      notifyListeners();
    }
  }

  double get _quakeRatio => earthquakeMap[_quakeLevel] ?? 0;

  int _constDamage;
  set constDamage(int value) {
    if (value != _constDamage) {
      _constDamage = value;
      notifyListeners();
    }
  }

  int _hpC(int hp) => hp - _constDamage;
  int _hpQC(int hp) => (hp * _quakeRatio).toInt() - _constDamage;
  int _hpQQC(int hp) =>
      ((hp * _quakeRatio).toInt() * _quakeRatio).toInt() - _constDamage;

  DefenseTableSource(
      {required List<DefenseModel> source,
      required int quakeLevel,
      required int constDamage})
      : _source = source,
        _quakeLevel = quakeLevel,
        _constDamage = constDamage {
    _rows = _makeRows(_source);
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final isEvenRow = (effectiveRows.indexOf(row) % 2 == 0);

    return DataGridRowAdapter(
        color: isEvenRow ? Colors.transparent : Colors.blueGrey.shade100,
        cells: row.getCells().map<Widget>((dataCell) {
          if (dataCell.columnName == 'th') {
            final th = dataCell.value.th[0].toString();
            final bool isMax = dataCell.value.th.length > 1;

            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerRight,
                child: Text(
                  th,
                  style: TextStyle(
                      color: isMax ? Colors.indigoAccent : null, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ));
          } else if (dataCell.columnName == 'defense') {
            final defense =
                _display(dataCell.value.defense, dataCell.value.level);
            final int supercharge = dataCell.value.supercharge;

            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      defense,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    ...List.generate(supercharge, (_) {
                      return Image.asset('assets/Icon_Supercharge.webp',
                          width: 12, height: 12);
                    })
                  ],
                ));
          } else if (dataCell.columnName == 'hp') {
            final hp = dataCell.value.hp;

            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerRight,
                child: Text(hp.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16)));
          } else if (dataCell.columnName == 'hpC') {
            final hpC = _hpC(dataCell.value.hp);

            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerRight,
                child: Text(
                  hpC.toString(),
                  style: TextStyle(
                      color: hpC >= 0 ? Colors.indigoAccent : Colors.red,
                      fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ));
          } else if (dataCell.columnName == 'hpQC') {
            final hpQC = _hpQC(dataCell.value.hp);

            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerRight,
                child: Text(
                  hpQC.toString(),
                  style: TextStyle(
                      color: hpQC >= 0 ? Colors.indigoAccent : Colors.red,
                      fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ));
          } else {
            final hpQQC = _hpQQC(dataCell.value.hp);

            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerRight,
                child: Text(
                  hpQQC.toString(),
                  style: TextStyle(
                      color: hpQQC >= 0 ? Colors.indigoAccent : Colors.red,
                      fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ));
          }
        }).toList());
  }

  List<DataGridRow> _makeRows(List<DefenseModel> source) => source
      .map<DataGridRow>((data) => DataGridRow(cells: [
            DataGridCell(columnName: 'th', value: data),
            DataGridCell(columnName: 'defense', value: data),
            DataGridCell(columnName: 'hp', value: data),
            DataGridCell(columnName: 'hpC', value: data),
            DataGridCell(columnName: 'hpQC', value: data),
            DataGridCell(columnName: 'hpQQC', value: data)
          ]))
      .toList();
}
