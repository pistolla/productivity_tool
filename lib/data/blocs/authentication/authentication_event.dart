
abstract class AuthenticationEvent {
  late String accessToken;
  AuthenticationEvent(this.accessToken);
}

class UserAuthenticated extends AuthenticationEvent {
  final bool isAuthetic;
  UserAuthenticated(this.isAuthetic, token): super(token);
}

