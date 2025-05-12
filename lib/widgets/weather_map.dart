import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:viweather1/services/location_service.dart';

class WeatherMap extends StatefulWidget {
  final double latitude;
  final double longitude;
  final Function(double lat, double lon) onLocationSelected;

  const WeatherMap({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<WeatherMap> createState() => _WeatherMapState();
}

class _WeatherMapState extends State<WeatherMap> {
  late final MapController _mapController;
  final LocationService _locationService = LocationService();
  LatLng? _selectedLocation;
  bool _isLoading = false;
  double _currentZoom = 10.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _selectedLocation = LatLng(widget.latitude, widget.longitude);
  }

  @override
  void didUpdateWidget(WeatherMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.latitude != widget.latitude || oldWidget.longitude != widget.longitude) {
      _selectedLocation = LatLng(widget.latitude, widget.longitude);
      _mapController.move(
        _selectedLocation!,
        _currentZoom,
      );
    }
  }

  void _handleZoomIn() {
    final newZoom = _currentZoom + 1;
    if (newZoom <= 18) { // Максимальный зум для OpenStreetMap
      setState(() {
        _currentZoom = newZoom;
      });
      _mapController.move(_selectedLocation!, _currentZoom);
    }
  }

  void _handleZoomOut() {
    final newZoom = _currentZoom - 1;
    if (newZoom >= 3) { // Минимальный зум для комфортного просмотра
      setState(() {
        _currentZoom = newZoom;
      });
      _mapController.move(_selectedLocation!, _currentZoom);
    }
  }

  Future<void> _handleTap(LatLng location) async {
    setState(() {
      _isLoading = true;
      _selectedLocation = location;
    });

    try {
      widget.onLocationSelected(location.latitude, location.longitude);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting location: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _selectedLocation,
                zoom: _currentZoom,
                onTap: (_, location) => _handleTap(location),
                onMapReady: () {
                  _mapController.move(_selectedLocation!, _currentZoom);
                },
                interactiveFlags: InteractiveFlag.all,
                enableScrollWheel: true,
                enableMultiFingerGestureRace: true,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.viweather1',
                ),
                MarkerLayer(
                  markers: [
                    if (_selectedLocation != null)
                      Marker(
                        point: _selectedLocation!,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Кнопки масштабирования
        Positioned(
          right: 8,
          top: 8,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: _handleZoomIn,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      color: Colors.black87,
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove, size: 20),
                      onPressed: _handleZoomOut,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_isLoading)
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.3),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
} 