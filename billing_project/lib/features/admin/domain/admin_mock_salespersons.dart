import '../../salesperson/domain/salesperson_mock_shops.dart';

class SalespersonModel {
  const SalespersonModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    required this.isActive,
    required this.addedDate,
  });

  final String id;
  final String name;
  final String phone;
  final String city;
  final bool isActive;
  final DateTime addedDate;

  SalespersonModel copyWith({bool? isActive}) {
    return SalespersonModel(
      id: id,
      name: name,
      phone: phone,
      city: city,
      isActive: isActive ?? this.isActive,
      addedDate: addedDate,
    );
  }
}

/// Platform-wide salesperson roster for the Super Admin portal. Shop
/// assignment is looked up by matching ShopModel.salespersonName, since this
/// mock phase has no salespersonId foreign key on ShopModel yet.
List<SalespersonModel> buildMockSalespersons() {
  final now = DateTime.now();
  return [
    SalespersonModel(
      id: 'sp1',
      name: 'Venkatesh Naidu',
      phone: '+919876500001',
      city: 'Anantapur, Andhra Pradesh',
      isActive: true,
      addedDate: now.subtract(const Duration(days: 210)),
    ),
    SalespersonModel(
      id: 'sp2',
      name: 'Priya Sharma',
      phone: '+919876500002',
      city: 'Kadapa, Andhra Pradesh',
      isActive: true,
      addedDate: now.subtract(const Duration(days: 95)),
    ),
    SalespersonModel(
      id: 'sp3',
      name: 'Ramesh Babu',
      phone: '+919876500003',
      city: 'Guntur, Andhra Pradesh',
      isActive: false,
      addedDate: now.subtract(const Duration(days: 30)),
    ),
  ];
}

int shopCountFor(String salespersonName) => buildMockShopModelsFor(salespersonName).length;
