class LeaveApplicationModel {
  Data? data;
  int? status;

  LeaveApplicationModel({this.data, this.status});

  LeaveApplicationModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  int? userId;
  int? attendance;
  String? reason;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? latitude;
  String? longitude;
  String? date;

  Data(
      {this.id,
        this.userId,
        this.attendance,
        this.reason,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.latitude,
        this.longitude,
        this.date});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    attendance = json['attendance'];
    reason = json['reason'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['attendance'] = attendance;
    data['reason'] = reason;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['date'] = date;
    return data;
  }
}