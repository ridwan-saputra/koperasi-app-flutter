import '../domain/entities/transaction_entity.dart';

/// Map transaksi untuk SQLite (tanpa field join seperti nama_lengkap).
Map<String, dynamic> transactionToDbMap(TransactionEntity transaction) {
  final map = transaction.toJson();
  map.remove('nama_lengkap');
  return map;
}
