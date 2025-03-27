import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uncold_ai_moc/widgets/sign-in/bottom_button.dart';
import 'package:uncold_ai_moc/widgets/sign-in/step_header.dart';

class AdditionalSettingStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AdditionalSettingStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<AdditionalSettingStep> createState() =>
      _AdditionalSettingStepState();
}

class _AdditionalSettingStepState extends ConsumerState<AdditionalSettingStep>
    with SingleTickerProviderStateMixin {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _hasUpperCase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _hasMinLength = false;
  bool _isGmailConnected = false;

  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  bool _isGmailLoading = false;
  bool _isGmailComplete = false;

  bool _isPasswordMatch = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword(String password) {
    setState(() {
      _hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      _hasMinLength = password.length >= 8;
      _isPasswordMatch = password == _confirmPasswordController.text;

      final int metConditions =
          [
            _hasUpperCase,
            _hasNumber,
            _hasMinLength,
            _hasSpecialChar,
          ].where((condition) => condition).length;
      final double progress = metConditions / 4;

      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: progress,
      ).animate(
        CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
      );

      _progressController
        ..reset()
        ..forward();
    });
  }

  void _validateConfirmPassword(String confirmPassword) {
    setState(() {
      _isPasswordMatch = confirmPassword == _passwordController.text;
    });
  }

  Future<void> _handleGmailConnection() async {
    setState(() {
      _isGmailLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isGmailLoading = false;
      _isGmailComplete = true;
      _isGmailConnected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StepHeader(
          title: 'Additional Setting',
          onBack: widget.onBack,
          currentStep: 2,
          totalSteps: 3,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Create Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const Gap(8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            _hasUpperCase &&
                                    _hasNumber &&
                                    _hasMinLength &&
                                    _hasSpecialChar &&
                                    _isPasswordMatch
                                ? const Color(0xFFF0FDF4) // 연한 초록색
                                : const Color(0xFFFFEBEB), // 연한 빨간색
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _hasUpperCase &&
                                _hasNumber &&
                                _hasMinLength &&
                                _hasSpecialChar &&
                                _isPasswordMatch
                            ? 'Complete'
                            : 'Required',
                        style: TextStyle(
                          color:
                              _hasUpperCase &&
                                      _hasNumber &&
                                      _hasMinLength &&
                                      _hasSpecialChar &&
                                      _isPasswordMatch
                                  ? const Color(0xFF22C55E) // 초록색
                                  : const Color(0xFFDC2626), // 빨간색
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(24),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  onChanged: _validatePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Color(0xFF3B82F6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed:
                          () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                          ),
                    ),
                  ),
                ),
                const Gap(16),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  onChanged: _validateConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Color(0xFF3B82F6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_confirmPasswordController.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              _isPasswordMatch
                                  ? Icons.check_circle
                                  : Icons.error,
                              color:
                                  _isPasswordMatch ? Colors.green : Colors.red,
                              size: 20,
                            ),
                          ),
                        IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed:
                              () => setState(
                                () =>
                                    _isConfirmPasswordVisible =
                                        !_isConfirmPasswordVisible,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        _hasUpperCase &&
                                _hasNumber &&
                                _hasMinLength &&
                                _hasSpecialChar &&
                                _isPasswordMatch
                            ? const Color(0xFFF0FDF4)
                            : const Color(0xFFFFEBEB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          _hasUpperCase &&
                                  _hasNumber &&
                                  _hasMinLength &&
                                  _hasSpecialChar &&
                                  _isPasswordMatch
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFDC2626),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _hasUpperCase &&
                                    _hasNumber &&
                                    _hasMinLength &&
                                    _hasSpecialChar &&
                                    _isPasswordMatch
                                ? Icons.check_circle
                                : Icons.error,
                            size: 16,
                            color:
                                _hasUpperCase &&
                                        _hasNumber &&
                                        _hasMinLength &&
                                        _hasSpecialChar &&
                                        _isPasswordMatch
                                    ? const Color(0xFF22C55E)
                                    : const Color(0xFFDC2626),
                          ),
                          const Gap(8),
                          Text(
                            'Password Requirements',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  _hasUpperCase &&
                                          _hasNumber &&
                                          _hasMinLength &&
                                          _hasSpecialChar &&
                                          _isPasswordMatch
                                      ? const Color(0xFF22C55E)
                                      : const Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                      const Gap(12),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildPasswordRequirement(
                                  '8+ Characters',
                                  _hasMinLength,
                                ),
                              ),
                              Expanded(
                                child: _buildPasswordRequirement(
                                  'Uppercase Letter',
                                  _hasUpperCase,
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildPasswordRequirement(
                                  'Number',
                                  _hasNumber,
                                ),
                              ),
                              Expanded(
                                child: _buildPasswordRequirement(
                                  'Special Characters',
                                  _hasSpecialChar,
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildPasswordRequirement(
                                  'Password Match',
                                  _isPasswordMatch,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Gap(25),
                const Divider(height: 2),
                const Gap(25),

                Row(
                  children: [
                    const Text(
                      'Connect Mail',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const Gap(8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            _isGmailConnected
                                ? const Color(0xFFF0FDF4) // 연한 초록색
                                : const Color(0xFFFFEBEB), // 연한 빨간색
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _isGmailConnected ? 'Complete' : 'Required',
                        style: TextStyle(
                          color:
                              _isGmailConnected
                                  ? const Color(0xFF22C55E) // 초록색
                                  : const Color(0xFFDC2626), // 빨간색
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                // Container(
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     color:
                //         _isGmailConnected
                //             ? const Color(0xFFF0FDF4)
                //             : const Color(0xFFFFEBEB),
                //     borderRadius: BorderRadius.circular(8),
                //     border: Border.all(
                //       color:
                //           _isGmailConnected
                //               ? const Color(0xFF22C55E)
                //               : const Color(0xFFDC2626),
                //       width: 1,
                //     ),
                //   ),
                //   child: Row(
                //     children: [
                //       Icon(
                //         _isGmailConnected
                //             ? Icons.check_circle
                //             : Icons.warning_rounded,
                //         color:
                //             _isGmailConnected
                //                 ? const Color(0xFF22C55E)
                //                 : const Color(0xFFDC2626),
                //         size: 20,
                //       ),
                //       const Gap(12),
                //       Expanded(
                //         child: Text(
                //           _isGmailConnected
                //               ? 'Gmail account successfully connected!'
                //               : 'Gmail connection is required',
                //           style: TextStyle(
                //             color:
                //                 _isGmailConnected
                //                     ? const Color(0xFF22C55E)
                //                     : const Color(0xFFDC2626),
                //             fontSize: 14,
                //             fontWeight: FontWeight.w500,
                //             height: 1.5,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const Gap(16),
                _buildGmailButton(),
              ],
            ),
          ),
        ),

        BottomActionButton(
          text: 'Create Account',
          onPressed:
              _isGmailConnected &&
                      _hasUpperCase &&
                      _hasNumber &&
                      _hasMinLength &&
                      _hasSpecialChar &&
                      _isPasswordMatch
                  ? widget.onNext
                  : null,
          isEnabled:
              _isGmailConnected &&
              _hasUpperCase &&
              _hasNumber &&
              _hasMinLength &&
              _hasSpecialChar &&
              _isPasswordMatch,
        ),
      ],
    );
  }

  Widget _buildPasswordRequirement(String requirement, bool isMet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.error,
          color: isMet ? const Color(0xFF22C55E) : const Color(0xFFDC2626),
          size: 16,
        ),
        const Gap(8),
        Flexible(
          child: Text(
            requirement,
            style: TextStyle(
              color: isMet ? const Color(0xFF22C55E) : const Color(0xFFDC2626),
              fontSize: 13,
              fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGmailButton() {
    if (_isGmailComplete) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4ADE80),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBackgroundColor: const Color(0xFF4ADE80),
            disabledForegroundColor: Colors.white,
          ),
          icon: const Icon(Icons.check_circle),
          label: const Text(
            'Connect Complete',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isGmailLoading ? null : _handleGmailConnection,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDB4437),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon:
            _isGmailLoading
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : const Icon(Icons.mail),
        label: Text(
          _isGmailLoading ? 'Connecting...' : 'Connect Gmail',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
