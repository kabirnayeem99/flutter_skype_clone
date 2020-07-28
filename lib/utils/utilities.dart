class Utilities {
  static String getUsername(String email) {
    return "${email.split('@')[0]}";
  }

  static String getInitials(fullName) {
    List<String> fullNameSplits = fullName.split(" ");
    String firstNameInitial = fullNameSplits[0][0];
    String lastNameInitial = fullNameSplits[1][0];

    print(fullName);

    return firstNameInitial + lastNameInitial;
  }
}
