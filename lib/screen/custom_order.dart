import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:royalmart/Auth/signin.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/General/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CustomOrder extends StatefulWidget {
  const CustomOrder({Key key}) : super(key: key);

  @override
  _CustomOrderState createState() => _CustomOrderState();
}

class _CustomOrderState extends State<CustomOrder> {
  final myController = TextEditingController();
  final ImagePicker imgpicker = ImagePicker();
  bool isloginv = false;
  String imagepath = "";
  String base64Image = '';
  String fileName = '';
  String name = '';
  String email = '';
  String mobile = '';
  String userId = '';

  //bool isloginv=false;
  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isloginv = pref.get("isLogin");
    name = pref.get('name');
    print("name------------->${name}");
    mobile = pref.get("mobile");
    print("mobile------------->${mobile}");
    email = pref.get('email');
    print("email------------->${email}");
    userId = pref.get('user_id');
    print("userId------------->${userId}");

    if (isloginv == null) {
      isloginv = false;
    }
    /*if(isloginv==false){
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignInPage(),),);
    }*/
    /*if(isloginv==false){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInPage(),),);
    }*/

    setState(() {
      Constant.isLogin = isloginv;
      print("bool isloginv=false;--->${isloginv}");

      // print(Constant.image.length);
      // print(Constant.name.length);
      // print("Constant.name");
    });
  }

  @override
  void initState() {
    gatinfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            color: Colors.white,
            child: Constant.isLogin
                ? Form(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: myController,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: "Enter your message",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: AppColors.tela,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: AppColors.tela,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: InkWell(
                                  onTap: () {
                                    chooseImageFromCamera();
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(41),
                                    ),
                                    elevation: 7.0,
                                    shadowColor: AppColors.tela,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            size: 70,
                                            color: AppColors.tela,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: InkWell(
                                  onTap: () {
                                    chooseImageFromGallery();
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(41),
                                    ),
                                    elevation: 7.0,
                                    shadowColor: AppColors.tela,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons
                                                .photo_size_select_actual_outlined,
                                            size: 70,
                                            color: AppColors.tela,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          imagepath != ""
                              ? Flexible(
                                  child: Container(
                                    height: 200,
                                    width: 300,
                                    child: imagepath != ""
                                        ? Image.file(File(imagepath))
                                        : Container(),
                                  ),
                                )
                              : Container(),
                          MaterialButton(
                            color: AppColors.tela,
                            textColor: Colors.white,
                            onPressed: () {
                              if (isloginv) {
                                if (imagepath == '' &&
                                    myController.text.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "Please add your message or prescription..."),
                                  ));
                                } else {
                                  upload();
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content:
                                      Text("Please login to use this feature"),
                                ));
                              }
                            },
                            child: Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/login.png"),
                          Text(
                            "Login needed to access this page!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )),
      ),
    );
  }

  chooseImageFromCamera() async {
    try {
      var pickedFile = await imgpicker.getImage(source: ImageSource.camera);
      //you can use ImageCourse.camera for Camera capture
      if (pickedFile != null) {
        imagepath = pickedFile.path;
        log(imagepath);
        //output /data/user/0/com.example.testapp/cache/image_picker7973898508152261600.jpg

        File imagefile = File(imagepath); //convert Path to File

        List<int> imagebytes = await imagefile.readAsBytes(); //convert to bytes
        String base64string =
            base64Encode(imagebytes); //convert bytes to base64 string
        base64Image = base64string;

        log(base64string);
        /* Output:
              /9j/4Q0nRXhpZgAATU0AKgAAAAgAFAIgAAQAAAABAAAAAAEAAAQAAAABAAAJ3
              wIhAAQAAAABAAAAAAEBAAQAAAABAAAJ5gIiAAQAAAABAAAAAAIjAAQAAAABAAA
              AAAIkAAQAAAABAAAAAAIlAAIAAAAgAAAA/gEoAA ... long string output
              */

        Uint8List decodedbytes = base64.decode(base64string);
        //decode base64 stirng to bytes
        //Navigator.pop(context);

        setState(() {});
      } else {
        log("No image is selected.");
      }
    } catch (e) {
      log("error while picking file.");
    }
  }

  chooseImageFromGallery() async {
    try {
      var pickedFile = await imgpicker.getImage(source: ImageSource.gallery);
      //you can use ImageCourse.camera for Camera capture
      if (pickedFile != null) {
        imagepath = pickedFile.path;
        log(imagepath);
        //output /data/user/0/com.example.testapp/cache/image_picker7973898508152261600.jpg

        File imagefile = File(imagepath); //convert Path to File
        fileName = imagefile.path.split('/').last;

        List<int> imagebytes = await imagefile.readAsBytes(); //convert to bytes
        String base64string =
            base64Encode(imagebytes); //convert bytes to base64 string
        log(base64string);
        base64Image = base64string;
        Uint8List decodedbytes = base64.decode(base64string);
        //decode base64 stirng to bytes
        //Navigator.pop(context);

        setState(() {});
      } else {
        log("No image is selected.");
      }
    } catch (e) {
      log("error while picking file.");
    }
  }

  upload() async {
    // log('base64con--->$base64Image');
    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //sharedPreferences?.setBool("isLoggedIn", true);
    //var userId = sharedPreferences.getString('myId1');
    final uploadEndPoint =
        'http://www.ousudhpharmacy.w4u.in/manage/api/contacts/add';
    String fullUrl = uploadEndPoint;
    http.post(fullUrl, body: {
      "X-Api-Key": "86QGE23HKRZVYASULP9FT57NBWD4CXJM",
      "image": base64Image,
      "name": name,
      "mobile": mobile,
      "email": email,
      "massage": myController.text,
      "user_ip": userId,
      "shop_id": Constant.Shop_id,
    }).then((result) {
      print(result.body + "resuilt///////////////");
      var msg = "Prescription uploaded successfully...";
      showDialog(
          context: context,
          builder: (BuildContext) {
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp1()),
                  (route) => false);
            });
            return AlertDialog(
              title: Row(
                children: [
                  Text(
                    "We have received your prescription,\n kindly wait for a call back",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            );
          });
    }).catchError((error) {
      print("Errror--> ${error}");
    });
  }
}
