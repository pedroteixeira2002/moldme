import 'package:front_end_moldme/dtos/employee_dto.dart';
import 'package:front_end_moldme/mappers/company_mapper.dart';
import 'package:front_end_moldme/models/employee.dart';

class EmployeeMapper {
  // Convert DTO to Model
  static Employee fromDto(EmployeeDto dto) {
    return Employee(
      employeeId: dto.employeeId ?? '',
      name: dto.name,
      profession: dto.profession,
      nif: dto.nif,
      email: dto.email,
      contact: dto.contact,
      password: dto.password,
      companyId: dto.companyId,
      company: dto.company != null
          ? CompanyMapper.fromDto(dto.company!)
          : null, // Trata o caso em que dto.company é null
    );
  }

  // Convert Model to DTO
  static EmployeeDto toDto(Employee employee) {
    return EmployeeDto(
      employeeId: employee.employeeId,
      name: employee.name,
      profession: employee.profession,
      nif: employee.nif,
      email: employee.email,
      contact: employee.contact,
      password: employee.password,
      companyId: employee.companyId,
      company: employee.company != null
          ? CompanyMapper.toDto(employee.company!)
          : null, // Trata o caso em que employee.company é null
    );
  }
}
