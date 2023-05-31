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
  FilmReceiveHoldScreen({super.key, this.onChange});
  ValueChanged<List<Map<String, dynamic>>>? onChange;

  @override
  State<FilmReceiveHoldScreen> createState() => _FilmReceiveHoldScreenState();
}

class _FilmReceiveHoldScreenState extends State<FilmReceiveHoldScreen> {
  final TextEditingController password = TextEditingController();
  FilmReceiveDataSource? filmDataSource;
  List<DataSheetTableModel>? dstSqliteModel;
  List<DataSheetTableModel> dstList = [];
  List<int> _index = [];
  int? allRowIndex;
  List<DataSheetTableModel> selectAll = [];

  DataGridRow? datagridRow;
  bool isClick = false;
  Color _colorSend = COLOR_GREY;
  Color _colorDelete = COLOR_GREY;
  bool isHidewidget = false;

  DatabaseHelper databaseHelper = DatabaseHelper();

  Map<String, double> columnWidths = {
    'ID': double.nan,
    'pono': double.nan,
    'ivno': double.nan,
    'fi': double.nan,
    'ic': double.nan,
    'sb': double.nan,
    'packno': double.nan,
    'sd': double.nan,
    'status': double.nan,
    'w1': double.nan,
    'w2': double.nan,
    'Weight': double.nan,
    'md': double.nan,
    'tn': double.nan,
    'wg': double.nan,
    'rn': double.nan,
  };
  @override
  void initState() {
    super.initState();

    _getFilmReceive().then((result) {
      setState(() {
        dstList = result;
        filmDataSource = FilmReceiveDataSource(process: dstList);
      });
    });
  }

  Future _getHold() async {
    List<Map<String, dynamic>> sql =
        await databaseHelper.queryAllRows('DATA_SHEET');
    setState(() {
      widget.onChange?.call(sql);
    });
  }

  Future<List<DataSheetTableModel>> _getFilmReceive() async {
    try {
      List<Map<String, dynamic>> rows =
          await databaseHelper.queryAllRows('DATA_SHEET');
      List<DataSheetTableModel> result =
          rows.map((row) => DataSheetTableModel.fromMap(row)).toList();
      return result;
    } catch (e, s) {
      print(e);
      print(s);
      return [];
    }
  }

  Future _refreshPage() async {
    Future.delayed(Duration(seconds: 1), () {
      _getFilmReceive().then((result) {
        setState(() {
          dstList = result;
          filmDataSource = FilmReceiveDataSource(process: dstList);
          print(dstList);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FilmReceiveBloc, FilmReceiveState>(
          listener: (context, state) async {
            if (state is FilmReceiveLoadingState) {
              EasyLoading.show(status: "Loading ...");
            }
            if (state is FilmReceiveLoadedState) {
              EasyLoading.dismiss();
              if (state.item.RESULT == true) {
                await deletedInfo();
                await _refreshPage();
                await _getHold();

                EasyLoading.showSuccess("Send complete",
                    duration: Duration(seconds: 3));
              } else {
                _errorDialog(
                    isHideCancle: false,
                    text: Label("${state.item.MESSAGE ?? "Check Connection"}"),
                    onpressOk: () {
                      Navigator.pop(context);
                    });
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
                          allowColumnsResizing: true,
                          onColumnResizeUpdate:
                              (ColumnResizeUpdateDetails details) {
                            setState(() {
                              columnWidths[details.column.columnName] =
                                  details.width;
                            });
                            return true;
                          },
                          columnResizeMode: ColumnResizeMode.onResizeEnd,
                          onSelectionChanged:
                              (selectRow, deselectedRows) async {
                            if (selectRow.isNotEmpty) {
                              if (selectRow.length ==
                                      filmDataSource!.effectiveRows.length &&
                                  selectRow.length > 1) {
                                setState(() {
                                  selectRow.forEach((row) {
                                    _index.add(int.tryParse(
                                        row.getCells()[0].value.toString())!);

                                    _colorSend = COLOR_BLUE_DARK;
                                    _colorDelete = COLOR_RED;
                                  });
                                });
                              } else {
                                setState(() {
                                  _index.add(int.tryParse(selectRow.first
                                      .getCells()[0]
                                      .value
                                      .toString())!);
                                  datagridRow = selectRow.first;
                                  dstSqliteModel = datagridRow!
                                      .getCells()
                                      .map(
                                        (e) => DataSheetTableModel(),
                                      )
                                      .toList();
                                  print(_index);
                                  _colorSend = COLOR_BLUE_DARK;
                                  _colorDelete = COLOR_RED;
                                });
                              }
                            } else {
                              setState(() {
                                if (deselectedRows.length > 1) {
                                  _index.clear();
                                } else {
                                  _index.remove(int.tryParse(deselectedRows
                                      .first
                                      .getCells()[0]
                                      .value
                                      .toString())!);
                                }
                                _colorSend = Colors.grey;
                                _colorDelete = Colors.grey;
                              });
                            }
                          },

                          columns: <GridColumn>[
                            GridColumn(
                                visible: false,
                                columnName: 'ID',
                                label: Container(
                                  color: COLOR_BLUE_DARK,
                                  child: Center(
                                      child: Label(
                                    'ID',
                                    fontSize: 14,
                                    color: COLOR_WHITE,
                                  )),
                                  // color: COLOR_BLUE_DARK,
                                )),
                            GridColumn(
                                width: columnWidths['pono']!,
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
                              width: columnWidths['ivno']!,
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
                              width: columnWidths['fi']!,
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
                            ),
                            GridColumn(
                              width: columnWidths['ic']!,
                              columnName: 'ic',
                              label: Container(
                                color: COLOR_BLUE_DARK,
                                child: Center(
                                    child: Label(
                                  'Incoming',
                                  fontSize: 14,
                                  color: COLOR_WHITE,
                                )),
                              ),
                            ),
                            GridColumn(
                                width: columnWidths['sb']!,
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
                                width: columnWidths['packno']!,
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
                                width: columnWidths['sd']!,
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
                                width: columnWidths['status']!,
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
                                width: columnWidths['w1']!,
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
                                width: columnWidths['w2']!,
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
                                width: columnWidths['Weight']!,
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
                                width: columnWidths['md']!,
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
                                width: columnWidths['tn']!,
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
                                width: columnWidths['wg']!,
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
                                width: columnWidths['rn']!,
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
              _index.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: _index.length,
                        itemBuilder: ((context, index) {
                          return DataTable(
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
                                DataCell(Center(child: Label("Po No"))),
                                DataCell(Label(
                                    "${dstList.where((element) => element.ID == _index.first).first.PO_NO}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Invoice No."))),
                                DataCell(Label(
                                    "${dstList.where((element) => element.ID == _index.first).first.IN_VOICE}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Incoming Date"))),
                                DataCell(Label(
                                    "${dstList.where((element) => element.ID == _index.first).first.INCOMING_DATE}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Store By"))),
                                DataCell(Label(
                                    "${dstList.where((element) => element.ID == _index.first).first.STORE_BY}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Pack No"))),
                                DataCell(Label(
                                    "${dstList.where((element) => element.ID == _index.first).first.PACK_NO}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Store Date"))),
                                DataCell(Label(
                                    "${dstList.where((element) => element.ID == _index.first).first.STORE_DATE}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Status"))),
                                DataCell(Label(
                                    "${dstList.where((element) => element.ID == _index.first).first.STATUS}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("W1"))),
                                DataCell(Label(
                                    "${dstList.where((element) => element.ID == _index.first).first.W1}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("W2"))),
                                DataCell(Label(
                                    "${dstList.where((element) => element.ID == _index.first).first.W2}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Weight"))),
                                DataCell(Label(
                                    "${dstList.where((element) => element.ID == _index.first).first.WEIGHT}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Mfg.date"))),
                                DataCell(Label(
                                    "${dstList.where((element) => element.ID == _index.first).first.MFG_DATE}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Thickness"))),
                                DataCell(Label(
                                    "${dstList.where((element) => element.ID == _index.first).first.THICKNESS}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Wrap Grade"))),
                                DataCell(Label(
                                    "${dstList.where((element) => element.ID == _index.first).first.WRAP_GRADE}"))
                              ]),
                              DataRow(cells: [
                                DataCell(Center(child: Label("Roll No."))),
                                DataCell(Label(
                                    "${dstList.where((element) => element.ID == _index.first).first.ROLL_NO}"))
                              ])
                            ],
                          );
                        }),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: Button(
                    onPress: () {
                      if (_index.isNotEmpty) {
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
                      if (_index.isNotEmpty) {
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

  Future deletedInfo() async {
    _index.forEach((element) async {
      await databaseHelper.deletedRowSqlite(
          tableName: 'DATA_SHEET', columnName: 'ID', columnValue: element);
      _index.clear();
    });
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
              child: Label("Do you want Delete "),
            ),
          ],
        ),

        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await deletedInfo();
              await _getHold();
              await _refreshPage();

              EasyLoading.showSuccess("Delete Success");
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _sendDataServer() async {
    _index.forEach((element) async {
      var row = dstList.where((value) => value.ID == element).first;
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
    });
  }

  void _selectData() {
    EasyLoading.showInfo("Please Select Data", duration: Duration(seconds: 2));
  }

  void _errorDialog(
      {Label? text,
      Function? onpressOk,
      Function? onpressCancel,
      bool isHideCancle = true}) async {
    // EasyLoading.showError("Error[03]", duration: Duration(seconds: 5));//if password
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: text,
            ),
          ],
        ),

        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: isHideCancle,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(COLOR_BLUE_DARK)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              Visibility(
                visible: isHideCancle,
                child: SizedBox(
                  width: 15,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(COLOR_BLUE_DARK)),
                onPressed: () => onpressOk?.call(),
                child: const Text('OK'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class FilmReceiveDataSource extends DataGridSource {
  FilmReceiveDataSource({List<DataSheetTableModel>? process}) {
    if (process != null) {
      for (var _item in process) {
        _employees.add(
          DataGridRow(
            cells: [
              DataGridCell<int>(columnName: 'ID', value: _item.ID),
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
