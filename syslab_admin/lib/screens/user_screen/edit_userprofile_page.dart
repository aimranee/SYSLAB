import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syslab_admin/model/patient_model.dart';
import 'package:syslab_admin/screens/appointments/show_appointment_by_uid.dart';
import 'package:syslab_admin/screens/user_screen/choose_appointment_type.dart';
import 'package:syslab_admin/service/patient_service.dart';
import 'package:syslab_admin/utilities/dialog_box.dart';
import 'package:syslab_admin/utilities/input_field.dart';
import 'package:syslab_admin/widgets/bottom_navigation_bar_widget.dart';
import 'package:syslab_admin/widgets/buttons_widget.dart';
import 'package:syslab_admin/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/app_bars.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/toast_msg.dart';

class EditUserProfilePage extends StatefulWidget {
  final userDetails; //QueryDocumentSnapshot

  const EditUserProfilePage({Key key, this.userDetails}) : super(key: key);
  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  bool _isLoading = false;
  String _selectedGender = "";
  String _selectedfamilySituation = "";
  String _selectedBloodType = "";
  bool _isEnableBtn = true;
  bool _hasRamid = false;
  bool _hasCnss = false;
  String uId = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _uIdController = TextEditingController();
  final TextEditingController _cratedDateController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _emailController.text = widget.userDetails.email;
      _lastNameController.text = widget.userDetails.lastName;
      _firstNameController.text = widget.userDetails.firstName;
      _phoneNumberController.text = widget.userDetails.pNo;
      _cityController.text = widget.userDetails.city;
      _uIdController.text = widget.userDetails.uId;
      _ageController.text = widget.userDetails.age;
      _cratedDateController.text = widget.userDetails.createdTimeStamp;
      _selectedGender = widget.userDetails.gender;
      _selectedfamilySituation = widget.userDetails.familySituation;
      _cinController.text = widget.userDetails.cin;
      _selectedBloodType = widget.userDetails.bloodType;

      if (widget.userDetails.hasRamid == "1"){
        setState((){
          _hasRamid = true;
        });
      }
      if (widget.userDetails.hasCnss == "1"){
        setState((){
          _hasCnss = true;
        });
      }

    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneNumberController.dispose();
    _cityController.dispose();
    _uIdController.dispose();
    _cratedDateController.dispose();
    _cinController.dispose();
    // _updatedDateController.dispose();
    super.dispose();
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context,
        "Mise à jour",
        "Êtes-vous sûr de vouloir mettre à jour les détails du profil",
        _handleUpdate); //take a confirmation form the user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBarWidget(
          isEnableBtn: _isEnableBtn,
          onPressed: _takeConfirmation, // _handleUpdate,
          title: "Mise à jour",
        ),
        appBar: IAppBars.commonAppBar(context, "Editer profil"),
        body: _isLoading
            ? const LoadingIndicatorWidget()
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    _inputField(
                        "Prénom", "Entrez votre prénom", _firstNameController),
                    _inputField(
                        "Nom", "Entrez votre nom", _lastNameController),
                    _inputField("Ville", "Entrez votre ville", _cityController),
                    _ageInputField("Age", _ageController),
                    _genderDropDown(),
                    _emailInputField(),
                    _phnNumInputField(),
                    _readOnlyInputField("Utilisateur Id", _uIdController),
                    _readOnlyInputField("CIN", _cinController),
                    _readOnlyInputField("Créé à", _cratedDateController),
                    _checkRamid(_hasRamid),
                    _checkCnss(_hasCnss),
                    _familySituationDropDown(),
                    _bloodTypeDropDown(),
                    _roundedCheckedBtn("Vérifier les rendez-vous réservé"),
                    _newAppointmentBtn("Prendre un nouveau rendez-vous")
                  ],
                ),
              )
            );
  }

  _handleUpdate() {
    if (_formKey.currentState.validate()) {
      if ((_selectedGender == "" || _selectedGender == null) && (_selectedfamilySituation =="" || _selectedfamilySituation == null) && (_selectedBloodType =="" || _selectedBloodType == null)) {
        ToastMsg.showToastMsg("Please select gender");
      } else {
        setState(() {
          _isEnableBtn = false;
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
          C = "0";
      }
      if (_hasCnss == true){
          C = "1";
          R = "0";
      }

    DateTime now = DateTime.now();
    String createdTimeStamp = DateFormat('yyyy-MM-dd hh:mm').format(now);
    final patientModel = PatientModel(
        email: _emailController.text,
        lastName: _lastNameController.text,
        firstName: _firstNameController.text,
        age: _ageController.text,
        city: _cityController.text,
        uId: widget.userDetails.uId,
        cin: _cinController.text,
        familySituation: _selectedfamilySituation,
        bloodType: _selectedBloodType,
        hasRamid: R,
        hasCnss: C,
        gender: _selectedGender,
        pNo: _phoneNumberController.text,
        updatedTimeStamp: createdTimeStamp);
    // log(">>>>>>>>>>>>>>>>>>>>>>${patientModel.toUpdateJson()}");
    final res = await PatientService.updateData(patientModel);
    if (res == "success") {
      ToastMsg.showToastMsg("Mise à jour réussie");
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/UsersListPage', ModalRoute.withName('/HomePage'));
    } else if (res == "error") {
      ToastMsg.showToastMsg("Quelque chose s'est mal passé");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

 
  Widget _roundedCheckedBtn(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: RoundedBtnWidget(
          title: title,
          onPressed: () {
            Get.to (() =>
                ShowAppointmentByUidPage(userId: widget.userDetails.uId),
            );
          }),
    );
  }

  Widget _newAppointmentBtn(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: RoundedBtnWidget(
          title: title,
          onPressed: () {
            Get.to (() => 
                ChooseTypePage(userDetails: widget.userDetails),
            );
          }),
    );
  }

  Widget _readOnlyInputField(String labelText, controller) {
    return InputFields.readableInputField(controller, labelText, 1);
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
          return 'Entrez une adresse mail valide';
        } else {
          return null;
        }
      } else {
        return null;
      }
    }, TextInputType.emailAddress, 1);
  }

  Widget _phnNumInputField() {
    return InputFields.readableInputField(
        _phoneNumberController, "Numéro de portable", 1);
  }

  _checkRamid(bool _checked){
    return CheckboxListTile(
        title: const Text("RAMID"),
        controlAffinity: ListTileControlAffinity.platform,
        value: _checked,
        onChanged: (bool value) {
          setState(() {
            _hasRamid = value;
            _hasCnss = !value;
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
            _hasRamid = !value;
          });
        },
        activeColor: Colors.green,
        checkColor: Colors.black,

    );
  }

  _genderDropDown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: _selectedGender,
        //elevation: 5,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: btnColor,
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
          "Genre",
        ),
        onChanged: (String value) {
          setState(() {
            log(value);
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
          "Situation familiale",
        ),
        onChanged: (String value) {
          setState(() {
            _selectedfamilySituation = value;
          });
        },
      ),
    );
  }
    _bloodTypeDropDown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: _selectedBloodType,
        //elevation: 5,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: appBarColor,
        items: <String>[
          'A+',
          'A-',
          'B+',
          'B-',
          'AB',
          'O',
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
          "Groupe sanguin",
        ),
        onChanged: (String value) {
          setState(() {
            _selectedBloodType = value;
          });
        },
      ),
    );
  }

}
