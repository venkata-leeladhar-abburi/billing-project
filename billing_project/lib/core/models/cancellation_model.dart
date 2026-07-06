enum CancellationStatus { pending, approved, rejected }

class CancellationRequest {
  const CancellationRequest({
    required this.id,
    required this.shopId,
    required this.shopName,
    required this.ownerName,
    required this.ownerPhone,
    required this.salespersonName,
    required this.planName,
    required this.monthlyAmount,
    required this.reason,
    required this.requestedDate,
    required this.status,
    this.notes = '',
    this.salespersonAction = CancellationStatus.pending,
    this.adminNotes = '',
  });

  final String id;
  final String shopId;
  final String shopName;
  final String ownerName;
  final String ownerPhone;
  final String salespersonName;
  final String planName;
  final double monthlyAmount;
  final String reason;
  final DateTime requestedDate;
  final CancellationStatus status;
  final String notes;
  final CancellationStatus salespersonAction;
  final String adminNotes;

  CancellationRequest copyWith({
    CancellationStatus? status,
    String? notes,
    CancellationStatus? salespersonAction,
    String? adminNotes,
  }) {
    return CancellationRequest(
      id: id,
      shopId: shopId,
      shopName: shopName,
      ownerName: ownerName,
      ownerPhone: ownerPhone,
      salespersonName: salespersonName,
      planName: planName,
      monthlyAmount: monthlyAmount,
      reason: reason,
      requestedDate: requestedDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      salespersonAction: salespersonAction ?? this.salespersonAction,
      adminNotes: adminNotes ?? this.adminNotes,
    );
  }
}

List<CancellationRequest> buildMockCancellationRequests() {
  final now = DateTime.now();
  return [
    CancellationRequest(
      id: 'cr1',
      shopId: 's4',
      shopName: 'Lakshmi Jewels',
      ownerName: 'Lakshmi',
      ownerPhone: '+919876543240',
      salespersonName: 'Priya Sharma',
      planName: 'Pro',
      monthlyAmount: 599,
      reason: 'Too expensive',
      requestedDate: now.subtract(const Duration(days: 1)),
      status: CancellationStatus.pending,
      salespersonAction: CancellationStatus.pending,
    ),
    CancellationRequest(
      id: 'cr2',
      shopId: 's2',
      shopName: 'Krishna Steel',
      ownerName: 'Krishna Rao',
      ownerPhone: '+919876543220',
      salespersonName: 'Priya Sharma',
      planName: 'Basic',
      monthlyAmount: 299,
      reason: 'Switching to another app',
      requestedDate: now.subtract(const Duration(days: 10)),
      status: CancellationStatus.approved,
      salespersonAction: CancellationStatus.approved,
    ),
    CancellationRequest(
      id: 'cr3',
      shopId: 's1',
      shopName: 'Raju Silks',
      ownerName: 'Rajesh Kumar',
      ownerPhone: '+919876543210',
      salespersonName: 'Venkatesh Naidu',
      planName: 'Pro',
      monthlyAmount: 599,
      reason: 'Technical issues',
      requestedDate: now.subtract(const Duration(days: 25)),
      status: CancellationStatus.rejected,
      salespersonAction: CancellationStatus.rejected,
      notes: 'Owner resolved the issue with support, decided to continue.',
    ),
  ];
}
