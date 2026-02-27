import 'package:flutter/material.dart';
import 'package:moto_slot/core/design_system/app_colors.dart';
import 'package:moto_slot/core/design_system/app_radius.dart';
import 'package:moto_slot/core/design_system/app_typography.dart';
import 'package:moto_slot/core/design_system/app_shadows.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.isLoading;
    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: enabled ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 150),
          child: Container(
            width: widget.width ?? double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppRadius.borderRadiusMd,
              boxShadow: enabled ? AppShadows.primary : null,
            ),
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: 20, color: AppColors.textOnPrimary),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.text,
                          style: AppTypography.button.copyWith(color: AppColors.textOnPrimary),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.isLoading;
    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: enabled ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 150),
          child: Container(
            width: widget.width ?? double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: 20, color: AppColors.primary),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.text,
                          style: AppTypography.button.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavyButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const NavyButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  State<NavyButton> createState() => _NavyButtonState();
}

class _NavyButtonState extends State<NavyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.isLoading;
    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: enabled ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 150),
          child: Container(
            width: widget.width ?? double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: AppRadius.borderRadiusMd,
              boxShadow: enabled ? AppShadows.md : null,
            ),
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: 20, color: AppColors.textOnPrimary),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.text,
                          style: AppTypography.button.copyWith(color: AppColors.textOnPrimary),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class OutlinedAppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final Color? color;

  const OutlinedAppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.color,
  });

  @override
  State<OutlinedAppButton> createState() => _OutlinedAppButtonState();
}

class _OutlinedAppButtonState extends State<OutlinedAppButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.primary;
    final enabled = widget.onPressed != null && !widget.isLoading;
    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: enabled ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 150),
          child: Container(
            width: widget.width ?? double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: AppRadius.borderRadiusMd,
              border: Border.all(color: color, width: 1.5),
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: 20, color: color),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.text,
                          style: AppTypography.button.copyWith(color: color),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class GhostButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  const GhostButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.color,
  });

  @override
  State<GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<GhostButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.primary;
    final enabled = widget.onPressed != null;
    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: enabled ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 150),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 18, color: color),
                  const SizedBox(width: 6),
                ],
                Text(
                  widget.text,
                  style: AppTypography.button.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
