class UserModel{
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? state;
  String? campus;
  bool? emailVerified;
  String? countryId;
  String? username;
  String? password;
  String? image;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.state,
    this.campus,
    this.emailVerified,
    this.countryId,
    this.username,
    this.password,
    this.image
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['_id'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    email: json['email'],
    phone: json['phone'].toString(),
    state: json['state'],
      emailVerified: json['emailVerified'],
    campus: json['campus'],
    countryId: json['countryId'],
    username: json['username'],
    image: json['image']
  );

  factory UserModel.fromJson2(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'].toString(),
      state: json['state'],
      emailVerified: json['emailVerified'],
      campus: json['campus'],
      countryId: json['countryId'],
      username: json['username'],
      image: json['image']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phone": phone,
    "state": state,
    "campus": campus,
    "emailVerified": emailVerified ?? false,
    "countryId": countryId,
    "username": username,
    "password": password,
    "image": image
  };

  Map<String, dynamic> toJson2() => {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phone": phone,
    "state": state,
    "campus": campus,
    "emailVerified": emailVerified ?? false,
    "countryId": countryId,
    "username": username,
    "password": password,
    "image": image
  };


}


