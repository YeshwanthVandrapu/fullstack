class UserModal {
  int id;
  String name;
  String roll;

  UserModal({
    required this.id,
    required this.name,
    required this.roll,
  });

  factory UserModal.fromJson(Map<String, dynamic> json) => UserModal(
        id: json["id"],
        name: json["name"],
        roll: json["roll"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "roll": roll,
      };
}