// TEMP FILE — full connected-app preview using the REAL AppRouter, skipping
// Supabase.initialize/Firebase.initializeApp (not configured yet, Phase 0).
// app_router.dart's _redirect already catches Supabase-not-initialized and
// treats it as "no session", so navigation works via the MockSession bypass.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_strings.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() => runApp(const ProviderScope(child: _PreviewApp()));

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
