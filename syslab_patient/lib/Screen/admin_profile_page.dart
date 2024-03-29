
import 'dart:developer';
import 'package:get/get.dart';
import 'package:patient/utilities/color.dart';
import 'package:patient/utilities/curverdpath.dart';
import 'package:patient/utilities/style.dart';
import 'package:patient/widgets/call_msg_widget.dart';
import 'package:patient/widgets/custom_drawer.dart';
import 'package:patient/widgets/error_widget.dart';
import 'package:patient/widgets/loading_indicator.dart';
import 'package:patient/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:patient/Service/admin_profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class AdminProfilePage extends StatefulWidget {
  String id;
  AdminProfilePage({Key key, this.id}) : super(key: key);

  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  bool isConn = Get.arguments;
  bool _isLoading = false;
  @override
  void initState() {
     log(widget.id);
    _checkData();
    super.initState();
  }
  _checkData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = true;
    });

    if (pref.getString("token") != "") {
      setState(() {
          isConn = true;
        });
    }

    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      drawer : CustomDrawer(isConn: isConn),
        body: _isLoading ? const LoadingIndicatorWidget() : FutureBuilder(
            future: AdminProfileService.getData(), //fetch doctors profile details like name, profileImage, description etc
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data.length==0
                    ? const NoDataWidget()
                    : _buildContent(snapshot.data[0]);
              } else if (snapshot.hasError) {
                return const IErrorWidget();
              } else {
                return const LoadingIndicatorWidget();
              }
            })
    );
  }

  Widget _buildContent(profile) {
    return SingleChildScrollView(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      SizedBox(
        height: 240,
        // color: Colors.yellowAccent,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            SizedBox(
              height: 150,
              width: MediaQuery.of(context).size.width,
              // color: Colors.red,
              child: CustomPaint(
                painter: CurvePainter(),
              ),
            ),
            Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: appBarIconColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      " Dr Profile",
                      style: kAppbarTitleStyle,
                    ),
                    IconButton(
                        icon: const Icon(
                          Icons.home,
                          color: appBarIconColor,
                        ),
                        onPressed: () {
                          Navigator.popUntil(
                              context, ModalRoute.withName('/HomePage'));
                        })
                  ],
                )),
            Positioned(
              top: 80,
              left: 25,
              right: 25,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                              "Dr ${profile.firstName} ${profile.lastName}",
                              //doctors first name and last name
                              style: const TextStyle(
                                color: Colors.black,
                                //change colors form here
                                fontFamily: 'OpenSans-Bold',
                                // change font style from here
                                fontSize: 15.0,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                              //"jhdsvdsh",
                              profile.subTitle,
                              //doctor subtitle
                              style: const TextStyle(
                                color: Colors.black,
                                //change colors form here
                                fontFamily: 'OpenSans-Bold',
                                // change font style from here
                                fontSize: 15.0,
                              )),
                        ),
                        CallMsgWidget(
                          primaryNo: profile.pNo1,
                          whatsAppNo: profile.whatsAppNo,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25, top: 10),
          child:
              _callUsMailUsBox(profile.pNo1, profile.pNo2, profile.email)),
      const Padding(
        padding: EdgeInsets.only(top: 8, left: 25.0, right: 25),
        child: Text("Location", style: kPageTitleStyle),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25, top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.height * .39,
                width: MediaQuery.of(context).size.width * .8,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed('/ReachUsPage');
                  },
                  child: Card(
                    elevation: 10.0,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          'assets/images/map.png',
                          fit: BoxFit.fill,
                        ) //this is a asset image only not a google map integration

                        ),
                  ),
                )),
            
          ],
        ),
      )
    ],
      ),
    );
  }

  Widget _callUsMailUsBox(String phn, String phn2, String email) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * .15,
          width: MediaQuery.of(context).size.width * .4,
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text("Call us", style: kPageTitleStyle),
                    Text(
                      "$phn\n$phn2",
                      style: const TextStyle(
                        fontFamily: 'OpenSans-Regular',
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .15,
          width: MediaQuery.of(context).size.width * .4,
          child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text("Mail us", style: kPageTitleStyle),
                      Text(
                        email,
                        style: const TextStyle(
                          fontFamily: 'OpenSans-Regular',
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
        Positioned(
            right: 25,
            bottom: 12,
            child: GestureDetector(
              onTap: () async {
 //take clinic longitude from google map
                const _url =
                    '';
                await canLaunch(_url)
                    ? await launch(_url)
                    : throw 'Could not launch $_url'; //launch google map
              },
              child: const CircleAvatar(
                radius: 25,
                backgroundColor: btnColor,
                child: Icon(
                  Icons.near_me,
                  color: appBarIconColor,
                ),
              ),
            ),
          )
      ],
    );
  }
}
