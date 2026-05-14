import 'package:go_router/go_router.dart';
import 'package:singgah/features/auth/presentation/screens/splash_screen.dart';
import 'package:singgah/features/destination/presentation/screens/destination_detail_screen.dart';
import 'package:singgah/features/destination/presentation/screens/explore_result_screen.dart';
import 'package:singgah/features/destination/presentation/screens/explore_screen.dart';
import 'package:singgah/features/home/presentation/screens/home_screen.dart';
import 'package:singgah/features/hotel/presentation/screens/hotel_detail_screen.dart';
import 'package:singgah/features/trip/presentation/screens/create_trip/create_trip_screen.dart';
import 'package:singgah/features/trip/presentation/screens/trip_detail_screen.dart';
import 'package:singgah/features/trip/presentation/screens/trip_list_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/create-trip',
      builder: (context, state) => const CreateTripScreen(),
    ),
    GoRoute(
      path: '/trips',
      builder: (context, state) => const TripListScreen(),
    ),
    GoRoute(
      path: '/trip-detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TripDetailScreen(tripId: id);
      },
    ),
    GoRoute(
      path: '/explore',
      builder: (context, state) => const ExploreScreen(),
    ),
    GoRoute(
      path: '/explore-result',
      builder: (context, state) => const ExploreResultScreen(),
    ),
    GoRoute(
      path: '/destination-detail',
      builder: (context, state) => const DestinationDetailScreen(),
    ),
    GoRoute(
      path: '/hotel-detail',
      builder: (context, state) => const HotelDetailScreen(),
    ),
  ],
);
