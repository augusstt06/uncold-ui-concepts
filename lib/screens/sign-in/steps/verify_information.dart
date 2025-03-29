import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uncold_ai/widgets/sign-in/bottom_button.dart';
import 'package:uncold_ai/widgets/sign-in/step_header.dart';

class VerifyInformationStep extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const VerifyInformationStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const Gap(8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () {},
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StepHeader(
          title: 'Verify Information',
          onBack: onBack,
          currentStep: 1,
          totalSteps: 3,
        ),
        const Gap(24),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        // Icon(
                        //   Icons.info_outline,
                        //   color: Color(0xFF2563EB),
                        //   size: 20,
                        // ),
                        // Gap(12),
                        Expanded(
                          child: Text(
                            "We've extracted the following information from your business card. Please verify and edit if needed.",
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),
                  _buildInfoField('Full Name', '김충연'),
                  const Gap(16),
                  _buildInfoField('Job Title', 'Senior Developer'),
                  const Gap(16),
                  _buildInfoField('Email', 'augusstt06@gmail.com'),
                  const Gap(16),
                  _buildInfoField('Phone Number', '+1 (555) 123-4567'),
                  const Gap(16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Company Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const Gap(8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Text(
                                  'Acme Corporation\n123 Business Street\nSuite 456\nNew York, NY 10001',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () {},
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        BottomActionButton(
          text: 'Continue',
          onPressed: onNext,
          showArrow: true,
        ),
      ],
    );
  }
}
