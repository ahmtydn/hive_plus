part of hive_plus_secure;

final _builtinTypes = <Type, _TypeHandler<dynamic>>{
  bool: const _TypeHandler<bool>.builtin(bool),
  num: const _TypeHandler<num>.builtin(num),
  String: const _TypeHandler<String>.builtin(String),
  List: const _TypeHandler<List<dynamic>>.builtin(List),
  Map: const _TypeHandler<Map<String, dynamic>>.builtin(Map),
};

class _TypeRegistry {
  final Map<int, _TypeHandler<dynamic>> _registry = {};
  final Map<Type, _TypeHandler<dynamic>> _reverseRegistry = {..._builtinTypes};

  void register<T>(
    Type type,
    int typeId,
    T? Function(dynamic json) fromJson,
    Map<String, dynamic>? Function(T value)? toJson,
  ) {
    if (type == dynamic) {
      throw ArgumentError('Cannot register dynamic type.');
    }

    // Wrap toJson to accept dynamic and cast to T
    Map<String, dynamic>? Function(dynamic)? wrappedToJson;
    if (toJson != null) {
      wrappedToJson = (dynamic value) {
        if (value is T) {
          return toJson(value);
        }
        throw ArgumentError(
          'Type mismatch in toJson. Expected $T but got ${value.runtimeType}.',
        );
      };
    }

    final handler = _TypeHandler<T>(
      type,
      typeId,
      (map) => fromJson(map),
      wrappedToJson,
    );
    _registry[typeId] = handler;
    _reverseRegistry[type] = handler;
  }

  T fromJson<T>(int? typeId, dynamic json) {
    dynamic value = json;
    if (typeId != null) {
      final handler = _registry[typeId];
      if (handler == null) {
        throw StateError(
          'Type is not registered. Did you forget to register it?',
        );
      }
      if (json is Map<String, dynamic>) {
        value = handler.fromJson(json);
      } else {
        throw ArgumentError('Type mismatch. Expected Map<String,dynamic> '
            'but got ${json.runtimeType}.');
      }
    }

    if (value is T) {
      return value;
    } else {
      throw ArgumentError(
        'Type mismatch. Expected $T but got ${value.runtimeType}.',
      );
    }
  }

  dynamic toJson(dynamic value) {
    final handler = _reverseRegistry[value.runtimeType];
    if (handler != null && handler.toJson != null) {
      return handler.toJson!(value);
    }

    // Check if the value matches any registered handler
    for (final MapEntry(key: type, value: h) in _reverseRegistry.entries) {
      if (h.handlesValue(value) && h.toJson != null) {
        _reverseRegistry[type] = h;
        return h.toJson!(value);
      }
    }

    // If no handler found, return value as-is for built-in types
    return value;
  }

  int? findTypeId(dynamic value) {
    final handler = _reverseRegistry[value.runtimeType];
    if (handler != null) {
      return handler.typeId;
    }

    for (final MapEntry(key: type, value: handler)
        in _reverseRegistry.entries) {
      if (handler.handlesValue(value)) {
        _reverseRegistry[type] = handler;
        return handler.typeId;
      }
    }

    return null;
  }

  void reset() {
    _registry.clear();
    _reverseRegistry.clear();
    _reverseRegistry.addAll(_builtinTypes);
  }
}

T? _noop<T>(Map<String, dynamic> json) {
  throw UnimplementedError();
}

class _TypeHandler<T> {
  const _TypeHandler(
    this.type,
    this.typeId,
    this.fromJson,
    this.toJson,
  );

  const _TypeHandler.builtin(this.type)
      : typeId = null,
        fromJson = _noop,
        toJson = null;

  final Type type;
  final int? typeId;

  final T? Function(Map<String, dynamic> json) fromJson;
  final Map<String, dynamic>? Function(dynamic value)? toJson;

  bool handlesValue(dynamic value) {
    return value.runtimeType == type || value is T;
  }
}
