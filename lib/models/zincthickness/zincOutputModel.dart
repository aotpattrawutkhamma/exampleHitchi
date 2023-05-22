class ZincThicknessOutputModel {
  const ZincThicknessOutputModel({
    this.OPERATORNAME,
    this.BATCHNO,
    this.THICKNESS1,
    this.THICKNESS2,
    this.THICKNESS3,
    this.THICKNESS4,
    this.THICKNESS6,
    this.THICKNESS7,
    this.THICKNESS8,
    this.THICKNESS9,
    this.STARTDATE,
  });

  final int? OPERATORNAME;
  final String? BATCHNO;
  final String? THICKNESS1;
  final String? THICKNESS2;
  final String? THICKNESS3;
  final String? THICKNESS4;
  final String? THICKNESS6;
  final String? THICKNESS7;
  final String? THICKNESS8;
  final String? THICKNESS9;
  final String? STARTDATE;
  ZincThicknessOutputModel copyWith({
    int? OPERATORNAME,
    String? BATCHNO,
    String? THICKNESS1,
    String? THICKNESS2,
    String? THICKNESS3,
    String? THICKNESS4,
    String? THICKNESS6,
    String? THICKNESS7,
    String? THICKNESS8,
    String? THICKNESS9,
    String? STARTDATE,
  }) {
    return ZincThicknessOutputModel(
      OPERATORNAME: OPERATORNAME ?? this.OPERATORNAME,
      BATCHNO: BATCHNO ?? this.BATCHNO,
      THICKNESS1: THICKNESS1 ?? this.THICKNESS1,
      THICKNESS2: THICKNESS2 ?? this.THICKNESS2,
      THICKNESS3: THICKNESS3 ?? this.THICKNESS3,
      THICKNESS4: THICKNESS4 ?? this.THICKNESS4,
      THICKNESS6: THICKNESS6 ?? this.THICKNESS6,
      THICKNESS7: THICKNESS7 ?? this.THICKNESS7,
      THICKNESS8: THICKNESS8 ?? this.THICKNESS8,
      THICKNESS9: THICKNESS9 ?? this.THICKNESS9,
      STARTDATE: STARTDATE ?? this.STARTDATE,
    );
  }

  @override
  Map toJson() => {
        'OperatorName': OPERATORNAME,
        'BatchNo': BATCHNO,
        'thickness1': THICKNESS1,
        'thickness2': THICKNESS2,
        'thickness3': THICKNESS3,
        'thickness4': THICKNESS4,
        'thickness6': THICKNESS6,
        'thickness7': THICKNESS7,
        'thickness8': THICKNESS8,
        'thickness9': THICKNESS9,
        'StartDate': STARTDATE,
      };
}
