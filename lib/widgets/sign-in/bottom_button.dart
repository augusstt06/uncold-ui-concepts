import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BottomActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final IconData? icon;
  final bool showArrow;
  final double? iconSize;
  final EdgeInsets? padding;

  const BottomActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.icon,
    this.showArrow = false,
    this.iconSize = 20,
    this.padding = const EdgeInsets.only(
      left: 16,
      right: 16,
      bottom: 45,
      top: 20,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: SizedBox(
        width: double.infinity,

        height: 56,
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.disabled)) {
                return Colors.grey;
              }
              return const Color(0xFF3B82F6);
            }),
            overlayColor: WidgetStateProperty.resolveWith<Color>(
              (states) => const Color(0xFF1D4ED8),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (icon != null || showArrow) ...[
                const Gap(8),
                if (icon != null)
                  Icon(icon, color: Colors.white, size: iconSize),
                if (showArrow)
                  const Text(
                    ' →',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
