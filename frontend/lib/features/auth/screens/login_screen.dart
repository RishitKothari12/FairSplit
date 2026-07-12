import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Gap(40),

            const AppLogo(size: 120),

            const Gap(32),

            const Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Gap(8),

            Text(
              "Manage your shared expenses\nwith ease",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),

            const Gap(40),

            CustomTextField(
              label: "Email",
              hintText: "Enter your email",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
            ),

            const Gap(20),

            CustomTextField(
              label: "Password",
              hintText: "Enter your password",
              controller: _passwordController,
              obscureText: _obscurePassword,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
              textInputAction: TextInputAction.done,
            ),

            const Gap(14),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text("Forgot Password?"),
              ),
            ),

            const Gap(8),

            PrimaryButton(
                text: "Login",
                loading: ref.watch(authControllerProvider),
                onPressed: () async {
                    final controller = ref.read(
                    authControllerProvider.notifier,
                    );

                    final messenger = ScaffoldMessenger.of(context);
                    final router = GoRouter.of(context);

                    final success = await controller.login(
                    email: _emailController.text.trim(),
                    password: _passwordController.text,
                    );

                    if (!mounted) return;

                    if (success) {
                    router.go(AppRouter.home);
                    } else {
                    messenger.showSnackBar(
                        const SnackBar(
                        content: Text(
                            "Invalid email or password",
                        ),
                        ),
                    );
                    }
                },
            ),
            const Gap(28),

            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "OR",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),

            const Gap(24),

            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.g_mobiledata),
              label: const Text(
                "Continue with Google (Coming Soon)",
              ),
            ),

            const Gap(32),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Register"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}