import 'dart:async';

class ParentSession {
  final String sessionId;
  final DateTime authenticatedAt;
  final DateTime expiresAt;
  final bool isRevoked;

  const ParentSession({
    required this.sessionId,
    required this.authenticatedAt,
    required this.expiresAt,
    this.isRevoked = false,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt) || isRevoked;
  bool get isValid => !isExpired;

  Duration get remainingDuration {
    if (isExpired) return Duration.zero;
    return expiresAt.difference(DateTime.now());
  }

  ParentSession copyWith({
    String? sessionId,
    DateTime? authenticatedAt,
    DateTime? expiresAt,
    bool? isRevoked,
  }) {
    return ParentSession(
      sessionId: sessionId ?? this.sessionId,
      authenticatedAt: authenticatedAt ?? this.authenticatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isRevoked: isRevoked ?? this.isRevoked,
    );
  }
}

class ParentUnauthorizedException implements Exception {
  final String message;
  const ParentUnauthorizedException([
    this.message = 'Parent authorization required for this action or route.',
  ]);

  @override
  String toString() => 'ParentUnauthorizedException: $message';
}

class ParentSessionExpiredException extends ParentUnauthorizedException {
  final DateTime expiredAt;
  ParentSessionExpiredException(this.expiredAt)
      : super(
            'Parent authorization session expired at ${expiredAt.toIso8601String()}. Please re-authenticate.');
}

class ParentSessionService {
  static const Duration defaultSessionDuration = Duration(minutes: 15);

  final Duration defaultDuration;
  final bool enableExpiryTimer;
  ParentSession? _currentSession;
  Timer? _expiryTimer;

  final StreamController<bool> _authChangeController =
      StreamController<bool>.broadcast(sync: true);

  ParentSessionService({
    this.defaultDuration = defaultSessionDuration,
    this.enableExpiryTimer = false,
  });

  ParentSession? get currentSession => _currentSession;

  bool get isAuthorized => _currentSession?.isValid ?? false;

  Stream<bool> get authStateStream => _authChangeController.stream;

  ParentSession authenticate({Duration? duration}) {
    _expiryTimer?.cancel();

    final now = DateTime.now();
    final sessionDuration = duration ?? defaultDuration;
    final expires = now.add(sessionDuration);

    final session = ParentSession(
      sessionId: 'ps_${now.millisecondsSinceEpoch}',
      authenticatedAt: now,
      expiresAt: expires,
      isRevoked: false,
    );

    _currentSession = session;
    if (enableExpiryTimer) {
      _expiryTimer = Timer(sessionDuration, _onSessionExpired);
    }
    _authChangeController.add(true);
    return session;
  }

  bool renewSession({Duration? extension}) {
    if (!isAuthorized || _currentSession == null) return false;

    final sessionDuration = extension ?? defaultDuration;
    final expires = DateTime.now().add(sessionDuration);

    _currentSession = _currentSession!.copyWith(expiresAt: expires);
    _expiryTimer?.cancel();
    if (enableExpiryTimer) {
      _expiryTimer = Timer(sessionDuration, _onSessionExpired);
    }
    return true;
  }

  void revokeSession() {
    _expiryTimer?.cancel();
    _expiryTimer = null;
    if (_currentSession != null) {
      _currentSession = _currentSession!.copyWith(isRevoked: true);
      _authChangeController.add(false);
    }
  }

  T executeWithAuthorization<T>(T Function() action) {
    final session = _currentSession;
    if (session == null || session.isRevoked) {
      throw const ParentUnauthorizedException();
    }
    if (session.isExpired) {
      throw ParentSessionExpiredException(session.expiresAt);
    }
    return action();
  }

  Future<T> executeWithAuthorizationAsync<T>(
      Future<T> Function() action) async {
    final session = _currentSession;
    if (session == null || session.isRevoked) {
      throw const ParentUnauthorizedException();
    }
    if (session.isExpired) {
      throw ParentSessionExpiredException(session.expiresAt);
    }
    return await action();
  }

  void _onSessionExpired() {
    _authChangeController.add(false);
  }

  void dispose() {
    _expiryTimer?.cancel();
    _authChangeController.close();
  }
}

/// Single production session shared by the router, gate, and providers.
final ParentSessionService appParentSessionService =
    ParentSessionService(enableExpiryTimer: true);
