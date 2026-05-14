import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:singgah/features/auth/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Simulate splash delay if needed, but for now just go directly
      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) {
          context.go('/');
        }
      });
    });
    return _buildSplashUI(context);
  }

  Widget _buildSplashUI(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Singgah',
                  style: textTheme.displayLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Berhenti, lalu lanjut.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 56,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'v1.0',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.outlineVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
