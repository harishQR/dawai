import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:royalmart/BottomNavigation/screenpage.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/locatization/language.dart';
import 'package:royalmart/locatization/language_constant.dart';
import 'package:royalmart/model/productmodel.dart';
import 'package:royalmart/screen/SelectCity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'AppConstant.dart';
import 'Home.dart';

class AnimatedSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  static List<Products> filteredUsers = new List();

  var _visible = true;
  String logincheck;
  void _changelanguage(String language) async {
    Locale _locale = await setLocale(language);
    MyApp.setLocale(context, _locale);
  }

  void checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String cityname = pref.getString("city");
    String cityid = pref.getString("cityid");
    String lang_cod = pref.getString("language_code");
    _changelanguage(lang_cod != null ? lang_cod : "en");
    print("lang_cod ${lang_cod}");

    setState(() {
      Constant.cityid = cityid != null ? cityid : "";
      print(Constant.cityid);
      // cityid==null? Navigator.push(context, MaterialPageRoute(builder: (context) => SelectCity()),
      // ):Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),);
    });

    // print(cityname);
  }

  AnimationController animationController;
  Animation<double> animation;
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    checkLogin();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp1()),
    );
    /* Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );*/
  }

  @override
  void initState() {
    super.initState();

    DatabaseHelper.getData("0").then((usersFromServe) {
      setState(() {
        ScreenState.list = usersFromServe;
      });
    });

    DatabaseHelper.getSlider().then((usersFromServe1) {
      if (this.mounted) {
        setState(() {
          ScreenState.sliderlist = usersFromServe1;
        });
      }
    });
//
//
//     DatabaseHelper.getTopProduct("top","10").then((usersFromServe){
//       setState(() {
//         ScreenState.topProducts=usersFromServe;
//       });
//     });
//
// //    search
//     DatabaseHelper.getTopProduct1("new","10").then((usersFromServe){
//       setState(() {
//         ScreenState.dilofdayProducts=usersFromServe;
//       });
//     });

    search("").then((usersFromServe) {
      setState(() {
        filteredUsers = usersFromServe;
//        print(filteredUsers.length.toString()+" jkjg");
      });
    });
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
//    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
//              Padding(padding: EdgeInsets.only(bottom: 30.0),child:new Image.asset('assets/images/powered_by.png',height: 25.0,fit: BoxFit.scaleDown,))
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/splash.gif',
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
