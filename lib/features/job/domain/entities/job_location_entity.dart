class JobLocationEntity{
  final String name;
  final String? detail;
  final double latitude;
  final double longitude;

  const JobLocationEntity({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.detail,
  });
}