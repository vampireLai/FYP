class Validation {
  static bool isNotEmpty(String value) {
    return value.isNotEmpty;
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    return phoneNumber.isNotEmpty && phoneNumber.length >= 10;
  }

  static bool doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }
}
