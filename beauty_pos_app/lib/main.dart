// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'ui/desktop/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: BeautyPosApp(),
    ),
  );
}

class BeautyPosApp extends ConsumerWidget {
  const BeautyPosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Beauty POS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
