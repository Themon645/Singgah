import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:singgah/features/trip/domain/entities/trip.dart';
import 'package:singgah/features/trip/presentation/providers/trip_provider.dart';

class CreateTripScreen extends ConsumerStatefulWidget {
  const CreateTripScreen({super.key});

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  int _currentStep = 1;
  final int _totalSteps = 4;

  // Form State
  final _nameController = TextEditingController();
  String _origin = 'Jakarta';
  String _destination = 'Bandung';
  DateTime _startDate = DateTime(2026, 6, 12);
  DateTime _endDate = DateTime(2026, 6, 14);
  String _vehicleType = 'Mobil';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleCreateTrip() {
    final newTrip = Trip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.isEmpty ? 'Trip Baru' : _nameController.text,
      origin: _origin,
      destination: _destination,
      startDate: _startDate,
      endDate: _endDate,
      vehicleType: _vehicleType,
    );

    ref.read(tripsProvider.notifier).addTrip(newTrip);
    _showSuccessDialog();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(_currentStep == 1 ? Icons.close : Icons.arrow_back, 
                color: colorScheme.onSurfaceVariant),
          onPressed: () {
            if (_currentStep == 1) {
              context.pop();
            } else {
              setState(() => _currentStep--);
            }
          },
        ),
        title: Column(
          children: [
            Text('Trip baru', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_totalSteps, (index) {
                final stepIndex = index + 1;
                final isActive = stepIndex == _currentStep;
                return Container(
                  width: isActive ? 12 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isActive ? colorScheme.primary : colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: _buildStepContent(),
      bottomNavigationBar: _currentStep < 5 ? Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            if (_currentStep < 4) {
              setState(() => _currentStep++);
            } else {
              _handleCreateTrip();
            }
          },
          child: Text(_currentStep == 4 ? 'Buat trip' : 'Lanjut'),
        ),
      ) : null,
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1: return _buildStep1();
      case 2: return _buildStep2();
      case 3: return _buildStep3();
      case 4: return _buildStep4();
      default: return const SizedBox();
    }
  }

  Widget _buildStep1() {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Beri nama tripmu.', style: textTheme.headlineLarge),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            autofocus: true,
            style: textTheme.headlineMedium,
            decoration: const InputDecoration(
              hintText: 'Weekend di Bandung',
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dari mana, ke mana?', style: textTheme.headlineLarge),
          const SizedBox(height: 32),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Column(
                children: [
                  _buildLocationCard(
                    label: 'Dari',
                    value: _origin,
                    icon: Icons.trip_origin,
                    onTap: () => _showLocationPicker('Dari'),
                  ),
                  const SizedBox(height: 8),
                  _buildLocationCard(
                    label: 'Ke',
                    value: _destination,
                    icon: Icons.location_on,
                    onTap: () => _showLocationPicker('Ke'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton.filled(
                  onPressed: () {
                    setState(() {
                      final temp = _origin;
                      _origin = _destination;
                      _destination = temp;
                    });
                  },
                  icon: const Icon(Icons.swap_vert),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: colorScheme.primary,
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.primaryContainer.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Rute ini biasanya memakan waktu 3 jam via jalan tol Cipularang.',
                    style: textTheme.labelMedium?.copyWith(color: colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.labelSmall),
                Text(value, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationPicker(String type) {
    final cities = ['Jakarta', 'Bandung', 'Yogyakarta', 'Bali', 'Malang', 'Surabaya', 'Semarang'];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilih Kota $type', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(cities[index]),
                      onTap: () {
                        setState(() {
                          if (type == 'Dari') {
                            _origin = cities[index];
                          } else {
                            _destination = cities[index];
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStep3() {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final dateFormat = DateFormat('dd MMM yyyy');

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kapan kamu pergi?', style: textTheme.headlineLarge),
          const SizedBox(height: 32),
          
          // Start Date Card
          _buildDateCard(
            label: 'Tanggal Mulai',
            value: dateFormat.format(_startDate),
            icon: Icons.calendar_today,
            onTap: () => _selectDateRange(context),
          ),
          const SizedBox(height: 16),
          
          // End Date Card
          _buildDateCard(
            label: 'Tanggal Selesai',
            value: dateFormat.format(_endDate),
            icon: Icons.event,
            onTap: () => _selectDateRange(context),
          ),
          
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.primaryContainer.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Durasi perjalanan: ${_endDate.difference(_startDate).inDays + 1} hari',
                    style: textTheme.labelMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            'Tips: Pilih rentang tanggal untuk menyusun rencana harian yang lebih akurat.',
            style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.labelSmall),
                Text(value, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            Icon(Icons.edit_calendar_outlined, color: colorScheme.outline, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: colorScheme.copyWith(
              primary: colorScheme.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Widget _buildStep4() {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pakai kendaraan apa?', style: textTheme.headlineLarge),
          const SizedBox(height: 32),
          InkWell(
            onTap: () => setState(() => _vehicleType = 'Motor'),
            child: _buildVehicleOption(Icons.motorcycle, 'Motor', _vehicleType == 'Motor'),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => setState(() => _vehicleType = 'Mobil'),
            child: _buildVehicleOption(Icons.directions_car, 'Mobil', _vehicleType == 'Mobil'),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleOption(IconData icon, String label, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.surfaceVariant.withOpacity(0.3) : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? colorScheme.primary : colorScheme.outlineVariant, width: isSelected ? 2 : 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isSelected ? colorScheme.primaryContainer : colorScheme.surfaceVariant,
            child: Icon(icon, color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 16),
          Text(label, style: textTheme.titleLarge),
          const Spacer(),
          if (isSelected) 
            Icon(Icons.check_circle, color: colorScheme.primary)
          else
            Container(width: 24, height: 24, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: colorScheme.outlineVariant))),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Scaffold(
        backgroundColor: colorScheme.surface,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle, size: 80, color: colorScheme.primary),
                ),
                const SizedBox(height: 32),
                Text('Trip dibuat!', style: textTheme.headlineLarge),
                const SizedBox(height: 16),
                Text(
                  '${_nameController.text.isEmpty ? 'Trip Baru' : _nameController.text} siap kamu rencanakan.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 64),
                ElevatedButton(
                  onPressed: () => context.go('/trip-detail'),
                  child: const Text('Lihat Detail Trip'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go('/'),
                  child: Text('Ke Home', style: TextStyle(color: colorScheme.secondary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
