class ReportRouteSheetModel {
  const ReportRouteSheetModel({this.PROBLEM, this.PROCESS});

  final List<ReportRouteSheetModelProcess>? PROCESS;
  final List<ReportRouteSheetModelProblem>? PROBLEM;

  List<Object> get props => [PROCESS!, PROBLEM!];

  static ReportRouteSheetModel fromJson(dynamic json) {
    return ReportRouteSheetModel(
      PROCESS: json['Process'] != null
          ? json['Process']
              .map(
                  (dynamic item) => ReportRouteSheetModelProcess.fromJson(item))
              .cast<ReportRouteSheetModelProcess>()
              .toList()
          : [],
      PROBLEM: json['Problem'] != null
          ? json['Problem']
              .map(
                  (dynamic item) => ReportRouteSheetModelProblem.fromJson(item))
              .cast<ReportRouteSheetModelProblem>()
              .toList()
          : [],
    );
  }
}

class ReportRouteSheetModelProcess {
  const ReportRouteSheetModelProcess(
      {this.AMOUNT,
      this.FINISH_DATE,
      this.FINISH_TIME,
      this.ORDER,
      this.PROCESS,
      this.START_DATE,
      this.START_TIME});
  final int? ORDER;
  final String? PROCESS;
  final String? START_DATE;
  final String? START_TIME;
  final String? FINISH_DATE;
  final String? FINISH_TIME;
  final int? AMOUNT;
  List<Object> get props => [
        AMOUNT!,
        FINISH_DATE!,
        FINISH_TIME!,
        ORDER!,
        PROCESS!,
        START_DATE!,
        START_TIME!,
      ];

  static ReportRouteSheetModelProcess fromJson(dynamic json) {
    return ReportRouteSheetModelProcess(
      ORDER: json['Order'],
      PROCESS: json['Process'],
      START_DATE: json['START_DATE'],
      START_TIME: json['START_TIME'],
      FINISH_DATE: json['FINISH_DATE'],
      FINISH_TIME: json['FINISH_TIME'],
      AMOUNT: json['Amount'],
    );
  }
}

class ReportRouteSheetModelProblem {
  const ReportRouteSheetModelProblem({this.DESCRIPTION, this.PROCESS});
  final String? PROCESS;
  final String? DESCRIPTION;
  List<Object> get props => [PROCESS!, DESCRIPTION!];

  static ReportRouteSheetModelProblem fromJson(dynamic json) {
    return ReportRouteSheetModelProblem(
        PROCESS: json['Process'], DESCRIPTION: json['Description']);
  }
}


// // To parse this JSON data, do
// //
// //     final reportRouteSheetModel = reportRouteSheetModelFromJson(jsonString);

// import 'dart:convert';

// ReportRouteSheetModel reportRouteSheetModelFromJson(String str) =>
//     ReportRouteSheetModel.fromJson(json.decode(str));

// String reportRouteSheetModelToJson(ReportRouteSheetModel data) =>
//     json.encode(data.toJson());

// class ReportRouteSheetModel {
//   List<Process> process;
//   List<dynamic> problem;

//   ReportRouteSheetModel({
//     required this.process,
//     required this.problem,
//   });

//   factory ReportRouteSheetModel.fromJson(Map<String, dynamic> json) =>
//       ReportRouteSheetModel(
//         process:
//             List<Process>.from(json["Process"].map((x) => Process.fromJson(x))),
//         problem: List<dynamic>.from(json["Problem"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "Process": List<dynamic>.from(process.map((x) => x.toJson())),
//         "Problem": List<dynamic>.from(problem.map((x) => x)),
//       };
// }

// class Process {
//   int order;
//   String process;
//   String startDate;
//   String startTime;
//   String finishDate;
//   String finishTime;
//   int amount;

//   Process({
//     required this.order,
//     required this.process,
//     required this.startDate,
//     required this.startTime,
//     required this.finishDate,
//     required this.finishTime,
//     required this.amount,
//   });

//   factory Process.fromJson(Map<String, dynamic> json) => Process(
//         order: json["Order"],
//         process: json["Process"],
//         startDate: json["START_DATE"],
//         startTime: json["START_TIME"],
//         finishDate: json["FINISH_DATE"],
//         finishTime: json["FINISH_TIME"],
//         amount: json["Amount"],
//       );

//   Map<String, dynamic> toJson() => {
//         "Order": order,
//         "Process": process,
//         "START_DATE": startDate,
//         "START_TIME": startTime,
//         "FINISH_DATE": finishDate,
//         "FINISH_TIME": finishTime,
//         "Amount": amount,
//       };
// }

