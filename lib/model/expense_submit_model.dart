class ExpenseSubmitModel {
  bool? data;
  int? status;

  ExpenseSubmitModel({this.data, this.status});

  ExpenseSubmitModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['data'] = this.data;
    data['status'] = status;
    return data;
  }
}