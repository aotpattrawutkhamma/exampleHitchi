class BreakDownSheetModel {
  const BreakDownSheetModel(
      {this.BREAK_START_DATE,
      this.BREAK_STOP_DATE,
      this.CHECK_COMPLETE,
      this.ID,
      this.MACHINE_NO,
      this.OPERATOR_ACCEPT,
      this.OPERATOR_NAME,
      this.SERVICE_NO,
      this.START_TECH_DATE_1,
      this.START_TECH_DATE_2,
      this.TECH_1,
      this.TECH_2,
      this.STOP_DATE_TECH_1,
      this.STOP_DATE_TECH_2,
      this.NEW});
  final String? ID;
  final String? MACHINE_NO;
  final String? OPERATOR_NAME;
  final String? SERVICE_NO;
  final String? BREAK_START_DATE;
  final String? TECH_1;
  final String? START_TECH_DATE_1;
  final String? TECH_2;
  final String? START_TECH_DATE_2;
  final String? STOP_DATE_TECH_1;
  final String? STOP_DATE_TECH_2;
  final String? OPERATOR_ACCEPT;
  final String? BREAK_STOP_DATE;
  final String? CHECK_COMPLETE;
  final String? NEW;

  List<Object> get props => [
        ID!,
        MACHINE_NO!,
        OPERATOR_NAME!,
        SERVICE_NO!,
        BREAK_START_DATE!,
        TECH_1!,
        START_TECH_DATE_1!,
        TECH_2!,
        START_TECH_DATE_2!,
        STOP_DATE_TECH_1!,
        STOP_DATE_TECH_2!,
        OPERATOR_ACCEPT!,
        BREAK_STOP_DATE!,
        CHECK_COMPLETE!,
        NEW!,
      ];
  BreakDownSheetModel.fromMap(Map<String, dynamic> map)
      : ID = map['ID'],
        MACHINE_NO = map['MachineNo'],
        OPERATOR_NAME = map['CallUser'],
        SERVICE_NO = map['RepairNo'],
        BREAK_START_DATE = map['BreakStartDate'],
        TECH_1 = map['MT1'],
        START_TECH_DATE_1 = map['MT1StartDate'],
        TECH_2 = map['MT2'],
        START_TECH_DATE_2 = map['MT2StartDate'],
        STOP_DATE_TECH_1 = map['MT1StopDate'],
        STOP_DATE_TECH_2 = map['MT2StopDate'],
        OPERATOR_ACCEPT = map['CheckUser'],
        BREAK_STOP_DATE = map['BreakStopDate'],
        CHECK_COMPLETE = map['CheckComplete'],
        NEW = map[''];
}
