class SendWdsFinishOutputModel {
  const SendWdsFinishOutputModel(
      {this.BATCH_NO, this.ELEMNT_QTY, this.FINISH_DATE, this.OPERATOR_NAME});

  final int? BATCH_NO;
  final int? OPERATOR_NAME;
  final int? ELEMNT_QTY;
  final String? FINISH_DATE;

  SendWdsFinishOutputModel copyWith({
    int? BATCH_NO,
    int? OPERATOR_NAME,
    int? ELEMNT_QTY,
    String? FINISH_DATE,
  }) {
    return SendWdsFinishOutputModel(
      BATCH_NO: BATCH_NO ?? this.BATCH_NO,
      OPERATOR_NAME: OPERATOR_NAME ?? this.OPERATOR_NAME,
      ELEMNT_QTY: ELEMNT_QTY ?? this.ELEMNT_QTY,
      FINISH_DATE: FINISH_DATE ?? this.FINISH_DATE,
    );
  }

  @override
  Map toJson() => {
        'OperatorName': BATCH_NO,
        'BatchNo': OPERATOR_NAME,
        'ElementQty': ELEMNT_QTY,
        'FinishDate': FINISH_DATE,
      };
}
