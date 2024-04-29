import '../../model/tenancy.dart';

// Dummy data for tenancy agreement
TenancyAgreement getDummyTenancyAgreement() {
  return TenancyAgreement(
    remainingTime: '6 months',
    amountToBePaid: 1200.0,
    property: Property(
      name: 'Beautiful Apartment',
      description: 'A spacious apartment with great amenities',
      price: 1500.0,
      location: 'City Center',
      bedrooms: 2,
      bathrooms: 2,
      area: 1200,
      tenancyAgreementPeriod: '1 year',
    ),
  );
}
