class Property {
  String? id;
  String name;
  String description;
  double price;
  String location;
  int bedrooms;
  int bathrooms;
  double area;
  List<String> imageUrls;
  int tenancyAgreementPeriod;
  String status;

  Property({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.location,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.imageUrls,
    required this.tenancyAgreementPeriod,
    required this.status,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      location: json['location'] as String,
      bedrooms: json['bedrooms'] as int,
      bathrooms: json['bathrooms'] as int,
      area: json['area'] as double,
      imageUrls: List<String>.from(json['imageUrls']),
      tenancyAgreementPeriod: json['tenancyAgreementPeriod'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'location': location,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'imageUrls': imageUrls,
      'tenancyAgreementPeriod': tenancyAgreementPeriod,
      'status': status,
    };
  }
}
