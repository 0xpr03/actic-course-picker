class LoginData {
  String accessToken;
  String firstName;
  String lastName;
  int centerId;

  LoginData(this.accessToken, this.firstName, this.lastName, this.centerId);

  LoginData.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        firstName = json['person']['firstName'],
        lastName = json['person']['lastName'],
        centerId = json['person']['personId']['center'];
}
