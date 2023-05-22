import 'package:flutter/material.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/button/Button.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/input/boxInputField.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/route/router_list.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BgWhite(
      isHideAppBar: true,
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Label(
                    "Document Control",
                    fontSize: 25,
                  ),
                )),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: COLOR_WHITE,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black, blurRadius: 1, spreadRadius: 0),
                      BoxShadow(
                          color: Colors.black, blurRadius: 5, spreadRadius: 0),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            BoxInputField(
                              labelText: "Username",
                              controller: _userController,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Button(
                              text: Label(
                                "Login",
                                color: COLOR_WHITE,
                              ),
                              onPress: () => Navigator.pushNamed(
                                  context, RouterList.MAIN_MENU),
                            ),
                            const SizedBox(
                              height: 13,
                            ),
                            Button(
                              text: Label(
                                "Settings",
                                color: COLOR_WHITE,
                              ),
                              bgColor: COLOR_RED_LIGTHINS,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
