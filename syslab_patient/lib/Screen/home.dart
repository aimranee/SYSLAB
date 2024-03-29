

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:patient/Service/Noftification/handle_firebase_notification.dart';
import 'package:patient/Service/Noftification/handle_local_notification.dart';
import 'package:patient/Service/user_service.dart';
import 'package:patient/utilities/color.dart';
import 'package:patient/utilities/style.dart';
import 'package:patient/widgets/appbars_widget.dart';
import 'package:patient/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient/widgets/loading_indicator.dart';
import 'package:patient/widgets/bottom_navigation_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  bool isConn = false;
  
  @override
  void initState() {
    
    // initialize local and firebase notification
    HandleLocalNotification.initializeFlutterNotification(
        context); //local notification
    HandleFirebaseNotification.handleNotifications(
        context); //firebase notification
    _getAndSetUserData(); //get users details from database

    super.initState();
  }

  _getAndSetUserData() async {
    
    //start loading indicator
    
    setState(() {
      _isLoading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString("token").toString();

    if (token != "" && token != "null") {
      String uId = pref.getString("uId");
      // log("uId : "+uId);
      final user = await UserService.getData(uId);
      pref.setString("fcm", user[0].fcmId);
      pref.setString("firstName", user[0].firstName);
      pref.setString("lastName", user[0].lastName);
      setData(uId);
      setState(() {
        isConn = true;
        _isLoading = false;
      });
      
    }else{
      setState(() {
        _isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: _isLoading
        ? const LoadingIndicatorWidget()
        : BottomNavigationWidget(
          title: "Demander Rendez-vous", route: "/AppoinmentPage", isConn: isConn
        ),

      drawer: CustomDrawer(isConn: isConn),

      body: Stack(
            clipBehavior: Clip.none,
        children: [
          CAppBarWidget(title: "SYSLAB", isConn: isConn),
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
            child: _buildContent(),
          ),)
        ]
      )
    );
  }

  Widget _table() {
    return Table(
      children: [

        TableRow(children: [
          _cardImg('assets/icon/patient.svg', 'Profile', "/Profile", isConn),
          _cardImg('assets/icon/teeth.svg', 'Analyses', "/CategoryList", isConn),
        ]),

        TableRow(children: [
          _cardImg("assets/icon/appoin.svg", "Rendez-vous", '/Appointmentstatus', isConn),
          _cardImg('assets/icon/sch.svg', 'Disponibilité', '/AvailabilityPage', isConn),
        ]),

        TableRow(children: [     
          _cardImg('assets/icon/documents.svg', 'Resultas', "/Documents", isConn),
          _cardImg("assets/icon/call.svg", "Contactez-nous", "/ContactUsPage", isConn),
        ]),
      ],
    );
  }

  Widget _cardImg(String path, String title, String routeName, bool isConn) {
    return GestureDetector(
      onTap: () {
        if (routeName != null) Get.toNamed(routeName, arguments : isConn);
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .15,
        //width: MediaQuery.of(context).size.width * .1,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
                width: 30,
                child: SvgPicture.asset(path, semanticsLabel: 'Acme Logo'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  title,
                  style: kTitleStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          SizedBox(
            // height: MediaQuery.of(context).size.height * .20,
            width: MediaQuery.of(context).size.width *.5,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Container(            
                    margin: const EdgeInsets.all(6),
                    color: bgColor,
                    child: Image.asset(
                      'assets/images/image11.png',
                      fit: BoxFit.cover,
                    ) //recommended 200*300 pixel
                  )
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20, top: 8.0),
            child: Container(
              child: _table(),
            ),
          ),
        ],
      ),
    );
  }

  setData(uId) async {
    final fcm = await FirebaseMessaging.instance.getToken();
    await UserService.updateFcmId(uId, fcm);
  }
  
}
