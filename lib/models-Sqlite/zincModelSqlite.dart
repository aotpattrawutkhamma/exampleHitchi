class ZincModelSqlite {
  const ZincModelSqlite({
    this.ID,
    this.CheckUser,
    this.Batch,
    this.Thickness1,
    this.Thickness2,
    this.Thickness3,
    this.Thickness4,
    this.Thickness6,
    this.Thickness7,
    this.Thickness8,
    this.Thickness9,
    this.DateData,
  });
  final int? ID;
  final String? CheckUser;
  final String? Batch;
  final String? Thickness1;
  final String? Thickness2;
  final String? Thickness3;
  final String? Thickness4;
  final String? Thickness6;
  final String? Thickness7;
  final String? Thickness8;
  final String? Thickness9;
  final String? DateData;

  List<Object> get props => [
        ID!,
        CheckUser!,
        Batch!,
        Thickness1!,
        Thickness2!,
        Thickness3!,
        Thickness4!,
        Thickness6!,
        Thickness7!,
        Thickness8!,
        Thickness9!,
        DateData!,
      ];
  ZincModelSqlite.fromMap(Map<String, dynamic> map)
      : ID = map['ID'],
        CheckUser = map['CheckUser'],
        Batch = map['Batch'],
        Thickness1 = map['Thickness1'],
        Thickness2 = map['Thickness2'],
        Thickness3 = map['Thickness3'],
        Thickness4 = map['Thickness4'],
        Thickness6 = map['Thickness6'],
        Thickness7 = map['Thickness7'],
        Thickness8 = map['Thickness8'],
        Thickness9 = map['Thickness9'],
        DateData = map['DateData'];
}
