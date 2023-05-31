class CPPMDailyOutputModel {
  const CPPMDailyOutputModel({
    this.CHECKPOINT,
  });
  final List<PMDailyOutputModelPlan>? CHECKPOINT;

  List<Object> get props => [CHECKPOINT!];

  static CPPMDailyOutputModel fromJson(dynamic json) {
    return CPPMDailyOutputModel(
      CHECKPOINT: json['Status'] != null
          ? json['Status']
              .map((dynamic item) => PMDailyOutputModelPlan.fromJson(item))
              .cast<PMDailyOutputModelPlan>()
              .toList()
          : [],
    );
  }
}

class PMDailyOutputModelPlan {
  const PMDailyOutputModelPlan({
    this.CTTYPE,
    this.STATUS,
    this.DESCRIPTION,
  });
  final String? CTTYPE;
  final String? STATUS;
  final String? DESCRIPTION;
  List<Object> get props => [
        STATUS!,
        DESCRIPTION!,
      ];

  static PMDailyOutputModelPlan fromJson(dynamic json) {
    return PMDailyOutputModelPlan(
      CTTYPE: json['CP_Type'],
      STATUS: json['Status'],
      DESCRIPTION: json['Description'],
    );
  }
}
