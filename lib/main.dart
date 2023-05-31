import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/connection/testconnection_bloc.dart';
import 'package:hitachi/blocs/filmReceive/film_receive_bloc.dart';

import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/blocs/machineBreakDown/machine_break_down_bloc.dart';
import 'package:hitachi/blocs/planwinding/planwinding_bloc.dart';
import 'package:hitachi/blocs/pmDaily/pm_daily_bloc.dart';
import 'package:hitachi/blocs/treatment/treatment_bloc.dart';
import 'package:hitachi/blocs/zincthickness/zinc_thickness_bloc.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/route/route_generator.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/screens/auth/LoginScreen.dart';
import 'package:hitachi/screens/mainMenu/Homepage.dart';
import 'package:hitachi/screens/splash_screen.dart';
import 'package:hitachi/services/databaseHelper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LineElementBloc>(
          create: (_) => LineElementBloc(),
        ),
        BlocProvider<MachineBreakDownBloc>(
          create: (_) => MachineBreakDownBloc(),
        ),
        BlocProvider<FilmReceiveBloc>(
          create: (_) => FilmReceiveBloc(),
        ),
        BlocProvider<TreatmentBloc>(
          create: (_) => TreatmentBloc(),
        ),
        BlocProvider<ZincThicknessBloc>(
          create: (_) => ZincThicknessBloc(),
        ),
        BlocProvider<TestconnectionBloc>(
          create: (_) => TestconnectionBloc(),
        ),
        BlocProvider<PmDailyBloc>(
          create: (_) => PmDailyBloc(),
        ),
        BlocProvider<PlanWindingBloc>(
          create: (_) => PlanWindingBloc(),
        ),
      ],
      child: MaterialApp(
          builder: EasyLoading.init(),
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
          initialRoute: "/",
          onGenerateRoute: RouteGenerator.generateRoute),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
