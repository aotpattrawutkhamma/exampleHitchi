class ProcessFinishOutputModel {
  const ProcessFinishOutputModel({
    this.MACHINE,
    this.OPERATORNAME,
    this.REJECTQTY,
    this.BATCHNO,
    this.FINISHDATE,
  });

  final String? MACHINE;
  final int? OPERATORNAME;
  final int? REJECTQTY;
  final String? BATCHNO;
  final String? FINISHDATE;

  ProcessFinishOutputModel copyWith({
    String? MACHINE,
    int? OPERATORNAME,
    int? REJECTQTY,
    String? BATCHNO,
    String? FINISHDATE,
  }) {
    return ProcessFinishOutputModel(
      MACHINE: MACHINE ?? this.MACHINE,
      OPERATORNAME: OPERATORNAME ?? this.OPERATORNAME,
      REJECTQTY: REJECTQTY ?? this.REJECTQTY,
      BATCHNO: BATCHNO ?? this.BATCHNO,
      FINISHDATE: FINISHDATE ?? this.FINISHDATE,
    );
  }

  @override
  Map toJson() => {
        'Machine': MACHINE,
        'OperatorName': OPERATORNAME,
        'RejectQty': REJECTQTY,
        'BatchNo': BATCHNO,
        'FinishDate': FINISHDATE,
      };
}
