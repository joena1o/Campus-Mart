
class AccessToken {

  String _token = "";

  AccessToken._privateConstructor();

  static final AccessToken _instance = AccessToken._privateConstructor();

  static AccessToken get instance => _instance;

  String get token => _token;

  set setToken(String newToken) {
    _token = newToken;
  }

}