class UsersData {
  UsersData({
    required this.uid,
    required this.name,
    required this.birthDate,
    required this.sex,
    required this.quotes,
    required this.email,
    required this.role,
    required this.isActive,
  });

  String uid;
  String name;
  DateTime birthDate;
  String sex;
  String quotes;
  String email;
  String role;
  bool isActive;
}
