
import 'dart:ui';

import 'package:crop_crue/l10n/app_localizations.dart';
import 'package:crop_crue/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscurePassword = true;

  late final AnimationController _bgCtrl;
  late final Animation<double> _bgScale;
  late final AnimationController _introCtrl;

  // Nature & Wheat Theme
  static const Color _forestGreen = Color(0xFF174D35);
  static const Color _softSage = Color(0xFFE5F0E5);
  static const Color _warmCream = Color(0xFFF7F6ED);
  static const Color _wheatGold = Color(0xFFD5AE55);
  static const Color _deepGreen = Color(0xFF293B30);

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);

    _bgScale = Tween<double>(
      begin: 1,
      end: 1.15,
    ).animate(
      CurvedAnimation(
        parent: _bgCtrl,
        curve: Curves.easeInOut,
      ),
    );

    _introCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _introCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Widget _stagger({
    required double start,
    required double end,
    required Widget child,
  }) {
    final animation = CurvedAnimation(
      parent: _introCtrl,
      curve: Interval(
        start,
        end,
        curve: Curves.easeOutCubic,
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  InputDecoration _decoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: color,
          width: width,
        ),
      );
    }

    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white70,
      ),
      floatingLabelStyle: const TextStyle(
        color: _wheatGold,
      ),
      prefixIcon: Icon(
        icon,
        color: _softSage,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.12),
      errorStyle: const TextStyle(
        color: Color(0xFFFFCDD2),
      ),
      enabledBorder: border(Colors.white30),
      focusedBorder: border(_wheatGold, 1.6),
      errorBorder: border(const Color(0xFFFFCDD2)),
      focusedErrorBorder: border(
        const Color(0xFFFFCDD2),
        1.6,
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: _forestGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _submit(AppLocalizations t) {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _bgScale,
            builder: (_, _) => Transform.scale(
              scale: _bgScale.value,
              child: Image.asset(
                'assets/images/wheat_field.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Forest green overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _forestGreen.withValues(alpha: 0.38),
                  _deepGreen.withValues(alpha: 0.82),
                ],
              ),
            ),
          ),

          // Login content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 420,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 14,
                        sigmaY: 14,
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(
                          24,
                          28,
                          24,
                          24,
                        ),
                        decoration: BoxDecoration(
                          color: _forestGreen.withValues(alpha: 0.48),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: _wheatGold.withValues(alpha: 0.55),
                            width: 1.2,
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Logo
                              _stagger(
                                start: 0,
                                end: 0.45,
                                child: Container(
                                  width: 112,
                                  height: 112,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: _warmCream,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _wheatGold,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.25,
                                        ),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'assets/images/app_logo.jpeg',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Title and subtitle
                              _stagger(
                                start: 0.1,
                                end: 0.5,
                                child: Column(
                                  children: [
                                    Text(
                                      t.loginTitle,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: _warmCream,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      t.loginSubtitle,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: _softSage,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 28),

                              // Email field
                              _stagger(
                                start: 0.2,
                                end: 0.65,
                                child: TextFormField(
                                  controller: _emailCtrl,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [
                                    AutofillHints.email,
                                  ],
                                  decoration: _decoration(
                                    label: t.email,
                                    icon: Icons.email_outlined,
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return t.errRequired;
                                    }

                                    final valid = RegExp(
                                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                    ).hasMatch(value.trim());

                                    return valid
                                        ? null
                                        : t.errInvalidEmail;
                                  },
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Password field
                              _stagger(
                                start: 0.3,
                                end: 0.75,
                                child: TextFormField(
                                  controller: _passwordCtrl,
                                  obscureText: _obscurePassword,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [
                                    AutofillHints.password,
                                  ],
                                  onFieldSubmitted: (_) => _submit(t),
                                  decoration: _decoration(
                                    label: t.password,
                                    icon: Icons.lock_outline,
                                    suffix: IconButton(
                                      tooltip: _obscurePassword
                                          ? t.showPassword
                                          : t.hidePassword,
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: _wheatGold,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword =
                                              !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? t.errRequired
                                          : null,
                                ),
                              ),

                              // Forgot password
                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: TextButton(
                                  onPressed: () =>
                                      _showMessage(t.resetNotConfigured),
                                  child: Text(
                                    t.forgotPassword,
                                    style: const TextStyle(
                                      color: _wheatGold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Login button
                              _stagger(
                                start: 0.45,
                                end: 0.9,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: () => _submit(t),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _wheatGold,
                                      foregroundColor: _deepGreen,
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text(
                                      t.login,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Register link
                              _stagger(
                                start: 0.55,
                                end: 1,
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      t.dontHaveAccount,
                                      style: const TextStyle(
                                        color: _softSage,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (_) =>
                                                const RegisterPage(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        t.registerButton,
                                        style: const TextStyle(
                                          color: _wheatGold,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
