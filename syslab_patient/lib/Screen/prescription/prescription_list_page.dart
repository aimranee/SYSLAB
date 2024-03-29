import 'dart:developer';

import 'package:get/get.dart';
import 'package:patient/Screen/prescription/prescription_details.dart';
import 'package:patient/Service/prescription_service.dart';
import 'package:patient/utilities/color.dart';
import 'package:patient/utilities/decoration.dart';
import 'package:patient/widgets/appbars_widget.dart';
import 'package:patient/widgets/auth_screen.dart';
import 'package:patient/widgets/bottom_navigation_bar_widget.dart';
import 'package:patient/widgets/custom_drawer.dart';
import 'package:patient/widgets/error_widget.dart';
import 'package:patient/widgets/loading_indicator.dart';
import 'package:patient/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';


class PrescriptionListPage extends StatefulWidget {
  const PrescriptionListPage({Key key}) : super(key: key);

  @override
  _PrescriptionListPageState createState() => _PrescriptionListPageState();
}

class _PrescriptionListPageState extends State<PrescriptionListPage> {
 final ScrollController _scrollController = ScrollController();
 bool _isLoading = false;
 bool isConn = Get.arguments;
  @override
  void initState() {
    // _TestConnection();
    super.initState();
  }

 @override
  void dispose() {
   _scrollController.dispose();
   super.dispose();
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationWidget(route: "/ContactUsPage", title:"Contactez-nous"),
      drawer : CustomDrawer(isConn: isConn),
      body: _isLoading ? const LoadingIndicatorWidget() : Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          CAppBarWidget(title:"Resultats", isConn: isConn),
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            bottom: 0,
            child: ! isConn ? const AuthScreen() : Container(
              height: MediaQuery.of(context).size.height,
              decoration:IBoxDecoration.upperBoxDecoration(),
              child:FutureBuilder(
                  future: PrescriptionService.getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data.length == 0
                          ? const NoDataWidget()
                          : Padding(
                          padding: const EdgeInsets.only(top: 0.0, left: 8, right: 8),
                          child: _buildCard(snapshot.data));
                    } else if (snapshot.hasError) {
                      return const IErrorWidget();
                    } else {
                      return const LoadingIndicatorWidget();
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCard(prescriptionDetails) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: prescriptionDetails.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.to(() => PrescriptionDetailsPage(
                      title: prescriptionDetails[index].appointmentName, 
                      prescriptionDetails:prescriptionDetails[index]
                    ),
              );

            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    title: Text(
                      prescriptionDetails[index].appointmentName,
                      style: const TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 14.0,
                      )),
                        trailing: const Icon(Icons.arrow_forward_ios,color: iconsColor,size: 20,),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${prescriptionDetails[index].patientName}",
                          style: const TextStyle(
                            fontFamily: 'OpenSans-SemiBold',
                            fontSize: 14,
                          ),
                        ),
                        Text("${prescriptionDetails[index].appointmentDate} ${prescriptionDetails[index].appointmentTime}",
                          style: const TextStyle(
                            fontFamily: 'OpenSans-Regular',
                            fontSize: 10,
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ),
          );
        });
  }
}


