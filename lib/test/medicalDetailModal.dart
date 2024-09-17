class MedicalModal {
  String reason;
  String visitedDate;

  MedicalModal({
    required this.reason,
    required this.visitedDate,
  });

  factory MedicalModal.fromJson(Map<String, dynamic> json) => MedicalModal(
        reason: json["reason"],
        visitedDate: json["visitedDate"],
      );

  Map<String, dynamic> toJson() => {
        "reason": reason,
        "visitedDate": visitedDate,
      };
}
