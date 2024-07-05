import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/BottomNavigation/categories.dart';
import 'package:royalmart/BottomNavigation/profile.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/General/Home.dart';
import 'package:royalmart/Web/WebviewTermandCondition.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/screen/CustomeOrder.dart';
import 'package:royalmart/screen/ShowAddress.dart';
import 'package:royalmart/screen/myorder.dart';
import 'package:royalmart/screen/newWishlist.dart';
import 'package:royalmart/screen/productlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:share/share.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool islogin = false;
  String name, email, image, cityname;
  int wcount;
  SharedPreferences pref;
  void gatinfo() async {
    pref = await SharedPreferences.getInstance();
    islogin = pref.get("isLogin");
    int wcount1 = pref.get("wcount");
    name = pref.get("name");
    email = pref.get("email");
    image = pref.get("pp");
    cityname = pref.get("city");
    if (islogin == null) {
      islogin = false;
    }

    // print(islogin);
    setState(() {
      Constant.name = name;
      Constant.email = email;
      islogin == null ? Constant.isLogin = false : Constant.isLogin = islogin;
      Constant.image = image;
      print(Constant.image);

      Constant.citname = cityname;

      // print( Constant.image.length);
      wcount = wcount1;
    });
  }

  bool check = false;
  // _displayDialog(BuildContext context) async {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         return AlertDialog(
  //           scrollable: true,
  //           title: Text('Select City'),
  //           content: Container(
  //             width: double.maxFinite,
  //             height: 400,
  //             child: FutureBuilder(
  //                 future: getPcity(),
  //                 builder: (context, snapshot) {
  //                   if (snapshot.hasData) {
  //                     return ListView.builder(
  //                         scrollDirection: Axis.vertical,
  //                         itemCount: snapshot.data.length == null ? 0 : snapshot.data.length,
  //                         itemBuilder: (BuildContext context, int index) {
  //                           return Container(
  //                             width: snapshot.data[index] != 0 ? 130.0 : 230.0,
  //                             color: Colors.white,
  //                             margin: EdgeInsets.only(right: 10),
  //                             child: InkWell(
  //                               onTap: () {
  //                                 setState(() {
  //                                   check = true;
  //                                   pref.setString('city', snapshot.data[index].places);
  //                                   pref.setString('cityid', snapshot.data[index].loc_id);
  //                                   Constant.cityid = snapshot.data[index].loc_id;
  //                                   Constant.citname = snapshot.data[index].places;
  //
  //                                   Navigator.pop(context);
  //
  //                                   Navigator.push(
  //                                     context,
  //                                     MaterialPageRoute(builder: (context) => MyApp1()),
  //                                   );
  //                                 });
  //                               },
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: <Widget>[
  //                                   Card(
  //                                     child: Container(
  //                                       width: MediaQuery.of(context).size.width,
  //                                       padding: EdgeInsets.all(10),
  //                                       child: Padding(
  //                                         padding: EdgeInsets.only(left: 10, right: 10),
  //                                         child: Text(
  //                                           snapshot.data[index].places,
  //                                           overflow: TextOverflow.ellipsis,
  //                                           maxLines: 2,
  //                                           style: TextStyle(
  //                                             fontSize: 15,
  //                                             color: AppColors.black,
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   // Divider(
  //                                   //
  //                                   //   color: AppColors.black,
  //                                   // ),
  //                                 ],
  //                               ),
  //                             ),
  //                           );
  //                         });
  //                   }
  //                   return Center(child: CircularProgressIndicator());
  //                 }),
  //           ),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text(
  //                 'CANCEL',
  //                 style: TextStyle(color: check ? Colors.green : Colors.grey),
  //               ),
  //               onPressed: () {
  //                 if (check) {
  //                   Navigator.of(context).pop(); // Pop the current route if check is true
  //                 } else {
  //                   showLongToast("Please Select city"); // Show a toast message if check is false
  //                 }
  //               },
  //             )
  //
  //           ],
  //         );
  //       });
  // }


  @override
  void initState() {
    gatinfo();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            color: AppColors.red,
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Container(
                height: 68,
                color: AppColors.tela,
                child: Center(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 11, right: 12),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp1()),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.teladep,
                            size: 25,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Menu",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            if (Constant.isLogin) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TrackOrder()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignInPage()),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.shopping_bag,
                            color: AppColors.teladep,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /* USER PROFILE DRAWER Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 40,left: 20),
                  color: AppColors.tela1,
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  child:CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.white,
                    child: ClipOval(
                      child: new SizedBox(
                        width: 100.0,
                        height: 100.0,
                        child:Constant.image==null? Image.asset('assets/images/logo.png',):Constant.image.length==1?Image.asset('assets/images/logo.png',):Constant.image=="https://www.bigwelt.com/manage/uploads/customers/nopp.png"? Image.asset('assets/images/logo.png',):Image.network(
                          Constant.image,
                          fit: BoxFit.fill,),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child:Text(islogin?Constant.name:" ",style: TextStyle(color: Colors.black),) ,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20,bottom: 20),
                  child:Text(islogin?Constant.email:" ",style: TextStyle(color: Colors.black),),
                ),
            /*    InkWell(
                  onTap: (){
                    _displayDialog(context);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20,bottom: 20),
                    child:Text(Constant.citname!=null?Constant.citname:" ",
                      overflow:TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: Colors.black),),
                  ),
                ),*/
              ],
            ),*/
          ),

          /* UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/drawer-header.jpg'),
                )),
            currentAccountPicture:  CircleAvatar(
              radius:30,
              backgroundColor: Colors.black,
              backgroundImage:Constant.image==null? AssetImage('assets/images/logo.jpg',):Constant.image.length==1?AssetImage('assets/images/logo.jpg',):Constant.image=="https://www.bigwelt.com/manage/uploads/customers/nopp.png"? AssetImage('assets/images/logo.jpg',):NetworkImage(
                  Constant.image),
            ),
            accountName: Text(islogin?Constant.name:" ",style: TextStyle(color: Colors.black),),
            accountEmail: Text(islogin?Constant.email:" ",style: TextStyle(color: Colors.black),),
          ),*/
          Container(
            child: ListView(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.home, color: AppColors.tela),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp1()),
                    );
                  },
                ),
                Divider(),
                ExpansionTile(
                  title: Text('My Account'),
                  leading: Icon(Icons.person, color: AppColors.tela),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: ListTile(
                          leading: Icon(
                            Icons.person,
                            color: AppColors.tela,
                          ),
                          title: Text("My Profile"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileView()),
                            );
                          }),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: ListTile(
                        leading: Icon(
                          Icons.shopping_bag,
                          color: AppColors.tela,
                        ),
                        title: Text("My Orders"),
                        onTap: () {
                          if (Constant.isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TrackOrder()),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignInPage()),
                            );
                          }
                        },
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: ListTile(
                        leading: Icon(
                          Icons.add_road,
                          color: AppColors.tela,
                        ),
                        title: Text("My Addresses"),
                        onTap: () {
                          if (Constant.isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ShowAddress("1")),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignInPage()),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Divider(),
                /*   ListTile(
                  leading: Icon(Icons.list_alt,
                      color: AppColors.tela),
                  title: Text('Shop By Categories'),
                  trailing: Text('',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(context, MaterialPageRoute(builder: (context) => Cgategorywise("0")),);
                  },
                ), */

                /* ListTile(
                  leading: Icon(Icons.offline_bolt_rounded,
                      color: AppColors.tela),
                  title: Text('Deals of the Day'),
                  trailing: Text('New',
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductList("day","DEALS OF THE DAY")),
                    );
                  },
                ),*/

                /* ListTile(
                  leading: Icon(Icons.stacked_line_chart,
                      color: AppColors.tela),
                  title: Text('Top Products'),
                  trailing: Text('',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductList("top","TOP PRODUCTS")),
                    );
                  },
                ),*/

                /* ListTile(
                  leading: Icon(Icons.traffic,
                      color: AppColors.tela),
                  title: Text('New Arrival'),
                  trailing: Text('',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          ProductList("day",
                              Constant.AProduct_type_Name2)),);
                  },
                ),*/
                /* ListTile(
                  leading:
                  Icon(Icons.favorite, color: AppColors.tela),
                  title: Text('My Wishlist'),
                  /* trailing: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Text(wcount!=null?wcount.toString():'0',
                        style: TextStyle(color: Colors.white, fontSize: 15.0)),
                  ),*/
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewWishList())
//                        NewWishList()),
//                      Cat_Product
                    );
                  },
                ), */

                /*  ListTile(
                  leading: Icon(Icons.star_border,
                      color: AppColors.tela),
                  title: Text('Rate US',),
                  onTap: () {
                    Navigator.of(context).pop();

                    String os = Platform.operatingSystem; //in your code
                    if (os == 'android') {
                      LaunchReview.launch(
                        androidAppId: "com.freshatdoorstep",);

                    }
                  },
                ),*/
                // ListTile(
                //   leading: Icon(Icons.analytics_rounded,
                //       color: AppColors.tela),
                //   title: Text('Blog'),
                //   trailing: Text('',
                //       style: TextStyle(color: Theme.of(context).primaryColor)),
                //   onTap: () {
                //     Navigator.of(context).pop();
                //
                //     Navigator.push(context, MaterialPageRoute(
                //         builder: (context) => BlogScreen()),
                //     );
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.phone, color: AppColors.tela),
                  title: Text('Contact Us'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "Contact Us",
                                ""
                                    "${Constant.base_url}contact"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.privacy_tip, color: AppColors.tela),
                  title: Text('Privacy Policy'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "Privacy Policy",
                                ""
                                    "${Constant.base_url}pp"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.privacy_tip, color: AppColors.tela),
                  title: Text('Shipping Policy'),
                  onTap: () {
                    _launchURL('http://www.bestdawai.w4u.us/cr');

                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.info, color: AppColors.tela),
                  title: Text('About Us'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "About Us",
                                ""
                                    "${Constant.base_url}about"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.file_copy, color: AppColors.tela),
                  title: Text('Terms & Conditions'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "Terms & Conditions",
                                ""
                                    "${Constant.base_url}tc"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                Divider(),
                /* ListTile(
                  leading:
                  Icon(Icons.file_copy, color: AppColors.tela),
                  title: Text('Terms & Conditions'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewClass("Terms & Conditions","https://www.freshatdoorstep.com/tc"))
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                    );
                  },
                ),*/
                /* ListTile(
                  leading:
                  Icon(Icons.question_answer, color: AppColors.tela),
                  title: Text('FAQ'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewClass("FAQ","https://www.freshatdoorstep.com/faq"))
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                    );
                  },
                ),*/
                ListTile(
                  leading: Icon(Icons.mobile_screen_share, color: AppColors.tela),
                  title: Text('Share'),
                  onTap: () {
                    _shairApp();
                  },
                ),
                Divider(),

                Constant.isLogin
                    ? new Container()
                    : ListTile(
                        leading: Icon(Icons.lock, color: AppColors.tela),
                        title: Text('Login'),
                        onTap: () {
                          Navigator.of(context).pop();

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignInPage()),
                          );
                        },
                      ),
                // Divider(),
//              ListTile(
//                leading:
//                    Icon(Icons.settings, color: AppColors.tela),
//                title: Text('Settings'),
//                onTap: () {
//
//                },
//              ),
                /* Constant.isLogin? ListTile(
                  leading: Icon(Icons.exit_to_app,
                      color: AppColors.tela),
                  title: Text('Logout'),
                  onTap: () async {
                    _callLogoutData();
                  },
                ):new Container()*/
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget rateUs() {
    return InkWell(
        onTap: () {
          String os = Platform.operatingSystem; //in your code
          if (os == 'android') {
            LaunchReview.launch(
              androidAppId: "https://play.google.com/store/apps/details?id=com.chickenista",
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
          child: Row(
            children: <Widget>[
              Text(
                "Rate Us",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14.0, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _callLogoutData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Constant.isLogin = false;
    Constant.email = " ";
    Constant.name = " ";
    Constant.image = " ";
    pref.setString("pp", " ");
    pref.setString("email", " ");
    pref.setString("name", " ");
    pref.setBool("isLogin", false);
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));
  }

  _shairApp() {
    Share.share("Hi, Looking for best deals online? Download " +
        Constant.appname +
        " app form click on this link  https://play.google.com/store/apps/details?id=${Constant.packageName}");
  }
}
