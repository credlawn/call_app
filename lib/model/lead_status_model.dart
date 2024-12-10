class LeadStatusModel {
  Leadlist? leadlist;
  int? status;

  LeadStatusModel({this.leadlist, this.status});

  LeadStatusModel.fromJson(Map<String, dynamic> json) {
    leadlist = json['list'] != null
        ? Leadlist.fromJson(json['list'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (leadlist != null) {
      data['list'] = leadlist!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class Leadlist {
  int? currentPage;
  List<LeadStatusData>? data;
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

  Leadlist(
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

  Leadlist.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <LeadStatusData>[];
      json['data'].forEach((v) {
        data!.add(LeadStatusData.fromJson(v));
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

class LeadStatusData {
  int? id;
  int? userId;
  int? bankId;
  int? serviceId;
  String? ccNo;
  String? name;
  String? middleName;
  String? lastName;
  String? motherName;
  String? spouseName;
  String? fatherName;
  String? email;
  String? mobile;
  String? alternateMobile;
  String? gender;
  String? qualifcation;
  String? hdfcAccountHolder;
  String? reSubmit;
  String? status;
  String? statusInternal;
  String? createdAt;
  String? updatedAt;
  Address? address;
  OfficeDetails? officeDetails;
  Documents? documents;
  Checklists? checklists;
  Bank? bank;
  String?submitType;
  // List<Null>? feedback;

  LeadStatusData(
      {this.id,
        this.userId,
        this.bankId,
        this.serviceId,
        this.ccNo,
        this.name,
        this.middleName,
        this.lastName,
        this.motherName,
        this.spouseName,
        this.fatherName,
        this.email,
        this.mobile,
        this.alternateMobile,
        this.gender,
        this.qualifcation,
        this.hdfcAccountHolder,
        this.reSubmit,
        this.status,
        this.statusInternal,
        this.createdAt,
        this.updatedAt,
        this.address,
        this.officeDetails,
        this.documents,
        this.checklists,
        this.bank,this.submitType
       });
  // this.feedback

  LeadStatusData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bankId = json['bank_id'];
    serviceId = json['service_id'];
    ccNo = json['cc_no'];
    name = json['name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    motherName = json['mother_name'];
    spouseName = json['spouse_name'];
    fatherName = json['father_name'];
    email = json['email'];
    mobile = json['mobile'];
    alternateMobile = json['alternate_mobile'];
    gender = json['gender'];
    qualifcation = json['qualifcation'];
    hdfcAccountHolder = json['hdfc_account_holder'];
    reSubmit = json['re_submit'];
    status = json['status'];
    submitType = json['submit_type'];
    statusInternal = json['status_internal'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    address =
    json['address'] != null ? Address.fromJson(json['address']) : null;
    officeDetails = json['office_details'] != null
        ? OfficeDetails.fromJson(json['office_details'])
        : null;
    documents = json['documents'] != null
        ? Documents.fromJson(json['documents'])
        : null;
    checklists = json['checklists'] != null
        ? Checklists.fromJson(json['checklists'])
        : null;
    bank = json['bank'] != null ? Bank.fromJson(json['bank']) : null;
    // if (json['feedback'] != null) {
    //   feedback = <Null>[];
    //   json['feedback'].forEach((v) {
    //     feedback!.add(Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['bank_id'] = bankId;
    data['service_id'] = serviceId;
    data['cc_no'] = ccNo;
    data['name'] = name;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['mother_name'] = motherName;
    data['spouse_name'] = spouseName;
    data['father_name'] = fatherName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['alternate_mobile'] = alternateMobile;
    data['gender'] = gender;
    data['qualifcation'] = qualifcation;
    data['hdfc_account_holder'] = hdfcAccountHolder;
    data['re_submit'] = reSubmit;
    data['status'] = status;
    data['status_internal'] = statusInternal;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['submit_type'] = submitType;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (officeDetails != null) {
      data['office_details'] = officeDetails!.toJson();
    }
    if (documents != null) {
      data['documents'] = documents!.toJson();
    }
    if (checklists != null) {
      data['checklists'] = checklists!.toJson();
    }
    if (bank != null) {
      data['bank'] = bank!.toJson();
    }
    // if (feedback != null) {
    //   data['feedback'] = feedback!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Address {
  int? id;
  int? leadId;
  String? currentAddress;
  String? landMark;
  String? city;
  String? pincode;
  String? house;
  String? createdAt;
  String? updatedAt;

  Address(
      {this.id,
        this.leadId,
        this.currentAddress,
        this.landMark,
        this.city,
        this.pincode,
        this.house,
        this.createdAt,
        this.updatedAt});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadId = json['lead_id'];
    currentAddress = json['current_address'];
    landMark = json['land_mark'];
    city = json['city'];
    pincode = json['pincode'];
    house = json['house'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lead_id'] = leadId;
    data['current_address'] = currentAddress;
    data['land_mark'] = landMark;
    data['city'] = city;
    data['pincode'] = pincode;
    data['house'] = house;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class OfficeDetails {
  int? id;
  int? leadId;
  String? officeName;
  String? officeEmail;
  String? officeAddress;
  String? officeLandMark;
  String? officeCity;
  String? officePincode;
  String? officeDesignation;
  String? surrogate;
  String? cardLimit;
  String? netSalary;
  String? createdAt;
  String? updatedAt;

  OfficeDetails(
      {this.id,
        this.leadId,
        this.officeName,
        this.officeEmail,
        this.officeAddress,
        this.officeLandMark,
        this.officeCity,
        this.officePincode,
        this.officeDesignation,
        this.surrogate,
        this.cardLimit,
        this.netSalary,
        this.createdAt,
        this.updatedAt});

  OfficeDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadId = json['lead_id'];
    officeName = json['office_name'];
    officeEmail = json['office_email'];
    officeAddress = json['office_address'];
    officeLandMark = json['office_land_mark'];
    officeCity = json['office_city'];
    officePincode = json['office_pincode'];
    officeDesignation = json['office_designation'];
    surrogate = json['surrogate'];
    cardLimit = json['card_limit'];
    netSalary = json['net_salary'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lead_id'] = leadId;
    data['office_name'] = officeName;
    data['office_email'] = officeEmail;
    data['office_address'] = officeAddress;
    data['office_land_mark'] = officeLandMark;
    data['office_city'] = officeCity;
    data['office_pincode'] = officePincode;
    data['office_designation'] = officeDesignation;
    data['surrogate'] = surrogate;
    data['card_limit'] = cardLimit;
    data['net_salary'] = netSalary;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Documents {
  int? id;
  int? leadId;
  String? panCard;
  String? panImg;
  String? adharNumber;
  String? adharFrontImg;
  String? adharBackImg;
  String? createdAt;
  String? updatedAt;

  Documents(
      {this.id,
        this.leadId,
        this.panCard,
        this.panImg,
        this.adharNumber,
        this.adharFrontImg,
        this.adharBackImg,
        this.createdAt,
        this.updatedAt});

  Documents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadId = json['lead_id'];
    panCard = json['pan_card'];
    panImg = json['pan_img'];
    adharNumber = json['adhar_number'];
    adharFrontImg = json['adhar_front_img'];
    adharBackImg = json['adhar_back_img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lead_id'] = leadId;
    data['pan_card'] = panCard;
    data['pan_img'] = panImg;
    data['adhar_number'] = adharNumber;
    data['adhar_front_img'] = adharFrontImg;
    data['adhar_back_img'] = adharBackImg;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Checklists {
  int? id;
  int? leadId;
  String? isPanCardSignAndKyc;
  String? isKycAnnexure;
  String? isAddressMatchAadhar;
  String? isResidentAndOfficeAddressDiffrent;
  String? isDesignationCheck;
  String? isPromoCodeAndKycCheck;
  String? isSalarySlipAndBankStatementCheck;
  String? isAadharQualityCheck;
  String? isPanQualityCheck;
  String? isCcstatementAndCcphotocopyAndCibilreportCheck;
  String? isActiveLoanCheck;
  String? isSarrogateCheck;
  String? isSignatureCheck;
  String? createdAt;
  String? updatedAt;

  Checklists(
      {this.id,
        this.leadId,
        this.isPanCardSignAndKyc,
        this.isKycAnnexure,
        this.isAddressMatchAadhar,
        this.isResidentAndOfficeAddressDiffrent,
        this.isDesignationCheck,
        this.isPromoCodeAndKycCheck,
        this.isSalarySlipAndBankStatementCheck,
        this.isAadharQualityCheck,
        this.isPanQualityCheck,
        this.isCcstatementAndCcphotocopyAndCibilreportCheck,
        this.isActiveLoanCheck,
        this.isSarrogateCheck,
        this.isSignatureCheck,
        this.createdAt,
        this.updatedAt});

  Checklists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadId = json['lead_id'];
    isPanCardSignAndKyc = json['is_pan_card_sign_and_kyc'];
    isKycAnnexure = json['is_kyc_annexure'];
    isAddressMatchAadhar = json['is_address_match_aadhar'];
    isResidentAndOfficeAddressDiffrent =
    json['is_resident_and_office_address_diffrent'];
    isDesignationCheck = json['is_designation_check'];
    isPromoCodeAndKycCheck = json['is_promo_code_and_kyc_check'];
    isSalarySlipAndBankStatementCheck =
    json['is_salary_slip_and_bank_statement_check'];
    isAadharQualityCheck = json['is_aadhar_quality_check'];
    isPanQualityCheck = json['is_pan_quality_check'];
    isCcstatementAndCcphotocopyAndCibilreportCheck =
    json['is_ccstatement_and_ccphotocopy_and_cibilreport_check'];
    isActiveLoanCheck = json['is_active_loan_check'];
    isSarrogateCheck = json['is_sarrogate_check'];
    isSignatureCheck = json['is_signature_check'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lead_id'] = leadId;
    data['is_pan_card_sign_and_kyc'] = isPanCardSignAndKyc;
    data['is_kyc_annexure'] = isKycAnnexure;
    data['is_address_match_aadhar'] = isAddressMatchAadhar;
    data['is_resident_and_office_address_diffrent'] =
        isResidentAndOfficeAddressDiffrent;
    data['is_designation_check'] = isDesignationCheck;
    data['is_promo_code_and_kyc_check'] = isPromoCodeAndKycCheck;
    data['is_salary_slip_and_bank_statement_check'] =
        isSalarySlipAndBankStatementCheck;
    data['is_aadhar_quality_check'] = isAadharQualityCheck;
    data['is_pan_quality_check'] = isPanQualityCheck;
    data['is_ccstatement_and_ccphotocopy_and_cibilreport_check'] =
        isCcstatementAndCcphotocopyAndCibilreportCheck;
    data['is_active_loan_check'] = isActiveLoanCheck;
    data['is_sarrogate_check'] = isSarrogateCheck;
    data['is_signature_check'] = isSignatureCheck;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Bank {
  int? id;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;

  Bank({this.id, this.name, this.status, this.createdAt, this.updatedAt});

  Bank.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
