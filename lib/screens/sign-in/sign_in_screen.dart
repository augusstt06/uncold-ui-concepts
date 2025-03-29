import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uncold_ai/screens/sign-in/steps/verify_information.dart';
import 'package:uncold_ai/screens/sign-in/steps/capture_business_card.dart';
import 'package:uncold_ai/screens/sign-in/steps/additional_setting.dart';

final signInStepProvider = StateProvider<int>((ref) => 0);

final isProcessingProvider = StateProvider<bool>((ref) => false);

@RoutePage()
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(signInStepProvider);
    // final isProcessing = ref.watch(isProcessingProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildStepContent(context, currentStep, ref)),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, int step, WidgetRef ref) {
    switch (step) {
      case 0:
        return CaptureBusinessCardStep(
          onNext: () => ref.read(signInStepProvider.notifier).state++,
          onBack: () => AutoRouter.of(context).pop(),
          onProcessingChange: (isProcessing) {
            ref.read(isProcessingProvider.notifier).state = isProcessing;
          },
        );
      case 1:
        return VerifyInformationStep(
          onNext: () => ref.read(signInStepProvider.notifier).state++,
          onBack: () => ref.read(signInStepProvider.notifier).state--,
        );
      case 2:
        return AdditionalSettingStep(
          onNext: () => ref.read(signInStepProvider.notifier).state++,
          onBack: () => ref.read(signInStepProvider.notifier).state--,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
