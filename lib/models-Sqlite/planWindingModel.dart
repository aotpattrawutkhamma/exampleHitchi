class PlanWindingSQLiteModel {
  const PlanWindingSQLiteModel({
    this.ID,
    this.PLANDATE,
    this.ORDERPLAN,
    this.ORDERNO,
    this.BATCH,
    this.IPE,
    this.QTY,
    this.NOTE,
  });
  final int? ID;
  final String? PLANDATE;
  final String? ORDERPLAN;
  final String? ORDERNO;
  final String? BATCH;
  final String? IPE;
  final String? QTY;
  final String? NOTE;

  List<Object> get props => [
        ID!,
        PLANDATE!,
        ORDERPLAN!,
        ORDERNO!,
        BATCH!,
        IPE!,
        QTY!,
        NOTE!,
      ];
  PlanWindingSQLiteModel.fromMap(Map<String, dynamic> map)
      : ID = map['ID'],
        PLANDATE = map['PlanDate'],
        ORDERPLAN = map['OrderPlan'],
        ORDERNO = map['OrderNo'],
        BATCH = map['Batch'],
        IPE = map['IPE'],
        QTY = map['Qty'],
        NOTE = map['Note'];
}

// PLAN_WINDING_SHEET

// 'ID INTEGER PRIMARY KEY AUTOINCREMENT,'
// 'PlanDate TEXT, '
// 'OrderPlan TEXT, '
// 'OrderNo TEXT, '
// 'Batch TEXT, '
// 'IPE TEXT, '
// 'Qty TEXT, '
// 'Note TEXT) ');
