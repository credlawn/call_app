class CallLogModel {
  List<Contacts>? contacts;
  int? status;

  CallLogModel({this.contacts, this.status});

  CallLogModel.fromJson(Map<String, dynamic> json) {
    if (json['contacts'] != null) {
      contacts = <Contacts>[];
      json['contacts'].forEach((v) {
        contacts!.add(new Contacts.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contacts != null) {
      data['contacts'] = this.contacts!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Contacts {
  int? id;
  int? contactsId;
  int? userId;
  Null? remark;
  String? status;
  String? createdAt;
  String? updatedAt;
  Contact? contact;

  Contacts(
      {this.id,
        this.contactsId,
        this.userId,
        this.remark,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.contact});

  Contacts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contactsId = json['contacts_id'];
    userId = json['user_id'];
    remark = json['remark'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    contact =
    json['contact'] != null ? new Contact.fromJson(json['contact']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['contacts_id'] = this.contactsId;
    data['user_id'] = this.userId;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.contact != null) {
      data['contact'] = this.contact!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['city'] = this.city;
    data['data_sorch'] = this.dataSorch;
    data['ctc'] = this.ctc;
    data['status'] = this.status;
    data['call_status'] = this.callStatus;
    data['pull_date'] = this.pullDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
