class SendWindingStartModelOutput {
  const SendWindingStartModelOutput(
      {this.BATCH_NO,
      this.FILM_PACK_NO,
      this.FOIL_LOT,
      this.MACHINE_NO,
      this.OPERATOR_NAME,
      this.PAPER_CODE_LOT,
      this.PP_FILM_LOT,
      this.PRODUCT,
      this.START_DATE});
  final String? MACHINE_NO;
  final int? OPERATOR_NAME;
  final String? BATCH_NO;
  final int? PRODUCT;
  final int? FILM_PACK_NO;
  final String? PAPER_CODE_LOT;
  final String? PP_FILM_LOT;
  final String? FOIL_LOT;
  final String? START_DATE;

  SendWindingStartModelOutput copyWith({
    String? MACHINE_NO,
    int? OPERATOR_NAME,
    String? BATCH_NO,
    int? PRODUCT,
    int? FILM_PACK_NO,
    String? PAPER_CODE_LOT,
    String? PP_FILM_LOT,
    String? FOIL_LOT,
    String? START_DATE,
  }) {
    return SendWindingStartModelOutput(
      MACHINE_NO: MACHINE_NO ?? this.MACHINE_NO,
      OPERATOR_NAME: OPERATOR_NAME ?? this.OPERATOR_NAME,
      BATCH_NO: BATCH_NO ?? this.BATCH_NO,
      PRODUCT: PRODUCT ?? this.PRODUCT,
      FILM_PACK_NO: FILM_PACK_NO ?? this.FILM_PACK_NO,
      PAPER_CODE_LOT: PAPER_CODE_LOT ?? this.PAPER_CODE_LOT,
      PP_FILM_LOT: PP_FILM_LOT ?? this.PP_FILM_LOT,
      FOIL_LOT: FOIL_LOT ?? this.FOIL_LOT,
      START_DATE: START_DATE ?? this.START_DATE,
    );
  }

  @override
  Map toJson() => {
        "MachineNo": MACHINE_NO,
        "OperatorName": OPERATOR_NAME,
        "BatchNo": BATCH_NO,
        "Product": PRODUCT,
        "FilmPackNo": FILM_PACK_NO,
        "PaperCodeLot": PAPER_CODE_LOT,
        "PPFilmLot": PP_FILM_LOT,
        "FoilLot": FOIL_LOT,
        "StartDate": START_DATE,
      };
}

  // List<Object> get props => [
  //       MACHINE_NO!,
  //       OPERATOR_NAME!,
  //       BATCH_NO!,
  //       PRODUCT!,
  //       FILM_PACK_NO!,
  //       PAPER_CODE_LOT!,
  //       PP_FILM_LOT!,
  //       FOIL_LOT!,
  //       START_DATE!,
  //     ];

  // static SendWindingStartModel fromJson(dynamic json) {
  //   return SendWindingStartModel(
  //     MACHINE_NO: json['MachineNo'],
  //     OPERATOR_NAME: json['OperatorName'],
  //     BATCH_NO: json['BatchNo'],
  //     PRODUCT: json['Product'],
  //     FILM_PACK_NO: json['FilmPackNo'],
  //     PAPER_CODE_LOT: json['PaperCodeLot'],
  //     PP_FILM_LOT: json['PPFilmLot'],
  //     FOIL_LOT: json['FoilLot'],
  //     START_DATE: json['StartDate'],
  //   );
  // }

