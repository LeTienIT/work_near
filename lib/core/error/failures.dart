abstract class Failure {
  final String message;
  const Failure(this.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class RegisterFailure extends Failure {
  const RegisterFailure(super.message);
}

class GetProfileFailure extends Failure{
  const GetProfileFailure(super.message);
}