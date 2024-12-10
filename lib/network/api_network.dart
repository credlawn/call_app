class ApiNetwork {

  static const String url = 'https://call.credlawn.com/api/';

  static const String login = '${url}login';

  static const String callLogs = '${url}employee/contacts/list';

  static const String callStatus = '${url}employee/contacts/callstatus';

  static const String leadForm = '${url}employee/leads/add';

  static const String applyAnotherLead = '${url}employee/leads/re-apply';

  static const String leadStatus = '${url}employee/leads/list';

  static const String updateLeadStatus = '${url}employee/leads/update';

  static const String addLeadBank = '${url}employee/banks/list';

  static const String leaveApplication = '${url}employee/users/attendance/leave-request';

  static const String checkIn = '${url}employee/users/attendance/request';

  static const String attendance = '${url}employee/users/attendance/list';

  static const String leaveList = '${url}employee/users/attendance/leave-list';

  static const String feedback = '${url}employee/contacts/feedback';

  static const String expenseList = '${url}employee/hr/expenses-list';

  static const String expenseSubmit = '${url}employee/hr/expenses-submit';

  static const String reminderList = '${url}employee/contacts/reminder-list';

  static const String addReminder = '${url}employee/contacts/add-reminder';

  static const String interest = '${url}employee/contacts/GetContactStatus';

  static const String salarySlipDwnld = '${url}employee/Genrate-Slip';
}
