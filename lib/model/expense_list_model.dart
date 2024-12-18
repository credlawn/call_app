class ExpenseListModel {
  ExpenseListData? data;
  int? status;

  ExpenseListModel({this.data, this.status});

  ExpenseListModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ExpenseListData.fromJson(json['data']) : null;
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

class ExpenseListData {
  int? currentPage;
  List<ExpensePrintData>? data;
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

  ExpenseListData(
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

  ExpenseListData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <ExpensePrintData>[];
      json['data'].forEach((v) {
        data!.add(ExpensePrintData.fromJson(v));
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

class ExpensePrintData {
  int? id;
  int? userId;
  int? approvedBy;
  int?amount;
  String? title;
  String? attachment;
  String? status;
  String? createdAt;
  String? updatedAt;
  Employee? employee;

  ExpensePrintData(
      {this.id,
        this.userId,
        this.approvedBy,
        this.title,
        this.attachment,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.amount,
        this.employee});

  ExpensePrintData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    approvedBy = json['approved_by'];
    title = json['title'];
    attachment = json['attachment'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    employee = json['employee'] != null
        ? Employee.fromJson(json['employee'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['approved_by'] = approvedBy;
    data['amount'] = amount;
    data['title'] = title;
    data['attachment'] = attachment;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (employee != null) {
      data['employee'] = employee!.toJson();
    }
    return data;
  }
}

class Employee {
  int? id;
  String? name;

  Employee({this.id, this.name});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
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