import 'package:uncold_ai_moc/models/user_info.dart';

enum GmailConnectionStatus { notConnected, connecting, connected, error }

class GmailConnectionResult {
  final bool isSuccess;
  final String? errorMessage;
  final String? accessToken;

  const GmailConnectionResult({
    required this.isSuccess,
    this.errorMessage,
    this.accessToken,
  });
}

abstract class GmailServiceInterface {
  /// Gmail 계정 연동
  Future<GmailConnectionResult> connectGmail({
    required String email,
    required String name,
  });

  /// Gmail 계정 연동 해제
  Future<bool> disconnectGmail();

  /// Gmail 연동 상태 확인
  Future<GmailConnectionStatus> checkConnectionStatus();

  /// Gmail 프로필 정보 가져오기
  Future<UserInfo?> getGmailProfile();
}
