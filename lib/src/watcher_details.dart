part of hive_plus_secure;

/// Represents the type of change that occurred.
enum HiveChangeType {
  /// A new key-value pair was inserted.
  insert,

  /// An existing key-value pair was updated.
  update,

  /// A key-value pair was deleted.
  delete,
}

/// Represents a detailed field-level change.
@immutable
class HiveFieldChange {
  /// Creates a new field change.
  const HiveFieldChange({
    required this.fieldName,
    this.oldValue,
    this.newValue,
  });

  /// Creates a HiveFieldChange from JSON.
  factory HiveFieldChange.fromJson(Map<String, dynamic> json) {
    return HiveFieldChange(
      fieldName: json['fieldName'] as String,
      oldValue: json['oldValue'] as String?,
      newValue: json['newValue'] as String?,
    );
  }

  /// The name of the field that changed.
  final String fieldName;

  /// The old value of the field (null for new insertions).
  final String? oldValue;

  /// The new value of the field (null for deletions).
  final String? newValue;

  /// Converts this HiveFieldChange to JSON.
  Map<String, dynamic> toJson() {
    return {
      'fieldName': fieldName,
      'oldValue': oldValue,
      'newValue': newValue,
    };
  }

  @override
  String toString() => 'HiveFieldChange('
      'fieldName: $fieldName, '
      'oldValue: $oldValue, '
      'newValue: $newValue)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveFieldChange &&
          runtimeType == other.runtimeType &&
          fieldName == other.fieldName &&
          oldValue == other.oldValue &&
          newValue == other.newValue;

  @override
  int get hashCode => Object.hash(fieldName, oldValue, newValue);
}

/// Represents a detailed change notification for a key-value pair in Hive.
@immutable
class HiveChangeDetail {
  /// Creates a new change detail.
  const HiveChangeDetail({
    required this.changeType,
    required this.boxName,
    required this.key,
    required this.fieldChanges,
    required this.timestamp,
  });

  /// Creates a HiveChangeDetail from JSON.
  factory HiveChangeDetail.fromJson(Map<String, dynamic> json) {
    return HiveChangeDetail(
      changeType: HiveChangeType.values.firstWhere(
        (e) => e.toString().split('.').last == json['changeType'],
      ),
      boxName: json['boxName'] as String,
      key: json['key'] as String,
      fieldChanges: (json['fieldChanges'] as List<dynamic>)
          .map((item) => HiveFieldChange.fromJson(item as Map<String, dynamic>))
          .toList(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// The type of change that occurred.
  final HiveChangeType changeType;

  /// The name of the box where the change occurred.
  final String boxName;

  /// The key that was changed.
  final String key;

  /// The list of field-level changes.
  final List<HiveFieldChange> fieldChanges;

  /// The timestamp when the change occurred.
  final DateTime timestamp;

  /// Converts this HiveChangeDetail to JSON.
  Map<String, dynamic> toJson() {
    return {
      'changeType': changeType.toString().split('.').last,
      'boxName': boxName,
      'key': key,
      'fieldChanges': fieldChanges.map((fc) => fc.toJson()).toList(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() => 'HiveChangeDetail('
      'changeType: $changeType, '
      'boxName: $boxName, '
      'key: $key, '
      'fieldChanges: $fieldChanges, '
      'timestamp: $timestamp)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveChangeDetail &&
          runtimeType == other.runtimeType &&
          changeType == other.changeType &&
          boxName == other.boxName &&
          key == other.key &&
          fieldChanges == other.fieldChanges &&
          timestamp == other.timestamp;

  @override
  int get hashCode =>
      Object.hash(changeType, boxName, key, fieldChanges, timestamp);
}
