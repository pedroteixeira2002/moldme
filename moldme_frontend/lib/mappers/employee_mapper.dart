import 'package:front_end_moldme/dtos/employee_dto.dart';
import 'package:front_end_moldme/mappers/company_mapper.dart';
import 'package:front_end_moldme/models/employee.dart';

class EmployeeMapper {

  // Convert DTO to Model
  static Employee fromDto(EmployeeDto dto) {
    return Employee(
      employeeId: dto.employeeId,
      name: dto.name,
      profession: dto.profession,
      nif: dto.nif,
      email: dto.email,
      contact: dto.contact,
      password: dto.password,
      companyId: dto.companyId,
      company: CompanyMapper.fromDto(dto.company),
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
      company: CompanyMapper.toDto(employee.company),
    );
  }
}
