import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:hitachi/models-Sqlite/dataSheetModel.dart';
import 'package:hitachi/models-Sqlite/windingSheetModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'my_database.db');
    bool isDatabaseExists = await databaseExists(dbPath);
    if (isDatabaseExists) {
      print("Database already exists");
    } else {
      var database = await openDatabase(
        dbPath,
        version: 1,
        onCreate: _createDb,
        onUpgrade: (db, oldVersion, newVersion) =>
            _onUpgrade(db, oldVersion, newVersion),
      );
      print("Create a Tables Data");
      return database;
    }
    return await openDatabase(dbPath);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
      await db.execute('DROP TABLE IF EXISTS table1');
      await db.execute('DROP TABLE IF EXISTS table2');
      await db.execute('DROP TABLE IF EXISTS table3');
      _createDb(db, newVersion);
    }
  }
  //สร้างไฟล์กับ Column

  void _createDb(Database db, int newVersion) async {
    _createTableDataSheet(db, newVersion);
    _createTableWinding(db, newVersion);
    _createDateTimeNow(db, newVersion);
    _createTableJob(db, newVersion);
    _createTableProcess(db, newVersion);
    _createTableTreatment(db, newVersion);
    _createComboProblem(db, newVersion);
    _createTableBreakDown(db, newVersion);
    _createTableProblem(db, newVersion);
    _createSpecification(db, newVersion);
    _createWindingWeightSheet(db, newVersion);
    _createMaterialLoad(db, newVersion);
    _createMaterialTrace(db, newVersion);
    _createPMload(db, newVersion);
    _craetePM(db, newVersion);
    _createDateWindingPlan(db, newVersion);
    _createBarcodePrinting(db, newVersion);
    _createZincThickness(db, newVersion);
  }

  Future<int> insertSqlite(String tableName, Map<String, dynamic> row) async {
    Database db = await this.database;

    print("WriteData FucnTionInsertDataSheet ${tableName}");
    return await db.insert(tableName, row);
  }

  Future<int> deleted(String tableName, String row) async {
    Database db = await this.database;

    return await db.delete(tableName, where: row);
  }

  Future<int> updateSqlite(String tableName, Map<String, dynamic> row,
      String whereClause, List<dynamic> whereArgs) async {
    Database db = await this.database;

    print("Update Data ${tableName}");
    return await db.update(tableName, row,
        where: whereClause, whereArgs: whereArgs);
  }

  Future<int> deletedRowSqlite(
      {String? tableName, String? columnName, dynamic? columnValue}) async {
    Database db = await this.database;

    print("DeleteRow Sucess ${tableName}");
    //ColumnName คือ Key whereArgs คือค่า ID
    return await db
        .delete(tableName!, where: '$columnName = ?', whereArgs: [columnValue]);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    Database db = await this.database;
    return await db.query(tableName);
  }

  Future<List<Map<String, dynamic>>> queryWeight({
    String? stringValue,
    String? selected,
    String? table,
  }) async {
    try {
      String sql = "SELECT $selected " +
          "FROM  $table " +
          "WHERE BatchNo = '${stringValue}'"; // แก้ไขตรงนี้

      Database db = await this.database;
      return await db.rawQuery(sql); // ปิดวงเล็บตรงนี้
    } catch (e, s) {
      print(e);
      print(s);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> queryDataSelect(
      {String? select1,
      String? select2,
      String? select3,
      String? select4,
      String? formTable,
      String? where,
      String? stringValue,
      int? intValue,
      String? keyAnd,
      String? keyAnd2,
      String? value,
      String? value2}) async {
    try {
      String sql = "SELECT ${select1}, ${select2}, ${select3}, ${select4} " +
          "FROM ${formTable} " +
          "WHERE ${where} = '${stringValue ?? intValue}'" + // แก้ไขตรงนี้
          " AND (${keyAnd}='${value}') " +
          "AND (${keyAnd2}='${value2}')";
      Database db = await this.database;
      return await db.rawQuery(sql); // ปิดวงเล็บตรงนี้
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> deleteSave(
      {String? tableName, String? where, String? keyWhere}) async {
    try {
      final Database db = await database;
      String sql = "${tableName} WHERE ${where} = '${keyWhere}'";
      print("Delete Success");
      await db.delete(sql);
    } on Exception {
      throw Exception();
    }
  }

  Future<int> updateWindingWeight(
      {String? table,
      String? key1,
      String? key2,
      String? yieldKey1,
      num? yieldKey2,
      String? whereKey,
      String? value}) async {
    try {
      final Database db = await database;
      String sql =
          "UPDATE ${table} SET ${key1}= '$yieldKey1', ${key2}= '$yieldKey2' WHERE ${whereKey}= '$value'";
      return await db.rawUpdate(sql);
    } on Exception {
      throw Exception();
    }
  }

  //เขียนข้อมูลในSQlite

  //ลบข้อมูลในSQLITE
  Future<void> deleteDataFromSQLite({
    String? tableName,
    String? where,
    String? id,
  }) async {
    try {
      Database db = await DatabaseHelper().database;
      int count = await db
          .delete('${tableName!}', where: '${where} = ?', whereArgs: [id]);
      print('Data deleted from SQLite with count: $count');
    } catch (e) {
      print('Error deleting from SQLite: $e');
    }
  }

  // Future<void> findSqliteFile() async {
  //   Directory appDocDir = await getApplicationDocumentsDirectory();
  //   String sqliteFilePath = '${appDocDir.path}/my_database.db';
  //   print(sqliteFilePath);
  //   // ตรวจสอบว่าไฟล์มีอยู่จริงหรือไม่
  //   if (await File(sqliteFilePath).exists()) {
  //     print('Found SQLite file at $sqliteFilePath');
  //   } else {
  //     print('SQLite file not found!');
  //   }
  // }
  //
  //TableDataSheetTable---------------------------------------------------------------------------------------------------------------------------------
  //
  Future<void> writeTableDataSheet_ToSQLite(
      {DataSheetTableModel? model}) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'PO_NO': model?.PO_NO,
        'INVOICE': model?.IN_VOICE,
        'FRIEGHT': model?.FRIEGHT,
        'INCOMING_DATE': model?.INCOMING_DATE,
        'STORE_BY': model?.STORE_BY,
        'PACK_NO': model?.PACK_NO,
        'STORE_DATE': model?.STORE_DATE,
        'STATUS': model?.STATUS,
        'W1': model?.W1,
        'W2': model?.W2,
        'WEIGHT': model?.WEIGHT,
        'MFG_DATE': model?.MFG_DATE,
        'THICKNESS': model?.THICKNESS,
        'WRAP_GRADE': model?.WRAP_GRADE,
        'ROLL_NO': model?.ROLL_NO,
        'checkComplete': model?.CHECK_COMPLETE,
      };
      int id = await db.insert('DATA_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createTableDataSheet(Database db, int newVersion) async {
    await db.execute('CREATE TABLE DATA_SHEET ('
        'ID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'PO_NO TEXT,'
        'INVOICE TEXT,'
        'FRIEGHT TEXT,'
        'INCOMING_DATE TEXT,'
        'STORE_BY TEXT,'
        'PACK_NO TEXT,'
        'STORE_DATE TEXT,'
        'STATUS TEXT,'
        'W1 TEXT,'
        'W2 TEXT,'
        'WEIGHT TEXT,'
        'MFG_DATE TEXT,'
        'THICKNESS1 TEXT,'
        'THICKNESS2 TEXT,'
        'WRAP_GRADE TEXT,'
        'ROLL_NO TEXT,'
        'checkComplete TEXT'
        ')');
  }

  ///
  //TABLE WINDING ------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableWindingSheet_ToSqlite(WindingSheetModel items) async {
    Database db = await DatabaseHelper().database;
    Map<String, dynamic> row = {
      'MachineNo': items.MACHINE_NO,
      'OperatorName': items.OPERATOR_NAME,
      'BatchNo': items.BATCH_NO,
      'Product': items.PRODUCT,
      'PackNo': items.PACK_NO,
      'PaperCore': items.PAPER_CORE,
      'PPCore': items.PP_CORE,
      'FoilCore': items.FOIL_CORE,
      'BatchStartDate': items.BATCH_START_DATE,
      'BatchEndDate': items.BATCH_END_DATE,
      'Element': items.ELEMENT,
      'Status': items.STATUS,
      'start_end': items.START_END,
      'checkComplete': items.CHECK_COMPLETE
    };
    int id = await db.insert('WINDING_SHEET', row);
    print('Data written to SQLite with id: $id');
  }

  void _createTableWinding(Database db, int newVersion) async {
    await db.execute('CREATE TABLE WINDING_SHEET ('
        'ID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'MachineNo TEXT, '
        'OperatorName TEXT, '
        'BatchNo TEXT, '
        'Product TEXT, '
        'PackNo TEXT, '
        'PaperCore TEXT, '
        'PPCore TEXT, '
        'FoilCore TEXT, '
        'BatchStartDate TEXT, '
        'BatchEndDate TEXT, '
        'Element TEXT, '
        'Status TEXT, '
        'start_end TEXT, '
        'value TEXT,'
        'checkComplete TEXT '
        ')');
  }

  ///
  //TABLE DATETIMENOW ------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableDateTimeNow_ToSqlite({String? dateTimeNow}) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'DateTimeNow': dateTimeNow,
      };
      int id = await db.insert('DATE_TIME_NOW_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createDateTimeNow(Database db, int newVersion) async {
    await db.execute('CREATE TABLE DATE_TIME_NOW_SHEET ('
        'DateTimeNow TEXT '
        ')');
  }

  ///
  //TABLE JOBB------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableJob_ToSqlite({
    int? machineNo,
    String? operator_Name,
    int? batch_No,
    int? product,
    int? pack_No,
    String? batchStartDate,
    String? batchEndDate,
    String? status,
    int? element,
    String? startEnd,
    String? checkComplete,
  }) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'MachineNo': machineNo,
        'OperatorName': operator_Name,
        'BatchNo': batch_No,
        'Product': product,
        'PackNo': pack_No,
        'BatchStartDate': batchStartDate,
        'BatchEndDate': batchEndDate,
        'Status': status,
        'Element': element,
        'StartEnd': startEnd,
        'CheckComplete': checkComplete,
      };
      int id = await db.insert('JOB_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createTableJob(Database db, int newVersion) async {
    await db.execute('CREATE TABLE JOB_SHEET ('
        'MachineNo INTEGER PRIMARY KEY AUTOINCREMENT,'
        'OperatorName TEXT,'
        'BatchNo INTEGER,'
        'Product INTEGER,'
        'PackNo INTEGER,'
        'BatchStartDate TEXT,'
        'BatchEndDate TEXT, '
        'Status TEXT,'
        'Element INTEGER,'
        'StartEnd TEXT,'
        'CheckComplete TEXT'
        ')');
  }

  ///
  //TABLE PROCESS------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableProcess_ToSqlite({
    int? ID,
    String? machine_No,
    String? operator_Name,
    String? operator_Name1,
    String? operator_Name2,
    String? operator_Name3,
    String? batch_No,
    String? start_Date,
    String? garbage,
    String? fin_Date,
    String? start_End,
    String? check_Complete,
  }) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'ID': ID,
        'Machine': machine_No,
        'OperatorName': operator_Name,
        'OperatorName1': operator_Name1,
        'OperatorName2': operator_Name2,
        'OperatorName3': operator_Name3,
        'BatchNo': batch_No,
        'StartDate': start_Date,
        'Garbage': garbage,
        'FinDate': fin_Date,
        'StartEnd': start_End,
        'CheckComplete': check_Complete,
      };
      int id = await db.insert('PROCESS_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createTableProcess(Database db, int newVersion) async {
    await db.execute('CREATE TABLE PROCESS_SHEET ('
        'ID INTEGER PRIMARY KEY AUTOINCREMENT,'
        'Machine TEXT,'
        'OperatorName TEXT,'
        'OperatorName1 TEXT,'
        'OperatorName2 TEXT,'
        'OperatorName3 TEXT,'
        'BatchNo TEXT,'
        'StartDate TEXT, '
        'Garbage TEXT,'
        'FinDate TEXT,'
        'StartEnd TEXT,'
        'CheckComplete TEXT'
        ')');
  }

  ///
  //TABLE TREATMENT------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableTreatment_ToSqlite({
    String? machineno,
    String? operatorname,
    int? batch1,
    int? batch2,
    int? batch3,
    int? batch4,
    int? batch5,
    int? batch6,
    int? batch7,
    String? startdate,
    String? findate,
    String? startend,
    String? checkcomplete,
  }) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'MachineNo': machineno,
        'OperatorName': operatorname,
        'Batch1': batch1,
        'Batch2': batch2,
        'Batch3': batch3,
        'Batch4': batch4,
        'Batch5': batch5,
        'Batch6': batch6,
        'Batch7': batch7,
        'StartDate': startdate,
        'FinDate': findate,
        'StartEnd': startend,
        'CheckComplete': checkcomplete,
      };
      int id = await db.insert('TREATMENT_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createTableTreatment(Database db, int newVersion) async {
    await db.execute('CREATE TABLE TREATMENT_SHEET ('
        'ID INTEGER PRIMARY KEY AUTOINCREMENT ,'
        'MachineNo TEXT,'
        'OperatorName TEXT,'
        'Batch1 TEXT,'
        'Batch2 TEXT,'
        'Batch3 TEXT,'
        'Batch4 TEXT,'
        'Batch5 TEXT, '
        'Batch6 TEXT,'
        'Batch7 TEXT,'
        'StartDate TEXT,'
        'FinDate TEXT,'
        'StartEnd TEXT,'
        'CheckComplete TEXT'
        ')');
  }

  ///
  //TABLE PROBLEM------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableProblem_ToSqlite({
    String? machineNo,
    String? operatorName,
    int? batchNo,
    String? pDate,
    String? problemAlway,
    String? problemETC,
    String? checkComplete,
  }) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'MachineNo': machineNo,
        'OperatorName': operatorName,
        'BatchNo': batchNo,
        'PDate': pDate,
        'ProblemAlway': problemAlway,
        'ProblemETC': problemETC,
        'CheckComplete': checkComplete,
      };
      int id = await db.insert('PROBLEM_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createTableProblem(Database db, int newVersion) async {
    await db.execute('CREATE TABLE PROBLEM_SHEET ('
        'MachineNo INTEGER PRIMARY KEY AUTOINCREMENT,'
        'OperatorName TEXT,'
        'BatchNo TEXT,'
        'PDate TEXT,'
        'ProblemAlway TEXT,'
        'ProblemETC TEXT,'
        'CheckComplete TEXT'
        ')');
  }

  ///
  //TABLE BREAKDOWN------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableBreakDown_ToSqlite({
    int? machineNo,
    String? callUser,
    String? repairNo,
    String? breakStartDate,
    String? mt1,
    String? mt1StartDate,
    String? mt2,
    String? mt2StartDate,
    String? mt1StopDate,
    String? mt2StopDate,
    String? checkUser,
    String? breakStopDate,
    String? checkComplete,
  }) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'MachineNo': machineNo,
        'CallUser': callUser,
        'RepairNo': repairNo,
        'BreakStartDate': breakStartDate,
        'MT1': mt1,
        'MT1StartDate': mt1StartDate,
        'MT2': mt2,
        'MT2StartDate': mt2StartDate,
        'MT1StopDate': mt1StopDate,
        'MT2StopDate': mt2StopDate,
        'CheckUser': checkUser,
        'BreakStopDate': breakStopDate,
        'CheckComplete': checkComplete,
      };
      int id = await db.insert('BREAKDOWN_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createTableBreakDown(Database db, int newVersion) async {
    await db.execute('CREATE TABLE BREAKDOWN_SHEET ('
        'ID INTEGER PRIMARY KEY AUTOINCREMENT,'
        'MachineNo TEXT,'
        'CallUser TEXT,'
        'RepairNo TEXT,'
        'BreakStartDate TEXT,'
        'MT1 TEXT,'
        'MT1StartDate TEXT,'
        'MT2 TEXT,'
        'MT2StartDate TEXT,'
        'MT1StopDate TEXT,'
        'MT2StopDate TEXT,'
        'CheckUser TEXT,'
        'BreakStopDate TEXT,'
        'CheckComplete TEXT'
        ')');
  }

  ///
  //TABLE COMBOTPROBLEM------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableComboProblem_ToSqlite({
    int? ID,
    String? process,
    String? probelm,
  }) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'ID': ID,
        'Process': process,
        'Problem': probelm,
      };
      int id = await db.insert('COMBO_PROBLEM_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createComboProblem(Database db, int newVersion) async {
    await db.execute('CREATE TABLE COMBO_PROBLEM_SHEET ('
        'ID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'Process TEXT,'
        'Problem TEXT'
        ')');
  }

  //////////////////////////////////////////////////////////////
  ////////////////////////////Phase 2////////////////////////////
  //////////////////////////////////////////////////////////////////

  ///
  //TABLE SPECIFICATION_SHEET------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableSpecification_ToSqlite({
    String? JUMET,
    String? IPE,
    num? Wind_min,
    num? Wind_Avg,
    num? Wind_Max,
    num? Wind_Dia,
    num? Wind_Turn,
    String? Clearing,
    String? Treatment,
    String? Ipeak,
    String? HighVolt,
    String? Reactor,
    num? Measure_Min,
    num? Measure_Max,
    String? Tangent,
    num? BomP,
    num? SM,
    num? S1,
    num? S2,
  }) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'JUMET': JUMET,
        'IPE': IPE,
        'Wind_min': Wind_min,
        'Wind_Avg': Wind_Avg,
        'Wind_Max': Wind_Max,
        'Wind_Dia': Wind_Dia,
        'Wind_Turn': Wind_Turn,
        'Clearing': Clearing,
        'Treatment': Treatment,
        'Ipeak': Ipeak,
        'HighVolt': HighVolt,
        'Reactor': Reactor,
        'Measure_Min': Measure_Min,
        'Measure_Max': Measure_Max,
        'Tangent': Tangent,
        'BomP': BomP,
        'SM': SM,
        'S1': S1,
        'S2': S2,
      };
      int id = await db.insert('SPECIFICATION_SHEET', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  void _createSpecification(Database db, int newVersion) async {
    await db.execute('CREATE TABLE SPECIFICATION_SHEET ('
        'JUMET TEXT, '
        'IPE TEXT,'
        'Wind_min REAL,'
        'Wind_Avg REAL,'
        'Wind_Max REAL,'
        'Wind_Dia REAL,'
        'Wind_Turn REAL,'
        'Clearing TEXT,'
        'Treatment TEXT,'
        'Ipeak TEXT,'
        'HighVolt TEXT,'
        'Reactor TEXT,'
        'Measure_Min REAL,'
        'Measure_Max REAL,'
        'Tangent TEXT,'
        'BomP REAL,'
        'SM REAL,'
        'S1 REAL,'
        'S2 REAL'
        ')');
  }

  ///
  //TABLE WINDING_WEIGHT_SHEET------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  Future<void> writeTableWindingWeightSheet_ToSqlite({
    String? machineNo,
    int? batchNo,
    num? target,
  }) async {
    Database db = await DatabaseHelper().database;
    Map<String, dynamic> row = {
      'MachineNo': machineNo,
      'BatchNo': batchNo,
      'Target': target,
    };
    int id = await db.insert('WINDING_WEIGHT_SHEET', row);
    print('Data written to SQLite with id: $id');
  }

  void _createWindingWeightSheet(Database db, int newVersion) async {
    await db.execute('CREATE TABLE WINDING_WEIGHT_SHEET ('
        'MachineNo TEXT, '
        'BatchNo TEXT,'
        'Target REAL'
        ')');
  }

  void _createMaterialLoad(Database db, int newVersion) async {
    await db.execute('CREATE TABLE MATERIALLOAD_SHEET ('
        'Itemcode TEXT, '
        'Type TEXT)');
  }

  void _createMaterialTrace(Database db, int newVersion) async {
    await db.execute('CREATE TABLE MATERIAL_TRACE_SHEET ('
        'ID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'Material TEXT, '
        'Type TEXT, '
        'OperatorName TEXT, '
        'BatchNo TEXT, '
        'MachineNo TEXT, '
        'Material1 TEXT, '
        'LotNo1 TEXT, '
        'Date1 TEXT, '
        'Material2 TEXT, '
        'LotNo2 TEXT, '
        'Date2 TEXT)');
  }

  void _createPMload(Database db, int newVersion) async {
    await db.execute('CREATE TABLE PMLOAD_SHEET ('
        'CP_Type TEXT, '
        'Status TEXT, '
        'Description TEXT)');
  }

  void _craetePM(Database db, int newVersion) async {
    await db.execute('CREATE TABLE PM_SHEET ('
        'OperatorName TEXT, '
        'CheckPointPM TEXT, '
        'Status TEXT, '
        'DatePM TEXT)');
  }

  void _createDateWindingPlan(Database db, int newVersion) async {
    await db.execute('CREATE TABLE DATE_WINDING_PLAN_SHEET ('
        'LoadDate TEXT, '
        'LoadTime TEXT)');
  }

  void _createWindingPlan(Database db, int newVersion) async {
    await db.execute('CREATE TABLE WINDING_PLAN_SHEET ('
        'ID INTEGER PRIMARY KEY AUTOINCREMENT,'
        'IDPlanDate INTEGER, '
        'PlanDate TEXT, '
        'OrderPlan INTEGER, '
        'OrderNo TEXT, '
        'Batch TEXT, '
        'IPE TEXT, '
        'Qty INTEGER, '
        'Note TEXT)');
  }

  void _createBarcodePrinting(Database db, int newVersion) async {
    await db.execute('CREATE TABLE BARCODE_PRINTING_SHEET ('
        'ID INTEGER PRIMARY KEY AUTOINCREMENT,'
        'CheckUser TEXT, '
        'Batch TEXT, '
        'Product TEXT, '
        'Barcode TEXT, '
        'Result INTEGER, '
        'DateBarcode TEXT)');
  }

  void _createZincThickness(Database db, int newVersion) async {
    await db.execute('CREATE TABLE ZINCTHICKNESS_SHEET ('
        'ID INTEGER PRIMARY KEY AUTOINCREMENT,'
        'CheckUser TEXT, '
        'Batch TEXT, '
        'Thickness1 TEXT, '
        'Thickness2 TEXT, '
        'Thickness3 TEXT, '
        'Thickness4 TEXT, '
        'Thickness6 TEXT, '
        'Thickness7 TEXT, '
        'Thickness8 TEXT, '
        'Thickness9 TEXT, '
        'DateData TEXT)');
  }

  Future<List<Map<String, dynamic>>> fetchZincThickness({String? batch}) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT * FROM ZincThickness WHERE Batch = ?",
      [batch],
    );
    return result;
  }

/////////Select Database ////
  Future<List<Map<String, dynamic>>> queryTypeMaterial(
      {String? material,
      String? value,
      String? value2,
      String? value3,
      String? value4,
      String? value5}) async {
    try {
      String sql = "SELECT Material " +
          "FROM MATERIAL_TRACE_SHEET " +
          "WHERE Material = '$material' " +
          "AND (Type='$value') " +
          "AND (OperatorName='$value2') " +
          "AND (BatchNo='$value3') " +
          "AND (LotNo1='$value4') " +
          "AND (Date1='$value5')";
      Database db = await this.database;
      return await db.rawQuery(sql); // ปิดวงเล็บตรงนี้
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> queryTypeMaterialAll(
      {String? material,
      String? value,
      String? value2,
      String? value3,
      String? value4,
      String? value5,
      String? value6,
      String? value7,
      String? value8,
      String? valueMaterial1}) async {
    try {
      String sql = "SELECT Material " +
          "FROM MATERIAL_TRACE_SHEET " +
          "WHERE Material = '$material' " +
          "AND (Type='$value') " +
          "AND (OperatorName='$value2') " +
          "AND (BatchNo='$value3') " +
          "AND (Material1='$valueMaterial1') " +
          "AND (LotNo1='$value4') " +
          "AND (Date1='$value5') " +
          "AND (Material2='$value6') " +
          "AND (LotNo2='$value7') " +
          "AND (Date2='$value8')";
      Database db = await this.database;
      return await db.rawQuery(sql); // ปิดวงเล็บตรงนี้
    } catch (e) {
      print(e);
      return [];
    }
  }
}
