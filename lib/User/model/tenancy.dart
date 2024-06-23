class TenancyAgreement {
  final String remainingTime;
  final double amountToBePaid;
  final Property property;

  TenancyAgreement({
    required this.remainingTime,
    required this.amountToBePaid,
    required this.property,
  });
}

class Property {
  final String name;
  final String description;
  final double price;
  final String location;
  final int bedrooms;
  final int bathrooms;
  final int area;
  final String tenancyAgreementPeriod;

  Property({
    required this.name,
    required this.description,
    required this.price,
    required this.location,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.tenancyAgreementPeriod,
  });
}
