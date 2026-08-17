class NotificationParameterOption {
  final Object value;
  final String label;
  final String? description;
  final String? imageUrl;

  const NotificationParameterOption({
    required this.value,
    required this.label,
    this.description,
    this.imageUrl,
  });
}


