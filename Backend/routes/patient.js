const express = require("express");
const availabilityController = require("../controllers/availabilityController");
const analysesController = require("../controllers/analysesController");
const appointmentsController = require("../controllers/appointmentsController");
const appointmentsTypeController = require("../controllers/appointmentsTypeController");
const patientController = require("../controllers/patientController");
const prescriptionController = require("../controllers/prescriptionController");
const notificationController = require("../controllers/notificationController");
// const patientMiddleware = require("../middleware/verify_patient");

const routes = express.Router();

routes.route("/signup").post(patientController.signup);
routes.route("/login").post(patientController.login);
routes.route("/update_user").put(patientController.update_user);
routes.route("/update_user_fcm").put(patientController.update_user_fcm);
routes.route("/get_fcmId_admin").get(patientController.get_fcmId_admin);
routes.route("/get_user/:uId").get(patientController.get_user);

routes.route("/get_availability").get(availabilityController.get_availability);

routes.route("/get_analyses").get(analysesController.get_analyses);
routes
  .route("/get_analyses_byId/:id")
  .get(analysesController.get_analyses_byId);
routes.route("/get_categories").get(analysesController.get_categories);
routes.route("/get_cat_analyse").get(analysesController.get_cat_analyse);
routes
.route("/get_appointment_by_status/:uId/:status")
  .get(appointmentsController.get_appointment_by_status);

routes.route("/add_appointment").post(appointmentsController.add_appointment);
routes
  .route("/get_appointment_type")
  .get(appointmentsTypeController.get_appointment_type);


routes
  .route("/get_prescription/:uId")
  .get(prescriptionController.get_prescription);
routes
  .route("/get_prescription_byid/:patientId/:appointmentId")
  .get(prescriptionController.get_prescription_byid);

routes
  .route("/update_prescription_isPaied")
  .put(prescriptionController.update_prescription_isPaied);

routes
  .route("/update_appointment_status")
  .put(appointmentsController.update_appointment_status);

routes
  .route("/get_notif_status_patient/:uId")
  .get(notificationController.get_notif_status_patient);
routes
  .route("/update_notif_status_patient")
  .put(notificationController.update_notif_status_patient);
routes
  .route("/update_notif_status_admin")
  .put(notificationController.update_notif_status_admin);

module.exports = routes;
