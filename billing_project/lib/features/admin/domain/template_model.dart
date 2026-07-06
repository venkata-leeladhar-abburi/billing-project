enum MetaApprovalStatus { approved, pending, rejected, inactive }

enum TemplateCategory { marketing, utility }

class TemplateVariable {
  const TemplateVariable({required this.index, required this.description});

  final int index;
  final String description;
}

class TemplateModel {
  const TemplateModel({
    required this.id,
    required this.businessType,
    required this.templateName,
    required this.category,
    required this.body,
    required this.status,
    required this.isActive,
    this.header = '',
    this.footer = '',
    this.variables = const [],
    this.lastUpdated,
    this.rejectionReason,
    this.aisensyTemplateId = '',
  });

  final String id;
  final String businessType;
  final String templateName;
  final TemplateCategory category;
  final String body;
  final MetaApprovalStatus status;
  final bool isActive;
  final String header;
  final String footer;
  final List<TemplateVariable> variables;
  final DateTime? lastUpdated;
  final String? rejectionReason;
  final String aisensyTemplateId;

  TemplateModel copyWith({
    String? templateName,
    TemplateCategory? category,
    String? body,
    MetaApprovalStatus? status,
    bool? isActive,
    String? header,
    String? footer,
    List<TemplateVariable>? variables,
    DateTime? lastUpdated,
    String? rejectionReason,
  }) {
    return TemplateModel(
      id: id,
      businessType: businessType,
      templateName: templateName ?? this.templateName,
      category: category ?? this.category,
      body: body ?? this.body,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      header: header ?? this.header,
      footer: footer ?? this.footer,
      variables: variables ?? this.variables,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      aisensyTemplateId: aisensyTemplateId,
    );
  }
}

List<TemplateModel> buildMockTemplates() {
  final now = DateTime.now();
  return [
    TemplateModel(
      id: 't_clothing',
      businessType: 'Clothing',
      templateName: 'clothing_festival_offer',
      category: TemplateCategory.marketing,
      body: 'New arrivals at {{1}}! Visit us for {{2}} off this festival season.',
      status: MetaApprovalStatus.approved,
      isActive: true,
      footer: 'Reply STOP to opt out',
      variables: const [TemplateVariable(index: 1, description: 'Shop name'), TemplateVariable(index: 2, description: 'Offer %')],
      lastUpdated: now.subtract(const Duration(days: 40)),
      aisensyTemplateId: 'aisensy_tmpl_001',
    ),
    TemplateModel(
      id: 't_steel',
      businessType: 'Steel',
      templateName: 'steel_payment_reminder',
      category: TemplateCategory.utility,
      body: 'Dear {{1}}, your payment of ₹{{2}} is due at {{3}}.',
      status: MetaApprovalStatus.approved,
      isActive: true,
      variables: const [TemplateVariable(index: 1, description: 'Customer name'), TemplateVariable(index: 2, description: 'Amount'), TemplateVariable(index: 3, description: 'Shop name')],
      lastUpdated: now.subtract(const Duration(days: 90)),
      aisensyTemplateId: 'aisensy_tmpl_002',
    ),
    TemplateModel(
      id: 't_electronics',
      businessType: 'Electronics',
      templateName: 'electronics_new_stock',
      category: TemplateCategory.marketing,
      body: 'Fresh stock arrived at {{1}}! {{2}} now available.',
      status: MetaApprovalStatus.pending,
      isActive: false,
      variables: const [TemplateVariable(index: 1, description: 'Shop name'), TemplateVariable(index: 2, description: 'Item name')],
      lastUpdated: now.subtract(const Duration(days: 2)),
      aisensyTemplateId: 'aisensy_tmpl_003',
    ),
    TemplateModel(
      id: 't_grocery',
      businessType: 'Grocery',
      templateName: 'grocery_daily_offer',
      category: TemplateCategory.marketing,
      body: 'Fresh deals today at {{1}}! Get {{2}} on essentials.',
      status: MetaApprovalStatus.approved,
      isActive: true,
      variables: const [TemplateVariable(index: 1, description: 'Shop name'), TemplateVariable(index: 2, description: 'Discount')],
      lastUpdated: now.subtract(const Duration(days: 55)),
      aisensyTemplateId: 'aisensy_tmpl_004',
    ),
    TemplateModel(
      id: 't_pharmacy',
      businessType: 'Pharmacy',
      templateName: 'pharmacy_refill_reminder',
      category: TemplateCategory.utility,
      body: 'Hi {{1}}, time to refill your medicines at {{2}}. Visit us anytime.',
      status: MetaApprovalStatus.rejected,
      isActive: false,
      variables: const [TemplateVariable(index: 1, description: 'Customer name'), TemplateVariable(index: 2, description: 'Shop name')],
      lastUpdated: now.subtract(const Duration(days: 5)),
      rejectionReason: 'Template body implies medical advice, which violates WhatsApp Business Policy on healthcare messaging.',
      aisensyTemplateId: 'aisensy_tmpl_005',
    ),
    TemplateModel(
      id: 't_jewellery',
      businessType: 'Jewellery',
      templateName: 'jewellery_festival_offer',
      category: TemplateCategory.marketing,
      body: 'Exclusive festival collection at {{1}}! Flat {{2}} off on making charges.',
      status: MetaApprovalStatus.approved,
      isActive: true,
      variables: const [TemplateVariable(index: 1, description: 'Shop name'), TemplateVariable(index: 2, description: 'Discount')],
      lastUpdated: now.subtract(const Duration(days: 130)),
      aisensyTemplateId: 'aisensy_tmpl_006',
    ),
    TemplateModel(
      id: 't_furniture',
      businessType: 'Furniture',
      templateName: 'furniture_new_collection',
      category: TemplateCategory.marketing,
      body: 'New furniture collection now at {{1}}! Visit for {{2}}.',
      status: MetaApprovalStatus.approved,
      isActive: true,
      variables: const [TemplateVariable(index: 1, description: 'Shop name'), TemplateVariable(index: 2, description: 'Offer')],
      lastUpdated: now.subtract(const Duration(days: 70)),
      aisensyTemplateId: 'aisensy_tmpl_007',
    ),
  ];
}
