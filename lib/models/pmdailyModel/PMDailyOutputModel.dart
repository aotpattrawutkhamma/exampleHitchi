class PMDailyOutputModel {
  const PMDailyOutputModel({
    this.OPERATORNAME,
    this.CHECKPOINT,
    this.STATUS,
    this.STARTDATE,
  });
  final int? OPERATORNAME;
  final String? CHECKPOINT;
  final String? STATUS;
  final String? STARTDATE;

  PMDailyOutputModel copyWith({
    int? OPERATORNAME,
    String? CHECKPOINT,
    String? STATUS,
    String? STARTDATE,
  }) {
    return PMDailyOutputModel(
      OPERATORNAME: OPERATORNAME ?? this.OPERATORNAME,
      CHECKPOINT: CHECKPOINT ?? this.CHECKPOINT,
      STATUS: STATUS ?? this.STATUS,
      STARTDATE: STARTDATE ?? this.STARTDATE,
    );
  }

  @override
  Map toJson() => {
        'OperatorName': OPERATORNAME,
        'CheckPoint': CHECKPOINT,
        'Status': STATUS,
        'StartDate': STARTDATE,
      };
}
