import '../dtos/companyDTO.dart';
import '../models/company.dart';

class CompanyMapper {
  static Company fromDto(CompanyDTO dto) {
    return Company(
      name: dto.name,
      taxId: dto.taxId,
      address: dto.address,
      contact: dto.contact,
      email: dto.email,
      sector: dto.sector,
      plan: dto.plan,
    );
  }

  static CompanyDTO toDto(Company model, String password) {
    return CompanyDTO(
      name: model.name,
      taxId: model.taxId,
      address: model.address,
      contact: model.contact,
      email: model.email,
      sector: model.sector,
      plan: model.plan,
      password: password,
    );
  }
}