import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/shared/infrastructure/services/key_value_storage_service_impl.dart';

final keyValueStorageServiceProvider = Provider<KeyValueStorageServiceImpl>((ref) {
  return KeyValueStorageServiceImpl();
});
