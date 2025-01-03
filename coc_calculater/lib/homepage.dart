import 'package:coc_calculater/model/defense_data_grid_source.dart';
import 'package:coc_calculater/provider.dart';
import 'package:coc_calculater/ui/damages_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

final _quakeLevelProvider = StateProvider<int>((ref) => 5);

final _totalConstantDamageProvider = Provider<int>((ref) {
  final damageModels = ref.watch(damageModelProvider);

  return damageModels.fold<int>(0, (sum, model) => sum + ref.watch(damageCardNotifierProvider(model)).damage);
});

final _impDefenseFilterCheckBox = StateProvider<bool>((ref) => false);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final damageModels = ref.watch(damageModelProvider);
    final defenseModels = ref.watch(defenseModelProvider);

    final isImpDefenseFilterApplied = ref.watch(_impDefenseFilterCheckBox);

    final defenceDataGridSource = DefenseDataGridSource(rawRowsData: defenseModels, quakeLevel: 5, constDamage: 0);
    defenceDataGridSource.quakeLevel = ref.watch(_quakeLevelProvider);
    defenceDataGridSource.constDamage = ref.watch(_totalConstantDamageProvider);

    ref.listen<bool>(_impDefenseFilterCheckBox, (previous, next) {
      if (next) {
        defenceDataGridSource.addImpDefenseFilter();
      } else {
        defenceDataGridSource.removeImpDefenseFilter();
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('COC Calculator'),
        backgroundColor: Colors.white,
        elevation: 2,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;

          if (width >= 0) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  // Constant Damage Container
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20)
                    ),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),

                      child: Column(
                        children: [
                          Text(
                            'Constant Damage',
                            style: Theme.of(context).textTheme.titleLarge
                          ),

                          const SizedBox(height: 8),

                          SizedBox(
                            height: 310,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: damageModels.length,
                              itemBuilder: (context, index) => DamageCard(model: damageModels[index])
                            )
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total :',
                                style: Theme.of(context).textTheme.titleLarge
                              ),

                              const SizedBox(width: 8),

                              Image.asset(
                                'assets/Damage.webp',
                                width: 24,
                                height: 24
                              ),

                              const SizedBox(width: 8),
                      
                              Text(
                                ref.watch(_totalConstantDamageProvider).toString(),
                                style: Theme.of(context).textTheme.titleLarge
                              )
                            ],
                          )
                        ]
                      )
                    )
                  ),

                  // Table Container
                  Container(
                    margin: const EdgeInsets.all(12),
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
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    'Result',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 1,

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,

                                  children: [
                                    const Text(
                                      'Show only important Defenses : ',
                                    ),

                                    const SizedBox(width: 8),
                                    
                                    Checkbox(
                                      value: isImpDefenseFilterApplied,
                                      onChanged: (bool? value) {
                                        ref.read(_impDefenseFilterCheckBox.notifier).state = value!;
                                      }
                                    ),

                                    const SizedBox(width: 16)
                                  ],
                                )
                              )
                            ],
                          ),

                          const SizedBox(height: 20),

                          SfDataGrid(
                            source: defenceDataGridSource,
                            shrinkWrapRows: true,
                            columnWidthMode: ColumnWidthMode.fill,
                            allowFiltering: true,
                            allowSorting: true,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            gridLinesVisibility: GridLinesVisibility.both,

                            columns: <GridColumn>[
                              GridColumn(
                                columnName: 'defense',
                                label: const Text(''),
                                visible: false
                              ),

                              GridColumn(
                                columnName: 'th',
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  alignment: Alignment.centerRight,
                                  child: const Text(
                                    'Town Hall',
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ),
                                allowSorting: false,
                                filterPopupMenuOptions: const FilterPopupMenuOptions(
                                  filterMode: FilterMode.checkboxFilter,
                                  canShowSortingOptions: false,
                                  showColumnName: false
                                )
                              ),

                              GridColumn(
                                columnName: 'display',
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    'Defense',
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ),
                                allowFiltering: false,
                                allowSorting: false
                              )
                              ,
                              GridColumn(
                                columnName: 'hp',
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  alignment: Alignment.centerRight,
                                  child: const Text(
                                    'Hitpoints',
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ),
                                allowFiltering: false
                              ),

                              GridColumn(
                                columnName: 'hpC',
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  alignment: Alignment.centerRight,
                                  child: const Text(
                                    '0 Quake',
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ),
                                allowFiltering: false,
                                allowSorting: false
                              ),

                              GridColumn(
                                columnName: 'hpQC',
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  alignment: Alignment.centerRight,
                                  child: const Text(
                                    '1 Quake',
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ),
                                allowFiltering: false,
                                allowSorting: false
                              ),

                              GridColumn(
                                columnName: 'hpQQC',
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  alignment: Alignment.centerRight,
                                  child: const Text(
                                    '2 Quake',
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ),
                                allowFiltering: false,
                                allowSorting: false
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  )
                ]
              )
            );
          }

          return const Center(
            child: Text('Screen width is too small to display content'),
          );
        },
      )
    );
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget tabletBody;
  final Widget desktopBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.tabletBody,
    required this.desktopBody,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return mobileBody;
    } else if (width < 1200) {
      return tabletBody;
    } else {
      return desktopBody;
    }
  }
}
