import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:singgah/app/router.dart';
import 'package:singgah/app/theme.dart';
import 'package:singgah/features/auth/domain/entities/user.dart';
import 'package:singgah/features/destination/domain/entities/destination.dart';
import 'package:singgah/features/trip/domain/entities/trip.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Load environment variables
    await dotenv.load(fileName: ".env");
    debugPrint("Dotenv loaded. Google Key: ${dotenv.env['GOOGLE_PLACES_API_KEY']?.substring(0, 5)}...");
    
    // Initialize Hive
    await Hive.initFlutter();
    
    // Register Adapters
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(TripStatusAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(TripAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(DestinationAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(UserAdapter());
    
    // Open Boxes
    await Hive.openBox<Trip>('trips_box');
    await Hive.openBox<User>('users_box');

    runApp(
      const ProviderScope(
        child: SinggahApp(),
      ),
    );
  } catch (e) {
    debugPrint('Initialization Error: $e');
    // Jalankan app minimal untuk menunjukkan pesan error jika gagal total
    runApp(MaterialApp(home: Scaffold(body: Center(child: Text('Terjadi kesalahan saat memulai aplikasi: $e')))));
  }
}

class SinggahApp extends StatelessWidget {
  const SinggahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Singgah',
      theme: SinggahTheme.lightTheme,
      darkTheme: SinggahTheme.darkTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
