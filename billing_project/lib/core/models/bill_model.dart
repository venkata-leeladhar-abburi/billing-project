enum BillStatus { sent, failed, pending }

class BillModel {
  const BillModel({
    required this.id,
    required this.billNumber,
    required this.customerName,
    required this.total,
    required this.status,
    required this.sentAgo,
    this.sentAt,
    this.customerId,
  });

  final String id;
  final String billNumber;
  final String customerName;
  final double total;
  final BillStatus status;
  final String sentAgo;
  final DateTime? sentAt;
  final String? customerId;
}
