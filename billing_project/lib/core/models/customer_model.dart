class CustomerModel {
  const CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.billCount,
    required this.totalBilled,
    this.lastBilledAt,
    this.addedAt,
  });

  final String id;
  final String name;
  final String phone;
  final int billCount;
  final double totalBilled;
  final DateTime? lastBilledAt;
  final DateTime? addedAt;
}
