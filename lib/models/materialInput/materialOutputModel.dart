class MaterialOutputModel {
  const MaterialOutputModel({
    this.MATERIAL,
    this.MACHINENO,
    this.OPERATORNAME,
    this.BATCHNO,
    this.LOT,
    this.STARTDATE,
  });
  final String? MATERIAL;
  final String? MACHINENO;
  final int? OPERATORNAME;
  final String? BATCHNO;
  final String? LOT;
  final String? STARTDATE;

  MaterialOutputModel copyWith({
    String? MATERIAL,
    String? MACHINENO,
    int? OPERATORNAME,
    String? BATCHNO,
    String? LOT,
    String? STARTDATE,
  }) {
    return MaterialOutputModel(
      MATERIAL: MATERIAL ?? this.MATERIAL,
      MACHINENO: MACHINENO ?? this.MACHINENO,
      OPERATORNAME: OPERATORNAME ?? this.OPERATORNAME,
      BATCHNO: BATCHNO ?? this.BATCHNO,
      LOT: LOT ?? this.LOT,
      STARTDATE: STARTDATE ?? this.STARTDATE,
    );
  }

  @override
  Map toJson() => {
        'Material': MATERIAL,
        'MachineNo': MACHINENO,
        'OperatorName': OPERATORNAME,
        'BatchNo': BATCHNO,
        'Lot': LOT,
        'StartDate': STARTDATE,
      };
}
