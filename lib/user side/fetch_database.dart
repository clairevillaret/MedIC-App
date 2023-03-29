class Hospital{
  final String name;
  final double latitude;
  final double longitude;

  const Hospital({
    required this.name,
    required this.latitude,
    required this.longitude,

  });

  factory Hospital.fromMap(Map<dynamic, dynamic> map) {
    return Hospital(
      name: map['name'] ?? '',
      latitude: map['latitude'] ?? '',    //this is from real time database
      longitude: map['longitude'] ?? '',
    );
  }

}