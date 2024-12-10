import 'package:call_log_app/network/api_helper.dart';
import 'package:flutter/material.dart';

import '../model/lead_status_model.dart';

class AppController extends ChangeNotifier {
  List<LeadStatusData> leadStatusList = [];

  void getSavedForms() async {
    leadStatusList.clear();

    LeadStatusModel lead = await ApiHelper.leadStatus();

    if (lead.status == 1) {
      leadStatusList = lead.leadlist!.data ?? [];
      leadStatusList =
          leadStatusList.where((element) => element.submitType == '0').toList();
    }
    notifyListeners();
  }
}
