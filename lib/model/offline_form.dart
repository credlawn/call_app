class OfflineForm {
  int? id;
  String? bankId;
  String? serviceId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? motherName;
  String? spouseName;
  String? fatherName;
  String? email;
  String? mobile;
  String? gender;
  String? qualification;
  String? accountHolder;
  String? currentAddress;
  String? landmark;
  String? pinCode;
  String? house;
  String? officeName;
  String? officeEmail;
  String? officeLandmark;
  String? officePinCode;
  String? officeDesignation;
  String? surrogate;
  String? cardLimit;
  String? netSalary;
  String? panCard;
  String? aadharNo;
  String? adharFrontImage;
  String? adharBackImage;
  String? panCardImage;

  OfflineForm(
      {this.id,
      this.bankId,
      this.serviceId,
      this.firstName,
      this.middleName,
      this.lastName,
      this.motherName,
      this.spouseName,
      this.fatherName,
      this.email,
      this.mobile,
      this.gender,
      this.qualification,
      this.accountHolder,
      this.currentAddress,
      this.landmark,
      this.pinCode,
      this.house,
      this.officeName,
      this.officeEmail,
      this.officeLandmark,
      this.officePinCode,
      this.officeDesignation,
      this.surrogate,
      this.cardLimit,
      this.netSalary,
      this.panCard,
      this.aadharNo,
      this.adharFrontImage,
      this.adharBackImage,
      this.panCardImage});

  OfflineForm.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    bankId = map['bankId'];
    serviceId = map['serviceId'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    motherName = map['motherName'];
    spouseName = map['spouseName'];
    fatherName = map['fatherName'];
    email = map['email'];
    mobile = map['mobile'];
    gender = map['gender'];
    qualification = map['qualification'];
    accountHolder = map['accountHolder'];
    currentAddress = map['currentAddress'];
    landmark = map['landmark'];
    pinCode = map['pinCode'];
    house = map['house'];
    officeName = map['officeName'];
    officeEmail = map['officeEmail'];
    officeLandmark = map['officeLandmark'];
    officePinCode = map['offincePinCode'];
    officeDesignation = map['officeDesignation'];
    surrogate = map['surrogate'];
    cardLimit = map['cardLimit'];
    netSalary = map['netSalary'];
    panCard = map['panCard'];
    aadharNo = map['aadharNo'];
    adharFrontImage = map['adharFrontImage'];
    adharBackImage = map['adharBackImage'];
    panCardImage = map['panCardImage'];
  }

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bankId']=bankId;
    data['serviceId'] = serviceId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['middleName']=middleName;
    data['spouseName'] = spouseName;
    data['fatherName'] = fatherName;
    data['email']= email;
    data['mobile'] = mobile;
    data['gender'] = gender;
    data['qualification']=qualification;
    data['accountHolder'] = accountHolder;
    data['currentAddress'] = currentAddress;
    data['landmark'] = landmark;
    data['pinCode'] = pinCode;
    data['house'] = house;
    data['officeName'] = officeName;
    data['officeEmail'] = officeEmail;
    data['officeLandmark']=officeLandmark;
    data['officePinCode'] = officePinCode;
    data['officeDesignation'] = officeDesignation;
    data['surrogate'] = surrogate;
    data['cardLimit'] = cardLimit;
    data['netSalary'] = netSalary;
    data['panCard'] = panCard;
    data['aadharNo'] = aadharNo;
    data['adharFrontImage'] = adharFrontImage;
    data['adharBackImage'] = adharBackImage;
    data['panCardImage'] = panCardImage;
    return data;
  }
}
