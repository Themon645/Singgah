import 'package:flutter/material.dart';
import 'package:singgah/features/destination/domain/entities/destination.dart';
import 'package:singgah/features/trip/domain/entities/trip.dart';
import 'package:singgah/features/home/domain/entities/travel_reminder.dart';

class TravelReminderService {
  static List<TravelReminder> buildTravelReminders(
    List<Trip> trips,
    DateTime now,
  ) {
    final today = DateUtils.dateOnly(now);
    final reminders = <TravelReminder>[];

    final relevantTrips = trips
        .where(
          (trip) =>
              trip.status == TripStatus.upcoming ||
              trip.status == TripStatus.ongoing,
        )
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    for (final trip in relevantTrips) {
      final tripStart = DateUtils.dateOnly(trip.startDate);
      final daysUntilStart = tripStart.difference(today).inDays;

      if (daysUntilStart == 1) {
        reminders.add(
          TravelReminder(
            title: 'jangan lupa besok anda ke ${trip.destination}',
            subtitle: 'Trip: ${trip.name}',
          ),
        );
        continue;
      }

      if (daysUntilStart <= 0 && trip.itinerary.isNotEmpty) {
        final nextDestination = _nextDestinationForTrip(trip, now);
        if (nextDestination != null) {
          final reminderTime = _parseDestinationTime(now, nextDestination);
          if (reminderTime != null) {
            final minutesLeft = reminderTime.difference(now).inMinutes;
            if (minutesLeft >= 0 && minutesLeft <= 10) {
              reminders.add(
                TravelReminder(
                  title:
                      'pergi ke ${nextDestination.name},hari ini pukul ${_formatTime(reminderTime)}',
                  subtitle: '10 menit lagi',
                ),
              );
              continue;
            }

            if (minutesLeft > 10) {
              reminders.add(
                TravelReminder(
                  title:
                      'pergi ke ${nextDestination.name},hari ini pukul ${_formatTime(reminderTime)}',
                  subtitle: 'Sisa $minutesLeft menit lagi',
                ),
              );
              continue;
            }
          }

          reminders.add(
            TravelReminder(
              title: 'pergi ke ${nextDestination.name}',
              subtitle: 'Ikuti itinerary perjalanan Anda hari ini.',
            ),
          );
        }
      }
    }

    return reminders;
  }

  static Destination? _nextDestinationForTrip(Trip trip, DateTime now) {
    if (trip.itinerary.isEmpty) return null;

    for (final destination in trip.itinerary) {
      final destinationTime = _parseDestinationTime(now, destination);
      if (destinationTime == null || !destinationTime.isBefore(now)) {
        return destination;
      }
    }

    return trip.itinerary.last;
  }

  static DateTime? _parseDestinationTime(
    DateTime baseDate,
    Destination destination,
  ) {
    final timeText = destination.arrivalTime ?? destination.departureTime;
    if (timeText == null || timeText.isEmpty) {
      return null;
    }

    final parts = timeText.split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;

    return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
