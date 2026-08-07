class AttachmentUuidService {
  AttachmentUuidService._();
  static final I = AttachmentUuidService._();
  final Map<String, String> _names = {};

  void save({required String uuid, required String fileName}) {
    _names[uuid] = fileName;
  }

  String? get(String uuid) {
    return _names[uuid];
  }

  void remove(String uuid) {
    _names.remove(uuid);
  }
}
