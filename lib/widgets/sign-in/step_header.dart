import 'package:flutter/material.dart';
import 'package:uncold_ai/widgets/sign-in/progress.dart';

class StepHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final int currentStep;
  final int totalSteps;

  const StepHeader({
    super.key,
    required this.title,
    required this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 25),
                onPressed: onBack,
              ),
              Expanded(
                child: SignInProgressbar(
                  currentStep: currentStep,
                  totalSteps: totalSteps,
                  width: double.infinity,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
