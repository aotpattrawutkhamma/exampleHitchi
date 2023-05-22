import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/input/rowBoxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/reportRouteSheet/reportRouteSheetModel.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PlanWinding_Screen extends StatefulWidget {
  const PlanWinding_Screen({super.key});

  @override
  State<PlanWinding_Screen> createState() => _PlanWinding_ScreenState();
}

class _PlanWinding_ScreenState extends State<PlanWinding_Screen> {
  @override
  Widget build(BuildContext context) {
    return BgWhite(
      textTitle: "Plan Winding",
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            RowBoxInputField(
              labelText: "Load Date and Time :",
            )
          ],
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
              DataGridCell<int>(columnName: 'date', value: _item.ORDER),
              DataGridCell<String>(columnName: 'no', value: _item.PROCESS),
              DataGridCell<String>(
                  columnName: 'order', value: _item.START_DATE),
              DataGridCell<String>(
                  columnName: 'batch', value: _item.START_TIME),
              DataGridCell<String>(columnName: 'ipe', value: _item.FINISH_DATE),
              DataGridCell<String>(columnName: 'qty', value: _item.FINISH_TIME),
              DataGridCell<int>(columnName: 'remark', value: _item.AMOUNT),
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
