class NotificationParameterOptionEntity {
  final Object value;
  final String label;
  final String? description;
  final String? imageUrl;

  const NotificationParameterOptionEntity({
    required this.value,
    required this.label,
    this.description,
    this.imageUrl,
  });
}
