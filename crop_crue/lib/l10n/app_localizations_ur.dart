// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get registerTitle => 'اکاؤنٹ بنائیں';

  @override
  String get registerSubtitle => 'اپنی گندم کی فصل کی حفاظت شروع کریں';

  @override
  String get fullName => 'پورا نام';

  @override
  String get email => 'ای میل';

  @override
  String get password => 'پاس ورڈ';

  @override
  String get confirmPassword => 'پاس ورڈ کی تصدیق کریں';

  @override
  String get registerButton => 'رجسٹر کریں';

  @override
  String get alreadyHaveAccount => 'پہلے سے اکاؤنٹ ہے؟';

  @override
  String get login => 'لاگ ان';

  @override
  String get errRequired => 'یہ خانہ ضروری ہے';

  @override
  String get errInvalidEmail => 'درست ای میل درج کریں';

  @override
  String get errPasswordShort => 'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے';

  @override
  String get errPasswordMismatch => 'پاس ورڈ مماثل نہیں ہیں';

  @override
  String get registerSuccess => 'اکاؤنٹ کامیابی سے بن گیا!';
}
