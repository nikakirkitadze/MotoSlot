import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/locale/cubit_l10n.dart';
import 'package:moto_slot/core/utils/date_utils.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';
import 'package:moto_slot/modules/payments/presentation/cubit/receipt_upload_cubit.dart';
import 'package:moto_slot/modules/payments/presentation/cubit/receipt_upload_state.dart';

class ReceiptUploadScreen extends StatelessWidget {
  final Booking booking;

  const ReceiptUploadScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReceiptUploadCubit, ReceiptUploadState>(
      listener: (context, state) {
        if (state.step == ReceiptStep.confirmed &&
            state.confirmedBooking != null) {
          context.go('/booking-confirmation', extra: state.confirmedBooking);
        }
        if (state.step == ReceiptStep.pendingReview &&
            state.pendingReviewBooking != null) {
          context.go('/receipt-pending-review',
              extra: state.pendingReviewBooking);
        }
        if (state.step == ReceiptStep.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizeMessage(context, state.errorMessage!)),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // Header
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: AppColors.textPrimary),
                      onPressed: () => _showCancelDialog(context),
                    ),
                    Expanded(
                      child: Text(
                        context.l10n.receiptUploadTitle,
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Blue gradient section with booking details
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: AppColors.blueGradient,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: AppRadius.borderRadiusLg,
                            border: Border.all(
                                color:
                                    AppColors.primary.withValues(alpha: 0.3)),
                            boxShadow: AppShadows.md,
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.bookingDetails,
                                style:
                                    AppTypography.headlineMedium.copyWith(
                                  color: AppColors.navy,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildIconDetailRow(
                                Icons.sports_motorsports_outlined,
                                context.l10n.lesson,
                                context.l10n
                                    .minLesson(booking.durationMinutes),
                              ),
                              const SizedBox(height: 12),
                              _buildIconDetailRow(
                                Icons.calendar_today_rounded,
                                context.l10n.date,
                                AppDateUtils.formatDate(booking.startTime),
                              ),
                              const SizedBox(height: 12),
                              _buildIconDetailRow(
                                Icons.access_time_rounded,
                                context.l10n.time,
                                AppDateUtils.formatTimeRange(
                                    booking.startTime, booking.endTime),
                              ),
                              if (booking.location != null) ...[
                                const SizedBox(height: 12),
                                _buildIconDetailRow(
                                  Icons.location_on_outlined,
                                  context.l10n.location,
                                  booking.location!,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Fee + instructions section
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildFeeRow(
                            context.l10n.lessonFee,
                            context.l10n.gelCurrency(
                                booking.amount?.toStringAsFixed(2) ??
                                    '0.00'),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(
                                height: 1, color: AppColors.divider),
                          ),
                          _buildFeeRow(
                            'Total',
                            context.l10n.gelCurrency(
                                booking.amount?.toStringAsFixed(2) ??
                                    '0.00'),
                            isBold: true,
                          ),
                          const SizedBox(height: 20),
                          // Instructions
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.info.withValues(alpha: 0.08),
                              borderRadius: AppRadius.borderRadiusMd,
                              border: Border.all(
                                  color:
                                      AppColors.info.withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.info_outline_rounded,
                                    color: AppColors.info, size: 24),
                                const SizedBox(height: 8),
                                Text(
                                  context.l10n.receiptUploadInstructions(
                                      booking.amount?.toStringAsFixed(2) ??
                                          '0.00'),
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.info,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  context.l10n
                                      .receiptUploadInstructionsSubtitle,
                                  style: AppTypography.bodySmall.copyWith(
                                    color:
                                        AppColors.info.withValues(alpha: 0.8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Image picker area
                          BlocBuilder<ReceiptUploadCubit,
                              ReceiptUploadState>(
                            builder: (context, state) {
                              return _buildImagePickerArea(context, state);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom CTA
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: BlocBuilder<ReceiptUploadCubit, ReceiptUploadState>(
                  builder: (context, state) {
                    if (state.step == ReceiptStep.analyzing) {
                      return _buildProgressIndicator(
                          context.l10n.analyzingReceipt);
                    }
                    if (state.step == ReceiptStep.uploading) {
                      return _buildProgressIndicator(
                          context.l10n.uploadingReceipt);
                    }
                    return Column(
                      children: [
                        Text(
                          context.l10n.slotHeldDuringUpload,
                          style: AppTypography.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        NavyButton(
                          text: context.l10n.submitReceipt,
                          onPressed: state.hasImage
                              ? () => context
                                  .read<ReceiptUploadCubit>()
                                  .validateAndUploadReceipt(
                                      booking: booking)
                              : null,
                          isLoading: state.isLoading,
                          icon: Icons.upload_file_rounded,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerArea(
      BuildContext context, ReceiptUploadState state) {
    if (state.hasImage) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: AppRadius.borderRadiusMd,
            child: Image.file(
              state.selectedImage!,
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedAppButton(
            text: context.l10n.changeImage,
            onPressed: () => _showImageSourceSheet(context),
            icon: Icons.swap_horiz_rounded,
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () => _showImageSourceSheet(context),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadius.borderRadiusMd,
          border: Border.all(
            color: AppColors.border,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 48,
              color: AppColors.textHint.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.receiptUpload,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.takePhotoOrChoose,
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(String message) {
    return Column(
      children: [
        const AppLoadingIndicator(),
        const SizedBox(height: 12),
        Text(
          message,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.receiptUpload,
              style: AppTypography.headlineMedium
                  .copyWith(color: AppColors.navy),
            ),
            AppSpacing.verticalLg,
            AppCard(
              onTap: () {
                Navigator.of(context).pop();
                context
                    .read<ReceiptUploadCubit>()
                    .pickImage(source: ImageSource.camera);
              },
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                    child: const Icon(Icons.camera_alt_rounded,
                        color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.takePhoto,
                            style: AppTypography.titleMedium),
                        Text(context.l10n.takePhotoDescription,
                            style: AppTypography.bodySmall),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textHint),
                ],
              ),
            ),
            AppSpacing.verticalSm,
            AppCard(
              onTap: () {
                Navigator.of(context).pop();
                context
                    .read<ReceiptUploadCubit>()
                    .pickImage(source: ImageSource.gallery);
              },
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                    child: const Icon(Icons.photo_library_rounded,
                        color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.chooseFromGallery,
                            style: AppTypography.titleMedium),
                        Text(context.l10n.chooseFromGalleryDescription,
                            style: AppTypography.bodySmall),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textHint),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            style: AppTypography.bodyMedium,
            children: [
              TextSpan(
                text: '$label: ',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeeRow(String label, String value, {bool isBold = false}) {
    final style = isBold
        ? AppTypography.headlineMedium.copyWith(color: AppColors.navy)
        : AppTypography.bodyLarge;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusLg),
        backgroundColor: AppColors.surface,
        title: Text(
          context.l10n.cancelPaymentTitle,
          style: AppTypography.headlineMedium
              .copyWith(color: AppColors.navy),
          textAlign: TextAlign.center,
        ),
        content: Text(
          context.l10n.cancelPaymentMessage,
          style: AppTypography.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedAppButton(
                  text: context.l10n.continuePayment,
                  color: AppColors.navy,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NavyButton(
                  text: context.l10n.cancel,
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    context.go('/home');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
