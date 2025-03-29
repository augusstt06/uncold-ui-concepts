import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uncold_ai_moc/interfaces/gmail_service_interface.dart';
// import 'package:uncold_ai_moc/services/gmail/moc_service.dart';
import 'package:uncold_ai_moc/services/gmail/gmail_service.dart';

final gmailServiceProvider = Provider<GmailServiceInterface>((ref) {
  return GmailService();
});

final gmailConnectionStatusProvider = StreamProvider<GmailConnectionStatus>((
  ref,
) async* {
  final service = ref.watch(gmailServiceProvider);

  while (true) {
    final status = await service.checkConnectionStatus();
    yield status;
    await Future.delayed(const Duration(seconds: 1));
  }
});
