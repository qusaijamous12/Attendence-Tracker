class UserModel{
  final String id;
  final String name;
  final String email;
  final String role;

  UserModel({required this.id,required this.name,required this.email,required this.role});

  factory UserModel.fromJson(final Map<String,dynamic> json){
    return UserModel(
        id: json['uid'],
        name: json['fullName'],
        email: json['email'],
        role: json['role']);
  }
}