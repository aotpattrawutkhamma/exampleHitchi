import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/filmReceive/film_receive_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models-Sqlite/dataSheetModel.dart';
import 'package:hitachi/models/filmReceiveModel/filmreceiveOutputModel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../services/databaseHelper.dart';

class FilmReceiveHoldScreen extends StatefulWidget {
  const FilmReceiveHoldScreen({super.key});

  @override
  State<FilmReceiveHoldScreen> createState() => _FilmReceiveHoldScreenState();
}

class _FilmReceiveHoldScreenState extends State<FilmReceiveHoldScreen> {
  final TextEditingController password = TextEditingController();
  FilmReceiveDataSource? filmDataSource;
  List<DataSheetTableModel>? dstSqliteModel;
  List<DataSheetTableModel> dstList = [];
  int? index;
  int? allRowIndex;
  List<DataSheetTableModel> selectAll = [];

  DataGridRow? datagridRow;
  bool isClick = false;
  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;
  bool isHidewidget = false;

  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  void initState() {
    super.initState();

    _getFilmReceive().then((result) {
      setState(() {
        dstList = result;
        filmDataSource = FilmReceiveDataSource(process: dstList);
        print(dstList);
      });
    });
  }

  Future<List<DataSheetTableModel>> _getFilmReceive() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('DATA_SHEET');
      List<DataSheetTableModel> result = rows
          .map((row) => DataSheetTableModel.fromMap(
              row.map((key, value) => MapEntry(key, value.toString()))))
          .toList();

      return result;
    } catch (e, s) {
      print(e);
      print(s);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FilmReceiveBloc, FilmReceiveState>(
          listener: (context, state) {
            if (state is FilmReceiveLoadingState) {
              EasyLoading.show();
            }
            if (state is FilmReceiveLoadedState) {
              if (state.item.RESULT == true) {
                deletedInfo();
                Navigator.pop(context);
                EasyLoading.showSuccess("Send complete",
                    duration: Duration(seconds: 3));
              } else {
                EasyLoading.showError("Please Check Data");
              }
            }
            if (state is FilmReceiveErrorState) {
              EasyLoading.showError("Can not send");
            }
          },
        )
      ],
      child: BgWhite(
        isHideAppBar: true,
        textTitle: "Winding job Start(Hold)",
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              filmDataSource != null
                  ? Expanded(
                      child: Container(
                        child: SfDataGrid(
                          source: filmDataSource!,
                          // columnWidthMode: ColumnWidthMode.fill,
                          showCheckboxColumn: true,
                          selectionMode: SelectionMode.multiple,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          gridLinesVisibility: GridLinesVisibility.both,
                          onSelectionChanged:
                              (selectRow, deselectedRows) async {
                            if (selectRow.isNotEmpty) {
                              if (selectRow.length ==
                                  filmDataSource!.effectiveRows.length) {
                                print("all");
                                setState(() {
                                  selectRow.forEach((row) {
                                    allRowIndex = filmDataSource!.effectiveRows
                                        .indexOf(row);

                                    _colorSend = COLOR_SUCESS;
                                    _colorDelete = COLOR_RED;
                                  });
                                });
                              } else if (selectRow.length !=
                                  filmDataSource!.effectiveRows.length) {
                                setState(() {
                                  selectRow.forEach((element) {
                                    index = selectRow.isNotEmpty
                                        ? filmDataSource!.effectiveRows
                                            .indexOf(element)
                                        : null;
                                    datagridRow = filmDataSource!.effectiveRows
                                        .elementAt(index!);
                                    dstSqliteModel = datagridRow!
                                        .getCells()
                                        .map(
                                          (e) => DataSheetTableModel(),
                                        )
                                        .toList();
                                  });
                                  if (!selectAll.contains(dstList[index!])) {
                                    selectAll.add(dstList[index!]);
                                    print(selectAll.length);
                                  }
                                  _colorSend = COLOR_SUCESS;
                                  _colorDelete = COLOR_RED;
                                });
                              }
                            } else {
                              setState(() {
                                if (selectAll.contains(dstList[index!])) {
                                  selectAll.remove(dstList[index!]);
                                  print(selectAll.length);
                                }
                               if (selectAll.isEmpty) {
                                  _colorSend = Colors.grey;
                                  _colorDelete = Colors.grey;
                                }
                              });

                              print('No Rows Selected');
                            }
                          },
                          // onCellTap: (details) async {
                          //   if (details.rowColumnIndex.rowIndex != 0) {
                          //     setState(() {
                          //       index = details.rowColumnIndex.rowIndex - 1;
                          //       datagridRow = filmDataSource!.effectiveRows
                          //           .elementAt(index!);
                          //       dstSqliteModel = datagridRow!
                          //           .getCells()
                          //           .map(
                          //             (e) => DataSheetTableModel(
                          //                 PO_NO: e.value.toString()),
                          //           )
                          //           .toList();
                          //       _colorSend = COLOR_SUCESS;
                          //       _colorDelete = COLOR_RED;
                          //     });
                          //   }
                          // },
                          columns: <GridColumn>[
                            GridColumn(
                                columnName: 'pono',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'PO No.',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                  // color: COLOR_BLUE_DARK,
                                )),
                            GridColumn(
                              columnName: 'ivno',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                    child: Label(
                                  'Invoice No.',
                                  textAlign: TextAlign.center,
                                  fontSize: 14,
                                  color: COLOR_WHITE,
                                )),
                              ),
                            ),
                            GridColumn(
                                columnName: 'fi',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Freight',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                ),
                                width: 100),
                            GridColumn(
                                columnName: 'ic',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Incoing',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                ),
                                width: 100),
                            GridColumn(
                                columnName: 'sb',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'StoreBy',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'packno',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'PackNo.',
                                    textAlign: TextAlign.center,
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'sd',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Store Date',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'status',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Status',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'w1',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'w1',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'w2',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'w2',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'Weight',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Weight',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'md',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Mfg.Date',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'tn',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Thickness',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'wg',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Wrap Grade',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                            GridColumn(
                                columnName: 'rn',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'Roll No.',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                )),
                          ],
                        ),
                      ),
                    )
                  : CircularProgressIndicator(),
              dstSqliteModel != null
                  ? Expanded(
                      child: Container(
                          child: ListView(
                        children: [
                          DataTable(
                              horizontalMargin: 20,
                              headingRowHeight: 30,
                              dataRowHeight: 30,
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => COLOR_BLUE_DARK),
                              border: TableBorder.all(
                                width: 1.0,
                                color: COLOR_BLACK,
                              ),
                              columns: [
                                DataColumn(
                                  numeric: true,
                                  label: Label(
                                    "",
                                    color: COLOR_BLUE_DARK,
                                  ),
                                ),
                                DataColumn(label: Label(""))
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(Center(child: Label("PO no."))),
                                  DataCell(
                                      Label("${dstList[index!].PO_NO ?? ""}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Invoice No."))),
                                  DataCell(Label("${dstList[index!].IN_VOICE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(
                                      Center(child: Label("Incoming Date"))),
                                  DataCell(
                                      Label("${dstList[index!].INCOMING_DATE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Store By"))),
                                  DataCell(Label("${dstList[index!].STORE_BY}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Pack No"))),
                                  DataCell(Label("${dstList[index!].PACK_NO}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Store Date"))),
                                  DataCell(
                                      Label("${dstList[index!].STORE_DATE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Status"))),
                                  DataCell(Label("${dstList[index!].STATUS}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Weight1"))),
                                  DataCell(Label("${dstList[index!].W1}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Weight2"))),
                                  DataCell(Label("${dstList[index!].W2}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Weight"))),
                                  DataCell(Label("${dstList[index!].WEIGHT}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Mfg.date"))),
                                  DataCell(Label("${dstList[index!].MFG_DATE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Thickness"))),
                                  DataCell(
                                      Label("${dstList[index!].THICKNESS}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Wrap Grade"))),
                                  DataCell(
                                      Label("${dstList[index!].WRAP_GRADE}"))
                                ]),
                                DataRow(cells: [
                                  DataCell(Center(child: Label("Roll No."))),
                                  DataCell(Label("${dstList[index!].ROLL_NO}"))
                                ]),
                              ])
                        ],
                      )),
                    )
                  : Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Label(
                              "No data",
                              color: COLOR_RED,
                              fontSize: 30,
                            ),
                            CircularProgressIndicator()
                          ],
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: Button(
                    onPress: () {
                      if (dstSqliteModel != null) {
                        _AlertDialog();
                      } else {
                        _selectData();
                      }
                    },
                    text: Label(
                      "Delete",
                      color: COLOR_WHITE,
                    ),
                    bgColor: _colorDelete,
                  )),
                  Expanded(child: Container()),
                  Expanded(
                      child: Button(
                    text: Label("Send", color: COLOR_WHITE),
                    bgColor: _colorSend,
                    onPress: () {
                      if (dstList.isNotEmpty) {
                        _sendDataServer();
                      } else {
                        EasyLoading.showInfo("Please Select Data");
                      }
                    },
                  )),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void deletedInfo() async {
    if (index != null) {
      for (var row in selectAll) {
        await databaseHelper.deletedRowSqlite(
            tableName: 'DATA_SHEET', columnName: 'ID', columnValue: row.ID);
      }
    } else if (allRowIndex != null) {
      for (var row in dstList) {
        await databaseHelper.deletedRowSqlite(
            tableName: 'DATA_SHEET', columnName: 'ID', columnValue: row.ID);
      }
    }
  }

  void _AlertDialog() async {
    // EasyLoading.showError("Error[03]", duration: Duration(seconds: 5));//if password
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child:
                  Label("Do you want Delete \n Po No ${dstList[index!].PO_NO}"),
            ),
          ],
        ),

        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              deletedInfo();

              Navigator.pop(context);
              Navigator.pop(context);
              EasyLoading.showSuccess("Delete Success");
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _sendDataServer() async {
    if (index != null) {
      for (var row in selectAll) {
        BlocProvider.of<FilmReceiveBloc>(context).add(
          FilmReceiveSendEvent(
            FilmReceiveOutputModel(
              PONO: row.PO_NO,
              INVOICE: row.IN_VOICE,
              FRIEGHT: row.FRIEGHT,
              DATERECEIVE: row.INCOMING_DATE,
              OPERATORNAME: int.tryParse(row.STORE_BY.toString()),
              PACKNO: row.PACK_NO,
              STATUS: row.STATUS,
              WEIGHT1: num.tryParse(row.W1.toString()),
              WEIGHT2: num.tryParse(row.W2.toString()),
              MFGDATE: row.MFG_DATE,
              THICKNESS: row.THICKNESS,
              WRAPGRADE: row.WRAP_GRADE,
              ROLL_NO: row.ROLL_NO,
            ),
          ),
        );
        print("Check ${row.ID}");
      }
    } else if (allRowIndex != null) {
      for (var row in dstList) {
        BlocProvider.of<FilmReceiveBloc>(context).add(
          FilmReceiveSendEvent(
            FilmReceiveOutputModel(
              PONO: row.PO_NO,
              INVOICE: row.IN_VOICE,
              FRIEGHT: row.FRIEGHT,
              DATERECEIVE: row.INCOMING_DATE,
              OPERATORNAME: int.tryParse(row.STORE_BY.toString()),
              PACKNO: row.PACK_NO,
              STATUS: row.STATUS,
              WEIGHT1: num.tryParse(row.W1.toString()),
              WEIGHT2: num.tryParse(row.W2.toString()),
              MFGDATE: row.MFG_DATE,
              THICKNESS: row.THICKNESS,
              WRAPGRADE: row.WRAP_GRADE,
              ROLL_NO: row.ROLL_NO,
            ),
          ),
        );
      }
    }
  }

  void _selectData() {
    EasyLoading.showInfo("Please Select Data", duration: Duration(seconds: 2));
  }
}

class FilmReceiveDataSource extends DataGridSource {
  FilmReceiveDataSource({List<DataSheetTableModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'pono', value: _item.PO_NO),
              DataGridCell<String>(columnName: 'ivno', value: _item.IN_VOICE),
              DataGridCell<String>(columnName: 'fi', value: _item.FRIEGHT),
              DataGridCell<String>(
                  columnName: 'ic', value: _item.INCOMING_DATE),
              DataGridCell<String>(columnName: 'sb', value: _item.STORE_BY),
              DataGridCell<String>(columnName: 'packno', value: _item.PACK_NO),
              DataGridCell<String>(columnName: 'sd', value: _item.STORE_DATE),
              DataGridCell<String>(columnName: 'status', value: _item.STATUS),
              DataGridCell<String>(columnName: 'w1', value: _item.W1),
              DataGridCell<String>(columnName: 'w2', value: _item.W2),
              DataGridCell<String>(columnName: 'Weight', value: _item.WEIGHT),
              DataGridCell<String>(columnName: 'md', value: _item.MFG_DATE),
              DataGridCell<String>(columnName: 'tn', value: _item.THICKNESS),
              DataGridCell<String>(columnName: 'wg', value: _item.WRAP_GRADE),
              DataGridCell<String>(columnName: 'rn', value: _item.ROLL_NO),
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
