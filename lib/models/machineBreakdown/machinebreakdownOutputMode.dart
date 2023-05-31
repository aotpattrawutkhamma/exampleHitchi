class MachineBreakDownOutputModel {
  const MachineBreakDownOutputModel({
    this.MACHINE_NO,
    this.OPERATOR_NAME,
    this.SERVICE,
    this.BREAK_START_DATE,
    this.MT1,
    this.MT1_START_DATE,
    this.MT2,
    this.MT2_START_DATE,
    this.MT1_STOP,
    this.MT2_STOP,
    this.ACCEPT,
    this.BREAK_STOP_DATE,
  });
  final String? MACHINE_NO;
  final String? OPERATOR_NAME;
  final String? SERVICE;
  final String? BREAK_START_DATE;
  final String? MT1;
  final String? MT1_START_DATE;
  final String? MT2;
  final String? MT2_START_DATE;
  final String? MT1_STOP;
  final String? MT2_STOP;
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
      MT1: TECH1 ?? this.MT1,
      MT1_START_DATE: START_DATE_TECH_1 ?? this.MT1_START_DATE,
      MT2: TECH2 ?? this.MT2,
      MT2_START_DATE: START_DATE_TECH_2 ?? this.MT2_START_DATE,
      MT1_STOP: STOP_TECH_DATE_1 ?? this.MT1_STOP,
      MT2_STOP: STOP_TECH_DATE_2 ?? this.MT2_STOP,
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
        'MT1': MT1,
        'MT1StartDate': MT1_START_DATE,
        'MT2': MT2,
        'MT2StartDate': MT2_START_DATE,
        'MT1StopDate': MT1_STOP,
        'MT2StopDate': MT2_STOP,
        'CheckUser': ACCEPT,
        'BreakStopDate': BREAK_STOP_DATE,
      };
}
