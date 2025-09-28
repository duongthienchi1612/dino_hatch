import 'dart:io';

import 'package:dino_hatch/l10n/app_localizations.dart';
import 'package:dino_hatch/preference/language_preference.dart';
import 'package:dino_hatch/preference/user_reference.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dino_hatch/utilities/router.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
  
  // Kiểm tra nếu không chạy trên web thì thiết lập định hướng landscape
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } else {
    // Đối với web, thiết lập SystemUI để tối ưu trải nghiệm
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  // Cài đặt kích thước cửa sổ tối thiểu cho desktop
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    await windowManager.ensureInitialized();
    
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1024, 600),
      minimumSize: Size(800, 480),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: 'Flower Bloom',
    );
    
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Lấy ngôn ngữ từ LanguagePreference, nếu không có thì lấy từ UserReference
  // Nếu cả hai đều không có, sử dụng ngôn ngữ hệ thống
  final savedLanguage = await LanguagePreference.getLanguageCode() ?? await UserReference().getLanguage();
  String initialLanguage;
  
  if (savedLanguage != null) {
    initialLanguage = savedLanguage;
  } else {
    // Lấy ngôn ngữ hệ thống
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final systemLanguage = systemLocale.languageCode;
    
    // Kiểm tra xem ngôn ngữ hệ thống có được hỗ trợ không
    final supportedLanguages = ['en', 'vi']; // Thêm các ngôn ngữ được hỗ trợ
    initialLanguage = supportedLanguages.contains(systemLanguage) ? systemLanguage : 'en';
    
    // Lưu ngôn ngữ mặc định vào preferences
    await LanguagePreference.setLanguageCode(initialLanguage);
    await UserReference().setLanguage(initialLanguage);
  }

  runApp(DinoHatchApp(initialLanguage: initialLanguage));
}

class DinoHatchApp extends StatefulWidget {
    final String initialLanguage;
  const DinoHatchApp({super.key, required this.initialLanguage});

  @override
  State<DinoHatchApp> createState() => _DinoHatchAppState();
}

class _DinoHatchAppState extends State<DinoHatchApp> {

    late Locale _locale;

      @override
  void initState() {
    super.initState();
    _locale = Locale(widget.initialLanguage);
  }

  void _changeLanguage(String languageCode) async {
    // Lưu ngôn ngữ vào cả hai nơi
    await LanguagePreference.setLanguageCode(languageCode);

    setState(() {
      _locale = Locale(languageCode);
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: _locale,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Dino Hatch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
