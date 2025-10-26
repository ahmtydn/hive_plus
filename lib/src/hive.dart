part of hive_plus_secure;

/// Open boxes and register adapters.
class Hive {
  static var _typeRegistry = _TypeRegistry();
  static final _openBoxes = <String, Box<dynamic>>{};

  /// The default name if you don't specify a name for a box.
  static const defaultName = 'hive_plus';

  /// The default directory for all boxes.
  static String? defaultDirectory;

  /// Registers a type adapter to allow Hive to (de)serialize your objects.
  ///
  /// Example:
  /// ```dart
  /// class Person {
  ///   String name;
  ///   int age;
  ///
  ///   factory Person.fromJson(Map<String, dynamic> json) {
  ///     return Person()
  ///       ..name = json['name'] as String
  ///       ..age = json['age'] as int;
  ///     }
  ///
  ///   Map<String, dynamic> toJson() {
  ///     return {
  ///       'name': name,
  ///       'age': age,
  ///     };
  ///   }
  /// }
  ///
  /// Hive.registerAdapter(
  ///   'Person',
  ///   Person.fromJson,
  ///   Person,
  ///   (p) => p.toJson(),
  /// );
  /// ```
  static void registerAdapter<T>(
    String typeName,
    T? Function(dynamic json) fromJson, [
    Type? type,
    Map<String, dynamic>? Function(T value)? toJson,
  ]) {
    final resolvedType = type ?? T;
    if (resolvedType == dynamic) {
      throw ArgumentError('Cannot register adapter for dynamic type.');
    }
    _typeRegistry.register<T>(
      resolvedType,
      Isar.fastHash(typeName),
      fromJson,
      toJson,
    );
  }

  /// Get or open the box with [name] in the given [directory]. If no directory
  /// is specified, the default directory is used.
  ///
  /// If the box is already open, the same instance is returned.
  ///
  /// The [encryptionKey] is used to encrypt the box. If the box was already
  /// opened with a different encryption key, an error is thrown.
  ///
  /// The [maxSizeMiB] is the maximum size of the box in MiB. If the box grows
  /// bigger than this, an exception is thrown. It is recommended to set this
  /// value to a small value if possible.
  ///
  /// The [inspector] parameter allows enabling/disabling the Isar Inspector
  /// for debugging purposes. Defaults to `true` for backward compatibility.
  static Box<E> box<E>({
    String name = defaultName,
    String? directory,
    String? encryptionKey,
    int maxSizeMiB = 5,
    bool inspector = true,
  }) {
    final box = _openBoxes[name];
    if (box != null) {
      if (box is Box<E>) {
        return box;
      } else {
        throw ArgumentError('Box was already opened with a different type. '
            'Expected Box<${box.runtimeType}> but got Box<$E>.');
      }
    }

    final dir = directory ?? defaultDirectory;
    if (dir == null) {
      throw ArgumentError(
        'No directory specified and no default directory set.',
        'directory',
      );
    }

    final isar = Isar.open(
      name: name,
      schemas: [FrameSchema],
      directory: dir,
      engine: encryptionKey != null ? IsarEngine.sqlite : IsarEngine.isar,
      maxSizeMiB: maxSizeMiB,
      encryptionKey: encryptionKey,
      inspector: inspector,
    );
    final newBox = _BoxImpl<E>(isar);
    _openBoxes[name] = newBox;
    return newBox;
  }

  /// Runs [computation] in a new isolate and returns the result. Also takes
  /// care of initializing Hive and closing all boxes afterwards.
  ///
  /// The optional [debugName] can be used to identify the isolate in debuggers.
  static Future<T> compute<T>(
    FutureOr<T> Function() computation, {
    String? debugName,
  }) {
    final registry = _typeRegistry;
    final dir = defaultDirectory;
    return Isolate.run(
      () async {
        Hive._typeRegistry = registry;
        Hive.defaultDirectory = dir;
        try {
          return await computation();
        } finally {
          Hive.closeAllBoxes();
        }
      },
      debugName: debugName ?? 'Hive Isolate',
    );
  }

  /// Closes all open boxes.
  static void closeAllBoxes() {
    for (final box in _openBoxes.values) {
      box.close();
    }
  }

  /// Closes all open boxes and delete their data.
  ///
  /// If a box is still open in another isolate, it will not be deleted.
  static void deleteAllBoxesFromDisk() {
    for (final box in _openBoxes.values) {
      box.deleteFromDisk();
    }
  }

  /// Drop a database without opening it first.
  ///
  /// This is useful when you need to drop a corrupted or encrypted database
  /// that cannot be opened with the current encryption key.
  ///
  /// [name] is the name of the database to drop.
  ///
  /// [directory] is the directory where the database files are stored.
  ///
  /// [encryptionKey] determines the storage engine used
  /// (SQLite if provided, Isar if null).
  static void dropDatabase({
    required String name,
    required String directory,
    String? encryptionKey,
  }) {
    Isar.deleteDatabase(
      name: name,
      directory: directory,
      engine: encryptionKey != null ? IsarEngine.sqlite : IsarEngine.isar,
    );

    // Remove from open boxes if it was open
    _openBoxes.remove(name);
  }
}
