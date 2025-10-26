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
  ) {
    if (type == dynamic) {
      throw ArgumentError('Cannot register dynamic type.');
    }

    final handler = _TypeHandler<T>(
      type,
      typeId,
      (map) => fromJson(map),
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
  const _TypeHandler(this.type, this.typeId, this.fromJson);

  const _TypeHandler.builtin(this.type)
      : typeId = null,
        fromJson = _noop;

  final Type type;
  final int? typeId;

  final T? Function(Map<String, dynamic> json) fromJson;

  bool handlesValue(dynamic value) {
    return value.runtimeType == type || value is T;
  }
}
