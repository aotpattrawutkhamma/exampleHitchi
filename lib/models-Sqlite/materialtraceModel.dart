class MaterialTraceModel {
  const MaterialTraceModel({
    this.ID,
    this.MATERIAL,
    this.MATERIAL_TYPE,
    this.OPERATOR_NAME,
    this.BATCH_NO,
    this.MACHINE_NO,
    this.MATERIAL_1,
    this.LOTNO_1,
    this.DATE_1,
    this.MATERIAL_2,
    this.LOT_NO_2,
    this.DATE_2,
  });
  final int? ID;
  final String? MATERIAL;
  final String? MATERIAL_TYPE;
  final String? OPERATOR_NAME;
  final String? BATCH_NO;
  final String? MACHINE_NO;
  final String? MATERIAL_1;
  final String? LOTNO_1;
  final String? DATE_1;
  final String? MATERIAL_2;
  final String? LOT_NO_2;
  final String? DATE_2;

  List<Object> get props => [
        ID!,
        MATERIAL!,
        MATERIAL_TYPE!,
        OPERATOR_NAME!,
        BATCH_NO!,
        MACHINE_NO!,
        MATERIAL_1!,
        LOTNO_1!,
        DATE_1!,
        MATERIAL_2!,
        LOT_NO_2!,
        DATE_2!,
      ];
  MaterialTraceModel.fromMap(Map<String, dynamic> map)
      : ID = map['ID'],
        MATERIAL = map['Material'],
        MATERIAL_TYPE = map['Type'],
        OPERATOR_NAME = map['OperatorName'],
        BATCH_NO = map['BatchNo'],
        MACHINE_NO = map['MachineNo'],
        MATERIAL_1 = map['Material1'],
        LOTNO_1 = map['LotNo1'],
        DATE_1 = map['Date1'],
        MATERIAL_2 = map['Material2'],
        LOT_NO_2 = map['LotNo2'],
        DATE_2 = map['Date2'];
}
