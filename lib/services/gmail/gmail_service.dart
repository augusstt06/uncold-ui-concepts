import 'package:google_sign_in/google_sign_in.dart';
import 'package:uncold_ai_moc/interfaces/gmail_service_interface.dart';
import 'package:uncold_ai_moc/models/user_info.dart';

class GmailService implements GmailServiceInterface {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/gmail.send',
      'https://www.googleapis.com/auth/gmail.readonly',
    ],
    signInOption: SignInOption.standard,
  );

  GoogleSignInAccount? _currentUser;

  @override
  Future<GmailConnectionResult> connectGmail({
    required String email,
    required String name,
  }) async {
    try {
      print('Gmail 연동 시작: $email');

      // 현재 로그인된 계정이 있다면 로그아웃
      await _googleSignIn.signOut();

      // Google 로그인 시도
      final account = await _googleSignIn.signIn();

      if (account == null) {
        print('로그인 취소됨');
        return const GmailConnectionResult(
          isSuccess: false,
          errorMessage: '로그인이 취소되었습니다.',
        );
      }

      print('로그인된 계정: ${account.email}');

      // 입력된 이메일과 실제 로그인된 계정이 일치하는지 확인
      if (account.email != email) {
        await _googleSignIn.signOut();
        return const GmailConnectionResult(
          isSuccess: false,
          errorMessage: '입력하신 이메일과 다른 계정으로 로그인하셨습니다.',
        );
      }

      // 인증 토큰 획득
      final auth = await account.authentication;
      _currentUser = account;

      print('Gmail 연동 성공');
      return GmailConnectionResult(
        isSuccess: true,
        accessToken: auth.accessToken,
      );
    } catch (e) {
      print('Gmail 연동 에러: $e');
      return GmailConnectionResult(
        isSuccess: false,
        errorMessage: 'Gmail 연동 중 오류가 발생했습니다: $e',
      );
    }
  }

  @override
  Future<bool> disconnectGmail() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
      return true;
    } catch (e) {
      print('Gmail 연동 해제 중 오류: $e');
      return false;
    }
  }

  @override
  Future<GmailConnectionStatus> checkConnectionStatus() async {
    try {
      final isSignedIn = await _googleSignIn.isSignedIn();
      if (!isSignedIn) {
        return GmailConnectionStatus.notConnected;
      }

      final currentUser = await _googleSignIn.signInSilently();
      if (currentUser == null) {
        return GmailConnectionStatus.notConnected;
      }

      return GmailConnectionStatus.connected;
    } catch (e) {
      print('상태 확인 중 에러: $e');
      return GmailConnectionStatus.error;
    }
  }

  @override
  Future<UserInfo?> getGmailProfile() async {
    try {
      if (_currentUser == null) {
        return null;
      }

      return UserInfo(
        fullName: _currentUser!.displayName ?? '',
        email: _currentUser!.email,
        jobTitle: 'Senior Developer', // mock data
        phoneNumber: '+1 (555) 123-4567', // mock data
        companyInfo: 'Acme Corporation\n123 Business Street', // mock data
      );
    } catch (e) {
      print('프로필 정보 가져오기 실패: $e');
      return null;
    }
  }
}
