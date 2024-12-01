import 'package:front_end_moldme/dtos/offer_dto.dart';
import 'package:front_end_moldme/models/offer.dart';

import '../models/status.dart';
import 'company_mapper.dart';
import 'project_mapper.dart';


/// Maps between Offer and OfferDto.
class OfferMapper {

  /// Converts an OfferDto to an Offer model.
  static Offer fromDto(OfferDto dto) {
    return Offer(
      offerId: dto.offerId,
      companyId: dto.companyId,
      company: CompanyMapper.fromDto(dto.company),
      projectId: dto.projectId,
      project: ProjectMapper.fromDto(dto.project),
      date: dto.date,
      status: Status.values.firstWhere((e) => e.name == dto.status),
      description: dto.description,
    );
  }


  /// Converts an Offer model to an OfferDto.
  static OfferDto toDto(Offer offer) {
    return OfferDto(
      offerId: offer.offerId,
      companyId: offer.companyId,
      company: CompanyMapper.toDto(offer.company),
      projectId: offer.projectId,
      project: ProjectMapper.toDto(offer.project),
      date: offer.date,
      status: offer.status.toString().split('.').last, // Convert enum to string
      description: offer.description,
    );
  }

}
