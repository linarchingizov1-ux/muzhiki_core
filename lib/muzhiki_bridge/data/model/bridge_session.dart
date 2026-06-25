class BridgeSession {
  final String accessToken;
  final int expiresAt;
  final Map<String, dynamic>? user;

  const BridgeSession({
    required this.accessToken,
    required this.expiresAt,
    required this.user,
  });

  BridgeSession copyWith({
    String? accessToken,
    int? expiresAt,
    Map<String, dynamic>? user,
  }) {
    return BridgeSession(
      accessToken: accessToken ?? this.accessToken,
      expiresAt: expiresAt ?? this.expiresAt,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toJson() {
    return {'accessToken': accessToken, 'expiresAt': expiresAt, 'user': user};
  }
}
