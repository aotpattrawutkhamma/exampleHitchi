import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/blocs/planwinding/planwinding_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/planWindingModel.dart';
import 'package:hitachi/models/planWinding/PlanWindingOutputModel.dart';
import 'package:hitachi/models/reportRouteSheet/reportRouteSheetModel.dart';
import 'package:hitachi/screens/lineElement/reportRouteSheet/page/problemPage.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PlanWinding_Screen extends StatefulWidget {
  const PlanWinding_Screen({super.key, this.onChange});
  final ValueChanged<String>? onChange;

  @override
  State<PlanWinding_Screen> createState() => _PlanWinding_ScreenState();
}

class _PlanWinding_ScreenState extends State<PlanWinding_Screen> {
  final TextEditingController batchNoController = TextEditingController();
  List<PlanWindingOutputModelPlan>? PlanWindingModel;
  PlanWindingDataSource? planwindingDataSource;
  Color? bgChange;
  String _loadData = "Load Date&Time : ";
  DatabaseHelper databaseHelper = DatabaseHelper();

  late Map<String, double> columnWidths = {
    'data': double.nan,
    'no': double.nan,
    'order': double.nan,
    'b': double.nan,
    'ipe': double.nan,
    'qty': double.nan,
    'remark': double.nan,
  };

  @override
  void initState() {
    super.initState();
    // BlocProvider.of<LineElementBloc>(context).add(
    //   ReportRouteSheetEvenet(batchNoController.text.trim()),
    // );
  }

  // PlanWindingBloc
  // PlanWindingState
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // BlocListener<PlanWindingBloc, PlanWindingState>(
        BlocListener<PlanWindingBloc, PlanWindingState>(
          listener: (context, state) {
            if (state is PlanWindingLoadingState) {
              EasyLoading.show();
            }
            if (state is PlanWindingLoadedState) {
              EasyLoading.dismiss();
              setState(() {
                PlanWindingModel = state.item.PLAN;
                planwindingDataSource =
                    PlanWindingDataSource(PLAN: PlanWindingModel);
              });
            }
            if (state is PlanWindingErrorState) {
              EasyLoading.dismiss();
              EasyLoading.showError("Check Connection",
                  duration: Duration(seconds: 5));
              // print(state.error);
            }
          },
        )
      ],
      child: BgWhite(
        isHideAppBar: true,
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                child: Label(_loadData),
              ),
              SizedBox(
                height: 5,
              ),
              planwindingDataSource != null
                  ? Expanded(
                      flex: 5,
                      child: Container(
                        child: SfDataGrid(
                          footerHeight: 10,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          source: planwindingDataSource!,
                          columnWidthMode: ColumnWidthMode.fill,
                          allowPullToRefresh: true,
                          allowColumnsResizing: true,
                          onColumnResizeUpdate:
                              (ColumnResizeUpdateDetails details) {
                            setState(() {
                              columnWidths[details.column.columnName] =
                                  details.width;
                              print(details.width);
                            });
                            return true;
                          },
                          columns: [
                            GridColumn(
                              width: columnWidths['data']!,
                              columnName: 'data',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'Data',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['no']!,
                              columnName: 'no',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'No.',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['order']!,
                              columnName: 'order',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'Order',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['b']!,
                              columnName: 'b',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'B',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['ipe']!,
                              columnName: 'ipe',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'IPE',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['qty']!,
                              columnName: 'qty',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'QTY',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['remark']!,
                              columnName: 'remark',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'Remark',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Visibility(
                          visible: true,
                          child: Container(
                              child: Label(
                            " ",
                            color: COLOR_RED,
                          )),
                        ),
                      ],
                    ),
              Container(
                child: Button(
                  height: 40,
                  // bgColor: bgChange ?? Colors.grey,
                  text: Label(
                    "Load Plan",
                    color: COLOR_WHITE,
                  ),
                  onPress: () => _loadPlan(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _loadPlan() {
    _loadData = "Load Date&Time : " +
        DateFormat('yyyy MM dd HH:mm:ss').format(DateTime.now()).toString();
    BlocProvider.of<PlanWindingBloc>(context).add(
      PlanWindingSendEvent(),
    );
    // widget.onChange!(batchNoController.text.trim());
  }
}

class PlanWindingDataSource extends DataGridSource {
  PlanWindingDataSource({List<PlanWindingOutputModelPlan>? PLAN}) {
    if (PLAN != null) {
      databaseHelper.deleteDataAllFromSQLite(tableName: 'PLAN_WINDING_SHEET');
      for (var _item in PLAN) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<String>(
                  columnName: 'data', value: _item.WDGDATEPLANS),
              DataGridCell<int>(columnName: 'no', value: _item.ORDER),
              DataGridCell<String>(columnName: 'order', value: _item.ORDERNO),
              DataGridCell<String>(columnName: 'b', value: _item.BATCH),
              DataGridCell<int>(columnName: 'ipe', value: _item.IPECODE),
              DataGridCell<int>(columnName: 'qty', value: _item.WDGQTYPLAN),
              DataGridCell<String>(
                  columnName: 'remark', value: _item.NOTE ?? ""),
            ],
          ),
        );
        databaseHelper.insertSqlite('PLAN_WINDING_SHEET', {
          'PlanDate': _item.WDGDATEPLANS,
          'OrderPlan': _item.ORDER,
          'OrderNo': _item.ORDERNO,
          'Batch': _item.BATCH,
          'IPE': _item.IPECODE,
          'Qty': _item.WDGQTYPLAN,
          'Note': _item.NOTE,
        });
      }
    } else {
      EasyLoading.showError("Can not Call API");

      _getPlanWindingSheet();
    }
  }

  List<DataGridRow> _employees = [];
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  List<DataGridRow> get rows => _employees;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (dataGridCell) {
          return Container(
            alignment: (dataGridCell.columnName == 'id' ||
                    dataGridCell.columnName == 'qty')
                ? Alignment.center
                : Alignment.center,
            child: Text(dataGridCell.value.toString()),
          );
        },
      ).toList(),
    );
  }

  Future<List<PlanWindingSQLiteModel>> _getPlanWindingSheet() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('PLAN_WINDING_SHEET');
      List<PlanWindingSQLiteModel> result = rows
          // .where((row) => row['Status'] == 'P')
          .map((row) => PlanWindingSQLiteModel.fromMap(row))
          .toList();

      for (var _item in result) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'data', value: _item.PLANDATE),
              DataGridCell<String>(columnName: 'no', value: _item.ORDERNO),
              DataGridCell<String>(columnName: 'order', value: _item.ORDERNO),
              DataGridCell<String>(columnName: 'b', value: _item.BATCH),
              DataGridCell<String>(columnName: 'ipe', value: _item.IPE),
              DataGridCell<String>(columnName: 'qty', value: _item.QTY),
              DataGridCell<String>(columnName: 'remark', value: _item.NOTE),
            ],
          ),
        );
      }

      return result;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
