enum SupportChatsEventWidgetsType { records, mobileWidgets, none }

class SupportChatsEventWidgets {
  final SupportChatsEventWidgetsType type;
  final String label;
  const SupportChatsEventWidgets({required this.type, required this.label});
}
