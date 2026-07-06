import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';
import '../core/theme/app_theme.dart';

class FairSplitApp extends StatelessWidget {
  const FairSplitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'FairSplit',

      theme: AppTheme.lightTheme,

      routerConfig: AppRouter.router,
    );
  }
}