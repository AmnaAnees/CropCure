import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:crop_crue/l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  // Slow zoom on the background (Ken Burns effect)
  late final AnimationController _bgCtrl;
  late final Animation<double> _bgScale;

  // Staggered entrance animation for the card contents
  late final AnimationController _introCtrl;

  static const _green = Color(0xFF2E7D32);

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);
    _bgScale = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));

    _introCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _introCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  /// Fade + slide-up animation for a section, active between [start] and [end]
  /// of the intro timeline (values from 0.0 to 1.0).
  Widget _stagger({
    required double start,
    required double end,
    required Widget child,
  }) {
    final animation = CurvedAnimation(
      parent: _introCtrl,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.25),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  Future<void> _submit() async {
    final t = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.registerSuccess),
        backgroundColor: _green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  InputDecoration _decoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: c, width: w),
    );

    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      floatingLabelStyle: const TextStyle(color: Colors.white),
      prefixIcon: Icon(icon, color: Colors.white70),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.12),
      errorStyle: const TextStyle(color: Color(0xFFFFCDD2)),
      enabledBorder: border(Colors.white30),
      focusedBorder: border(Colors.white, 1.6),
      errorBorder: border(const Color(0xFFFFCDD2)),
      focusedErrorBorder: border(const Color(0xFFFFCDD2), 1.6),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ---------- Animated background ----------
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

          // Dark gradient so the text stays readable
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.25),
                  Colors.black.withValues(alpha: 0.65),
                ],
              ),
            ),
          ),

          // ---------- Content ----------
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Logo (elastic pop-in)
                              // Logo (elastic pop-in)

                              ScaleTransition(
                                scale: CurvedAnimation(
                                  parent: _introCtrl,
                                  curve: const Interval(
                                    0.0,
                                    0.45,
                                    curve: Curves.elasticOut,
                                  ),
                                ),
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
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

                              const SizedBox(height: 16),

                              _stagger(
                                start: 0.15,
                                end: 0.5,
                                child: Column(
                                  children: [
                                    Text(
                                      t.registerTitle,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      t.registerSubtitle,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Full name
                              _stagger(
                                start: 0.25,
                                end: 0.6,
                                child: TextFormField(
                                  controller: _nameCtrl,
                                  style: const TextStyle(color: Colors.white),
                                  textInputAction: TextInputAction.next,
                                  decoration: _decoration(
                                    label: t.fullName,
                                    icon: Icons.person_outline,
                                  ),
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                      ? t.errRequired
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Email
                              _stagger(
                                start: 0.35,
                                end: 0.7,
                                child: TextFormField(
                                  controller: _emailCtrl,
                                  style: const TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: _decoration(
                                    label: t.email,
                                    icon: Icons.email_outlined,
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return t.errRequired;
                                    }
                                    final ok = RegExp(
                                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                    ).hasMatch(v.trim());
                                    return ok ? null : t.errInvalidEmail;
                                  },
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Password
                              _stagger(
                                start: 0.45,
                                end: 0.8,
                                child: TextFormField(
                                  controller: _passCtrl,
                                  obscureText: _obscurePass,
                                  style: const TextStyle(color: Colors.white),
                                  textInputAction: TextInputAction.next,
                                  decoration: _decoration(
                                    label: t.password,
                                    icon: Icons.lock_outline,
                                    suffix: IconButton(
                                      icon: Icon(
                                        _obscurePass
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () => setState(
                                        () => _obscurePass = !_obscurePass,
                                      ),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return t.errRequired;
                                    }
                                    return v.length < 6
                                        ? t.errPasswordShort
                                        : null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Confirm password
                              _stagger(
                                start: 0.55,
                                end: 0.9,
                                child: TextFormField(
                                  controller: _confirmCtrl,
                                  obscureText: _obscureConfirm,
                                  style: const TextStyle(color: Colors.white),
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _submit(),
                                  decoration: _decoration(
                                    label: t.confirmPassword,
                                    icon: Icons.lock_reset_outlined,
                                    suffix: IconButton(
                                      icon: Icon(
                                        _obscureConfirm
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () => setState(
                                        () =>
                                            _obscureConfirm = !_obscureConfirm,
                                      ),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return t.errRequired;
                                    }
                                    return v != _passCtrl.text
                                        ? t.errPasswordMismatch
                                        : null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Register button
                              _stagger(
                                start: 0.65,
                                end: 1.0,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: _loading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _green,
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor: _green
                                          .withValues(alpha: 0.7),
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      child: _loading
                                          ? const SizedBox(
                                              key: ValueKey('loader'),
                                              height: 22,
                                              width: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              t.registerButton,
                                              key: const ValueKey('label'),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Login link
                              _stagger(
                                start: 0.75,
                                end: 1.0,
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      t.alreadyHaveAccount,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (Navigator.canPop(context)) {
                                          Navigator.pop(context);
                                        }
                                        // TODO: or pushReplacement(LoginPage)
                                      },
                                      child: Text(
                                        t.login,
                                        style: const TextStyle(
                                          color: Color(0xFFA5D6A7),
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
