import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uncold_ai_moc/screens/sign-in/steps/scan_processing.dart';
import 'package:uncold_ai_moc/widgets/sign-in/bottom_button.dart';
import 'package:uncold_ai_moc/widgets/sign-in/step_header.dart';

class CaptureBusinessCardStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final ValueChanged<bool> onProcessingChange;

  const CaptureBusinessCardStep({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.onProcessingChange,
  });

  @override
  State<CaptureBusinessCardStep> createState() =>
      _CaptureBusinessCardStepState();
}

class _CaptureBusinessCardStepState extends State<CaptureBusinessCardStep>
    with SingleTickerProviderStateMixin {
  bool isPreviewSelected = true;
  bool isCapturing = false;
  bool isExtracting = false;
  bool showProcessing = false;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isExtracting = true;
        });
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            showProcessing = true;
            widget.onProcessingChange(true);
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _startCapturing() {
    setState(() {
      isCapturing = true;
    });
    _progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (showProcessing) {
      return ScanProcessingStep(
        onNext: () {
          widget.onProcessingChange(false);
          widget.onNext();
        },
      );
    }

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StepHeader(
              title: 'Capture Business Card',
              onBack: widget.onBack,
              currentStep: 0,
              totalSteps: 3,
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isCapturing
                                      ? (isExtracting
                                          ? 'Extracting information...'
                                          : 'Hold steady capturing...')
                                      : 'Position your business card within the frame',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        isCapturing
                                            ? const Color(0xFF4ADE80)
                                            : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (isCapturing && !isExtracting) ...[
                                  const Gap(8),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 4,
                                    child: AnimatedBuilder(
                                      animation: _progressController,
                                      builder: (context, child) {
                                        return LinearProgressIndicator(
                                          value: _progressController.value,
                                          backgroundColor: Colors.white,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                Color
                                              >(Color(0xFF4ADE80)),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(30),
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
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFF2563EB),
                          size: 20,
                        ),
                        Gap(12),
                        Expanded(
                          child: Text(
                            'Capture the business card clearly for better information extraction.',
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
                ],
              ),
            ),

            const Spacer(),

            BottomActionButton(
              text: 'Capture Card',
              onPressed: isCapturing ? null : _startCapturing,
              isEnabled: !isCapturing,
              icon: Icons.camera_alt_rounded,
            ),
          ],
        ),
      ],
    );
  }
}
