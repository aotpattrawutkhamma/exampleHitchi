class ProcessModel {
  const ProcessModel({
    this.ID,
    this.MACHINE,
    this.OPERATOR_NAME,
    this.OPERATOR_NAME1,
    this.OPERATOR_NAME2,
    this.OPERATOR_NAME3,
    this.BATCH_NO,
    this.STARTDATE,
    this.GARBAGE,
    this.FINDATE,
    this.STARTEND,
    this.CHECKCOMPLETE,
  });
  final int? ID;
  final String? MACHINE;
  final String? OPERATOR_NAME;
  final String? OPERATOR_NAME1;
  final String? OPERATOR_NAME2;
  final String? OPERATOR_NAME3;
  final String? BATCH_NO;
  final String? STARTDATE;
  final String? GARBAGE;
  final String? FINDATE;
  final String? STARTEND;
  final String? CHECKCOMPLETE;

  List<Object> get props => [
        ID!,
        MACHINE!,
        OPERATOR_NAME!,
        OPERATOR_NAME1!,
        OPERATOR_NAME2!,
        OPERATOR_NAME3!,
        BATCH_NO!,
        STARTDATE!,
        GARBAGE!,
        FINDATE!,
        STARTEND!,
        CHECKCOMPLETE!,
      ];
  ProcessModel.fromMap(Map<String, dynamic> map)
      : ID = map['ID'],
        MACHINE = map['Machine'],
        OPERATOR_NAME = map['OperatorName'],
        OPERATOR_NAME1 = map['OperatorName1'],
        OPERATOR_NAME2 = map['OperatorName2'],
        OPERATOR_NAME3 = map['OperatorName3'],
        BATCH_NO = map['BatchNo'],
        STARTDATE = map['StartDate'],
        GARBAGE = map['Garbage'],
        FINDATE = map['FinDate'],
        STARTEND = map['StartEnd'],
        CHECKCOMPLETE = map['CheckComplete'];
}
