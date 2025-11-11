import 'package:geolocator/geolocator.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<LocationEntity> getCurrentLocation() async {
    final Position position = await dataSource.getCurrentPosition();
    return LocationEntity(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
