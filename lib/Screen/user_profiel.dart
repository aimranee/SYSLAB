import 'dart:developer';

import 'package:get/get.dart';
import 'package:laboratoire_app/Service/user_service.dart';
import 'package:laboratoire_app/model/user_model.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/utilities/dialog_box.dart';
import 'package:laboratoire_app/utilities/inputfields.dart';
import 'package:laboratoire_app/widgets/auth_screen.dart';
import 'package:laboratoire_app/widgets/appbars_widget.dart';
import 'package:laboratoire_app/widgets/bottom_navigation_bar_widget.dart';
import 'package:laboratoire_app/widgets/custom_drawer.dart';
import 'package:laboratoire_app/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:laboratoire_app/utilities/toast_msg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key key}) : super(key: key);
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isLoading = false;
  String _selectedGender = "";
  String _selectedfamilySituation = "";
  String _isEnableBtn = "false";
  bool isConn = false;
  bool _hasRamid = false;
  bool _hasCnss = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _uIdController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();

  @override
  void initState() {
    _setData();
    super.initState();
  }

  @override
  void dispose() {
      
    _emailController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneNumberController.dispose();
    _cityController.dispose();
    _uIdController.dispose();
    _cinController.dispose();
    super.dispose();
  }

  _takeConfirmation() {
    !isConn ? Container() : 
    DialogBoxes.confirmationBox(
        context,
        "Update",
        "Are you sure you want to update profile details",
        _handleUpdate
    ); //take a confirmation form the user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _isLoading
        ? LoadingIndicatorWidget() : 
        BottomNavigationStateWidget(
        title: "Update",
        onPressed: _takeConfirmation,
        clickable: _isEnableBtn,
      ),
      drawer : CustomDrawer(isConn: isConn),
      body: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          CAppBarWidget(title: "Profile", isConn: isConn), //common app bar
          Positioned(
              top: 90,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: IBoxDecoration.upperBoxDecoration(),
                  child: ! isConn ? const AuthScreen() : _buildContent())),
        ],
      ),
    );
  }

  _handleUpdate() {
    if (_formKey.currentState.validate()) {
      if ((_selectedGender == "" || _selectedGender == null) && (_selectedfamilySituation =="" || _selectedfamilySituation == null)) {
        ToastMsg.showToastMsg("Please select gender");
      } else {
        setState(() {
          _isEnableBtn = "";
          _isLoading = true;
        });
        _updateDetails();
      }
    }
  }

  _updateDetails() async {
    String R = "0";
    String C = "0";
      if (_hasRamid == true){
          R = "1";
      }
      if (_hasCnss == true){
          C = "1";
      }

    final userModel = UserModel(
        email: _emailController.text,
        lastName: _lastNameController.text,
        firstName: _firstNameController.text,
        cin: _cinController.text,
        age: _ageController.text,
        city: _cityController.text,
        gender: _selectedGender,
        familySituation: _selectedfamilySituation,
        hasRamid: R,
        hasCnss: C,
        // uId: _uIdController.text,
        pNo: _phoneNumberController.text,

      );
    // log(">>>>>>>>>>>>>>>>>>>>>>${userModel.toUpdateJson()}");
    final res = await UserService.updateData(userModel);
    if (res == "success") {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString("firstName", _firstNameController.text);
      prefs.setString("lastName", _lastNameController.text);

      ToastMsg.showToastMsg("Successfully Updated");
    } else if (res == "error") {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = "false";
      _isLoading = false;
    });
  }

  Widget _ageInputField(String labelText, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      if (item.length > 0 && item.length <= 3) {
        return null;
      } else if (item.length > 3) {
        return "Enter valid age";
      } else {
        return "Enter age";
      }
    }, TextInputType.number, 1);
  }

  Widget _inputField(String labelText, String validatorText, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length > 0 ? null : validatorText;
    }, TextInputType.text, 1);
  }

  Widget _emailInputField() {
    return InputFields.commonInputField(_emailController, "Email", (item) {
      Pattern pattern =
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?)*$";
      RegExp regex = RegExp(pattern);
      if (item.length > 0) {
        if (!regex.hasMatch(item) || item == null) {
          return 'Enter a valid email address';
        } else {
          return null;
        }
      } else {
        return null;
      }
    }, TextInputType.emailAddress, 1);
  }

  Widget _phnNumInputField(String labelText, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      if (item.length == 10) {
        return null;
      } else if (item.length < 10 || item.length > 10) {
        return "Enter valid phone numbre";
      } else {
        return "Enter phone numbre";
      }
    }, TextInputType.number, 1);
  }


  _genderDropDown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: _selectedGender,
        //elevation: 5,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: appBarColor,
        items: <String>[
          'Male',
          'Female',
          'Other',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        hint: const Text(
          "Gender",
        ),
        onChanged: (String value) {
          setState(() {
            _selectedGender = value;
          });
        },
      ),
    );
  }

  _familySituationDropDown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: _selectedfamilySituation,
        //elevation: 5,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: appBarColor,
        items: <String>[
          'Célibataire',
          'Marié',
          'Divorcé',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        hint: const Text(
          "Family Situation",
        ),
        onChanged: (String value) {
          setState(() {
            _selectedfamilySituation = value;
          });
        },
      ),
    );
  }

  _checkRamid(bool _checked){
    return CheckboxListTile(
        title: const Text("RAMID"),
        controlAffinity: ListTileControlAffinity.platform,
        value: _checked,
        onChanged: (bool value) {
          setState(() {
            _hasRamid = value;
          });
        },
        activeColor: Colors.green,
        checkColor: Colors.black,

    );
  }

  _checkCnss(bool _checked){
    return CheckboxListTile(
        title: const Text("CNSS"),
        controlAffinity: ListTileControlAffinity.platform,
        value: _checked,
        onChanged: (bool value) {
          setState(() {
            _hasCnss = value;
          });
        },
        activeColor: Colors.green,
        checkColor: Colors.black,

    );
  }

  _buildContent() {
    return _isLoading
        ? LoadingIndicatorWidget()
        : Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                _inputField("First Name", "Enter first name", _firstNameController),
                _inputField("Last Name", "Enter last name", _lastNameController),
                _inputField("City", "Enter city", _cityController),
                _inputField("CIN", "Enter CIN", _cinController),
                _ageInputField("Age", _ageController),
                _genderDropDown(),
                _checkRamid(_hasRamid),
                _checkCnss(_hasCnss),
                _familySituationDropDown(),
                _emailInputField(),
                _phnNumInputField("Phone numbre", _phoneNumberController),
              ],
            ),
          );
  }

  void _setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = true;
    });

    if (prefs.getString("fcm") != "") {
      setState(() {
        isConn = true;
      });
      
      final user = await UserService.getData();

      _emailController.text = user[0].email;
      _lastNameController.text = user[0].lastName;
      _firstNameController.text = user[0].firstName;
      _firstNameController.text = user[0].firstName;
      _phoneNumberController.text = user[0].pNo;
      _cityController.text = user[0].city;
      _uIdController.text = user[0].uId;
      _cinController.text = user[0].cin;
      _ageController.text = user[0].age;
      _selectedGender = user[0].gender;
      _selectedfamilySituation = user[0].familySituation;

      if (user[0].hasRamid == "1"){
        setState((){
          _hasRamid = true;
        });
      }

      if (user[0].hasCnss == "1"){
        setState((){
          _hasCnss = true;
        });
      }
      
    }else{
      setState(() {
        isConn = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
    
  }
}
