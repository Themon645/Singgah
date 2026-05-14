import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingPages = [
    OnboardingData(
      title: 'Satu rencana, satu tempat.',
      description: 'Simpan tempat menarik, susun jadwal, dan nikmati perjalanan tanpa repot.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBsTGiyvOh0gGZI8zCoH6mnjnauvcF1F4w9vZVgtnyC-sZPmTvx96ccSk534whEgh2IXnW9BVfRr0iE0RYTxW7NxURV5s9HzjlSuY8q9lPAtwuVZmkChJYUPpSFR73aiS2PF3e4UeOyi2fYODtMudViSocV-db7kU6ZSO7bi5uetCxBxNTn65BMRg4-A8ba1oS5sCzfJATE-wHboi4kPRd__j8rf684TbFCUAFYiefdmjVnDe0s1M61ugADZAiJRGydwPrbAs_XwBA',
    ),
    OnboardingData(
      title: 'Jadwal yang realistis.',
      description: 'Estimasi waktu antar tempat dihitung otomatis sesuai jenis kendaraanmu.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDYIoHbHZEPNYsuuLqHfsxzBsiD9JD1qDab1uKCHQr-2B4b8rk7A6UDP8_2nClJWqrhM-fVy2-l7r6cgRGiN5CuGPn7eQIuBmkw8hy1nRyphD3jaGiKYwstZGdpr1DnpGZfKlRFKUipsyYNcg0Vs60pXrzzyY5OopU9JdoF5CKUER3RjOpVQrIOeyxW0Bux1Z9K3lnlwcu_eLMozXcHPLzI0LuiZOn6-Jj5vrTZ-wgeHvYpueGz9fatWEWC9xD585TvnN5HnhGyNY4',
    ),
    OnboardingData(
      title: 'Temukan yang searah.',
      description: 'Singgah menyarankan tempat-tempat menarik di sepanjang rutemu.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAGtPbqyAIp2xANhkmGZ7r-eGrtPk5P59EmfTWFWliS5yWY7fIUdft8Qv6tLOaquQONft6jZym2CSlCz3WrwhQF732wpfZhdELQLG8RG3ioZeV5NbfCGgJIQ3vJab7uzjjIO3UgRBf7OB8_1ge8tWOJhYSpKDkpq2uDSJ33SN4ErgIU7tHVfivEi1Xm3DG_UUB5ia82hczz2nBYkWZ0ZS3uE303EXOq-HH55zPGPZqd7tUvW84KfYaLe22d4o4Mh3jYnYlmNrzS6PI',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingPages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: SizedBox(
                      width: double.infinity,
                      child: Image.network(
                        _onboardingPages[index].imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 32),
                          Text(
                            _onboardingPages[index].title,
                            style: textTheme.headlineLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _onboardingPages[index].description,
                            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingPages.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? colorScheme.primary : colorScheme.outlineVariant,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _onboardingPages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      context.go('/auth');
                    }
                  },
                  child: Text(_currentPage == _onboardingPages.length - 1 ? 'Mulai' : 'Lanjut'),
                ),
                if (_currentPage < _onboardingPages.length - 1)
                  TextButton(
                    onPressed: () => context.go('/auth'),
                    child: Text('Lewati', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String imageUrl;

  OnboardingData({required this.title, required this.description, required this.imageUrl});
}
