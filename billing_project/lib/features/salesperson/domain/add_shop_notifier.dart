import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/plan_type.dart';

part 'add_shop_notifier.g.dart';

enum MandateStatus { notStarted, sending, waitingApproval, approved, failed }

class AddShopState {
  const AddShopState({
    this.shopName = '',
    this.ownerName = '',
    this.ownerMobile = '',
    this.whatsappNumber = '',
    this.sameAsMobile = true,
    this.address = '',
    this.city = '',
    this.state = '',
    this.pinCode = '',
    this.gstNumber = '',
    this.businessType,
    this.logoPath,
    this.logoSkipped = false,
    this.selectedPlan,
    this.upiId = '',
    this.mandateStatus = MandateStatus.notStarted,
    this.newShopId,
  });

  final String shopName;
  final String ownerName;
  final String ownerMobile;
  final String whatsappNumber;
  final bool sameAsMobile;
  final String address;
  final String city;
  final String state;
  final String pinCode;
  final String gstNumber;
  final String? businessType;
  final String? logoPath;
  final bool logoSkipped;
  final SubscriptionPlan? selectedPlan;
  final String upiId;
  final MandateStatus mandateStatus;
  final String? newShopId;

  double get planAmount {
    switch (selectedPlan) {
      case SubscriptionPlan.basic:
        return 299;
      case SubscriptionPlan.pro:
        return 599;
      case SubscriptionPlan.business:
        return 999;
      case null:
        return 0;
    }
  }

  bool get step1Valid =>
      shopName.trim().length >= 2 &&
      ownerName.trim().length >= 2 &&
      ownerMobile.trim().length == 10 &&
      whatsappNumber.trim().length == 10 &&
      address.trim().length >= 10 &&
      city.trim().isNotEmpty &&
      state.trim().isNotEmpty &&
      pinCode.trim().length == 6 &&
      businessType != null;

  AddShopState copyWith({
    String? shopName,
    String? ownerName,
    String? ownerMobile,
    String? whatsappNumber,
    bool? sameAsMobile,
    String? address,
    String? city,
    String? state,
    String? pinCode,
    String? gstNumber,
    String? businessType,
    String? logoPath,
    bool clearLogo = false,
    bool? logoSkipped,
    SubscriptionPlan? selectedPlan,
    String? upiId,
    MandateStatus? mandateStatus,
    String? newShopId,
  }) {
    return AddShopState(
      shopName: shopName ?? this.shopName,
      ownerName: ownerName ?? this.ownerName,
      ownerMobile: ownerMobile ?? this.ownerMobile,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      sameAsMobile: sameAsMobile ?? this.sameAsMobile,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
      gstNumber: gstNumber ?? this.gstNumber,
      businessType: businessType ?? this.businessType,
      logoPath: clearLogo ? null : (logoPath ?? this.logoPath),
      logoSkipped: logoSkipped ?? this.logoSkipped,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      upiId: upiId ?? this.upiId,
      mandateStatus: mandateStatus ?? this.mandateStatus,
      newShopId: newShopId ?? this.newShopId,
    );
  }
}

@riverpod
class AddShopNotifier extends _$AddShopNotifier {
  @override
  AddShopState build() => const AddShopState();

  void saveStep1({
    required String shopName,
    required String ownerName,
    required String ownerMobile,
    required String whatsappNumber,
    required bool sameAsMobile,
    required String address,
    required String city,
    required String stateName,
    required String pinCode,
    required String gstNumber,
    required String businessType,
  }) {
    state = state.copyWith(
      shopName: shopName,
      ownerName: ownerName,
      ownerMobile: ownerMobile,
      whatsappNumber: sameAsMobile ? ownerMobile : whatsappNumber,
      sameAsMobile: sameAsMobile,
      address: address,
      city: city,
      state: stateName,
      pinCode: pinCode,
      gstNumber: gstNumber,
      businessType: businessType,
    );
  }

  void setLogo(String path) {
    state = state.copyWith(logoPath: path, logoSkipped: false);
  }

  void skipLogo() {
    state = state.copyWith(clearLogo: true, logoSkipped: true);
  }

  void selectPlan(SubscriptionPlan plan) {
    state = state.copyWith(selectedPlan: plan);
  }

  void setUpiId(String upiId) {
    state = state.copyWith(upiId: upiId);
  }

  Future<void> createAutoPayMandate() async {
    state = state.copyWith(mandateStatus: MandateStatus.sending);
    // TODO: replace with real POST /subscriptions/autopay/create call when backend ready
    await Future.delayed(const Duration(milliseconds: 800));

    state = state.copyWith(mandateStatus: MandateStatus.waitingApproval);
    // TODO: replace with real polling of GET /subscriptions/autopay/status when backend ready
    await Future.delayed(const Duration(milliseconds: 2500));

    state = state.copyWith(
      mandateStatus: MandateStatus.approved,
      newShopId: 'shop_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  void reset() {
    state = const AddShopState();
  }
}
