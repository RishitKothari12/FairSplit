import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'router.dart';

class FairSplitApp extends StatelessWidget {
  const FairSplitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FairSplit',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      routerConfig: AppRouter.router,
    );
  }
}