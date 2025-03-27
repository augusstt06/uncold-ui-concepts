import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ScanProcessingStep extends StatefulWidget {
  final VoidCallback onNext;

  const ScanProcessingStep({super.key, required this.onNext});

  @override
  State<ScanProcessingStep> createState() => _ScanProcessingStepState();
}

class _ScanProcessingStepState extends State<ScanProcessingStep>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _bounceController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _bounceAnimation;
  String _previousStage = 'research';
  bool _isRotating = false;

  final List<String> stages = ['research', 'generation', 'complete'];
  String currentStage = 'research';
  bool showCompletionIcon = false;

  // 각 단계별 상태 관리
  final Map<String, String> stageLabels = {
    'research': 'uncold.ai is looking at the business card',
    'generation': 'Content organized by uncold.ai',
    'complete': 'Check out what uncold.ai did!',
  };

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // 상수 정의
  static const double kIconContainerSize = 64.0;
  static const double kIconSize = 28.0;
  static const double kStageIndicatorSize = 32.0;
  static const double kInnerCircleSize = 16.0;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 90).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.05,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.05,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_bounceController);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 0.6,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.6,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
    ]).animate(_pulseController);

    _bounceController.repeat();
    _pulseController.repeat();
    _scheduleNextStage();
  }

  void _scheduleNextStage() {
    if (currentStage != 'complete') {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _rotateToNextStage();
        }
      });
    }
  }

  void _rotateToNextStage() {
    setState(() {
      _isRotating = true;
      _previousStage = currentStage;
      int currentIndex = stages.indexOf(currentStage);
      currentStage = stages[currentIndex + 1];
    });

    _progressController.forward().then((_) {
      setState(() {
        _isRotating = false;
      });
      _progressController.reset();

      if (currentStage == 'complete') {
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() => showCompletionIcon = true);
          Future.delayed(const Duration(seconds: 2), widget.onNext);
        });
      } else {
        _scheduleNextStage();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _bounceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 제목
            const Text(
              'Processing Your Business Card',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
            ),
            const Gap(60),

            // 메인 컨텐츠 블록
            Container(
              constraints: const BoxConstraints(minHeight: 320, maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // 상단 아이콘
                  Container(
                    width: kIconContainerSize,
                    height: kIconContainerSize,
                    decoration: BoxDecoration(
                      color:
                          showCompletionIcon
                              ? Colors.green.shade50
                              : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(
                        kIconContainerSize / 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        showCompletionIcon
                            ? Icons.check_circle_outline
                            : Icons.credit_card,
                        size: kIconSize,
                        color:
                            showCompletionIcon
                                ? Colors.green.shade600
                                : Colors.blue.shade600,
                      ),
                    ),
                  ),
                  const Gap(32),

                  // 진행 상태 인디케이터
                  SizedBox(
                    height: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          stages.asMap().entries.map((entry) {
                            return _buildDot(
                              entry.key,
                              stages.indexOf(currentStage),
                            );
                          }).toList(),
                    ),
                  ),
                  const Gap(24),

                  // 현재 단계 표시
                  SizedBox(
                    height: 80,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: _buildStageIndicator(),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(40),

            // 하단 설명 텍스트
            Text(
              'uncold.ai is analyzing your business card and preparing personalized follow-up suggestions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageIndicator() {
    return Container(
      height: 80,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_isRotating)
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform(
                  transform:
                      Matrix4.identity()
                        ..setEntry(3, 2, 0.002)
                        ..rotateX(_rotationAnimation.value * 3.14159 / 180),
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: 1 - (_rotationAnimation.value / 90),
                    child: _buildStageBlock(_previousStage),
                  ),
                );
              },
            ),

          if (_isRotating)
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform(
                  transform:
                      Matrix4.identity()
                        ..setEntry(3, 2, 0.002)
                        ..rotateX(
                          (_rotationAnimation.value - 90) * 3.14159 / 180,
                        ),
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: _rotationAnimation.value / 90,
                    child: _buildStageBlock(currentStage),
                  ),
                );
              },
            )
          else
            _buildStageBlock(currentStage),
        ],
      ),
    );
  }

  Widget _buildStageBlock(String stage) {
    bool isComplete = stage == 'complete' && showCompletionIcon;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: isComplete ? Colors.green.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 원 아이콘 부분 (펄스 효과)
          SizedBox(
            width: kStageIndicatorSize,
            height: kStageIndicatorSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!isComplete) ...[
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Container(
                        width: kStageIndicatorSize,
                        height: kStageIndicatorSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.blue.shade600.withOpacity(
                              _pulseAnimation.value,
                            ),
                            width: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    width: kInnerCircleSize,
                    height: kInnerCircleSize,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      shape: BoxShape.circle,
                    ),
                  ),
                ] else
                  Container(
                    width: kStageIndicatorSize,
                    height: kStageIndicatorSize,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: kInnerCircleSize,
                      height: kInnerCircleSize,
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: kInnerCircleSize * 0.8,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // 텍스트 부분 (바운싱 제거)
          Flexible(
            child: Text(
              stageLabels[stage] ?? 'Unknown stage',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color:
                    isComplete ? Colors.green.shade700 : Colors.blue.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int stageIndex, int currentIndex) {
    final bool isCurrentStage = stageIndex == currentIndex;
    final bool isCompletedStage =
        stageIndex < currentIndex ||
        (stageIndex == currentIndex && showCompletionIcon);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              isCurrentStage && !showCompletionIcon
                  ? Colors.blue.shade500
                  : isCompletedStage
                  ? Colors.green.shade500
                  : Colors.grey.shade300,
        ),
      ),
    );
  }
}
