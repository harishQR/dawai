import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:royalmart/model/CategaryModal.dart';
import 'package:royalmart/model/productmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constant {
  // static const String base_url = "http://www.comelyindia.w4u.in/";
  static String appname = "Best Dawai";
  static String packageName = "com.bestdawaiappuser";
  static const String base_url = "http://www.bestdawai.w4u.us/";
  static const String mainurl = "http://www.bigweltpharmacydemo.w4u.in/";
  static const String API_KEY = "RXW2ZEPH9LYJA7G5SCQT4M8BDVNUKF63";
  static const String Shop_id = "31081";
  // "1948";
  static const String registration = "user.php";
  static const String post = "post.php";
  static const String Subscription = "subscription.php";
  static const String postvalue = "post.php?key=1234&action=add";
  static bool isLogin = false;
  static String Base_Imageurl = base_url + "manage/uploads/gallery/";
  static String Product_Imageurl = base_url + "manage/uploads/gallery/";
  static String Product_Imageurl2 = base_url + "manage/uploads/gallery/";
  static String Product_Imageurl1 = base_url + "manage/uploads/gallery/1/";
  static String Product_Imageurl5 = base_url + "manage/uploads/gallery/";
  static String Product_Imageurl6 = base_url + "manage/uploads/manage_pages/";
  static String AppName_showon_Homescreen = "Category";
  static String AppName_showon_Homescreen1 = "Creation";
  static String AProduct_type_Name1 = "Trending";
  static String AProduct_type_Name2 = "New Arrival";
  static String my_Order = "My orders";
  static String Shipping_add = "Shipping addresses";
  static String My_Review = "My review";
  static int val = 0;
  static String cityid = "";
  static String pinid = "";
  static String citname = "";
  static bool Checkupdate = false;
  static String contact = "9284310365";

  static double latitude = 0.0;
  static double longitude = 0.0;
  static String User_ID = "";
  static bool check = false;
  static String Mobile = "";
  static String username = " ";
  static String email11 = "surajwagh8586@gmail.com ";
  static String name = " ";
  static String user_id = " ";
  static String email = " ";
  static String image = "";
  static String phone = "tel: 9284310365";
  final String SIGN_IN = 'signin';
  final String SIGN_UP = 'signup';
  static int itemcount = 0;
  static int wishlist = 0;
  static int carditemCount = 0;
  static double totalAmount = 0;
  static double shipingAmount = 0;
  static List<Categary> list = List();

  static Widget setvalue() {}
}

class AppColors {
  static const red = Color(0xFFE3F2FD);
  static const grey = Color(0xFF424242);
  static const black = Color(0xFF222222);
  static const blackdrawer = Color(0xFF222222);
  static const product_title_name = Color(0xFF222222);
  static const App_H_name = Color(0xFF222222);
  static const Appname = Color(0xFFFFFFFF);

  static const tela = Color(0xFFfc6c31);
  static const tela1 = Color(0xFFfcec39);
  static const bgColor = Color(0xFF8be4e5);
  static const teladep = Color(0xFF222222);
  static const telamoredeep = Color(0xFF40C4FF);
  static const onselectedBottomicon = Color(0xFFFF8F00);
  static const homeiconcolor = Color(0xFFFF8F00);
  static const category_button_Icon_color = Color(0xFFFF8F00);
  static const categoryicon = Color(0xFF00BCD4);
  static const carticon = Color(0xFFFF80AB);
  static const lightGray = Color(0xFF9B9B9B);
  static const darkGray = Color(0xFF616161);
  static const mrp = Color(0xFF979797);
  static const sellp = Color(0xFF2AA952);
  static const white = Color(0xFFFFFFFF);
  static const button_text_color = Color(0xFF607D8B);
  static const success = Color(0xFF2AA952);
  static const green = Color(0xFF2AA952);
  static const pink = Color(0xFFFF4081);
  static const boxColor1 = tela;
  static const boxColor2 = tela1;
  static const checkoup_paybuttoncolor = Color(0xFF40C4FF);
}

Widget showCircle() {
  return Align(
    alignment: Alignment.center,
    child: Padding(
      padding: EdgeInsets.only(left: 15, bottom: 18),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.homeiconcolor,
          // color: Colors.orange,
        ),
        child: Text('${Constant.carditemCount}',
            style: TextStyle(color: Colors.white, fontSize: 15.0)),
      ),
    ),
  );
}

Widget showLongToast(String s) {
  Fluttertoast.showToast(
    msg: s,
    toastLength: Toast.LENGTH_LONG,
  );
}

Widget showSticker(int index, List<Products> product) {
  // double.parse(products1[index].discount)>0?
  return Align(
    alignment: Alignment.topLeft,
    child: Stack(
      children: [
        Container(
          height: 70,
          width: 80,
          child: Image.asset("assets/images/rebon.png"),
        ),
        Container(
          padding: const EdgeInsets.only(left: 9.0, top: 11),
          child: RotationTransition(
            turns: new AlwaysStoppedAnimation(360 / 192),
            child: new Text(
              "${double.parse(product[index].discount).toStringAsFixed(0)} % off",
              style: TextStyle(color: AppColors.white, fontSize: 10),
            ),
          ),
        ),

        // Padding(
        //   padding: const EdgeInsets.only(left:30.0,top:3),
        //   child: Text("${double.parse(products1[index].discount).toStringAsFixed(0)} % off",style: TextStyle(color: AppColors.white,fontSize: 12),),
        // ),
      ],
    ),
  );
}

Widget showSticker1(int index, List<Products> product) {
  // double.parse(products1[index].discount)>0?
  return Align(
    alignment: Alignment.topLeft,
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
            ),
            color: Colors.red,
          ),
          height: 35,
          width: 60,
          child: Center(
              child: new Text(
            "${double.parse(product[index].discount).toStringAsFixed(0)} % off",
            style: TextStyle(color: AppColors.white, fontSize: 10),
          )),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left:30.0,top:3),
        //   child: Text("${double.parse(products1[index].discount).toStringAsFixed(0)} % off",style: TextStyle(color: AppColors.white,fontSize: 12),),
        // ),
      ],
    ),
  );
}

Future cartItemcount(int val) async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  pref.setInt("itemCount", val);
  print(val.toString() + "shair....");
}
