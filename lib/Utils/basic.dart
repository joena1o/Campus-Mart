String getInitials(String fullName) {
  List<String> names = fullName.split(' ');

  if (names.length < 2) {
    // If the name has less than 2 parts, return just the first letter of the only name part
    return names.first[0].toUpperCase();
  }

  String firstNameInitial = names.first[0].toUpperCase();
  String lastNameInitial = names.last[0].toUpperCase();

  return firstNameInitial + lastNameInitial;
}