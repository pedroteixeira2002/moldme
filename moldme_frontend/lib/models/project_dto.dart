class ProjectDto {
  String? name;
  String? description;
  int? status;
  double? budget;
  String? startDate;
  String? endDate;
  String? companyId;
  List<String>? employeeIds;

  ProjectDto(
      {this.name,
      this.description,
      this.status,
      this.budget,
      this.startDate,
      this.endDate,
      this.companyId,
      this.employeeIds});

  ProjectDto.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    status = json['status'];
    budget = json['budget'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    companyId = json['companyId'];
    employeeIds = json['employeeIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['status'] = status;
    data['budget'] = budget;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['companyId'] = companyId;
    data['employeeIds'] = employeeIds;
    return data;
  }
}