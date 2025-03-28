import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uncold_ai_moc/models/user_info.dart';

final userInfoProvider = StateProvider<UserInfo>((ref) {
  return const UserInfo(
    fullName: '김충연',
    email: 'augusstt06@gmail.com',
    jobTitle: 'Senior Developer',
    phoneNumber: '+1 (555) 123-4567',
    companyInfo:
        'Acme Corporation\n123 Business Street\nSuite 456\nNew York, NY 10001',
  );
});
