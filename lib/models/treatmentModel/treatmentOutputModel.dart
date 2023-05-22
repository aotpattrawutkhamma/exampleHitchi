class TreatMentOutputModel {
  const TreatMentOutputModel(
      {this.MACHINE_NO,
      this.OPERATOR_NAME,
      this.BATCH_NO_1,
      this.BATCH_NO_2,
      this.BATCH_NO_3,
      this.BATCH_NO_4,
      this.BATCH_NO_5,
      this.BATCH_NO_6,
      this.BATCH_NO_7,
      this.START_DATE,
      this.FINISH_DATE});

  final String? MACHINE_NO;
  final int? OPERATOR_NAME;
  final String? BATCH_NO_1;
  final String? BATCH_NO_2;
  final String? BATCH_NO_3;
  final String? BATCH_NO_4;
  final String? BATCH_NO_5;
  final String? BATCH_NO_6;
  final String? BATCH_NO_7;
  final String? START_DATE;
  final String? FINISH_DATE;
  TreatMentOutputModel copyWith(
      {String? MACHINE_NO,
      int? OPERATOR_NAME,
      String? BATCH_NO_1,
      String? BATCH_NO_2,
      String? BATCH_NO_3,
      String? BATCH_NO_4,
      String? BATCH_NO_5,
      String? BATCH_NO_6,
      String? BATCH_NO_7,
      String? START_DATE,
      String? FINISH_DATE}) {
    return TreatMentOutputModel(
        MACHINE_NO: MACHINE_NO ?? this.MACHINE_NO,
        OPERATOR_NAME: OPERATOR_NAME ?? this.OPERATOR_NAME,
        BATCH_NO_1: BATCH_NO_1 ?? this.BATCH_NO_1,
        BATCH_NO_2: BATCH_NO_2 ?? this.BATCH_NO_2,
        BATCH_NO_3: BATCH_NO_3 ?? this.BATCH_NO_3,
        BATCH_NO_4: BATCH_NO_4 ?? this.BATCH_NO_4,
        BATCH_NO_5: BATCH_NO_5 ?? this.BATCH_NO_5,
        BATCH_NO_6: BATCH_NO_6 ?? this.BATCH_NO_6,
        BATCH_NO_7: BATCH_NO_7 ?? this.BATCH_NO_7,
        START_DATE: START_DATE ?? this.START_DATE,
        FINISH_DATE: FINISH_DATE ?? this.FINISH_DATE);
  }

  @override
  Map toJson() => {
        'MachineNo': MACHINE_NO,
        'OperatorName': OPERATOR_NAME,
        'BatchNo1': BATCH_NO_1,
        'BatchNo2': BATCH_NO_2,
        'BatchNo3': BATCH_NO_3,
        'BatchNo4': BATCH_NO_4,
        'BatchNo5': BATCH_NO_5,
        'BatchNo6': BATCH_NO_6,
        'BatchNo7': BATCH_NO_7,
        'StartDate': START_DATE,
        'FinishDate': FINISH_DATE
      };
}
