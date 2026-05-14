import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singgah/features/destination/domain/entities/destination.dart';
import 'package:singgah/features/trip/presentation/providers/trip_provider.dart';

class TimePickerSheet extends ConsumerStatefulWidget {
  final String tripId;
  final Destination destination;

  const TimePickerSheet({
    super.key,
    required this.tripId,
    required this.destination,
  });

  @override
  ConsumerState<TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends ConsumerState<TimePickerSheet> {
  late String _arrivalTime;
  late String _departureTime;

  @override
  void initState() {
    super.initState();
    _arrivalTime = widget.destination.arrivalTime ?? '10:00';
    _departureTime = widget.destination.departureTime ?? '12:30';
  }

  Future<void> _selectTime(bool isArrival) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse((isArrival ? _arrivalTime : _departureTime).split(':')[0]),
        minute: int.parse((isArrival ? _arrivalTime : _departureTime).split(':')[1]),
      ),
    );
    if (picked != null) {
      setState(() {
        final formatted = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        if (isArrival) {
          _arrivalTime = formatted;
        } else {
          _departureTime = formatted;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Atur waktu kunjungan', style: textTheme.headlineMedium),
          ),
          const SizedBox(height: 8),
          Text(widget.destination.name, style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary)),
          const SizedBox(height: 32),
          
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectTime(true),
                  child: _buildTimeInput(context, 'Tiba', _arrivalTime),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectTime(false),
                  child: _buildTimeInput(context, 'Pergi', _departureTime),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: () async {
              await ref.read(tripsProvider.notifier).updateDestination(
                widget.tripId,
                widget.destination.id,
                arrivalTime: _arrivalTime,
                departureTime: _departureTime,
              );
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTimeInput(BuildContext context, String label, String time) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.labelSmall),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.schedule, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(time, style: textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}
