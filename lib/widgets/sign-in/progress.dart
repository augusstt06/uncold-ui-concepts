import 'package:flutter/material.dart';

class SignInProgressbar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double width;
  final double height;
  final Color activeColor;
  final Color inactiveColor;

  const SignInProgressbar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.width = 300,
    this.height = 7,
    this.activeColor = const Color(0xFF3B82F6),
    this.inactiveColor = const Color(0xFFE5E7EB),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        child: Row(
          children: List.generate(
            totalSteps,
            (index) => Expanded(
              child: Container(
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height / 2),
                  color: index <= currentStep ? activeColor : inactiveColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
