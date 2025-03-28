import 'package:uncold_ai_moc/interfaces/gmail_service_interface.dart';
import 'package:uncold_ai_moc/models/user_info.dart';

class MockGmailService implements GmailServiceInterface {
  GmailConnectionStatus _status = GmailConnectionStatus.notConnected;
  UserInfo? _connectedProfile;

  @override
  Future<GmailConnectionResult> connectGmail({
    required String email,
    required String name,
  }) async {
    // 연동 과정 시뮬레이션
    await Future.delayed(const Duration(seconds: 2));

    // 이메일 형식 검증
    if (!email.contains('@gmail.com')) {
      return const GmailConnectionResult(
        isSuccess: false,
        errorMessage: '올바른 Gmail 주소를 입력해주세요.',
      );
    }

    // 연동 성공 시뮬레이션
    _status = GmailConnectionStatus.connected;
    _connectedProfile = UserInfo(
      fullName: name,
      email: email,
      jobTitle: 'Senior Developer', // mock data
      phoneNumber: '+1 (555) 123-4567', // mock data
      companyInfo: 'Acme Corporation\n123 Business Street', // mock data
    );

    return GmailConnectionResult(
      isSuccess: true,
      accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<bool> disconnectGmail() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _status = GmailConnectionStatus.notConnected;
    _connectedProfile = null;
    return true;
  }

  @override
  Future<GmailConnectionStatus> checkConnectionStatus() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _status;
  }

  @override
  Future<UserInfo?> getGmailProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _connectedProfile;
  }
}
