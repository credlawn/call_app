class CheckListModel {
  String? title;
  bool? isCheck;

  CheckListModel({this.title, this.isCheck});

  static List<CheckListModel> checkListModel = [
    CheckListModel(
        title: "Pan card Sign & PAN no. match with all forms & KYC's",
        isCheck: false),
    CheckListModel(
        title: 'KYC  Annexure Check (with Aadhar Last 4 digit)',
        isCheck: false),
    CheckListModel(title: 'Address match with Aadhar card', isCheck: false),
    CheckListModel(
        title: 'Residential & office Address should be different',
        isCheck: false),
    CheckListModel(title: 'Designation check', isCheck: false),
    CheckListModel(
        title: 'Promo code Match with all forms & KYC', isCheck: false),
    CheckListModel(title: 'Salary Slip & Bank statement check', isCheck: false),
    CheckListModel(title: 'Aadhar Card Quality check', isCheck: false),
    CheckListModel(title: 'Pan card quality check', isCheck: false),
    CheckListModel(
        title: 'CC Statement/ CC Photocopy/ CIBIL Report', isCheck: false),
    CheckListModel(
        title: 'Active Loan details (In case active loan required in CIBIL)',
        isCheck: false),
    CheckListModel(
        title: 'Sarrogate check (correct card source)', isCheck: false),
  ];

}
