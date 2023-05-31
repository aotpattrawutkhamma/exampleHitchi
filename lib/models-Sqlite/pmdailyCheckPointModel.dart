class PMDailyCheckPointSQLiteModel {
  const PMDailyCheckPointSQLiteModel({
    this.ID,
    this.CTTYPE,
    this.STATUS,
    this.DESCRIPTION,
  });
  final int? ID;
  final String? CTTYPE;
  final String? STATUS;
  final String? DESCRIPTION;

  List<Object> get props => [
        ID!,
        CTTYPE!,
        STATUS!,
        DESCRIPTION!,
      ];
  PMDailyCheckPointSQLiteModel.fromMap(Map<String, dynamic> map)
      : ID = map['ID'],
        CTTYPE = map['CTType'],
        STATUS = map['Status'],
        DESCRIPTION = map['Description'];
}

// PLAN_WINDING_SHEET

// 'ID INTEGER PRIMARY KEY AUTOINCREMENT,'
// 'Status TEXT, '
// 'Description TEXT) ');
