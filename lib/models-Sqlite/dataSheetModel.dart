class DataSheetTableModel {
  const DataSheetTableModel({
    this.ID,
    this.PO_NO,
    this.IN_VOICE,
    this.FRIEGHT,
    this.INCOMING_DATE,
    this.STORE_BY,
    this.PACK_NO,
    this.STORE_DATE,
    this.STATUS,
    this.W1,
    this.W2,
    this.WEIGHT,
    this.MFG_DATE,
    this.THICKNESS,
    this.WRAP_GRADE,
    this.ROLL_NO,
    this.CHECK_COMPLETE,
  });
  final int? ID;
  final String? PO_NO;
  final String? IN_VOICE;
  final String? FRIEGHT;
  final String? INCOMING_DATE;
  final String? STORE_BY;
  final String? PACK_NO;
  final String? STORE_DATE;
  final String? STATUS;
  final String? W1;
  final String? W2;
  final String? WEIGHT;
  final String? MFG_DATE;
  final String? THICKNESS;
  final String? WRAP_GRADE;
  final String? ROLL_NO;
  final String? CHECK_COMPLETE;

  List<Object> get props => [
        ID!,
        PO_NO!,
        IN_VOICE!,
        FRIEGHT!,
        INCOMING_DATE!,
        STORE_BY!,
        PACK_NO!,
        STORE_DATE!,
        STATUS!,
        W1!,
        W2!,
        WEIGHT!,
        MFG_DATE!,
        THICKNESS!,
        WRAP_GRADE!,
        ROLL_NO!,
        CHECK_COMPLETE!,
      ];
  DataSheetTableModel.fromMap(Map<String, dynamic> map)
      : ID = map['ID'],
        PO_NO = map['PO_NO'],
        IN_VOICE = map['INVOICE'],
        FRIEGHT = map['FRIEGHT'],
        INCOMING_DATE = map['INCOMING_DATE'],
        STORE_BY = map['STORE_BY'],
        PACK_NO = map['PACK_NO'],
        STORE_DATE = map['STORE_DATE'],
        STATUS = map['STATUS'],
        W1 = map['W1'],
        W2 = map['W2'],
        WEIGHT = map['WEIGHT'],
        MFG_DATE = map['MFG_DATE'],
        THICKNESS = map['THICKNESS1'],
        WRAP_GRADE = map['WRAP_GRADE'],
        ROLL_NO = map['ROLL_NO'],
        CHECK_COMPLETE = map['checkComplete'];
}
