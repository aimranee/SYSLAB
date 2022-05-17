
class PrescriptionModel {
  String prescription;
  String patientName; //fcm id
  String appointmentId;
  String appointmentTime;
  String appointmentDate;
  String appointmentName;
  String drName;
  String fileUrl;

  PrescriptionModel({
    this.appointmentTime,
    this.appointmentDate,
    this.appointmentId,
    this.appointmentName,
    this.patientName,
    this.prescription,
    this.fileUrl,
    this.drName
  });

  factory PrescriptionModel.fromJson(Map<String,dynamic> json){
    return PrescriptionModel(
      appointmentTime: json['appointmentTime'],
      appointmentDate: json['appointmentDate'],
      appointmentId: json['appointmentId'],
      appointmentName: json['appointmentName'],
      prescription: json['prescription'],
      patientName: json['patientName'],
      drName: json['drName'],
      fileUrl: json['fileUrl'],
    );
  }

}