import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/widgets/custom_button.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/custom_text_field.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/features/Farmers/Farmers%20Connect/Logic/connect_farmer_cubit.dart';
import 'package:web_dashboard/features/Farmers/Farmers%20Connect/Logic/connect_farmer_state.dart';

class AddFarmerDialog extends StatefulWidget {
  const AddFarmerDialog({super.key});

  @override
  State<AddFarmerDialog> createState() => _AddFarmerDialogState();

  /// Shows the add farmer dialog
  static Future<bool?> show(BuildContext context) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Farmer Dialog',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const AddFarmerDialog();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: curvedAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}

class _AddFarmerDialogState extends State<AddFarmerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Reset cubit state and clear field when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConnectFarmerCubit>().reset();
      _usernameController.clear();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _handleConnect() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      if (username.isNotEmpty) {
        context.read<ConnectFarmerCubit>().connectFarmer(username);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return BlocListener<ConnectFarmerCubit, ConnectFarmerState>(
      listener: (context, state) {
        if (state is ConnectFarmerSuccess) {
          // Reset cubit state before closing
          context.read<ConnectFarmerCubit>().reset();
          Navigator.of(context).pop(true);
        }
      },
      child: Dialog(
        backgroundColor: AppColors.transparent,
        insetPadding: SizeConfig.scalePadding(horizontal: 6),
        child: BlocBuilder<ConnectFarmerCubit, ConnectFarmerState>(
          builder: (context, state) {
            return Container(
              width: SizeConfig.responsive(
                mobile: SizeConfig.screenWidth * 0.85,
                tablet: SizeConfig.screenWidth * 0.4,
                desktop: SizeConfig.screenWidth * 0.35,
              ),
              padding: SizeConfig.allPadding(
                SizeConfig.responsive(mobile: 4, tablet: 5, desktop: 6),
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(
                  SizeConfig.scaleRadius(
                    SizeConfig.responsive(mobile: 3, tablet: 4, desktop: 5),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      padding: SizeConfig.allPadding(
                        SizeConfig.responsive(mobile: 3, tablet: 3.5, desktop: 4),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_add_outlined,
                        size: SizeConfig.responsive(mobile: 32, tablet: 40, desktop: 48),
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(2.5)),

                    // Title
                    CustomText(
                      'Connect to Farmer',
                      fontSize: SizeConfig.responsive(mobile: 18, tablet: 20, desktop: 22),
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(1)),

                    // Description
                    CustomText(
                      'Enter the farmer\'s username to connect and add them to your list.',
                      fontSize: SizeConfig.responsive(mobile: 12, tablet: 13, desktop: 14),
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey600,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(3)),

                    // Error message if any
                    if (state is ConnectFarmerFailure) ...[
                      Container(
                        padding: SizeConfig.scalePadding(horizontal: 2, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.scaleRadius(2),
                          ),
                          border: Border.all(
                            color: AppColors.error.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                              size: SizeConfig.responsive(mobile: 18, tablet: 20, desktop: 22),
                            ),
                            SizedBox(width: SizeConfig.scaleWidth(2)),
                            Expanded(
                              child: CustomText(
                                state.failureMessage,
                                fontSize: SizeConfig.responsive(mobile: 11, tablet: 12, desktop: 13),
                                color: AppColors.error,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.scaleHeight(2)),
                    ],

                    // Username Field
                    CustomTextField(
                      fillColor: AppColors.primary.withOpacity(0.08),
                      controller: _usernameController,
                      label: 'Farmer Username',
                      hintText: 'Enter farmer username',
                      prefixWidget: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 8),
                        child: Icon(
                          Icons.alternate_email,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter farmer username';
                        }
                        if (value.trim().length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        return null;
                      },
                      enabled: state is! ConnectFarmerLoading,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(4)),

                    // Buttons
                    Row(
                      children: [
                        // Cancel button
                        Expanded(
                          child: CustomButton(
                            onPressed: state is ConnectFarmerLoading
                                ? null
                                : () => Navigator.of(context).pop(false),
                            text: 'Cancel',
                            type: ButtonType.outlined,
                            borderColor: AppColors.grey400,
                            textColor: AppColors.grey700,
                            height: SizeConfig.scaleHeight(
                              SizeConfig.responsive(mobile: 5, tablet: 5.5, desktop: 6),
                            ),
                            borderRadius: SizeConfig.scaleRadius(
                              SizeConfig.responsive(mobile: 2, tablet: 2.5, desktop: 3),
                            ),
                          ),
                        ),
                        SizedBox(width: SizeConfig.scaleWidth(3)),
                        // Connect button
                        Expanded(
                          child: state is ConnectFarmerLoading
                              ? Container(
                                  height: SizeConfig.scaleHeight(
                                    SizeConfig.responsive(mobile: 5, tablet: 5.5, desktop: 6),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(
                                      SizeConfig.scaleRadius(
                                        SizeConfig.responsive(mobile: 2, tablet: 2.5, desktop: 3),
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: SizeConfig.scaleWidth(5),
                                      height: SizeConfig.scaleWidth(5),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : CustomButton(
                                  onPressed: _handleConnect,
                                  text: 'Connect',
                                  backgroundColor: AppColors.primary,
                                  textColor: AppColors.white,
                                  height: SizeConfig.scaleHeight(
                                    SizeConfig.responsive(mobile: 5, tablet: 5.5, desktop: 6),
                                  ),
                                  borderRadius: SizeConfig.scaleRadius(
                                    SizeConfig.responsive(mobile: 2, tablet: 2.5, desktop: 3),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
