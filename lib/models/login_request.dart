class LoginRequest {
  final String userName;
  final String password;
  final String deviceId;
  final String deviceToken;
  final String deviceName;
  final String platform;
  final int qryOption;
  final int versionCode;
  final int userCode;
  final String osName;
  final String osVersion;

  const LoginRequest({
    required this.userName,
    required this.password,
    this.deviceId = 'init_id',
    this.deviceToken = '464be0aa-cfc8-46a7-a217-d4e2fe4eb85c',
    this.deviceName = 'Google Pixel 3 XL',
    this.platform = 'android',
    this.qryOption = 1,
    this.versionCode = 31,
    this.userCode = 1,
    this.osName = 'S',
    this.osVersion = '12',
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'userName': userName,
      'Password': password,
      'DeviceID': deviceId,
      'DeviceToken': deviceToken,
      'DeviceName': deviceName,
      'Platform': platform,
      'QryOption': qryOption.toString(),
      'VersionCode': versionCode.toString(),
      'UserCode': userCode.toString(),
      'OSName': osName,
      'OSVersion': osVersion,
    };
  }
}
