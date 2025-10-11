part of hive_plus_secure;

/// Built-in types that don't require custom serialization handlers.
/// These types are handled natively by the storage layer.
const _builtinTypes = {
  bool: _TypeHandler<bool>.builtin(),
  num: _TypeHandler<num>.builtin(),
  String: _TypeHandler<String>.builtin(),
  List: _TypeHandler<List<dynamic>>.builtin(),
  Map: _TypeHandler<Map<String, dynamic>>.builtin(),
};

/// Central registry for managing type serialization and deserialization.
///
/// This registry maintains bidirectional mappings between:
/// - Type IDs (integers) and their serialization handlers
/// - Dart runtime types and their handlers
///
/// The registry enables efficient type lookup during both serialization
/// (finding handlers by runtime type) and deserialization
/// (finding handlers by type ID).
class _TypeRegistry {
  /// Maps type IDs to their corresponding handlers for deserialization.
  final Map<int, _TypeHandler<dynamic>> _handlersByTypeId = {};

  /// Maps runtime types to their handlers for serialization.
  /// Initialized with built-in types that don't need custom handling.
  final Map<Type, _TypeHandler<dynamic>> _handlersByRuntimeType = {
    ..._builtinTypes,
  };

  /// Registers a custom type with the registry.
  ///
  /// [typeId] - Unique identifier for this type in serialized form
  /// [fromJson] - Deserializer function that reconstructs objects from JSON
  /// [type] - Optional explicit type (useful for generic types); defaults to T
  /// [toJson] - Optional serializer function that converts objects to JSON
  ///
  /// Throws [ArgumentError] if attempting to register `dynamic`.
  void register<T>(
    int typeId,
    T? Function(Map<String, dynamic> json) fromJson,
    Type? type, [
    Map<String, dynamic>? Function(T value)? toJson,
  ]) {
    if (T == dynamic) {
      throw ArgumentError(
        'Cannot register dynamic type. '
        'Provide an explicit type parameter when calling register.',
      );
    }

    final registeredType = type ?? T;
    final handler = _TypeHandler<T>(
      typeId: typeId,
      fromJson: fromJson,
      toJson: _wrapToJson(toJson),
    );

    _handlersByTypeId[typeId] = handler;
    _handlersByRuntimeType[registeredType] = handler;
  }

  /// Wraps the type-safe toJson function to accept dynamic parameters.
  /// This enables internal flexibility while maintaining
  /// type safety at the API boundary.
  Map<String, dynamic>? Function(dynamic)? _wrapToJson<T>(
    Map<String, dynamic>? Function(T value)? toJson,
  ) {
    if (toJson == null) return null;
    return (dynamic value) => toJson(value as T);
  }

  /// Deserializes a value from JSON using the registered
  /// handler for the given type ID.
  ///
  /// If [typeId] is null, assumes the value is already in
  /// its final form (built-in type).
  /// Otherwise, looks up the appropriate handler and applies deserialization.
  ///
  /// Returns the deserialized value cast to [T].
  ///
  /// Throws [StateError] if no handler is registered for the given type ID.
  /// Throws [ArgumentError] if the deserialized value
  /// doesn't match expected type [T].
  T fromJson<T>(int? typeId, dynamic json) {
    if (typeId == null) {
      return _castOrThrow<T>(json);
    }

    final handler = _handlersByTypeId[typeId];
    if (handler == null) {
      throw StateError(
        'No handler registered for type ID $typeId. '
        'Ensure you register this type before attempting deserialization.',
      );
    }

    if (json is! Map<String, dynamic>) {
      throw ArgumentError(
        'Expected Map<String, dynamic> for custom type deserialization, '
        'but received ${json.runtimeType}.',
      );
    }

    final deserialized = handler.fromJson(json);
    return _castOrThrow<T>(deserialized);
  }

  /// Safely casts a value to type [T] or throws a descriptive error.
  T _castOrThrow<T>(dynamic value) {
    if (value is T) {
      return value;
    }
    throw ArgumentError(
      'Type mismatch during deserialization. '
      'Expected $T but received ${value.runtimeType}.',
    );
  }

  /// Finds the type ID associated with the given value's runtime type.
  ///
  /// Uses a two-phase lookup strategy:
  /// 1. Direct lookup by exact runtime type (O(1), cached)
  /// 2. Linear search through registered handlers for inheritance/interface matches (O(n))
  ///
  /// When a match is found via linear search, it's cached for future lookups.
  /// Returns null if no handler is registered for this type.
  int? findTypeId(dynamic value) {
    final runtimeType = value.runtimeType;

    // Fast path: exact type match
    final cachedHandler = _handlersByRuntimeType[runtimeType];
    if (cachedHandler != null) {
      return cachedHandler.typeId;
    }

    // Slow path: check inheritance/interface compatibility
    for (final entry in _handlersByRuntimeType.entries) {
      if (entry.value.handlesValue(value)) {
        // Cache this match for future lookups
        _handlersByRuntimeType[runtimeType] = entry.value;
        return entry.value.typeId;
      }
    }

    return null;
  }

  /// Serializes a value to JSON using its registered handler.
  ///
  /// Uses the same two-phase lookup strategy as [findTypeId].
  /// Returns null if no handler is registered or the
  /// handler doesn't provide serialization.
  Map<String, dynamic>? toJson(dynamic value) {
    final runtimeType = value.runtimeType;

    // Fast path: exact type match
    final cachedHandler = _handlersByRuntimeType[runtimeType];
    if (cachedHandler?.toJson != null) {
      return cachedHandler!.toJson!(value);
    }

    // Slow path: check inheritance/interface compatibility
    for (final entry in _handlersByRuntimeType.entries) {
      if (entry.value.handlesValue(value) && entry.value.toJson != null) {
        // Cache this match for future lookups
        _handlersByRuntimeType[runtimeType] = entry.value;
        return entry.value.toJson!(value);
      }
    }

    return null;
  }

  /// Clears all registered handlers and restores built-in types.
  /// Useful for testing or when reinitializing the registry.
  void reset() {
    _handlersByTypeId.clear();
    _handlersByRuntimeType
      ..clear()
      ..addAll(_builtinTypes);
  }
}

/// Placeholder function that should never be called.
/// Used for built-in types that don't require custom deserialization.
Never _noop<T>(Map<String, dynamic> json) {
  throw UnimplementedError(
    'Built-in types should not use custom deserialization handlers.',
  );
}

/// Encapsulates serialization/deserialization logic for a specific type.
///
/// Each handler knows:
/// - Its unique type ID for wire format identification
/// - How to deserialize instances from JSON
/// - How to serialize instances to JSON (optional)
/// - Which values it can handle (via runtime type checking)
class _TypeHandler<T> {
  const _TypeHandler({
    required this.typeId,
    required this.fromJson,
    this.toJson,
  });

  /// Creates a handler for built-in types that don't need custom serialization.
  const _TypeHandler.builtin()
      : typeId = null,
        fromJson = _noop<T>,
        toJson = null;

  /// Unique identifier for this type in serialized form.
  /// Null for built-in types that are handled natively.
  final int? typeId;

  /// Deserializes a value from its JSON representation.
  final T? Function(Map<String, dynamic> json) fromJson;

  /// Serializes a value to its JSON representation.
  /// Optional; some types may only support deserialization.
  final Map<String, dynamic>? Function(dynamic value)? toJson;

  /// Checks whether this handler can process the given value.
  /// Uses runtime type checking to support inheritance and interfaces.
  bool handlesValue(dynamic value) => value is T;
}
