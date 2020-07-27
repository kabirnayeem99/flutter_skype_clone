class Utilities {
  static String getUsername(String email, String uid) {
    return "user_${email.split('@')[0]}_$uid";
  }

  static String getInitials(fullName) {

    List<String> fullNameSplits = fullName.split(" ");
    String firstNameInitial = fullNameSplits[0][0];
    String lastNameInitial = fullNameSplits[1][0];

    print(fullName);


    return firstNameInitial + lastNameInitial;
  }
}
