class ProjectDto {
  final String name;
  final String description;
  final int status; // Integer to match dropdown value
  final double budget;
  final String startDate;
  final String endDate;

  ProjectDto({
    required this.name,
    required this.description,
    required this.status,
    required this.budget,
    required this.startDate,
    required this.endDate,
  });

  factory ProjectDto.fromJson(Map<String, dynamic> json) {
    return ProjectDto(
      name: json['name'],
      description: json['description'],
      status: json['status'], // Integer expected
      budget: json['budget'].toDouble(),
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'budget': budget,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
