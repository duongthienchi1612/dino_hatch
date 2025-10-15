import 'dart:async';
import 'dart:io';

import 'package:dino_hatch/business/master_data_business.dart';
import 'package:dino_hatch/dependencies.dart';
import 'package:dino_hatch/utilities/app_configuration.dart';
import 'package:dino_hatch/utilities/database_factory.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dino_hatch/utilities/router.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // unawaited(Future<void>.delayed(const Duration(milliseconds: 1200), () {
    //   if (!mounted) return;
    //   context.go(Routes.home);
    // }));
  }

   Future<bool> _requestPermissions() async {
    bool isAllGranted = true;
    if (Platform.isAndroid) {
      if (!(await Permission.manageExternalStorage.isGranted)) {
        final permission = await Permission.manageExternalStorage.request();
        isAllGranted = permission == PermissionStatus.granted;
      }
    }
    return isAllGranted;
  }

  Future<void> _initializeDependencies() async {
    await AppDependencies.initialize();
    final isAllGranted = await _requestPermissions();
    if (isAllGranted) {
      final appConfig = injector.get<AppConfiguration>();
      await appConfig.init();
      await injector.get<DatabaseFactory>().initDatabase();
      await injector.get<MasterDataBusiness>().init();

    } else {
      await openAppSettings();
      exit(0);
    }
  }

    Future<void> timeSplashScreen() async {
    await Future.wait(
      [_initializeDependencies(), Future.delayed(const Duration(milliseconds: 1800))],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: timeSplashScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) { 
                    return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/splash_background.png'), fit: BoxFit.cover),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/splash_logo.png',
                  width: 300,
                ),
              ),
            ),
          );
          } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go(Routes.home);
              });
          }
          return Container();
      
        }
      ),
    );
  }
}


