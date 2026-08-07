class PendingMessage {
  final String uuid;
  final String text;
  final List<String> attachments;

  const PendingMessage({
    required this.uuid,
    required this.text,
    required this.attachments,
  });
}
