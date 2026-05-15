import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthLandingScreen extends StatelessWidget {
  const AuthLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.primary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: colorScheme.primary),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Logo Image
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.location_on, 
                  color: colorScheme.primary, 
                  size: 120
                ),
              ),
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang.',
                  style: textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masuk untuk mulai merencanakan perjalananmu.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            
            // Auth Buttons
            ElevatedButton(
              onPressed: () => context.push('/login'),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail_outline),
                  SizedBox(width: 12),
                  Text('Masuk dengan email'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur Google Login segera hadir!')),
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: colorScheme.primary),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuB63_MRkSvtd01p-sBx__3z5ifGnMhXiKQrqFnREjc-0Iwn6pGGKJjInPVpZ1fIuxXGFu4bIknIsQBfcKezSskh4MPDlJfKzCDp6c4SWgHHTxqAjNM_j53jlZMEjHN-Ap2uDI5YCYmZrWp1NJKwapZJdpo69hqdhAO6g2_hAotphtPp5WU3-kjKjvlOIx0_SilL7C14Bi5O6beOn9hdxB2sVdrf57ZiUGB-6FGBb0CSAk_CyJ2RiCB5G5_fIgFjmXAyjNsJCvMlaEI',
                    height: 20,
                  ),
                  const SizedBox(width: 12),
                  const Text('Lanjutkan dengan Google'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur Apple Login segera hadir!')),
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: colorScheme.primary),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.apple),
                  SizedBox(width: 12),
                  Text('Lanjutkan dengan Apple'),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            Center(
              child: TextButton(
                onPressed: () => context.push('/register'),
                child: Text.rich(
                  TextSpan(
                    text: 'Belum punya akun? ',
                    style: textTheme.labelMedium,
                    children: [
                      TextSpan(
                        text: 'Daftar',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 56),
          ],
        ),
      ),
    );
  }
}
