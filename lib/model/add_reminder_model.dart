
class AddReminderModel {
  Data? data;
  int? status;

  AddReminderModel({this.data, this.status});

  AddReminderModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class Data {
  int? userId;
  String? contactId;
  String? date;
  String? time;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.userId,
        this.contactId,
        this.date,
        this.time,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    contactId = json['contact_id'];
    date = json['date'];
    time = json['time'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['contact_id'] = contactId;
    data['date'] = date;
    data['time'] = time;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
