class PlanWindingOutputModel {
  const PlanWindingOutputModel({
    this.PLAN,
    // this.NOWDATETIME
  });
  // PlanWindingOutputModel
  final List<PlanWindingOutputModelPlan>? PLAN;
  // final List<PlanWindingOutputModelNowDateTime>? NOWDATETIME;

  List<Object> get props => [
        PLAN!
        // , NOWDATETIME!
      ];

  static PlanWindingOutputModel fromJson(dynamic json) {
    return PlanWindingOutputModel(
      PLAN: json['Plan'] != null
          ? json['Plan']
              .map((dynamic item) => PlanWindingOutputModelPlan.fromJson(item))
              .cast<PlanWindingOutputModelPlan>()
              .toList()
          : [],
      // NOWDATETIME: json['NowDateTime'] != null
      //     ? json['NowDateTime']
      //         .map((dynamic item) =>
      //             PlanWindingOutputModelNowDateTime.fromJson(item))
      //         .cast<PlanWindingOutputModelNowDateTime>()
      //         .toList()
      //     : [],
    );
  }
}

class PlanWindingOutputModelPlan {
  const PlanWindingOutputModelPlan(
      {this.WDGDATEPLANS,
      this.ORDER,
      this.ORDERNO,
      this.BATCH,
      this.IPECODE,
      this.WDGQTYPLAN,
      this.NOTE});
  final String? WDGDATEPLANS;
  final int? ORDER;
  final String? ORDERNO;
  final String? BATCH;
  final int? IPECODE;
  final int? WDGQTYPLAN;
  final String? NOTE;
  List<Object> get props => [
        WDGDATEPLANS!,
        ORDER!,
        ORDERNO!,
        BATCH!,
        IPECODE!,
        WDGQTYPLAN!,
        NOTE!,
      ];

  static PlanWindingOutputModelPlan fromJson(dynamic json) {
    return PlanWindingOutputModelPlan(
      WDGDATEPLANS: json['WDGdatePlans'],
      ORDER: json['Order'],
      ORDERNO: json['OrderNo'],
      BATCH: json['Batch'],
      IPECODE: json['IPE_CODE'],
      WDGQTYPLAN: json['WDGqtyPlan'],
      NOTE: json['Note'],
    );
  }
}

// class PlanWindingOutputModelNowDateTime {
//   const PlanWindingOutputModelNowDateTime({this.NOWDATE, this.NOWTIME});
//   final String? NOWDATE;
//   final String? NOWTIME;
//   List<Object> get props => [NOWDATE!, NOWTIME!];
//
//   static PlanWindingOutputModelNowDateTime fromJson(dynamic json) {
//     return PlanWindingOutputModelNowDateTime(
//         NOWDATE: json['NowDate'], NOWTIME: json['NowTime']);
//   }
// }
