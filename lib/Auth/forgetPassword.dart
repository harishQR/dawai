import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/Auth/widgets/custom_shape.dart';
import 'package:royalmart/Auth/widgets/customappbar.dart';
import 'package:royalmart/Auth/widgets/register.dart';
import 'package:royalmart/Auth/widgets/responsive_ui.dart';
import 'package:royalmart/Auth/widgets/textformfield.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/locatization/language_constant.dart';
import 'package:royalmart/model/RegisterModel.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ForgetPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child:Scaffold(
        body:


        ForgetPassword(),
      ),);
  }
}

class ForgetPassword extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<ForgetPassword> {

  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextEditingController nameController = TextEditingController();
//  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  void _showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }
  Future _getEmployee() async {
    SharedPreferences pref= await SharedPreferences.getInstance();

    var map = new Map<String, dynamic>();
    map['shop_id']=Constant.Shop_id;
    map['mobile']=nameController.text;
    final response = await http.post(Uri.parse(Constant.base_url+'api/forgot.php'),body:map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      User user = User.fromJson(jsonDecode(response.body));
      print(jsonBody.toString());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignInPage()));
      if(user.message.toString()=="Password has been sent to your email")
      {
//
      _showLongToast(user.message);
      Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInPage()));

      }
      else {
        _showLongToast(user.message);
      }

    } else
      throw Exception("Unable to get Employee list");
  }



  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      child: Container(
        height: _height,
        width: _width,
        padding: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Opacity(opacity: 0.88,child: CustomAppBar()),
              clipShape(),
              welcomeTextRow(),
              // signInTextRow(),
              form(),
//              forgetPassTextRow(),
              SizedBox(height: _height / 12),
              button(),
//              signUpTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height:_large? _height/4 : (_medium? _height/3.75 : _height/3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.boxColor1, AppColors.boxColor2],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large? _height/4.5 : (_medium? _height/4.25 : _height/4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.boxColor1, AppColors.boxColor2],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(top: _large? _height/60 : (_medium? _height/25 : _height/40)),
          child: Image.asset(
            'assets/images/logo.png',
            height: 200,
            width: 200,
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          Text(
            "${getTranslated(context, 'wel')}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large? 60 : (_medium? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Change your password!",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large? 20 : (_medium? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0,
          right: _width / 12.0,
          top: _height / 15.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height / 40.0),
//            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: nameController,
      icon: Icons.phone_android,
      hint: "${getTranslated(context, 'mob')}",
    );

  }

//  Widget passwordTextFormField() {
//    return CustomTextField(
//      keyboardType: TextInputType.emailAddress,
//      textEditingController: passwordController,
//      icon: Icons.lock,
//      obscureText: true,
//      hint: "Password",
//    );
//  }

  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Forgot your password?",
            style: TextStyle(fontWeight: FontWeight.w400,fontSize: _large? 14: (_medium? 12: 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              print("Routing");
            },
            child: Text(
              "Recover",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: AppColors.boxColor1),
            ),
          )
        ],
      ),
    );
  }

  Widget button() {
    return
  //       RaisedButton(
  //       elevation: 0,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
  //       onPressed: () {
  //         if (nameController.text.length!=10){
  //
  //           _showLongToast("Please enter the valied No.");
  //
  //
  //         }
  // //        else if(passwordController.text.length <3) {
  // //          _showLongToast("Password should be 6 latter");
  // //        }
  //         else {
  //           _getEmployee();
  //         }
  //
  // //          print("Routing to your account");
  // //          Scaffold
  // //              .of(context)
  // //              .showSnackBar(SnackBar(content: Text('Login Successful')));
  //
  //       },
  //       textColor: Colors.white,
  //       padding: EdgeInsets.all(0.0),
  //       child: Container(
  //         alignment: Alignment.center,
  //         width: _large? _width/4 : (_medium? _width/3.75: _width/3.5),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.all(Radius.circular(20.0)),
  //           gradient: LinearGradient(
  //             colors: <Color>[AppColors.boxColor1, AppColors.boxColor2],
  //           ),
  //         ),
  //         padding: const EdgeInsets.all(12.0),
  //         child: Text('${getTranslated(context, 'sub')}',style: TextStyle(fontSize: _large? 14: (_medium? 12: 10))),
  //       ),
  //     );
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          padding: EdgeInsets.all(0.0),
        ),
        onPressed: () {
          if (nameController.text.length != 10) {
            _showLongToast("Please enter a valid number.");
          } else {
            _getEmployee();
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            gradient: LinearGradient(
              colors: <Color>[AppColors.boxColor1, AppColors.boxColor2],
            ),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Text(
            '${getTranslated(context, 'sub')}',
            style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10), color: Colors.white),
          ),
        ),
      );

  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(fontWeight: FontWeight.w400,fontSize: _large? 14: (_medium? 12: 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Register()),
              );
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: AppColors.boxColor1, fontSize: _large? 19: (_medium? 17: 15)),
            ),
          )
        ],
      ),
    );
  }

}
