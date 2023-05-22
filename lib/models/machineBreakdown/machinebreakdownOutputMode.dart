class MachineBreakDownOutputModel {
  const MachineBreakDownOutputModel({
    this.MACHINE_NO,
    this.OPERATOR_NAME,
    this.SERVICE,
    this.BREAK_START_DATE,
    this.TECH1,
    this.START_DATE_TECH_1,
    this.TECH2,
    this.START_DATE_TECH_2,
    this.STOP_TECH_DATE_1,
    this.STOP_TECH_DATE_2,
    this.ACCEPT,
    this.BREAK_STOP_DATE,
  });
  final String? MACHINE_NO;
  final String? OPERATOR_NAME;
  final String? SERVICE;
  final String? BREAK_START_DATE;
  final String? TECH1;
  final String? START_DATE_TECH_1;
  final String? TECH2;
  final String? START_DATE_TECH_2;
  final String? STOP_TECH_DATE_1;
  final String? STOP_TECH_DATE_2;
  final String? ACCEPT;
  final String? BREAK_STOP_DATE;

  MachineBreakDownOutputModel copyWith({
    String? MACHINE_NO,
    String? OPERATOR_NAME,
    String? SERVICE,
    String? BREAK_START_DATE,
    String? TECH1,
    String? START_DATE_TECH_1,
    String? TECH2,
    String? START_DATE_TECH_2,
    String? STOP_TECH_DATE_1,
    String? STOP_TECH_DATE_2,
    String? ACCEPT,
    String? BREAK_STOP_DATE,
  }) {
    return MachineBreakDownOutputModel(
      MACHINE_NO: MACHINE_NO ?? this.MACHINE_NO,
      OPERATOR_NAME: OPERATOR_NAME ?? this.OPERATOR_NAME,
      SERVICE: SERVICE ?? this.SERVICE,
      BREAK_START_DATE: BREAK_START_DATE ?? this.BREAK_START_DATE,
      TECH1: TECH1 ?? this.TECH1,
      START_DATE_TECH_1: START_DATE_TECH_1 ?? this.START_DATE_TECH_1,
      TECH2: TECH2 ?? this.TECH2,
      START_DATE_TECH_2: START_DATE_TECH_2 ?? this.START_DATE_TECH_2,
      STOP_TECH_DATE_1: STOP_TECH_DATE_1 ?? this.STOP_TECH_DATE_1,
      STOP_TECH_DATE_2: STOP_TECH_DATE_2 ?? this.STOP_TECH_DATE_2,
      ACCEPT: ACCEPT ?? this.ACCEPT,
      BREAK_STOP_DATE: BREAK_STOP_DATE ?? this.BREAK_STOP_DATE,
    );
  }

  @override
  Map toJson() => {
        'MachineNo': MACHINE_NO,
        'CallUser': OPERATOR_NAME,
        'RepairNo': SERVICE,
        'BreakStartDate': BREAK_START_DATE,
        'MT1': TECH1,
        'MT1StartDate': START_DATE_TECH_1,
        'MT2': TECH2,
        'MT2StartDate': START_DATE_TECH_2,
        'MT1StopDate': STOP_TECH_DATE_1,
        'MT2StopDate': STOP_TECH_DATE_2,
        'CheckUser': ACCEPT,
        'BreakStopDate': BREAK_STOP_DATE,
      };
}
