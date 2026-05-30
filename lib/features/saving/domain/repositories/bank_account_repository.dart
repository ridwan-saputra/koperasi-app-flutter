import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_bank_account_entity.dart';

abstract class BankAccountRepository {
  Future<Either<Failure, List<UserBankAccountEntity>>> getAccountsByUser(String userId);

  Future<Either<Failure, UserBankAccountEntity>> saveAccount(UserBankAccountEntity account);

  Future<Either<Failure, bool>> deleteAccount(String accountId, String userId);
}
