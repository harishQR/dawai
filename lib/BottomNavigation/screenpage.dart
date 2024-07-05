import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/BottomNavigation/test_page.dart';
import 'package:royalmart/BottomNavigation/wishlist.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/General/Home.dart';
import 'package:royalmart/dbhelper/CarrtDbhelper.dart';
import 'package:royalmart/BottomNavigation/categories.dart';

import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/model/CategaryModal.dart';
import 'package:royalmart/model/Gallerymodel.dart';
import 'package:royalmart/model/productmodel.dart';
import 'package:royalmart/model/slidermodal.dart';
import 'package:royalmart/screen/SearchScreen.dart';
import 'package:royalmart/screen/SubCategry.dart';
import 'package:royalmart/screen/custom_order.dart';
import 'package:royalmart/screen/detailpage.dart';
import 'package:royalmart/screen/detailpage1.dart';
import 'package:royalmart/screen/myorder.dart';
import 'package:royalmart/screen/productlist.dart';
import 'package:royalmart/screen/secondtabview.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'new_cat.dart';

Future<PromotionBanner> createAlbum(String shop_id) async {
  var body = {"shop_id": Constant.Shop_id};
  final response = await http.post(Uri.parse('https://www.bigwelt.com/api/app-promo-banner.php'), body: body);
  print("response------>" + response.body);

  print("jsonDecode(response.body)---> ${jsonDecode(response.body)}");
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return PromotionBanner.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class PromotionBanner {
  String shopId;
  String images;
  bool status;
  String msg;
  String path;

  PromotionBanner({this.shopId, this.images, this.status, this.msg, this.path});

  PromotionBanner.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    images = json['images'];
    status = json['status'];
    msg = json['msg'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_id'] = this.shopId;
    data['images'] = this.images;
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['path'] = this.path;
    return data;
  }
}

class Screen extends StatefulWidget {
  @override
  ScreenState createState() => ScreenState();
}

class ScreenState extends State<Screen> {
  static int cartvalue = 0;

  bool progressbar = true;

  static List<String> imgList5 = [
    'https://www.liveabout.com/thmb/y4jjlx2A6PVw_QYG4un_xJSFGBQ=/400x250/filters:no_upscale():max_bytes(150000):strip_icc()/asos-plus-size-maxi-dress-56e73ba73df78c5ba05773ab.jpg',
    'https://www.thebalanceeveryday.com/thmb/lMeVfLyCZWVPdU5eyjFLyK4AYQs=/400x250/filters:no_upscale():max_bytes(150000):strip_icc()/metrostyle-catalog-df95d1ece06c4197b1da85e316a05f90.jpg',
    'https://rukminim1.flixcart.com/image/400/450/k3xcdjk0pkrrdj/sari/h/d/x/free-multicolor-combosr-28001-ishin-combosr-28001-original-imafa5257bxdzm5j.jpeg?q=90',
    'https://i.pinimg.com/474x/62/4e/ce/624ece8daf9650f1a382995b340dc1e9.jpg'
  ];

  int _current = 0;
  var _start = 0;
  static List<Categary> list = new List<Categary>();
  static List<Categary> list1 = new List<Categary>();
  static List<Categary> list2 = new List<Categary>();
  static List<Slider1> sliderlist = List<Slider1>();

  static List<Products> topProducts = List();
  static List<Products> bestDealsProducts = List();

  static List<Products> topProducts1 = List();
  static List<Products> dilofdayProducts = [];
  static List<Slider1> bannerSlider = List();
  List<Gallery> galiryImage = List();
  final List<String> imgL = List();
  List<Products> products1 = List();
  double sgst1, cgst1, dicountValue, admindiscountprice;
  PromotionBanner promotionBanner = PromotionBanner();
  String imageUrl = '';

  double mrp, totalmrp = 000;
  int _count = 1;

  // PackageInfo packageInfo ;
  // AppUpdateInfo _updateInfo;
  String lastversion = "0";
  int valcgeck;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  /* Future<void> checkForUpdate(BuildContext contex) async {
    packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    lastversion=version.substring(version.lastIndexOf(".")+1);

    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        valcgeck=int.parse(lastversion);
        _updateInfo = info;
        if(_updateInfo?.updateAvailable){
          Showpop();
        }
        _updateInfo?.updateAvailable == true;
        print(_updateInfo);
        print(version);
        print(_updateInfo.availableVersionCode-valcgeck);
        print(lastversion);
        print("_updateInfo.......");

//        showDilogue(contex);
        print(_updateInfo);
      });
    }).catchError((e) => _showError(e));
  }*/

  getPackageInfo() async {
    NewVersion newVersion = NewVersion(context: context);
    final status = await newVersion.getVersionStatus();
    // status.canUpdate; // (true)
    // status.localVersion ;// (1.2.1)
    // status.storeVersion; // (1.2.3)
    // status.appStoreLink;
    newVersion.showAlertIfNecessary();
    // print(status.canUpdate);
    // print(status.localVersion);
    // print(status.storeVersion);
    // print(status.appStoreLink);
  }

  final addController = TextEditingController();

  Position position;

  getAddress(double lat, double long) async {
    final coordinates = new Coordinates(lat, long);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      var address = first.subLocality.toString() +
          " " +
          first.subAdminArea.toString() +
          " " +
          first.featureName.toString() +
          " " +
          first.thoroughfare.toString();

      addController.text = address.replaceAll("null", "");
      // print('Rahul ${address}');
      // pref.setString("lat", lat.toString());
      // pref.setString("lat", lat.toString());
      // pref.setString("add", address.toString().replaceAll("null", ""));
    });
  }

  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      Constant.latitude = position.latitude;
      Constant.longitude = position.longitude;
      print(' lat ${Constant.latitude},${Constant.longitude}');
      getAddress(Constant.latitude, Constant.longitude);
    });
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();

    if (Constant.Checkupdate) {
      getPackageInfo();
      Constant.Checkupdate = false;
    }
    // checkForUpdate(context);

    DatabaseHelper.getData("0").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          list = usersFromServe;
        });
      }
    });

    DatabaseHelper.getSlider().then((usersFromServe1) {
      if (this.mounted) {
        setState(() {
          sliderlist = usersFromServe1;
        });
      }
    });

    DatabaseHelper.getPromotionBanner(Constant.Shop_id).then((value) {
      if (this.mounted) {
        print("valueee--> ${value.path}");
        promotionBanner = value;
        imageUrl = value.path;
        setState(() {});
      }
      print("my url--------->");
      print(Constant.mainurl + promotionBanner.path + promotionBanner.images);
      var url = Constant.mainurl + promotionBanner.path + promotionBanner.images;
    });
    DatabaseHelper.getTopProduct("top", "0").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          ScreenState.topProducts = usersFromServe;
//          ScreenState.topProducts.add(topProducts[0]);
        });
      }
    });
    DatabaseHelper.getTopProduct("day", "0").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          ScreenState.topProducts1 = usersFromServe;
//          ScreenState.topProducts.add(topProducts[0]);
        });
      }
    });

    DatabaseHelper.getfeature("yes", "10").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          products1 = usersFromServe;
//          ScreenState.topProducts.add(topProducts[0]);
        });
      }
    });
    DatabaseHelper.getTopProduct("best", "10").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          bestDealsProducts = usersFromServe;
          print("best---->${bestDealsProducts.first.productName}");
          print("best---->${bestDealsProducts.last.productName}");
//          ScreenState.topProducts.add(topProducts[0]);
        });
      }
    });
    getBanner().then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          bannerSlider = usersFromServe;
//          ScreenState.topProducts.add(topProducts[0]);
        });
      }
    });

//    search
    DatabaseHelper.getTopProduct1("new", "0").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          ScreenState.dilofdayProducts = usersFromServe;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    showDilogue(context);
    return Container(
        //color: Colors.white,
        color: Colors.grey.shade200,
        child: CustomScrollView(slivers: <Widget>[
          SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
              // The builder function returns a ListTile with a title that
              // displays the index of the current item.
              (context, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: AppColors.tela,
                    child: GestureDetector(
                      onTap: () {
                        _getCurrentLocation();
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => UserFilterDemo()),);
                      },
                      child: Card(
                        color: AppColors.tela,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0.0,
                        child: Container(
                          margin: EdgeInsets.only(top: 0, bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Material(
                              color: Colors.white,
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => UserFilterDemo()),
                                    );
                                  },
                                  child: TextField(
                                    enabled: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                        hintText: "            Looking for a medicine? Search",
                                        hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
                                        suffixIcon: Icon(
                                          Icons.search,
                                          color: AppColors.tela,
                                        )),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  sliderlist != null
                      ? sliderlist.length > 0
                          ? Container(
                              height: 200.0,
                              child: sliderlist != null
                                  ? sliderlist.length > 0
                                      ? CarouselSlider.builder(
                                          itemCount: sliderlist.length,
                                          options: CarouselOptions(
                                            aspectRatio: 2.7,
                                            viewportFraction: 1.3,
                                            // enlargeCenterPage: true,
                                            autoPlay: true,
                                          ),
                                          itemBuilder: (ctx, index, realIdx) {
                                            return Container(
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (!sliderlist[index].title.isEmpty) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => Screen2(sliderlist[index].title, "")),
                                                    );
                                                  } else if (!sliderlist[index].description.isEmpty) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => ProductDetails1(sliderlist[index].description)),
                                                    );
//

                                                  }
                                                },
                                                child: Container(

                                                    margin: EdgeInsets.only(left: 5.0, right: 5),
                                                    child: Card(
                                                      elevation: 7.0,
                                                      shadowColor: AppColors.tela,
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                                      child: ClipRRect(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(8.0),

                                                          ),
                                                          child: CachedNetworkImage(

                                                            width: MediaQuery.of(context).size.width - 15,
                                                            fit: BoxFit.fill,
                                                            imageUrl: Constant.Base_Imageurl + sliderlist[index].img,
                                                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                                            errorWidget: (context, url, error) => new Icon(Icons.error),
                                                          )),
                                                    )),
                                              ),
                                            );
                                          },
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor: AppColors.tela,
                                          ),
                                        )
                                  : Row())
                          : Container()
                      : Container(),

                  /*   Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all( 10) ,


                            decoration: new BoxDecoration(
//                              color: AppColors.white,
                       border:Border.all(
                           color: Colors.green
                       ),

                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image:  AssetImage("assets/images/banner2.jpeg"),
                            ),
                           borderRadius: BorderRadius.circular(10),


                              color: Colors.white,
                            ),

                          ),*/

                  /*list!=null?list.length>0? Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8.0, left: 8.0, right: 8.0),
                                  child: Text("Shop By Categories",
                                    style: TextStyle(
                                        color: AppColors.product_title_name,
                                        fontSize: 15,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                              ],
                            ),
                          ):Container():Container(),*/
                  /* list!=null? Container(
                            color: Color(0xFFf2f2f2),
//                    margin: EdgeInsets.symmetric(vertical: 8.0),
                            height: 170.0,

                            child: list!=null?list.length != null ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: list.length == null ? 0 : list
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(


                                    margin: EdgeInsets.symmetric(horizontal: 5),

                                    child: Column(
                                      children: <Widget>[
                                        Card(
                                          // color: AppColors.black,

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),),
                                          child: Material(
                                            color: AppColors.white,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => Cgategorywise("0")),);
                                                // Navigator.push(context, MaterialPageRoute(builder: (context) => Sbcategory(list[index].pCats, list[index].pcatId)),);

                                              },
                                              child: Container(
                                                height: 150.0,
                                                width: 150.0,
                                                decoration: new BoxDecoration(

                                                    borderRadius: BorderRadius.circular(10),
                                                    image: DecorationImage(
                                                        image:list[index].img.isEmpty? AssetImage("assets/images/logo.png",):NetworkImage(
                                                            Constant.base_url +
                                                                "manage/uploads/p_category/" +
                                                                list[index].img),
                                                        fit: BoxFit.cover
                                                    )
                                                ),
                                                child: Container(
//
                                                  decoration: BoxDecoration(
                                                    // color: AppColors.tela1,
                                                    borderRadius: BorderRadius
                                                        .circular(10),


                                                  ),
                                                  child: Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Container(
                                                        alignment:Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: AppColors.tela,
                                                          borderRadius: BorderRadius.only(
                                                              bottomRight: Radius.circular(10.0),
                                                              bottomLeft: Radius.circular(10.0)),
                                                        ),
                                                        width: MediaQuery.of(context).size.width,
                                                        height: 28,
                                                        child: Text(
                                                          list[index].pCats,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              fontSize: 12),
                                                        ),
                                                      )


                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),



                                      ],
                                    )

                                );
                              },) : Center(
                              child: CircularProgressIndicator(
                                backgroundColor: AppColors.tela,
                              ),
                            ):Container(),



                          ):Row(),*/

                  list != null
                      ? list.length > 0
                          ? Container(
                              color: AppColors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 10),
                                    child: Text(
                                      "Shop by Category",
                                      style: TextStyle(
                                          color: AppColors.product_title_name, fontSize: 14, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container()
                      : Container(),
                  list != null
                      ? list.length > 0
                          ? Container(
                                height:125,
                              child: GridView.count(
                                  physics: ClampingScrollPhysics(),
                                  controller: new ScrollController(keepScrollOffset: false),
                                  shrinkWrap: true,
                                  crossAxisCount: 4,
                                  childAspectRatio: 0.64,
                                  padding: EdgeInsets.only(top: 0, left: 0, right: 6, bottom: 0),
                                  children: List.generate(list.length, (index) {
                                    return InkWell(
                                      onTap: () {
                                        var i = list[index].pcatId;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Sbcategory(list[index].pCats, list[index].pcatId)),
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(0.0, 25.0, 5.0, 0.0),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(35),
                                              ),
                                              width: 70,
                                              height: 70,
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(35),
                                                ),
                                                elevation: 7.0,
                                                shadowColor: AppColors.tela,
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(0.0),
                                                      child: list[index].img.isEmpty
                                                          ? Image.asset("assets/images/logo.png", fit: BoxFit.fill)
                                                          : Image.network(Constant.base_url + "manage/uploads/p_category/" + list[index].img,
                                                              fit: BoxFit.fill),
                                                    )),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                // SizedBox(height: 10.0),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    list[index].pCats,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                      color: AppColors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                          ],
                                        ),
                                      ),
                                    );
                                  })),
                            )
                          : Row()
                      : Row(),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 7, right: 5),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CustomOrder()),
                            );
                          },
                          child: Container(
                            height: 70,
                            width: (MediaQuery.of(context).size.width / 2) - 2,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadowColor: AppColors.tela,
                                elevation: 7,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 10, top: 15),
                                      child: Text(
                                        "Upload Prescription",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10, top: 0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Save upto 50%",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: AppColors.sellp),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 12,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (Constant.isLogin) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TrackOrder()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CustomOrder()),
                              );
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 4),
                            height: 70,
                            width: (MediaQuery.of(context).size.width / 2) - 14,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadowColor: AppColors.tela,
                                elevation: 7,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 10, top: 15),
                                      child: Text(
                                        "Previous Orders",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10, top: 0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "View Orders",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: AppColors.tela),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 12,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  topProducts.length > 0
                      ? Container(
                          color: AppColors.white,
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                                child: Text(
                                  Constant.AProduct_type_Name1,
                                  style:
                                      TextStyle(color: AppColors.product_title_name, fontSize: 14, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
                                child:
                                // RaisedButton(
                                //     color: AppColors.tela,
                                //     child: Text('View All', style: TextStyle(color: AppColors.white)),
                                //     onPressed: () {
                                //       Navigator.push(
                                //         context,
                                //         MaterialPageRoute(builder: (context) => ProductList("Top", Constant.AProduct_type_Name1)),
                                //       );
                                //     }),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: AppColors.tela,
                                  ),
                                  child: Text('View All', style: TextStyle(color: AppColors.white)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ProductList("Top", Constant.AProduct_type_Name1)),
                                    );
                                  },
                                ),

                              )
                            ],
                          ),
                        )
                      : Container(),

                  topProducts.length > 0
                      ? Container(
//                            color: AppColors.black,
                          height: 325.0,
                          child: topProducts != null
                              ? Container(
//                              color: AppColors.tela,
                                  margin: EdgeInsets.only(
                                    left: 0.0,
                                  ),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: topProducts.length == null ? 0 : topProducts.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ProductDetails(topProducts[index])),
                                            );
                                          },
                                          child: Container(
                                            margin: index == 0
                                                ? EdgeInsets.only(left: 7.0, top: 20, bottom: 20)
                                                : EdgeInsets.only(left: 7.0, top: 20, bottom: 20),
                                            height: 260,
                                            width: 200,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              shadowColor: AppColors.tela,
                                              elevation: 7,
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        height: 130,
                                                        width: 200,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.only(
                                                            topRight: Radius.circular(10),
                                                            topLeft: Radius.circular(10),
                                                          ),
                                                          child: CachedNetworkImage(
                                                            fit: BoxFit.fill,
                                                            imageUrl: Constant.Product_Imageurl + topProducts[index].img,
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
                                                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                                            errorWidget: (context, url, error) => new Icon(Icons.error),
                                                          ),
                                                        ),
                                                      ),
                                                      double.parse(topProducts[index].discount) > 0
                                                          ? Align(
                                                              alignment: Alignment.topRight,
                                                              child: Container(
                                                                height: 50,
                                                                width: 40,
                                                                child: Stack(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/images/discountTag.png",
                                                                      fit: BoxFit.fill,
                                                                    ),
                                                                    Center(
                                                                      child: Text(
                                                                        "${double.parse(topProducts[index].discount).toStringAsFixed(0)}%\noff",
                                                                        style: TextStyle(
                                                                            color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5, right: 5),
                                                    child: Container(
                                                      height: 40,
                                                      child: Text(
                                                        topProducts[index].productName,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Divider(
                                                    thickness: 1,
                                                    color: AppColors.tela,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text('\u{20B9}${calDiscount(topProducts[index].buyPrice, topProducts[index].discount)}',
                                                          style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w700, fontSize: 12)),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        '(MRP \u{20B9} ${topProducts[index].buyPrice})',
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontStyle: FontStyle.italic,
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                            decoration: TextDecoration.lineThrough),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 7,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      if (Constant.isLogin) {
                                                        String mrp_price = calDiscount(topProducts[index].buyPrice, topProducts[index].discount);
                                                        totalmrp = double.parse(mrp_price);

                                                        double dicountValue = double.parse(topProducts[index].buyPrice) - totalmrp;
                                                        String gst_sgst = calGst(mrp_price, topProducts[index].sgst);
                                                        String gst_cgst = calGst(mrp_price, topProducts[index].cgst);

                                                        String adiscount = calDiscount(topProducts[index].buyPrice,
                                                            topProducts[index].msrp != null ? topProducts[index].msrp : "0");

                                                        admindiscountprice = (double.parse(topProducts[index].buyPrice) - double.parse(adiscount));

                                                        String color = "";
                                                        String size = "";
                                                        _addToproducts(
                                                            topProducts[index].productIs,
                                                            topProducts[index].productName,
                                                            topProducts[index].img,
                                                            int.parse(mrp_price),
                                                            int.parse(topProducts[index].count),
                                                            color,
                                                            size,
                                                            topProducts[index].productDescription,
                                                            gst_sgst,
                                                            gst_cgst,
                                                            topProducts[index].discount,
                                                            dicountValue.toString(),
                                                            topProducts[index].APMC,
                                                            admindiscountprice.toString(),
                                                            topProducts[index].buyPrice,
                                                            topProducts[index].shipping,
                                                            topProducts[index].quantityInStock);

                                                        setState(() {
//                                                                              cartvalue++;
                                                          Constant.carditemCount++;
                                                          cartItemcount(Constant.carditemCount);
                                                        });

//                                                                Navigator.push(context,
//                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);

                                                      } else {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => SignInPage()),
                                                        );
                                                      }
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        height: 40,
                                                        width: 100,
                                                        child: Card(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          elevation: 7,
                                                          color: AppColors.tela,
                                                          child: Center(
                                                              child: Text(
                                                            "ADD",
                                                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: AppColors.tela,
                                  ),
                                ),
                        )
                      : Container(),
                  //appBanner

                  bestDealsProducts.length > 0
                      ? Container(
                          color: AppColors.white,
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                                child: Text(
                                  "Best Deals",
                                  style:
                                      TextStyle(color: AppColors.product_title_name, fontSize: 14, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
                                child:
                                // RaisedButton(
                                //     color: AppColors.tela,
                                //     child: Text('View All', style: TextStyle(color: AppColors.white)),
                                //     onPressed: () {
                                //       Navigator.push(
                                //         context,
                                //         MaterialPageRoute(builder: (context) => ProductList("best", "Best Deals")),
                                //       );
                                //     }),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.tela,
                                  ),
                                  child: Text('View All', style: TextStyle(color: AppColors.white)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ProductList("best", "Best Deals")),
                                    );
                                  },
                                ),

                              )
                            ],
                          ),
                        )
                      : Container(),

                  bestDealsProducts.length > 0 && bestDealsProducts.isNotEmpty
                      ? Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: bestDealsProducts.length ,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetails(bestDealsProducts[index]),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 7, right: 7, top: 8),
                                    height: 130,
                                    width: MediaQuery.of(context).size.width,
                                    child: Stack(
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          elevation: 7,
                                          shadowColor: AppColors.tela,
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: 10),
                                                height: 100,
                                                width: 100,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  elevation: 7,
                                                  shadowColor: AppColors.tela,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(15),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.fill,
                                                      imageUrl: Constant.Product_Imageurl + bestDealsProducts[index].img,
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
                                                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                                      errorWidget: (context, url, error) => new Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(left: 8, top: 40),
                                                    height: 20,
                                                    width: MediaQuery.of(context).size.width / 1.6,
                                                    child: Text(
                                                      bestDealsProducts[index].productName,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.visible,
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(left: 8, top: 0),
                                                    height: 20,
                                                    width: MediaQuery.of(context).size.width / 1.6,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            '\u{20B9}${calDiscount(bestDealsProducts[index].buyPrice, bestDealsProducts[index].discount)}',
                                                            style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w700, fontSize: 12)),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          '(MRP \u{20B9} ${bestDealsProducts[index].buyPrice})',
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w700,
                                                              fontStyle: FontStyle.italic,
                                                              fontSize: 12,
                                                              color: Colors.grey,
                                                              decoration: TextDecoration.lineThrough),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            margin: EdgeInsets.only(top: 4, right: 14),
                                            width: 40,
                                            height: 40,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  child: Image.asset(
                                                    "assets/images/discountTag.png",
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                Center(
                                                  child: Text(
                                                    double.parse(bestDealsProducts[index].discount).toStringAsFixed(0) + "%\n off",
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: AppColors.white),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Container(),

                  bannerSlider != null
                      ? bannerSlider.length > 0
                          ? Container(
                              height: 170.0,
                              child: bannerSlider != null
                                  ? bannerSlider.length > 0
                                      ? CarouselSlider.builder(
                                          itemCount: bannerSlider.length,
                                          options: CarouselOptions(
                                            aspectRatio: 2.8,
                                            viewportFraction: 1.5,
                                            // enlargeCenterPage: true,
                                            autoPlay: false,
                                          ),
                                          itemBuilder: (ctx, index, realIdx) {
                                            return Container(
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (!bannerSlider[index].title.isEmpty) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => Screen2(sliderlist[index].title, "")),
                                                    );
                                                  } else if (!bannerSlider[index].description.isEmpty) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => ProductDetails1(bannerSlider[index].description)),
                                                    );
//

                                                  }
                                                },
                                                child: Container(
                                                    margin: EdgeInsets.only(left: 5.0, right: 5),
                                                    child: Card(
                                                      shadowColor: AppColors.tela,
                                                      elevation: 7,
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                      child: ClipRRect(
                                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                          child: CachedNetworkImage(
                                                            width: MediaQuery.of(context).size.width - 22,
                                                            fit: BoxFit.fill,
                                                            imageUrl: Constant.Base_Imageurl + bannerSlider[index].img,
                                                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                                            errorWidget: (context, url, error) => new Icon(Icons.error),
                                                          )),
                                                    )),
                                              ),
                                            );
                                          },
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor: AppColors.tela,
                                          ),
                                        )
                                  : Row())
                          : Container()
                      : Container(),

                  topProducts1 != null
                      ? topProducts1.length > 0
                          ? Container(
                              color: AppColors.white,
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                                    child: Text(
                                      'Deals of the day',
                                      style: TextStyle(
                                          color: AppColors.product_title_name, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
                                    child:
                                    // RaisedButton(
                                    //     color: AppColors.tela,
                                    //     child: Text('View All', style: TextStyle(color: AppColors.white)),
                                    //     onPressed: () {
                                    //       Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(builder: (context) => ProductList("day", "Deals of the day")),
                                    //       );
                                    //     }),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.tela,
                                      ),
                                      child: Text('View All', style: TextStyle(color: AppColors.white)),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ProductList("day", "Deals of the day")),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container()
                      : Container(),
                  topProducts1.length > 0
                      ? Container(
//                            color: AppColors.black,
                          height: 325.0,
                          child: topProducts1 != null
                              ? Container(
//                              color: AppColors.tela,
                                  margin: EdgeInsets.only(
                                    left: 0.0,
                                  ),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: topProducts1.length == null ? 0 : topProducts1.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ProductDetails(topProducts1[index])),
                                            );
                                          },
                                          child: Container(
                                            margin: index == 0
                                                ? EdgeInsets.only(left: 7.0, top: 20, bottom: 20)
                                                : EdgeInsets.only(left: 7.0, top: 20, bottom: 20),
                                            height: 260,
                                            width: 200,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              shadowColor: AppColors.tela,
                                              elevation: 7,
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        height: 130,
                                                        width: 200,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.only(
                                                            topRight: Radius.circular(10),
                                                            topLeft: Radius.circular(10),
                                                          ),
                                                          child: CachedNetworkImage(
                                                            fit: BoxFit.fill,
                                                            imageUrl: Constant.Product_Imageurl + topProducts1[index].img,
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
                                                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                                            errorWidget: (context, url, error) => new Icon(Icons.error),
                                                          ),
                                                        ),
                                                      ),
                                                      double.parse(topProducts1[index].discount) > 0
                                                          ? Align(
                                                              alignment: Alignment.topRight,
                                                              child: Container(
                                                                height: 50,
                                                                width: 40,
                                                                child: Stack(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/images/discountTag.png",
                                                                      fit: BoxFit.fill,
                                                                    ),
                                                                    Center(
                                                                      child: Text(
                                                                        "${double.parse(topProducts1[index].discount).toStringAsFixed(0)}%\noff",
                                                                        style: TextStyle(
                                                                            color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5, right: 5),
                                                    child: Container(
                                                      height: 40,
                                                      child: Text(
                                                        topProducts1[index].productName,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Divider(
                                                    thickness: 1,
                                                    color: AppColors.tela,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text('\u{20B9}${calDiscount(topProducts1[index].buyPrice, topProducts1[index].discount)}',
                                                          style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w700, fontSize: 12)),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        '(MRP \u{20B9} ${topProducts1[index].buyPrice})',
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontStyle: FontStyle.italic,
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                            decoration: TextDecoration.lineThrough),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 7,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      if (Constant.isLogin) {
                                                        String mrp_price = calDiscount(topProducts1[index].buyPrice, topProducts1[index].discount);
                                                        totalmrp = double.parse(mrp_price);

                                                        double dicountValue = double.parse(topProducts1[index].buyPrice) - totalmrp;
                                                        String gst_sgst = calGst(mrp_price, topProducts1[index].sgst);
                                                        String gst_cgst = calGst(mrp_price, topProducts1[index].cgst);

                                                        String adiscount = calDiscount(topProducts1[index].buyPrice,
                                                            topProducts1[index].msrp != null ? topProducts1[index].msrp : "0");

                                                        admindiscountprice = (double.parse(topProducts1[index].buyPrice) - double.parse(adiscount));

                                                        String color = "";
                                                        String size = "";
                                                        _addToproducts(
                                                            topProducts1[index].productIs,
                                                            topProducts1[index].productName,
                                                            topProducts1[index].img,
                                                            int.parse(mrp_price),
                                                            int.parse(topProducts1[index].count),
                                                            color,
                                                            size,
                                                            topProducts1[index].productDescription,
                                                            gst_sgst,
                                                            gst_cgst,
                                                            topProducts1[index].discount,
                                                            dicountValue.toString(),
                                                            topProducts1[index].APMC,
                                                            admindiscountprice.toString(),
                                                            topProducts1[index].buyPrice,
                                                            topProducts1[index].shipping,
                                                            topProducts1[index].quantityInStock);

                                                        setState(() {
//                                                                              cartvalue++;
                                                          Constant.carditemCount++;
                                                          cartItemcount(Constant.carditemCount);
                                                        });

//                                                                Navigator.push(context,
//                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);

                                                      } else {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => SignInPage()),
                                                        );
                                                      }
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        height: 40,
                                                        width: 100,
                                                        child: Card(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          elevation: 7,
                                                          color: AppColors.tela,
                                                          child: Center(
                                                              child: Text(
                                                            "ADD",
                                                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: AppColors.tela,
                                  ),
                                ),
                        )
                      : Container(),
                  /*Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(bottom: 5,left: 8,right: 8,top: 5),
                            padding: EdgeInsets.all( 8) ,


                            decoration: new BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),


//                              color: AppColors.white,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image:  AssetImage("assets/images/banner3.jpeg"),
                              ),


                              // color: Colors.white,
                            ),

                          ),*/

                  /* FutureBuilder(
                              future: getBanner(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    itemCount: snapshot.data.length == null
                                        ? 0
                                        : snapshot.data.length,

                                    shrinkWrap: true,
                                    primary: false,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      Slider1 item = snapshot.data[index];
                                      return InkWell(
                                          onTap: () {
                                            // print(item.title + "TITLE");
                                            // print(item.description + "DESCR");
                                            if (!item.title.isEmpty) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Screen2(
                                                            item.title, "")),
                                              );
                                            }
                                            else
                                            if (!item.description.isEmpty) {
                                              Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetails1(item
                                                            .description)),);
//

                                            }
                                          },

                                          child: Container(
                                            padding: EdgeInsets.only(
                                                top: 6.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 5),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: Constant
                                                  .Product_Imageurl5 + item.img,
                                              placeholder: (context, url) =>
                                                  Center(
                                                      child:
                                                      CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                              new Icon(Icons.error),

                                            ),
                                          )
                                      );
                                    },

                                  );
                                }
                                else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              }
                          ),*/
                  //yetan

                  /* bannerSlider!=null? bannerSlider.length>0? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: EdgeInsets.only(bottom:10, right: 0),
                              width: 412,
                              height: 200,
                              child: GridView.count(
                                scrollDirection: Axis.horizontal,

                                  crossAxisCount: 1,
                                  childAspectRatio: 0.4,
                                  padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 0),
                                  children: List.generate(bannerSlider.length, (index){

                                    return InkWell(
                                        onTap: () {
                                          // print(item.title + "TITLE");
                                          // print(item.description + "DESCR");
                                          if (!bannerSlider[index].title.isEmpty) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Screen2(
                                                          bannerSlider[index].title, "")),
                                            );
                                          }
                                          else
                                          if (!bannerSlider[index].description.isEmpty) {
                                            Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetails1(bannerSlider[index]
                                                          .description)),);
//

                                          }
                                        },

                                        child: Container(

                                            child:ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: Image.network(Constant.Product_Imageurl5 + bannerSlider[index].img,fit: BoxFit.fitWidth,
                                               ),
                                            )

                                          /*CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl: Constant
                                                .Product_Imageurl5 + bannerSlider[index].img,
                                            placeholder: (context, url) =>
                                                Center(
                                                    child:
                                                    CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                            new Icon(Icons.error),

                                          ),*/
                                        )
                                    );

                                  })),
                            ),
                          ):Container():Container(),*/

                  products1 != null
                      ? products1.length > 0
                          ? Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                                    child: Text(
                                      "Featured Products",
                                      style: TextStyle(
                                          color: AppColors.product_title_name, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
                                    child:
                                    // RaisedButton(
                                    //     color: AppColors.tela,
                                    //     child: Text('View All', style: TextStyle(color: AppColors.white)),
                                    //     onPressed: () {
                                    //       Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(builder: (context) => ProductList("yes", "Featured Products")),
                                    //       );
                                    //     }),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.tela,
                                      ),
                                      child: Text('View All', style: TextStyle(color: AppColors.white)),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ProductList("yes", "Featured Products")),
                                        );
                                      },
                                    ),

                                  )
                                ],
                              ),
                            )
                          : Container()
                      : Container(),
                  Container(
                    height: 10,
                    color: AppColors.white,
                  ),

                  products1 != null
                      ? products1.length > 0
                          ? Container(
                              child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                scrollDirection: Axis.vertical,
                                itemCount: products1.length ,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: index == 0
                                        ? EdgeInsets.only(left: 7, right: 7, top: 5, bottom: 5)
                                        : EdgeInsets.only(
                                            left: 7,
                                            right: 7,
                                            bottom: 7,
                                          ),
                                    child: Stack(
                                      children: [
                                        Card(
                                          elevation: 7,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          shadowColor: AppColors.tela,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => ProductDetails(products1[index])),
                                              );
                                            },
                                            child: Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Container(
                                                            child: Text(
                                                              products1[index].productName == null ? 'name' : products1[index].productName,
                                                              overflow: TextOverflow.fade,
                                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black)
                                                                  .copyWith(fontSize: 14),
                                                            ),
                                                          ),
                                                          SizedBox(height: 6),
                                                          Row(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                                                                child: Text(
                                                                    '\u{20B9} ${calDiscount(products1[index].buyPrice, products1[index].discount)}  ${products1[index].unit_type != null ? products1[index].unit_type : ""}',
                                                                    style: TextStyle(
                                                                      color: AppColors.sellp,
                                                                      fontWeight: FontWeight.w700,
                                                                    )),
                                                              ),
                                                              SizedBox(
                                                                width: 20,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  '\u{20B9} ${products1[index].buyPrice}',
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w700,
                                                                      fontStyle: FontStyle.italic,
                                                                      color: AppColors.mrp,
                                                                      decoration: TextDecoration.lineThrough),
                                                                ),
                                                              )
                                                            ],
                                                          ),

                                                          /* Container(
                                                          margin: EdgeInsets.only(left: 0.0,right: 10),
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: <Widget>[
                                                                SizedBox(width: 0.0,height: 10.0,),

                                                                Column(
                                                                  children: <Widget>[
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                      children: <Widget>[
                                                                        Container(
                                                                            height: 25,
                                                                            width: 35,
                                                                            child:
                                                                            Material(

                                                                              color: AppColors.teladep,
                                                                              elevation: 0.0,
                                                                              shape: RoundedRectangleBorder(
                                                                                side: BorderSide(
                                                                                  color: Colors.white,
                                                                                ),
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(15),
                                                                                ),
                                                                              ),
                                                                              clipBehavior: Clip.antiAlias,
                                                                              child:Padding (
                                                                                padding: EdgeInsets.only(bottom: 10),
                                                                                child: InkWell(
                                                                                    onTap: () {
                                                                                      print(products1[index].count);
                                                                                      if(products1[index].count!="1"){
                                                                                        setState(() {
//                                                                                _count++;

                                                                                          String  quantity=products1[index].count;
                                                                                          int totalquantity=int.parse(quantity)-1;
                                                                                          products1[index].count=totalquantity.toString();

                                                                                        });
                                                                                      }



//



                                                                                    },
                                                                                    child:Padding(padding: EdgeInsets.only(top:10.0,),

                                                                                      child:Icon(
                                                                                        Icons.maximize,size: 20,
                                                                                        color: Colors.white,
                                                                                      ),


                                                                                    )
                                                                                ),
                                                                              ),
                                                                            )),

                                                                        Padding(
                                                                          padding:
                                                                          EdgeInsets.only(top: 0.0, left: 15.0, right: 8.0),
                                                                          child:Center(
                                                                            child:
                                                                            Text(products1[index].count!=null?'${products1[index].count}':'$_count',

                                                                                style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 19,
                                                                                    fontFamily: 'Roboto',
                                                                                    fontWeight: FontWeight.bold)),

                                                                          ),),

                                                                        Container(
                                                                            margin: EdgeInsets.only(left: 3.0),
                                                                            height: 25,
                                                                            width: 35,
                                                                            child:
                                                                            Material(

                                                                              color: AppColors.teladep,
                                                                              elevation: 0.0,
                                                                              shape: RoundedRectangleBorder(
                                                                                side: BorderSide(
                                                                                  color: Colors.white,
                                                                                ),
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(15),
                                                                                ),
                                                                              ),
                                                                              clipBehavior: Clip.antiAlias,
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  if(int.parse(products1[index].count) <= int.parse(products1[index].quantityInStock)){
                                                                                    setState(() {
//                                                                                _count++;

                                                                                      String  quantity=products1[index].count;
                                                                                      int totalquantity=int.parse(quantity)+1;
                                                                                      products1[index].count=totalquantity.toString();

                                                                                    });
                                                                                  }
                                                                                  else{
                                                                                    showLongToast('Only  ${products1[index].count}  products in stock ');
                                                                                  }


                                                                                },


                                                                                child:Icon(
                                                                                  Icons.add,size: 20,
                                                                                  color: Colors.white,
                                                                                ),


                                                                              ),
                                                                            )),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                // SizedBox(width: 10,),

                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: <Widget>[

                                                                    Container(
                                                                        margin: EdgeInsets.only(left: 3.0),
                                                                        height: 40,

                                                                        child:
                                                                        Material(

                                                                          color: AppColors.sellp,
                                                                          elevation: 0.0,
                                                                          shape: RoundedRectangleBorder(
                                                                            side: BorderSide(
                                                                              color: Colors.white,
                                                                            ),
                                                                            borderRadius: BorderRadius.all(
                                                                              Radius.circular(20),
                                                                            ),
                                                                          ),
                                                                          clipBehavior: Clip.antiAlias,
                                                                          child: InkWell(
                                                                            onTap: () {
                                                                              if(Constant.isLogin){


                                                                                String  mrp_price=calDiscount(products1[index].buyPrice,products1[index].discount);
                                                                                totalmrp= double.parse(mrp_price);


                                                                                double dicountValue=double.parse(products1[index].buyPrice)-totalmrp;
                                                                                String gst_sgst=calGst(mrp_price,products1[index].sgst);
                                                                                String gst_cgst=calGst(mrp_price,products1[index].cgst);

                                                                                String  adiscount=calDiscount(products1[index].buyPrice,products1[index].msrp!=null?products1[index].msrp:"0");

                                                                                admindiscountprice=(double.parse(products1[index].buyPrice)-double.parse(adiscount));



                                                                                String color="";
                                                                                String size="";
                                                                                _addToproducts(products1[index].productIs,products1[index].productName,products1[index].img,int.parse(mrp_price),int.parse(products1[index].count),color,size,products1[index].productDescription,gst_sgst,gst_cgst,
                                                                                    products1[index].discount,dicountValue.toString(), products1[index].APMC, admindiscountprice.toString(),products1[index].buyPrice,products1[index].shipping,products1[index].quantityInStock);


                                                                                setState(() {
//                                                                              cartvalue++;
                                                                                  Constant.carditemCount++;
                                                                                  cartItemcount(Constant.carditemCount);

                                                                                });

//                                                                Navigator.push(context,
//                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);

                                                                              }
                                                                              else{


                                                                                Navigator.push(context,
                                                                                  MaterialPageRoute(builder: (context) => SignInPage()),);
                                                                              }

//

                                                                            },
                                                                            child:Padding(padding: EdgeInsets.only(left: 8,top: 5,bottom: 5,right: 8),
                                                                                child:Center(

                                                                                  child:Icon(Icons.add_shopping_cart,color: Colors.white,),

                                                                                )),),
                                                                        )),









                                                                  ],
                                                                ),






                                                              ]
                                                          ) ,
                                                        ),*/
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                                                    width: 110,
                                                    height: 110,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: AppColors.white,
                                                      ),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(55),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    child: Card(
                                                      shadowColor: AppColors.tela,
                                                      elevation: 7,
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(55)),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(
                                                          55,
                                                        ),
                                                        child: Image.network(
                                                          products1[index].img != null
                                                              ? Constant.Product_Imageurl + products1[index].img
                                                              : "ttps://www.drawplanet.cz/wp-content/uploads/2019/10/dsc-0009-150x100.jpg",
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        double.parse(products1[index].discount) > 0
                                            ? Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  margin: EdgeInsets.only(right: 16, top: 4),
                                                  height: 50,
                                                  width: 40,
                                                  child: Stack(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/discountTag.png",
                                                        fit: BoxFit.fill,
                                                      ),
                                                      Center(
                                                          child: Text(
                                                        double.parse(products1[index].discount).toStringAsFixed(0) + "%\noff",
                                                        style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                                      ))
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : Row()
                      : Row(),

                  dilofdayProducts.length > 0
                      ? Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                                child: Text(
                                  Constant.AProduct_type_Name2,
                                  style:
                                      TextStyle(color: AppColors.product_title_name, fontSize: 14, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
                                child:
                                // RaisedButton(
                                //     color: AppColors.tela,
                                //     child: Text('View All', style: TextStyle(color: AppColors.white)),
                                //     onPressed: () {
                                //       Navigator.push(
                                //         context,
                                //         MaterialPageRoute(builder: (context) => ProductList("new", Constant.AProduct_type_Name2)),
                                //       );
                                //     }),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: AppColors.tela,
                                  ),
                                  child: Text('View All', style: TextStyle(color: AppColors.white)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ProductList("new", Constant.AProduct_type_Name2)),
                                    );
                                  },
                                ),

                              )
                            ],
                          ),
                        )
                      : Container(),

                  dilofdayProducts.length > 0
                      ? Container(

                          child: GridView.count(
                              physics: ClampingScrollPhysics(),
                              controller: new ScrollController(keepScrollOffset: false),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              childAspectRatio: 0.68,
                              padding: EdgeInsets.only(top: 8, left: 9, right: 9, bottom: 0),
                              children: List.generate(dilofdayProducts.length, (index) {
                                return Container(

                                  child: Stack(
                                    children: [
                                      Card(
                                        elevation: 7.0,
                                        shadowColor: AppColors.tela,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ProductDetails(dilofdayProducts[index])),
                                                );
//
                                              },
                                              child: SizedBox(
                                                height: 200,
                                                width: double.infinity,
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: Constant.Product_Imageurl + dilofdayProducts[index].img,
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
                                                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                                  errorWidget: (context, url, error) => new Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                                                padding: EdgeInsets.only(left: 3, right: 5),
                                                color: AppColors.white,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      dilofdayProducts[index].productName,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          '\u{20B9} ${dilofdayProducts[index].buyPrice}',
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w700,
                                                              fontStyle: FontStyle.italic,
                                                              fontSize: 12,
                                                              color: AppColors.black,
                                                              decoration: TextDecoration.lineThrough),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 2.0, bottom: 1, right: 10),
                                                          child: Text(
                                                              '\u{20B9} ${calDiscount(dilofdayProducts[index].buyPrice, dilofdayProducts[index].discount)}',
                                                              style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w700, fontSize: 12)),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      double.parse(dilofdayProducts[index].discount) > 0
                                          ? Container(
                                              margin: EdgeInsets.only(left: 4, top: 4),
                                              height: 50,
                                              width: 40,
                                              child: Stack(
                                                children: [
                                                  Image.asset(
                                                    "assets/images/discountTag.png",
                                                    fit: BoxFit.fill,
                                                  ),
                                                  Center(
                                                      child: Text(
                                                    double.parse(dilofdayProducts[index].discount).toStringAsFixed(0) + "%\noff",
                                                    style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                                  ))
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                );
                              })),
                        )
                      : Container(),
                  Container(
                    height: 6,
                  ),

                  imageUrl.isEmpty
                      ? Container()
                      : Container(
                          height: 160,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(10),
                          decoration: new BoxDecoration(
//                              color: AppColors.white,

                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: imageUrl.isEmpty
                                  ? AssetImage("assets/images/logo.png")
                                  : NetworkImage("${Constant.mainurl + promotionBanner.path + promotionBanner.images}"),
                            ),
                            borderRadius: BorderRadius.circular(10),

                            color: Colors.white,
                          ),
                        ),

                  /* Container(
                            height: 500,
                            width: 200,
                            color:Color(0xFFf2f2f2),
                          ),*/
                ],
              ),
              // Builds 1000 ListTiles
              childCount: 1,
            ),
          ),
        ]));
  }

  /*Showpop(){
    showDialog(
      barrierDismissible: false, // JUST MENTION THIS LINE
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
              content: Padding(
                padding: const EdgeInsets.all(5.0),
                child:  Container(
                  height: 110.0,
                  width: 320.0,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding:  EdgeInsets.all(5.0),
                          child: Text("New Version is avaliable on Playstore",style: TextStyle(fontSize: 18,color: Colors.black),)
                      ),
//          Padding(
//              padding:  EdgeInsets.all(10.0),
//              child: Text('${_updateInfo.availableVersionCode}',style: TextStyle(fontSize: 18,color: Colors.black),)
//          ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          (_updateInfo.availableVersionCode-valcgeck)<3? FlatButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel !', style: TextStyle(color: AppColors.black, fontSize: 18.0),)):Row(),

                          FlatButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                                // _launchURL();
                              },
                              child: Text('Update ', style: TextStyle(color: AppColors.green, fontSize: 18.0),)),

                        ],
                      )
                    ],
                  ),
                ),
              )
          ),
        );
      },
    );
  }*/

//  showDilogue(BuildContext context) {
//    Dialog errorDialog = Dialog(
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//      //this right here
//      child: Container(
//        height: 160.0,
//        width: 300.0,
//
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Padding(
//                padding: EdgeInsets.all(10.0),
//                child: Text("New Version is avaliable on Playstore",
//                  style: TextStyle(fontSize: 18, color: Colors.black),)
//            ),
////          Padding(
////              padding:  EdgeInsets.all(10.0),
////              child: Text('${_updateInfo.availableVersionCode}',style: TextStyle(fontSize: 18,color: Colors.black),)
////          ),
//
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                FlatButton(
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                    },
//                    child: Text('Cancel !', style: TextStyle(
//                        color: AppColors.black, fontSize: 18.0),)),
//
//                FlatButton(
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                      _launchURL();
//                    },
//                    child: Text('Update Now ', style: TextStyle(
//                        color: AppColors.green, fontSize: 18.0),)),
//
//              ],
//            )
//          ],
//        ),
//      ),
//    );
//    showDialog(
//        context: context, builder: (BuildContext context) => errorDialog);
//  }

  String calDiscount(String byprice, String discount2) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(discount2);

    discount = (byprice1 - (byprice1 * discount1) / 100.0);

    returnStr = discount.toStringAsFixed(Constant.val);
    print(returnStr);
    return returnStr;
  }

  final DbProductManager dbmanager = new DbProductManager();

  ProductsCart products2;

//cost_price=buyprice
  void _addToproducts(String pID, String p_name, String image, int price, int quantity, String c_val, String p_size, String p_disc, String sgst,
      String cgst, String discount, String dis_val, String adminper, String adminper_val, String cost_price, String shippingcharge, String totalQun) {
    if (products2 == null) {
//      print(pID+"......");
//      print(p_name);
//      print(image);
//      print(price);
//      print(quantity);
//      print(c_val);
//      print(p_size);
//      print(p_disc);
//      print(sgst);
//      print(cgst);
//      print(discount);
//      print(dis_val);
//      print(adminper);
//      print(adminper_val);
//      print(cost_price);
      ProductsCart st = new ProductsCart(
          pid: pID,
          pname: p_name,
          pimage: image,
          pprice: (price * quantity).toString(),
          pQuantity: quantity,
          pcolor: c_val,
          psize: p_size,
          pdiscription: p_disc,
          sgst: sgst,
          cgst: cgst,
          discount: discount,
          discountValue: dis_val,
          adminper: adminper,
          adminpricevalue: adminper_val,
          costPrice: cost_price,
          shipping: shippingcharge,
          totalQuantity: totalQun);
      dbmanager.insertStudent(st).then((id) => {showLongToast(" Product added to the cart! "), print(' Added to Db ${id}')});
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WishList(),
        ),
      );
    }
  }

  String calGst(String byprice, String sgst) {
    String returnStr;
    double discount = 0.0;
    if (sgst.length > 1) {
      returnStr = discount.toString();
      double byprice1 = double.parse(byprice);
      print(sgst);

      double discount1 = double.parse(sgst);

      discount = ((byprice1 * discount1) / (100.0 + discount1));

      returnStr = discount.toStringAsFixed(2);
      print(returnStr);
      return returnStr;
    } else {
      return '0';
    }
  }

  _launchURL() async {
    const url = 'https://play.google.com/store/apps/details?id=com.gharbazar';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
