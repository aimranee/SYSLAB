const db = require("../db/db");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

exports.login = function (req, res) {
  db.getConnection((err, connection) => {
    try {
      const params = req.body;
      connection.query(
        `select * from patient where email = ?`,
        [params.email],
        (err, results) => {
          if (err) {
            console.log(err);
          }
          if (!results) {
            return res.json({
              success: 0,
              data: "Invalid email or password",
            });
          }
          return res.send("hereeee " + results.password);
          const result = bcrypt.compareSync(params.password, results.password);
          if (result) {
            results.password = undefined;
            const jsontoken = jwt.sign({ result: results }, "qwe1234", {
              expiresIn: "1h",
            });
            return res.json({
              success: 1,
              message: "login successfully",
              token: jsontoken,
            });
          } else {
            return res.json({
              success: 0,
              data: "Invalid email or password",
            });
          }
        }
      );
    } catch (e) {
      console.log("here");
      // console.log(error);
      return res.send("error in server");
    }
  });
};

exports.signup = function (req, res) {
  db.getConnection((err, connection) => {
    try {
      if (err) throw new Error("database connexion error");
      const params = req.body;
      connection.query(
        `SELECT * FROM patient WHERE LOWER(email) = LOWER(?)`,
        params.email,
        (err, result) => {
          if (result.length) {
            // error
            return res.status(409).send({ message: "Email deja existe" });
          } else {
            const salt = bcrypt.genSaltSync(10);
            let hashedPassword = bcrypt.hashSync(params.password, salt);
            if (!hashedPassword) {
              // throw new Error("error in hash");
              return res.json(
                { success: false, message: "error in hash password" },
                500
              );
            } else {
              console.log(hashedPassword);
              connection.query(
                `INSERT INTO patient (firstName, lastName, email, password, fcmId, pNo, city, createdTimeStamp, updatedTimeStamp, age, gender, cin, hasRamid, hasCnss, familySituation, bloodType, diseaseState)values(?,?,${db.escape(
                  params.email
                )},'${hashedPassword}',?,?,?,'${new Date()}','${new Date()}',?,?,?,?,?,?,?,?);`,
                [
                  params.firstName,
                  params.lastName,
                  params.fcmId,
                  params.pNo,
                  params.city,
                  params.age,
                  params.gender,
                  params.cin,
                  params.hasRamid,
                  params.hasCnss,
                  params.familySituation,
                  params.bloodType,
                  params.diseaseState,
                ],
                (err, rows) => {
                  connection.release();
                  if (!err) res.send(`success`);
                  else console.log(err);

                  console.log("The data from user table \n", rows);
                }
              );
            }
          }
        }
      );
    } catch (error) {
      console.log("here");
      // console.log(error);
      return res.send("error in server");
    }
  });
};

exports.update_user = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw new Error("database Error");
    const params = req.body;
    connection.query(
      "UPDATE patient SET firstName = ?, lastName = ?, city = ?, email = ?, age = ?, uId = ?, gender = ?, pNo = ?, familySituation = ?, hasCnss = ?, hasRamid = ?, cin = ?, bloodType = ? WHERE uId = ?",
      [
        params.firstName,
        params.lastName,
        params.city,
        params.email,
        params.age,
        params.uId,
        params.gender,
        params.pNo,
        params.familySituation,
        params.hasCnss,
        params.hasRamid,
        params.cin,
        params.bloodType,
        params.uId,
      ],
      (err, rows) => {
        connection.release();
        if (!err) res.send(`success`);
        else console.log(err);

        console.log("The data from user table \n", rows);
      }
    );
  });
};

exports.update_user_fcm = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "UPDATE patient SET fcmId = ? WHERE uId = ?",
      [params.fcmId, params.uId],
      (err, rows) => {
        connection.release();
        if (!err) res.send(`Bien Enregistrer!! ID : ${params.uId} bien`);
        else console.log(err);

        console.log("The data from user table \n", rows);
      }
    );
  });
};

exports.get_user = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    connection.query(
      "SELECT * FROM patient WHERE uId = ?",
      [req.params.uId],
      (err, rows) => {
        connection.release();
        if (!err) res.send(rows);
        else console.log(err);

        console.log("The data from user table \n", rows);
      }
    );
  });
};
