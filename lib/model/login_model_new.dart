class LoginNewModel {
  User? user;
  int? status;

  LoginNewModel({this.user, this.status});

  LoginNewModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['status'] = status;
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
  String? token;

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
        this.token});

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
    token = json['token'];
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
    data['token'] = token;
    return data;
  }
}