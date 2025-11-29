import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/custom_text_field.dart';
import 'package:web_dashboard/core/widgets/custom_button.dart';
import 'package:web_dashboard/core/widgets/build_icon.dart';
import 'package:web_dashboard/core/widgets/app_snack_bar.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/constants/app_assets.dart';
import 'package:web_dashboard/core/Helpers/regex.dart';
import 'package:web_dashboard/core/Helpers/Routing.dart';
import 'package:web_dashboard/features/Auth/Presentation/controllers/login_controller.dart';
import 'package:web_dashboard/features/Auth/Logic/login_cubit.dart';
import 'package:web_dashboard/features/Auth/Logic/login_state.dart';
import 'package:web_dashboard/features/Notifications/Logic/notification_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late LoginController _loginController;

  @override
  void initState() {
    super.initState();
    _loginController = LoginController(
      formKey: _formKey,
      emailController: _emailController,
      passwordController: _passwordController,
    );
  }

  @override
  void dispose() {
    _loginController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    _loginController.handleLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // Register FCM token with backend after successful login (if FCM is available)
          try {
            context.read<NotificationCubit>().registerFcmToken();
          } catch (e) {
            print('⚠️ FCM not available: $e');
          }
          
          showAppSnackBar(
            context: context,
            message: state.successMessage,
            icon: Icons.check_circle,
            backgroundColor: AppColors.primary,
            textColor: AppColors.white,
            behavior: SnackBarBehavior.floating,
          );
          // Navigate to dashboard after a short delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              context.pushReplacementNamed('/dashboard');
            }
          });
        } else if (state is LoginFailure) {
          showAppSnackBar(
            context: context,
            message: state.failureMessage,
            icon: Icons.error,
            backgroundColor: AppColors.error,
            textColor: AppColors.white,
            behavior: SnackBarBehavior.floating,
          );
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Center(
        child: SingleChildScrollView(
          padding: SizeConfig.scalePadding(
            horizontal: 4,
            vertical: 4,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: SizeConfig.responsive(
                mobile: SizeConfig.scaleWidth(90),
                tablet: SizeConfig.scaleWidth(50),
                desktop: SizeConfig.scaleWidth(40),
              ),
            ),
            padding: SizeConfig.scalePadding(
              all: SizeConfig.responsive(mobile: 4, tablet: 5, desktop: 6),
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                SizeConfig.getResponsiveBorderRadius(
                  mobile: 2,
                  tablet: 2.5,
                  desktop: 3,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  buildIcon(
                    AppAssets.logo,
                    SizeConfig.responsive(mobile: 6, tablet: 9, desktop: 12),
                    SizeConfig.responsive(mobile: 6, tablet: 9, desktop: 12),
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(3)),
                  
                  // Login Title
                  CustomText(
                    'Log in',
                    fontSize: SizeConfig.responsive(mobile: 24, tablet: 28, desktop: 32),
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(4)),
                  
                  // Email Field
                  CustomTextField(
                    label: 'Email',
                    hintText: 'Enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    fillColor: AppColors.weatherPrimary.withOpacity(0.3),
                    hintTextColor: AppColors.grey500,
                    enabledBorderColor: Colors.transparent,
                    borderRadius: SizeConfig.getResponsiveBorderRadius(
                      mobile: 1.5,
                      tablet: 2,
                      desktop: 2.5,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!AppRegex.isEmailValid(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(3)),
                  
                  // Password Field
                  CustomTextField(
                    label: 'Password',
                    hintText: 'Enter Your password',
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    fillColor: AppColors.weatherPrimary.withOpacity(0.3),
                    hintTextColor: AppColors.grey500,
                    enabledBorderColor: Colors.transparent,
                    borderRadius: SizeConfig.getResponsiveBorderRadius(
                      mobile: 1.5,
                      tablet: 2,
                      desktop: 2.5,
                    ),
                    onFieldSubmitted: (_) => _handleLogin(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(4)),
                  
                  // Login Button
                  CustomButton(
                    text: 'Log in',
                    onPressed: _handleLogin,
                    isLoading: state is LoginLoading,
                    expand: true,
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.white,
                    height: SizeConfig.responsive(mobile: 50, tablet: 55, desktop: 60),
                    borderRadius: SizeConfig.getResponsiveBorderRadius(
                      mobile: 1.5,
                      tablet: 2,
                      desktop: 2.5,
                    ),
                    fontSize: SizeConfig.responsive(mobile: 16, tablet: 18, desktop: 20),
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(2)),
                  
                  // Mock Login Button (for development)
                  TextButton(
                    onPressed: () {
                      showAppSnackBar(
                        context: context,
                        message: 'Mock login successful',
                        icon: Icons.check_circle,
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.white,
                        behavior: SnackBarBehavior.floating,
                      );
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (context.mounted) {
                          context.pushReplacementNamed('/dashboard');
                        }
                      });
                    },
                    child: CustomText(
                      'Skip Login (Mock)',
                      fontSize: SizeConfig.responsive(mobile: 14, tablet: 15, desktop: 16),
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
          );
        },
      ),
    );
  }
}

