import 'package:front_end_moldme/dtos/company_dto.dart';
import 'package:front_end_moldme/models/company.dart';

class CompanyMapper {
  // Convert Model to DTO
  static CompanyDto toDto(Company company) {
    return CompanyDto(
      companyId: company.companyId,
      name: company.name,
      taxId: company.taxId,
      address: company.address,
      contact: company.contact,
      email: company.email,
      sector: company.sector,
      plan: company.plan,
      password: company.password,
    );
  }

  // Convert DTO to Model
  static Company fromDto(CompanyDto dto) {
    return Company(
      companyId: dto.companyId,
      name: dto.name,
      taxId: dto.taxId,
      address: dto.address,
      contact: dto.contact,
      email: dto.email,
      sector: dto.sector,
      plan: dto.plan,
      password: dto.password,
    );
  }
}
