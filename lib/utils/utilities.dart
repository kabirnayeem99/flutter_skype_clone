class Utilities {
  static String getUsername(String email, String uid) {
    return "user_${email.split('@')[0]}_$uid";
  }
}
