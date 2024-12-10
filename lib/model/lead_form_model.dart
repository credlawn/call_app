class LeadFormModel {
  LeadFormData? data;
  int? status;

  LeadFormModel({this.data, this.status});

  LeadFormModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? LeadFormData.fromJson(json['data']) : null;
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

class LeadFormData {
  String? statusInternal;
  String? bankId;
  String? serviceId;
  String? name;
  String? middleName;
  String? lastName;
  String? motherName;
  String? spouseName;
  String? fatherName;
  String? email;
  String? mobile;
  String? gender;
  String? qualifcation;
  String? hdfcAccountHolder;
  int? userId;
  String? updatedAt;
  String? createdAt;
  int? id;

  LeadFormData(
      {this.statusInternal,
        this.bankId,
        this.serviceId,
        this.name,
        this.middleName,
        this.lastName,
        this.motherName,
        this.spouseName,
        this.fatherName,
        this.email,
        this.mobile,
        this.gender,
        this.qualifcation,
        this.hdfcAccountHolder,
        this.userId,
        this.updatedAt,
        this.createdAt,
        this.id});

  LeadFormData.fromJson(Map<String, dynamic> json) {
    statusInternal = json['status_internal'];
    bankId = json['bank_id'];
    serviceId = json['service_id'];
    name = json['name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    motherName = json['mother_name'];
    spouseName = json['spouse_name'];
    fatherName = json['father_name'];
    email = json['email'];
    mobile = json['mobile'];
    gender = json['gender'];
    qualifcation = json['qualifcation'];
    hdfcAccountHolder = json['hdfc_account_holder'];
    userId = json['user_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_internal'] = statusInternal;
    data['bank_id'] = bankId;
    data['service_id'] = serviceId;
    data['name'] = name;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['mother_name'] = motherName;
    data['spouse_name'] = spouseName;
    data['father_name'] = fatherName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['gender'] = gender;
    data['qualifcation'] = qualifcation;
    data['hdfc_account_holder'] = hdfcAccountHolder;
    data['user_id'] = userId;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
