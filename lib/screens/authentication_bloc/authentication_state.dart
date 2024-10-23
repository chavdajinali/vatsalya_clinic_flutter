// authentication_state.dart
abstract class AuthenticationState {}

// Represents the authenticated state
class Authenticated extends AuthenticationState {}

// Represents the unauthenticated state
class UnAuthenticated extends AuthenticationState {}

// Represents the loading state (during sign out or authentication process)
class AuthenticationLoading extends AuthenticationState {}
