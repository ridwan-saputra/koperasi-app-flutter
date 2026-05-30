class SupportedBank {
  const SupportedBank({required this.code, required this.name});

  final String code;
  final String name;
}

/// Bank yang didukung untuk penarikan dana.
const List<SupportedBank> kSupportedBanks = [
  SupportedBank(code: 'BCA', name: 'BCA'),
  SupportedBank(code: 'BRI', name: 'BRI'),
  SupportedBank(code: 'BNI', name: 'BNI'),
  SupportedBank(code: 'MANDIRI', name: 'Bank Mandiri'),
  SupportedBank(code: 'BTN', name: 'BTN'),
  SupportedBank(code: 'CIMB', name: 'CIMB Niaga'),
  SupportedBank(code: 'PERMATA', name: 'Bank Permata'),
  SupportedBank(code: 'DANAMON', name: 'Bank Danamon'),
];

const double kMinWithdrawAmount = 50000;
