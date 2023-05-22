class FilmReceiveOutputModel {
  const FilmReceiveOutputModel({
    this.PONO,
    this.INVOICE,
    this.FRIEGHT,
    this.DATERECEIVE,
    this.OPERATORNAME,
    this.PACKNO,
    this.STATUS,
    this.WEIGHT1,
    this.WEIGHT2,
    this.MFGDATE,
    this.THICKNESS,
    this.WRAPGRADE,
    this.ROLL_NO,
  });
  final String? PONO;
  final String? INVOICE;
  final String? FRIEGHT;
  final String? DATERECEIVE;
  final int? OPERATORNAME;
  final String? PACKNO;
  final String? STATUS;
  final num? WEIGHT1;
  final num? WEIGHT2;
  final String? MFGDATE;
  final String? THICKNESS;
  final String? WRAPGRADE;
  final String? ROLL_NO;

  FilmReceiveOutputModel copyWith({
    String? PONO,
    String? INVOICE,
    String? FRIEGHT,
    String? DATERECEIVE,
    int? OPERATORNAME,
    String? PACKNO,
    String? STATUS,
    num? WEIGHT1,
    num? WEIGHT2,
    String? MFGDATE,
    String? THICKNESS,
    String? WRAPGRADE,
    String? ROLL_NO,
  }) {
    return FilmReceiveOutputModel(
      PONO: PONO ?? this.PONO,
      INVOICE: INVOICE ?? this.INVOICE,
      FRIEGHT: FRIEGHT ?? this.FRIEGHT,
      DATERECEIVE: DATERECEIVE ?? this.DATERECEIVE,
      OPERATORNAME: OPERATORNAME ?? this.OPERATORNAME,
      PACKNO: PACKNO ?? this.PACKNO,
      STATUS: STATUS ?? this.STATUS,
      WEIGHT1: WEIGHT1 ?? this.WEIGHT1,
      WEIGHT2: WEIGHT2 ?? this.WEIGHT2,
      MFGDATE: MFGDATE ?? this.MFGDATE,
      THICKNESS: THICKNESS ?? this.THICKNESS,
      WRAPGRADE: WRAPGRADE ?? this.WRAPGRADE,
      ROLL_NO: ROLL_NO ?? this.ROLL_NO,
    );
  }

  @override
  Map toJson() => {
        'PONo': PONO,
        'Invoice': INVOICE,
        'Frieght': FRIEGHT,
        'DateReceive': DATERECEIVE,
        'OperatorName': OPERATORNAME,
        'PackNo': PACKNO,
        'Status': STATUS,
        'Weight1': WEIGHT1,
        'Weight2': WEIGHT2,
        'MfgDate': MFGDATE,
        'Thickness': THICKNESS,
        'WrapGrade': WRAPGRADE,
        'Roll_No': ROLL_NO,
      };
}
