class FeedbackModel {
  FeedbackData? data;
  int? status;

  FeedbackModel({this.data, this.status});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? FeedbackData.fromJson(json['data']) : null;
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

class FeedbackData {
  int? userId;
  String? remark;
  String? updatedAt;
  String? createdAt;
  int? id;

  FeedbackData({this.userId, this.remark, this.updatedAt, this.createdAt, this.id});

  FeedbackData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    remark = json['remark'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['remark'] = remark;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}