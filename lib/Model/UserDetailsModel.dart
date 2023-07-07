// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals, file_names

class UserDetailsModel {
  int? id;
  String? name;
  String? email;
  String? gender;
  String? status;

  UserDetailsModel({this.id, this.name, this.email, this.gender, this.status});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    gender = json['gender'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['status'] = this.status;
    return data;
  }
}
