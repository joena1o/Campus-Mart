class UserModel{

  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? state;
  String? campus;
  String? username;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.state,
    this.campus,
    this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['_id'],
    firstName: json['firstName'],
    lastName: json['lastname'],
    email: json['email'],
    phone: json['phone'].toString(),
    state: json['state'],
    campus: json['campus'],
    username: json['username'],
  );



}