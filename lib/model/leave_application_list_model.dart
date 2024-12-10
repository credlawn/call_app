class LeaveApplicationListModel {
  LeaveList? leaveList;
  int? status;

  LeaveApplicationListModel({this.leaveList, this.status});

  LeaveApplicationListModel.fromJson(Map<String, dynamic> json) {
    leaveList = json['LeaveList'] != null
        ? LeaveList.fromJson(json['LeaveList'])
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

class LeaveList {
  int? currentPage;
  List<LeaveListData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  LeaveList(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  LeaveList.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <LeaveListData>[];
      json['data'].forEach((v) {
        data!.add(LeaveListData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class LeaveListData {
  int? id;
  int? userId;
  int? attendance;
  String? reason;
  String? latitude;
  String? longitude;
  String? date;
  String? inDate;
  String? outDate;
  String? type;
  int? approvedBy;
  int? status;
  String? createdAt;
  String? updatedAt;
  User? user;

  LeaveListData(
      {this.id,
        this.userId,
        this.attendance,
        this.reason,
        this.latitude,
        this.longitude,
        this.date,
        this.inDate,
        this.outDate,
        this.type,
        this.approvedBy,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.user});

  LeaveListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    attendance = json['attendance'];
    reason = json['reason'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    date = json['date'];
    inDate = json['in_date'];
    outDate = json['out_date'];
    type = json['type'];
    approvedBy = json['approved_by'];
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
    data['reason'] = reason;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['date'] = date;
    data['in_date'] = inDate;
    data['out_date'] = outDate;
    data['type'] = type;
    data['approved_by'] = approvedBy;
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
  String? deletedAt;

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
        this.deletedAt});

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
    deletedAt = json['deleted_at'];
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
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}