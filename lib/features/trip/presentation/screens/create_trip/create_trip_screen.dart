import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:singgah/features/destination/domain/entities/destination.dart';
import 'package:singgah/features/destination/presentation/providers/destination_provider.dart';
import 'package:singgah/features/trip/domain/entities/trip.dart';
import 'package:singgah/features/trip/presentation/providers/trip_provider.dart';

class CreateTripScreen extends ConsumerStatefulWidget {
  const CreateTripScreen({super.key});

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  int _currentStep = 1;
  final int _totalSteps = 5;

  // Form State
  final _nameController = TextEditingController();
  final _searchPlaceController = TextEditingController();
  String _origin = 'Jakarta';
  String _destination = 'Bandung';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 2));
  String _vehicleType = 'Mobil';
  final List<Destination> _selectedDestinations = [];
  String _activeCategory = 'Semua';

  // City Coordinates mapping for API
  final Map<String, ({double lat, double lon})> _cityCoords = {
    'Jakarta': (lat: -6.2088, lon: 106.8456),
    'Bandung': (lat: -6.9175, lon: 107.6191),
    'Yogyakarta': (lat: -7.7956, lon: 110.3695),
    'Bali': (lat: -8.3405, lon: 115.0920),
    'Malang': (lat: -7.9839, lon: 112.6214),
    'Surabaya': (lat: -7.2575, lon: 112.7521),
    'Semarang': (lat: -7.0051, lon: 110.4381),
  };

  @override
  void dispose() {
    _nameController.dispose();
    _searchPlaceController.dispose();
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
      itinerary: _selectedDestinations,
    );

    ref.read(tripsProvider.notifier).addTrip(newTrip);
    _showSuccessDialog(newTrip.id);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(_currentStep == 1 ? Icons.close : Icons.arrow_back, 
                color: const Color(0xFF1B4332)),
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
            Text('Trip baru', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
                    color: isActive ? const Color(0xFF1B4332) : colorScheme.outlineVariant,
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: ElevatedButton(
          onPressed: () {
            if (_currentStep < 5) {
              setState(() => _currentStep++);
            } else {
              _handleCreateTrip();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B4332),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(_currentStep == 5 ? 'Selesaikan Rencana' : 'Lanjut'),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1: return _buildStep1();
      case 2: return _buildStep2();
      case 3: return _buildStep3();
      case 4: return _buildStep4();
      case 5: return _buildStep5();
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
          Text('Beri nama tripmu.', style: textTheme.headlineLarge?.copyWith(color: const Color(0xFF1B4332), fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            autofocus: true,
            style: textTheme.headlineMedium,
            decoration: const InputDecoration(
              hintText: 'Misal: Liburan Seru di Bali',
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF1B4332), width: 2)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF1B4332), width: 3)),
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
          Text('Tentukan tujuan.', style: textTheme.headlineLarge?.copyWith(color: const Color(0xFF1B4332), fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildLocationCard(label: 'Dari Mana', value: _origin, icon: Icons.trip_origin, onTap: () => _showLocationPicker('Dari')),
          const SizedBox(height: 12),
          Center(child: Icon(Icons.arrow_downward, color: colorScheme.outlineVariant)),
          const SizedBox(height: 12),
          _buildLocationCard(label: 'Tujuan Ke', value: _destination, icon: Icons.location_on, onTap: () => _showLocationPicker('Ke')),
        ],
      ),
    );
  }

  Widget _buildLocationCard({required String label, required String value, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1B4332)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.expand_more, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showLocationPicker(String type) {
    final cities = _cityCoords.keys.toList();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih Kota $type', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cities.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(cities[index], style: const TextStyle(fontSize: 16)),
                  onTap: () {
                    setState(() {
                      if (type == 'Dari') _origin = cities[index];
                      else _destination = cities[index];
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3() {
    final textTheme = Theme.of(context).textTheme;
    final dateFormat = DateFormat('dd MMM yyyy');
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Atur waktu.', style: textTheme.headlineLarge?.copyWith(color: const Color(0xFF1B4332), fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildDateCard(label: 'Durasi Perjalanan', value: '${dateFormat.format(_startDate)} - ${dateFormat.format(_endDate)}', onTap: () => _selectDateRange(context)),
          const SizedBox(height: 24),
          Text('Total: ${_endDate.difference(_startDate).inDays + 1} Hari', style: textTheme.titleMedium?.copyWith(color: const Color(0xFF1B4332), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDateCard({required String label, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFFF0F5F2), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            const Icon(Icons.calendar_month, color: Color(0xFF1B4332)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );
    if (picked != null) setState(() { _startDate = picked.start; _endDate = picked.end; });
  }

  Widget _buildStep4() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pilih kendaraan.', style: TextStyle(fontSize: 32, color: Color(0xFF1B4332), fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildVehicleOption(Icons.directions_car, 'Mobil', _vehicleType == 'Mobil'),
          const SizedBox(height: 16),
          _buildVehicleOption(Icons.motorcycle, 'Motor', _vehicleType == 'Motor'),
        ],
      ),
    );
  }

  Widget _buildVehicleOption(IconData icon, String label, bool isSelected) {
    return InkWell(
      onTap: () => setState(() => _vehicleType = label),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F0EA) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFF1B4332) : Colors.grey.shade300, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF1B4332) : Colors.grey),
            const SizedBox(width: 16),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isSelected ? const Color(0xFF1B4332) : Colors.black87)),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF1B4332)),
          ],
        ),
      ),
    );
  }

  Widget _buildStep5() {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    // Ambil koordinat kota tujuan
    final coords = _cityCoords[_destination] ?? _cityCoords['Jakarta']!;
    final nearbyPlacesAsync = ref.watch(nearbyDestinationsProvider((lat: coords.lat, lon: coords.lon)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Text('Tambah destinasi di $_destination.', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
        ),
        
        // Category Filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: ['Semua', 'Wisata', 'Cafe', 'Hotel', 'Belanja'].map((cat) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(cat),
                selected: _activeCategory == cat,
                onSelected: (val) => setState(() => _activeCategory = cat),
                selectedColor: const Color(0xFF1B4332),
                labelStyle: TextStyle(color: _activeCategory == cat ? Colors.white : const Color(0xFF1B4332)),
              ),
            )).toList(),
          ),
        ),

        if (_selectedDestinations.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: _selectedDestinations.map((d) => Chip(
                label: Text(d.name, style: const TextStyle(fontSize: 11)),
                onDeleted: () => setState(() => _selectedDestinations.remove(d)),
                backgroundColor: const Color(0xFFE8F0EA),
              )).toList(),
            ),
          ),

        Expanded(
          child: nearbyPlacesAsync.when(
            data: (places) {
              final filtered = places.where((p) => _activeCategory == 'Semua' || p.category == _activeCategory).toList();
              return ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final place = filtered[index];
                  final isSelected = _selectedDestinations.any((d) => d.id == place.id);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE8F0EA) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? const Color(0xFF1B4332) : colorScheme.outlineVariant),
                    ),
                    child: ListTile(
                      title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${place.category} • ${place.location}'),
                      trailing: Icon(isSelected ? Icons.check_circle : Icons.add_circle_outline, color: const Color(0xFF1B4332)),
                      onTap: () {
                        setState(() {
                          if (isSelected) _selectedDestinations.removeWhere((d) => d.id == place.id);
                          else _selectedDestinations.add(place);
                        });
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => const Center(child: Text('Gagal memuat rekomendasi tempat')),
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog(String tripId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 100, color: Color(0xFF1B4332)),
                const SizedBox(height: 32),
                const Text('Trip Berhasil Dibuat!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
                const SizedBox(height: 16),
                const Text('Rencana perjalananmu telah siap. Mari mulai petualangan!', textAlign: TextAlign.center),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () => context.go('/trip-detail/$tripId'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B4332), minimumSize: const Size.fromHeight(56)),
                  child: const Text('Lihat Detail Perjalanan', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
