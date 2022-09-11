/// Data retrieved on login
class AccountData {
  String accessToken;
  String firstName;
  String lastName;
  int centerId;
  String userId;

  AccountData(this.accessToken, this.firstName, this.lastName, this.centerId,
      this.userId);

  /// Parse from http API json
  AccountData.fromAPIJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        firstName = json['person']['firstName'],
        lastName = json['person']['lastName'],
        centerId = json['person']['personId']['center'],
        userId = json['person']['personId']['externalId'];

  /// Parse from storage json
  AccountData.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        centerId = json['centerId'],
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'firstName': firstName,
        'lastName': lastName,
        'centerId': centerId,
        'userId': userId,
      };
}
