class Hotel {
  final String name;
  final String location;
  final String imageUrl;
  final double pricePerNight;
  final double rating;
  final List<String> facilities;

  Hotel({
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.pricePerNight,
    required this.rating,
    required this.facilities,
  });
}
