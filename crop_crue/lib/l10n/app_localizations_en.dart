// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'Start protecting your wheat crop';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get registerButton => 'Register';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get login => 'Login';

  @override
  String get errRequired => 'This field is required';

  @override
  String get errInvalidEmail => 'Enter a valid email';

  @override
  String get errPasswordShort => 'Password must be at least 6 characters';

  @override
  String get errPasswordMismatch => 'Passwords do not match';

  @override
  String get registerSuccess => 'Account created successfully!';
}
