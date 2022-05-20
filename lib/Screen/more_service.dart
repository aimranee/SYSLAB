import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/style.dart';
import 'package:laboratoire_app/widgets/appbars_widget.dart';
import 'package:flutter/material.dart';

class MoreServiceScreen extends StatefulWidget {
  final serviceDetails;

  const MoreServiceScreen({Key key, this.serviceDetails}) : super(key: key);
  @override
  _MoreServiceScreenState createState() => _MoreServiceScreenState();
}

class _MoreServiceScreenState extends State<MoreServiceScreen> {
  @override
  void initState() {
     
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildContent());
  }

  Widget _buildContent() {
    return Stack(
      //overflow: Overflow.visible,
      children: <Widget>[
        CAppBarWidget(
          title: widget.serviceDetails.title, isConn: true
        ),
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
            child: Padding(
                padding: const EdgeInsets.only(
                  top: 0.0,
                  left: 20,
                  right: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text("Description", style: kPageTitleStyle),
                      const SizedBox(height: 20),
                      Text(
                        widget.serviceDetails.desc,
                        style: kParaStyle,
                      ),
                      const SizedBox(height: 20),
                      const Text("Duree", style: kPageTitleStyle),
                      const SizedBox(height: 20),
                      Text(
                        widget.serviceDetails.duree,
                        style: kParaStyle,
                      ),
                      const SizedBox(height: 20),
                      const Text("price", style: kPageTitleStyle),
                      const SizedBox(height: 20),
                      Text(
                        widget.serviceDetails.price,
                        style: kParaStyle,
                      ),
                    ],
                  ),
                )),
          ),
        )
      ],
    );
  }

  _buildCard() {
    return ListTile(
      contentPadding: const EdgeInsets.all(00.0),
      trailing: const Icon(Icons.arrow_drop_down_outlined, size: 30, color: appBarColor),
      // leading: CircleAvatar(
      //   backgroundColor: bgColor,
      //   radius: 30,
      //   child: ClipOval(
      //       child: Padding(
      //           padding: const EdgeInsets.all(00.0),
      //           child: widget.serviceDetails.imageUrl == ""
      //               ? Icon(Icons.category_outlined, color: appBarColor)
      //               : ImageBoxFillWidget(
      //                   imageUrl: widget.serviceDetails.imageUrl))),
      // ),
      title: const Text("price : ",
          style: TextStyle(
            fontFamily: 'OpenSans-Bold',
            fontSize: 14.0,
          )),
      subtitle: Text(widget.serviceDetails.price,
          style: const TextStyle(
            fontFamily: 'OpenSans-SemiBold',
            fontSize: 14.0,
          )),
          
    );
  }
}