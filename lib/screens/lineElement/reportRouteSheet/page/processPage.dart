import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/reportRouteSheet/reportRouteSheetModel.dart';
import 'package:hitachi/screens/lineElement/reportRouteSheet/page/problemPage.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ProcessPage extends StatefulWidget {
  const ProcessPage({super.key, this.onChange, this.receiveValue});
  final ValueChanged<String>? onChange;
  final String? receiveValue;

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  final TextEditingController batchNoController = TextEditingController();
  List<ReportRouteSheetModelProcess>? reportRouteSheetModel;
  EmployeeDataSource? employeeDataSource;
  String? originalValue;
  String trimmedValue = "";
  String valueCon = "456456";
  final f1 = FocusNode();
  @override
  void initState() {
    f1.requestFocus();
    batchNoController.text = widget.receiveValue ?? "";
    super.initState();
  }

  Map<String, double> columnWidths = {
    'id': double.nan,
    'proc': double.nan,
    'qty': double.nan,
    'startDate': double.nan,
    'startTime': double.nan,
    'EndDate': double.nan,
    'EndTime': double.nan,
  };

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LineElementBloc, LineElementState>(
          listener: (context, state) {
            if (state is GetReportRuteSheetLoadingState) {
              EasyLoading.show();
            }
            if (state is GetReportRuteSheetLoadedState) {
              EasyLoading.dismiss();
              setState(() {
                reportRouteSheetModel = state.item.PROCESS;
                employeeDataSource =
                    EmployeeDataSource(process: reportRouteSheetModel);
              });
            }
            if (state is GetReportRuteSheetErrorState) {
              EasyLoading.dismiss();
              EasyLoading.showError("Check Connection",
                  duration: Duration(seconds: 5));
              print(state.error);
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
                child: BoxInputField(
                  focusNode: f1,
                  labelText: "Batch No",
                  type: TextInputType.number,
                  maxLength: 12,
                  controller: batchNoController,
                  onEditingComplete: () {
                    if (batchNoController.text.length == 12) {
                      BlocProvider.of<LineElementBloc>(context).add(
                        ReportRouteSheetEvenet(batchNoController.text.trim()),
                      );
                      setState(() {
                        originalValue = batchNoController.text;
                      });
                      print("CheckValue ${originalValue}");

                      widget.onChange!(batchNoController.text.trim());
                    } else {
                      EasyLoading.showError("Please Input Batch No.");
                    }
                  },
                  // onChanged: (value) {
                  //   if (value.length >= 12) {}
                  // },
                ),
              ),
              SizedBox(
                height: 5,
              ),
              employeeDataSource != null
                  ? Expanded(
                      flex: 5,
                      child: Container(
                        child: SfDataGrid(
                          footerHeight: 10,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          source: employeeDataSource!,
                          columnWidthMode: ColumnWidthMode.fill,
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
                          columnResizeMode: ColumnResizeMode.onResizeEnd,
                          columns: [
                            GridColumn(
                              width: columnWidths['id']!,
                              columnName: 'id',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'ID',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['proc']!,
                              columnName: 'proc',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'Proc',
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
                                    'Qty',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['startDate']!,
                              columnName: 'startDate',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'Start Date',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['startTime']!,
                              columnName: 'startTime',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'start Time',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['EndDate']!,
                              columnName: 'EndDate',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'End Date',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: columnWidths['EndTime']!,
                              columnName: 'EndTime',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                  child: Label(
                                    'End Time',
                                    color: COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      child: Label(" Please input BatchNo"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({List<ReportRouteSheetModelProcess>? process}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<int>(columnName: 'id', value: _item.ORDER),
              DataGridCell<String>(columnName: 'proc', value: _item.PROCESS),
              DataGridCell<int>(columnName: 'qty', value: _item.AMOUNT),
              DataGridCell<String>(
                  columnName: 'startDate', value: _item.START_DATE),
              DataGridCell<String>(
                  columnName: 'startTime', value: _item.START_TIME),
              DataGridCell<String>(
                  columnName: 'EndDate', value: _item.FINISH_DATE),
              DataGridCell<String>(
                  columnName: 'EndTime', value: _item.FINISH_TIME),
            ],
          ),
        );
      }
    } else {
      EasyLoading.showError("Can not Call API");
    }
  }

  List<DataGridRow> _employees = [];

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
}
