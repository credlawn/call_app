class InterestModel {
  List<Data>? data;
  int? status;

  InterestModel({this.data, this.status});

  InterestModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Data {
  int? id;
  int? contactsId;
  int? userId;
  String? remark;
  String? status;
  String? createdAt;
  String? updatedAt;
  Contact? contact;

  Data(
      {this.id,
        this.contactsId,
        this.userId,
        this.remark,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.contact});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contactsId = json['contacts_id'];
    userId = json['user_id'];
    remark = json['remark'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    contact =
    json['contact'] != null ? Contact.fromJson(json['contact']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['contacts_id'] = contactsId;
    data['user_id'] = userId;
    data['remark'] = remark;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (contact != null) {
      data['contact'] = contact!.toJson();
    }
    return data;
  }
}

class Contact {
  int? id;
  String? name;
  String? mobile;
  String? city;
  String? dataSorch;
  String? ctc;
  int? status;
  String? callStatus;
  String? pullDate;
  String? createdAt;
  String? updatedAt;

  Contact(
      {this.id,
        this.name,
        this.mobile,
        this.city,
        this.dataSorch,
        this.ctc,
        this.status,
        this.callStatus,
        this.pullDate,
        this.createdAt,
        this.updatedAt});

  Contact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    city = json['city'];
    dataSorch = json['data_sorch'];
    ctc = json['ctc'];
    status = json['status'];
    callStatus = json['call_status'];
    pullDate = json['pull_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['mobile'] = mobile;
    data['city'] = city;
    data['data_sorch'] = dataSorch;
    data['ctc'] = ctc;
    data['status'] = status;
    data['call_status'] = callStatus;
    data['pull_date'] = pullDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
