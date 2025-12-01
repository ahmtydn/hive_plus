library hive_plus_secure;

import 'dart:async';
import 'dart:isolate'
    if (dart.library.html) 'package:hive_plus_secure/src/impl/isolate_stub.dart';

import 'package:hive_plus_secure/src/impl/frame.dart';
import 'package:isar_plus/isar_plus.dart';

export 'package:isar_plus/isar_plus.dart'
    show ChangeDetail, ChangeType, DocumentSerializable, EncryptionError;

part 'src/box.dart';
part 'src/hive.dart';
part 'src/impl/box_impl.dart';
part 'src/impl/type_registry.dart';
