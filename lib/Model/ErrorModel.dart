class ErrorModel {
  String message;


  ErrorModel(this.message,);

  factory ErrorModel.fromJson(dynamic json) {
    return ErrorModel(json['message'] as String,);
  }

  @override
  String toString() {
    return '{ ${this.message},  }';
  }
}