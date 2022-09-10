/// Data retrieved on login
class AccountData {
  String accessToken;
  String firstName;
  String lastName;
  int centerId;
  int userId;

  AccountData(this.accessToken, this.firstName, this.lastName, this.centerId,
      this.userId);

  AccountData.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        firstName = json['person']['firstName'],
        lastName = json['person']['lastName'],
        centerId = json['person']['personId']['center'],
        userId = json['person']['personId']['id'];

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'firstName': firstName,
        'lastName': lastName,
        'centerId': centerId,
        'userId': userId,
      };
}
