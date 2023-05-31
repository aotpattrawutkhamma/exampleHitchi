import 'config.dart';

class ApiConfig {
  static Map<String, dynamic> HEADER({String? Authorization}) {
    if (Authorization != null) {
      return {
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $Authorization'
      };
    } else {
      return {
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8',
      };
    }
  }

  //LineElement
  //GET
  static String LE_CHECKPACK_NO =
      "${BASE_API_URL}LineElement/WSCheckPackNo?packNo="; // Number
  //POST
  static String LE_SEND_WINDING_START =
      "${BASE_API_URL}LineElement/SendWindingStart";

  //Post
  static String LE_SEND_WINDING_START_WEIGHT =
      "${BASE_API_URL}LineElement/SendWindingStartReturnWeight";

  ///---------------------WINDING FINISH ----------------------///
  //Post
  static String LE_SEND_WINDING_FINISH =
      "${BASE_API_URL}LineElement/SendWindingFinish";
  static String LE_CHECK_SEND_WINDING_FINISH =
      "${BASE_API_URL}LineElement/WFCheckBatch?batch="; //ID

  ///---------------------REPORT ROUTE SHEET ----------------------///

  //Get
  static String LE_REPORT_ROUTE_SHEET =
      "${BASE_API_URL}LineElement/GetReportRouteSheet?batch=";

  ///---------------------MaterialInput ----------------------///

  //POST
  static String LE_MATERIALINPUT =
      "${BASE_API_URL}LineElement/SendMaterialInput";
  //
  static String LE_CHECK_MATERIAL_INPUT =
      "${BASE_API_URL}LineElement/CheckMaterial?material="; // ID  GET
  ///---------------------MACHINE BREAKDOWN ----------------------///

  //POST MACHINE BREAKDOWN
  static String MACHINE_BREAKDOWN = "${BASE_API_URL}LineElement/SendMachine";

  ///---------------------ProcessInput ----------------------///

  //POST ProcessStart
  static String LE_PROCESSSTARTINPUT =
      "${BASE_API_URL}LineElement/SendProcessStart";

  ///---------------------ProcessFinish ----------------------///
  //POST ProcessFinish
  static String LE_PROCESSFINISHINPUT =
      "${BASE_API_URL}LineElement/SendProcessFinish";

  ///---------------------PROCESS BREAKDOWN ----------------------///
  //POST PROCESS BREAKDOWN
  static String PROCESS_BREAKDOWN =
      "${BASE_API_URL}LineElement/SendProcessStart";

  //POST SEND FILM IN
  static String FILM_RECEIVE = "${BASE_API_URL}LineElement/SendFilmIn";
  //POST GETCHECK FILM IN
  static String CHECK_FILM_RECEIVE =
      "${BASE_API_URL}LineElement/FICheckPackNo?packNo="; //ID
  //POST SEND TreatmentStart
  static String TREAMTMENT_START = "${BASE_API_URL}LineElement/SendTreatStart";
  //POST SEND TreatmentFinish
  static String TREAMTMENT_FINISH =
      "${BASE_API_URL}LineElement/SendTreatFinish";
  //POST SEND ZincThickness
  static String ZINC_THICKNESS = "${BASE_API_URL}LineElement/SendZinc";
  //POST SEND TestConnection
  static String TEST_CONNECTION = "${BASE_API_URL}Connection/TestConnection";

  ///---------------------PM Daily ----------------------///

  //POST SEND PM_DAILY
  static String PM_DAILY = "${BASE_API_URL}LineElement/SendPMDaily";
  //Get PM_DAILY
  static String PM_GETDAILY = "${BASE_API_URL}LineElement/GetLoadStatus";

  ///---------------------PLAN_WINDING ----------------------///

  //Get PLAN_WINDING
  static String PLAN_WINDING = "${BASE_API_URL}LineElement/GetPlanWinding";
}
