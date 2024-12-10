import 'dart:convert';
import 'dart:typed_data';
import 'package:call_log_app/helper/session_manager.dart';
import 'package:call_log_app/model/attendance.dart';
import 'package:call_log_app/model/lead_form_model.dart';
import 'package:call_log_app/network/api_network.dart';
import 'package:http/http.dart';
import '../model/add_lead_bank_model.dart';
import '../model/add_reminder_model.dart';
import '../model/call_log_model.dart';
import '../model/checkin_model.dart';
import '../model/expense_list_model.dart';
import '../model/expense_submit_model.dart';
import '../model/feedback_model.dart';
import '../model/interest_model.dart';
import '../model/lead_status_model.dart';
import '../model/leave_application_list_model.dart';
import '../model/leave_application_model.dart';
import '../model/login_model_new.dart';
import '../model/reminder_list_model.dart';

class ApiHelper {
  static Future<LoginNewModel> loginNew(Map<String, String> body) async {
    try {
      var response = await post(
        Uri.parse(ApiNetwork.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return LoginNewModel.fromJson(jsonDecode(response.body));
      } else {
        return LoginNewModel(status: 0);
      }
    } catch (e) {
      print(e);
      return LoginNewModel(status: 0);
    }
  }

  static Future<CallLogModel> callLog() async {
    try {
      var response = await get(
        Uri.parse(ApiNetwork.callLogs),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SessionManager.getToken()}'
        },
      );
      if (response.statusCode == 200) {
        print('calll ${response.body}');
        return CallLogModel.fromJson(jsonDecode(response.body));

      } else {
        return CallLogModel(status: 0);
      }
    } catch (e) {
      print("CATCH OF CALL LOGS $e");
      return CallLogModel(status: 0);
    }
  }

  static Future<LeadStatusModel> leadStatus() async {
    try {
      var response = await get(
        Uri.parse(ApiNetwork.leadStatus),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SessionManager.getToken()}'
        },
      );
      if (response.statusCode == 200) {
        return LeadStatusModel.fromJson(jsonDecode(response.body));
      } else {
        print('Server Error');
        return LeadStatusModel(status: 0);
      }
    } catch (e) {
      print(e);
      return LeadStatusModel(status: 0);
    }
  }

  static Future<AddLeadBankModel> addLeadBank() async {
    try {
      var response = await get(Uri.parse(ApiNetwork.addLeadBank), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SessionManager.getToken()}',
      });
      if (response.statusCode == 200) {
        return AddLeadBankModel.fromJson(jsonDecode(response.body));
      } else {
        print('Server Error');
        return AddLeadBankModel(status: 0);
      }
    } catch (e) {
      print(e);
      return AddLeadBankModel(status: 0);
    }
  }

  static Future<LeaveApplicationModel> leaveApplication(
      Map<String, String> body) async {
    try {
      var response = await post(
        Uri.parse(ApiNetwork.leaveApplication),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SessionManager.getToken()}',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return LeaveApplicationModel.fromJson(jsonDecode(response.body));
      } else {
        print('Server Error');
        return LeaveApplicationModel(status: 0);
      }
    } catch (e) {
      print(e);
      return LeaveApplicationModel(status: 0);
    }
  }

  static Future<CheckInModel> checkIn(Map<String, String> body) async {
    try {
      var response = await post(Uri.parse(ApiNetwork.checkIn),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${SessionManager.getToken()}',
          },
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        return CheckInModel.fromJson(jsonDecode(response.body));
      } else {
        print('Server Error');
        return CheckInModel(status: 0);
      }
    } catch (e) {
      print('Exception: $e');
      return CheckInModel(status: 0);
    }
  }

  static Future<LeaveApplicationListModel> leaveList() async {
    try {
      var response = await get(
        Uri.parse(ApiNetwork.leaveList),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SessionManager.getToken()}'
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        return LeaveApplicationListModel.fromJson(jsonDecode(response.body));
      } else {
        print('Server error');
        return LeaveApplicationListModel(status: 0);
      }
    } catch (e) {
      print('Error: $e');
      return LeaveApplicationListModel(status: 0);
    }
  }

  static Future<FeedbackModel> feedback(Map<String, dynamic> body) async {
    try {
      var response = await post(Uri.parse(ApiNetwork.feedback),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${SessionManager.getToken()}'
          },
          body: jsonEncode(body));
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        return FeedbackModel.fromJson(jsonDecode(response.body));
      } else {
        print('Server Error');
        return FeedbackModel(
            status: 0, data: FeedbackData(remark: 'Server Error'));
      }
    } catch (e) {
      print('Error: $e');
      return FeedbackModel(status: 0, data: FeedbackData(remark: e.toString()));
    }
  }

  static Future<LeadFormModel> leadForm(
    Map<String, String> body,
    String pan,
    String aadharFront,
    String aadharBack,
    String customerphoto,
    String cardstatemenrimg,
    String cardimg,
    String cibilreportimg,
    String itrimg,
    String bankstatementimg,
    String salaryslipIMG1,
    String salaryslipIMG2,
    String salaryslipIMG3,
  ) async {
    print("body map---${body}");
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SessionManager.getToken()}'
      };
      var request = MultipartRequest('POST', Uri.parse(ApiNetwork.leadForm));
      request.fields.addAll(body);
      if (pan.isNotEmpty) {
        request.files
            .add(await MultipartFile.fromPath('documents[pan_img]', pan));
      }

      if (aadharFront.isNotEmpty && aadharBack.isNotEmpty) {
        request.files.add(await MultipartFile.fromPath(
            'documents[adhar_front_img]', aadharFront));
        request.files.add(await MultipartFile.fromPath(
            'documents[adhar_back_img]', aadharBack));
      }
      if (customerphoto.isNotEmpty) {
        request.files.add(await MultipartFile.fromPath(
            'documents[customer_photo]', customerphoto));
      }
      if (salaryslipIMG1.isNotEmpty) {
        request.files.add(await MultipartFile.fromPath(
            'documents[salary_slip1]', salaryslipIMG1));
      }
      print("SALAAARYYYY SLIIPPPP 1 = $salaryslipIMG1");
      if (salaryslipIMG2.isNotEmpty) {
        request.files.add(await MultipartFile.fromPath(
            'documents[salary_slip2]', salaryslipIMG2));
      }
      print("SALAAARYYYY SLIIPPPP 2 = $salaryslipIMG2");
      if (salaryslipIMG3.isNotEmpty) {
        request.files.add(await MultipartFile.fromPath(
            'documents[salary_slip3]', salaryslipIMG3));
      }
      print("SALAAARYYYY SLIIPPPP 3 = $salaryslipIMG3");
      if (cardstatemenrimg.isNotEmpty) {
        request.files.add(await MultipartFile.fromPath(
            'documents[card_statement_photo]', cardstatemenrimg));
      }
      if (cardimg.isNotEmpty) {
        request.files.add(
            await MultipartFile.fromPath('documents[card_photo]', cardimg));
      }
      if (cibilreportimg.isNotEmpty) {
        request.files.add(await MultipartFile.fromPath(
            'documents[civil_report_photo]', cibilreportimg));
      }
      if (itrimg.isNotEmpty) {
        request.files
            .add(await MultipartFile.fromPath('documents[itr_photo]', itrimg));
      }
      if (bankstatementimg.isNotEmpty) {
        request.files.add(await MultipartFile.fromPath(
            'documents[bank_statement_photo]', bankstatementimg));
      }

      /*     if(_salarySlipImgList.isNotEmpty){
        List<MultipartFile> files=[];

       _salarySlipImgList.forEach((element) async {
         files.add(await MultipartFile.fromPath(
             'documents.salary_slip[]', element.path));
       });
        request.files.addAll(files);
      }*/

      request.headers.addAll(headers);

      StreamedResponse response = await request.send();
      print("staus----${response.statusCode}");

      if (response.statusCode == 200) {
        var res = await response.stream.bytesToString();
        print("_panCardImg----${res}");
        return LeadFormModel.fromJson(jsonDecode(res));
      } else {
        return LeadFormModel(status: 0, data: LeadFormData());
      }
    } catch (e) {
      print('Error $e');
      return LeadFormModel(status: 0, data: LeadFormData());
    }
  }

  static Future<LeadFormModel> updateLeadForm(Map<String, String> body,
      String pan, String aadharFront, String aadharBack) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SessionManager.getToken()}'
      };

      var request =
          MultipartRequest('POST', Uri.parse(ApiNetwork.updateLeadStatus));
      request.fields.addAll(body);
      if (pan.isNotEmpty) {
        request.files.add(await MultipartFile.fromPath('pan_img', pan));
      }

      if (aadharFront.isNotEmpty && aadharBack.isNotEmpty) {
        request.files
            .add(await MultipartFile.fromPath('adhar_front_img', aadharFront));
        request.files
            .add(await MultipartFile.fromPath('adhar_back_img', aadharBack));
      }

      request.headers.addAll(headers);

      StreamedResponse response = await request.send();

      // print('ERROR ${await response.stream.bytesToString()}');

      print(response.statusCode);
      if (response.statusCode == 200) {
        var res = await response.stream.bytesToString();
        return LeadFormModel.fromJson(jsonDecode(res));
      } else {
        return LeadFormModel(status: 0, data: LeadFormData());
      }
    } catch (e) {
      print('Error $e');
      return LeadFormModel(status: 0, data: LeadFormData());
    }
  }

  static Future<LeadFormModel> applyAnotherLead(Map<String, String> body,
      String pan, String aadharFront, String aadharBack) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SessionManager.getToken()}'
      };
      var request =
          MultipartRequest('POST', Uri.parse(ApiNetwork.applyAnotherLead));
      request.fields.addAll(body);
      request.files
          .add(await MultipartFile.fromPath('documents[pan_img]', pan));
      request.files.add(await MultipartFile.fromPath(
          'documents[adhar_front_img]', aadharFront));
      request.files.add(await MultipartFile.fromPath(
          'documents[adhar_back_img]', aadharBack));
      request.headers.addAll(headers);

      StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var res = await response.stream.bytesToString();
        return LeadFormModel.fromJson(jsonDecode(res));
      } else {
        print('Status code ${response.statusCode}');
        print(response.reasonPhrase);
        return LeadFormModel(status: 0, data: LeadFormData());
      }
    } catch (e) {
      print('Error $e');
      return LeadFormModel(status: 0, data: LeadFormData());
    }
  }

  static Future<ExpenseListModel> expenseList() async {
    try {
      var response = await get(Uri.parse(ApiNetwork.expenseList), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SessionManager.getToken()}',
      });
      if (response.statusCode == 200) {
        return ExpenseListModel.fromJson(jsonDecode(response.body));
      } else {
        print('Server Error');
        return ExpenseListModel(status: 0);
      }
      /*  var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${SessionManager.getToken()}'
      };
      var request = MultipartRequest(
          'GET',
          Uri.parse(
              'https://ruparnatechnology.com/credlawn/api/employee/hr/expenses-list'));

      request.headers.addAll(headers);

      StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var res = await response.stream.bytesToString();
        print(res);
        return ExpenseListModel.fromJson(jsonDecode(res));
      } else {
        print(response.reasonPhrase);
        return ExpenseListModel(status: 0);
      }*/
    } catch (e) {
      print('exception error: $e');
      return ExpenseListModel(status: 0);
    }
  }

  static Future<ExpenseSubmitModel> addExpense(
      String title, String imgSub, String amount) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SessionManager.getToken()}'
      };

      Map<String, String> body = {
        'title[]': title,
        'amount[]': amount,
      };
      var request =
          MultipartRequest('POST', Uri.parse(ApiNetwork.expenseSubmit));
      request.fields.addAll(body);

      request.files.add(await MultipartFile.fromPath('attachments[]', imgSub));

      request.headers.addAll(headers);

      StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var res = await response.stream.bytesToString();
        return ExpenseSubmitModel.fromJson(jsonDecode(res));
      } else {
        return ExpenseSubmitModel(status: 0);
      }
    } catch (e) {
      print('Error : $e');
      return ExpenseSubmitModel(status: 0);
    }
  }

  static Future<ReminderListModel> reminderList() async {
    try {
      var response = await get(
        Uri.parse(ApiNetwork.reminderList),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SessionManager.getToken()}'
        },
      );
      if (response.statusCode == 200) {
        print("OnSuccess :- ${response.body}");
        return ReminderListModel.fromJson(jsonDecode(response.body));
      } else {
        print('Server error');
        return ReminderListModel(status: 0);
      }
    } catch (e) {
      print('Error: $e');
      return ReminderListModel(status: 0);
    }
  }

  static Future<AddReminderModel> addReminder(Map<String, String> body) async {
    try {
      var response = await post(Uri.parse(ApiNetwork.addReminder),
          headers: {
            'Authorization': 'Bearer ${SessionManager.getToken()}',
            'Accept': 'application/json',
          },
          body: body);
      print(response.body);

      if (response.statusCode == 200) {
        return AddReminderModel.fromJson(jsonDecode(response.body));
      } else {
        return AddReminderModel(status: 0);
      }
    } catch (e) {
      print('Exception Error: $e');
      return AddReminderModel(status: 0);
    }
  }

  static Future<Attendance> getAttendanceList() async {
    try {
      var response = await get(
        Uri.parse(ApiNetwork.attendance),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SessionManager.getToken()}'
        },
      );
      if (response.statusCode == 200) {
        return Attendance.fromJson(jsonDecode(response.body));
      } else {
        return Attendance(status: 0);
      }
    } catch (e) {
      print("Attandance List :- $e");
      return Attendance(status: 0);
    }
  }

  static Future<ExpenseSubmitModel> updateCallStatus(
      String contactId, String status) async {
    try {
      var headers = {'Authorization': 'Bearer ${SessionManager.getToken()}'};

      Map<String, String> body = {
        'User_id': contactId,
        'call_status': status,
      };
      var response = await post(Uri.parse(ApiNetwork.callStatus),
          headers: headers, body: body);
      if (response.statusCode == 200) {
        return ExpenseSubmitModel.fromJson(jsonDecode(response.body));
      } else {
        return ExpenseSubmitModel(status: 0);
      }
    } catch (e) {
      print(e);
      return ExpenseSubmitModel(status: 0);
    }
  }

  static Future<InterestModel> interest() async {
    Uri url = Uri.parse(ApiNetwork.interest);
    var headers = {'Authorization': 'Bearer ${SessionManager.getToken()}'};

    print(headers);
    try {
      var response = await get(url, headers: headers);
      print(response.body + "gdfggddddddddddddddfdgdg");
      if (response.statusCode == 200) {
        return InterestModel.fromJson(jsonDecode(response.body));
      } else {
        return InterestModel(status: 0);
      }
    } catch (e) {
      print(e);
      print("dfgvxdgdfgdfgfdgfdg");
      return InterestModel(status: 0);
    }
  }

  static Future<Uint8List?> salarySlipDwnld(Map<String, dynamic>body) async{
    Uri url = Uri.parse(ApiNetwork.salarySlipDwnld);
    var header = {'Authorization':'Bearer ${SessionManager.getToken()}'};
    print("SALARY SLIP BODY::$body");
    try {
      var response = await post(url, body: body,headers: header);
      if (response.statusCode == 200) {
        print("Response Body ::${response.body}");
        return response.bodyBytes;
      } else {
        return null;
      }
    } catch (e) {
      print("Salary Slip Catch::$e");
      return null;
    }
  }
}
