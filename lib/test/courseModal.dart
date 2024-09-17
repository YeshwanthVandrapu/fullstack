class CourseModal {
  String course;
  int status;

  CourseModal({
    required this.course,
    required this.status,
  });

  factory CourseModal.fromJson(Map<String, dynamic> json) => CourseModal(
        course: json["course"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "course": course,
        "status": status,
      };
}