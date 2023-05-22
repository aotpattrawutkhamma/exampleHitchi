// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:hitachi/helper/background/bg_white.dart';
// import 'package:hitachi/helper/colors/colors.dart';
// import 'package:hitachi/helper/input/boxInputField.dart';
// import 'package:hitachi/helper/text/label.dart';
// import 'package:hitachi/models-Sqlite/windingSheetModel.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
//
// class PMDaily_Screen extends StatefulWidget {
//   const PMDaily_Screen({Key? key}) : super(key: key);
//
//   @override
//   State<PMDaily_Screen> createState() => _PMDaily_ScreenState();
// }
//
// class _PMDaily_ScreenState extends State<PMDaily_Screen> {
//   // DataSource? employeeDataSource;
//   final TextEditingController OperatorName = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return BgWhite(
//       isHidePreviour: true,
//       textTitle: "PMDaily_Screen",
//       body: Container(
//         padding: EdgeInsets.all(15),
//         child: Column(
//           children: [
//             Container(
//               child: BoxInputField(
//                 labelText: "Operator Name",
//                 type: TextInputType.number,
//                 maxLength: 12,
//                 controller: OperatorName,
//                 onChanged: (value) {},
//               ),
//             ),
//             Container(
//               child: BoxInputField(
//                 labelText: "Check Point",
//                 type: TextInputType.number,
//                 maxLength: 12,
//                 controller: OperatorName,
//                 onChanged: (value) {},
//               ),
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             // employeeDataSource != null
//             //     ? Expanded(
//             //         flex: 5,
//             //         child:
//             Container(
//               child: SfDataGrid(
//                 footerHeight: 10,
//                 gridLinesVisibility: GridLinesVisibility.both,
//                 headerGridLinesVisibility: GridLinesVisibility.both,
//                 source: employeeDataSource!,
//                 columnWidthMode: ColumnWidthMode.fill,
//                 columns: [
//                   GridColumn(
//                     width: 120,
//                     columnName: 'id',
//                     label: Container(
//                       color: COLOR_BLUE_DARK,
//                       child: Center(
//                         child: Label(
//                           'ID',
//                           color: COLOR_WHITE,
//                         ),
//                       ),
//                     ),
//                   ),
//                   GridColumn(
//                     columnName: 'qty',
//                     label: Container(
//                       color: COLOR_BLUE_DARK,
//                       child: Center(
//                         child: Label(
//                           'Qty',
//                           color: COLOR_WHITE,
//                         ),
//                       ),
//                     ),
//                   ),
//                   GridColumn(
//                     width: 120,
//                     columnName: 'name',
//                     label: Container(
//                       color: COLOR_BLUE_DARK,
//                       child: Center(
//                         child: Label(
//                           'Proc',
//                           color: COLOR_WHITE,
//                         ),
//                       ),
//                     ),
//                   ),
//                   GridColumn(
//                     width: 120,
//                     columnName: 'startDate',
//                     label: Container(
//                       color: COLOR_BLUE_DARK,
//                       child: Center(
//                         child: Label(
//                           'start Date',
//                           color: COLOR_WHITE,
//                         ),
//                       ),
//                     ),
//                   ),
//                   GridColumn(
//                     width: 120,
//                     columnName: 'startTime',
//                     label: Container(
//                       color: COLOR_BLUE_DARK,
//                       child: Center(
//                         child: Label(
//                           'Start Time',
//                           color: COLOR_WHITE,
//                         ),
//                       ),
//                     ),
//                   ),
//                   GridColumn(
//                     width: 120,
//                     columnName: 'FINISH_DATE',
//                     label: Container(
//                       color: COLOR_BLUE_DARK,
//                       child: Center(
//                         child: Label(
//                           'End Date',
//                           color: COLOR_WHITE,
//                         ),
//                       ),
//                     ),
//                   ),
//                   GridColumn(
//                     width: 120,
//                     columnName: 'FINISH_TIME',
//                     label: Container(
//                       color: COLOR_BLUE_DARK,
//                       child: Center(
//                         child: Label(
//                           'End Time',
//                           color: COLOR_WHITE,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // )
//             // : Container(
//             //     child: Label(" กรุณากรอกข้อมูล"),
//             //   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // class DataSource extends DataGridSource {
// //   WindingsDataSource({List<WindingSheetModel>? process}) {
// //     if (process != null) {
// //       for (var _item in process) {
// //         _employees.add(
// //           DataGridRow(
// //             cells: [
// //               DataGridCell<int>(columnName: 'id', value: _item.ELEMENT),
// //               DataGridCell<String>(
// //                   columnName: 'name', value: _item.BATCH_END_DATE),
// //               DataGridCell<String>(
// //                   columnName: 'startDate', value: _item.BATCH_END_DATE),
// //               DataGridCell<String>(
// //                   columnName: 'startTime', value: _item.BATCH_END_DATE),
// //               DataGridCell<String>(
// //                   columnName: 'FINISH_DATE', value: _item.BATCH_END_DATE),
// //               DataGridCell<String>(
// //                   columnName: 'FINISH_TIME', value: _item.BATCH_END_DATE),
// //               DataGridCell<int>(columnName: 'qty', value: _item.ELEMENT),
// //             ],
// //           ),
// //         );
// //       }
// //     } else {
// //       EasyLoading.showError("Can not Call API");
// //     }
// //   }
// //
// //   List<DataGridRow> _employees = [];
// //
// //   @override
// //   List<DataGridRow> get rows => _employees;
// //
// //   @override
// //   DataGridRowAdapter? buildRow(DataGridRow row) {
// //     return DataGridRowAdapter(
// //       cells: row.getCells().map<Widget>(
// //         (dataGridCell) {
// //           return Container(
// //             alignment: (dataGridCell.columnName == 'id' ||
// //                     dataGridCell.columnName == 'qty')
// //                 ? Alignment.center
// //                 : Alignment.center,
// //             child: Text(dataGridCell.value.toString()),
// //           );
// //         },
// //       ).toList(),
// //     );
// //   }
// // }
