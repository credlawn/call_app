class Attendance {
  AttendanceData? leaveList;
  int? status;

  Attendance({this.leaveList, this.status});

  Attendance.fromJson(Map<String, dynamic> json) {
    leaveList = json['LeaveList'] != null
        ? AttendanceData.fromJson(json['LeaveList'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (leaveList != null) {
      data['LeaveList'] = leaveList!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class AttendanceData {
  int? currentPage;
  List<AttendanceDataList>? data;

  AttendanceData({this.currentPage, this.data});

  AttendanceData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <AttendanceDataList>[];
      json['data'].forEach((v) {
        data!.add(AttendanceDataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendanceDataList {
  int? id;
  int? userId;
  int? attendance;
  String? latitude;
  String? longitude;
  String? date;
  String? inDate;
  String? outDate;
  String? type;
  int? leaveType;
  int? status;
  String? createdAt;
  String? updatedAt;
  User? user;

  AttendanceDataList(
      {this.id,
        this.userId,
        this.attendance,
        this.latitude,
        this.longitude,
        this.date,
        this.inDate,
        this.outDate,
        this.type,
        this.leaveType,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.user});

  AttendanceDataList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    attendance = json['attendance'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    date = json['date'];
    inDate = json['in_date'];
    outDate = json['out_date'];
    type = json['type'];
    leaveType = json['leave_type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['attendance'] = attendance;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['date'] = date;
    data['in_date'] = inDate;
    data['out_date'] = outDate;
    data['type'] = type;
    data['leave_type'] = leaveType;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? gender;
  String? emailVerifiedAt;
  String? role;
  String? status;
  String? joiningDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
        this.name,
        this.email,
        this.mobile,
        this.gender,
        this.emailVerifiedAt,
        this.role,
        this.status,
        this.joiningDate,
        this.endDate,
        this.createdAt,
        this.updatedAt,
       });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    gender = json['gender'];
    emailVerifiedAt = json['email_verified_at'];
    role = json['role'];
    status = json['status'];
    joiningDate = json['joining_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['gender'] = gender;
    data['email_verified_at'] = emailVerifiedAt;
    data['role'] = role;
    data['status'] = status;
    data['joining_date'] = joiningDate;
    data['end_date'] = endDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
