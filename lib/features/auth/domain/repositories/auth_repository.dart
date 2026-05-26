import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  // Either<Kiri, Kanan>: Kiri untuk Error (Failure), Kanan untuk Sukses (UserEntity)
  Future<Either<Failure, UserEntity>> login(String email, String password);
}
