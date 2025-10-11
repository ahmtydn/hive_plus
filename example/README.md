# Hive Plus Comprehensive Example

This example demonstrates all the features and capabilities of Hive Plus, a fast and secure NoSQL database for Flutter and Dart.

## Features Demonstrated

### 1. **Basic Operations**
- **Put & Get**: Store and retrieve key-value pairs
- **Operator Overloading**: Use `box['key']` syntax
- **Default Values**: Provide fallback values for missing keys
- **Key Checking**: Check if a key exists with `containsKey()`
- **Keys & Length**: Access all keys and get box size

### 2. **Complex Data Types**
- **Lists**: Store and retrieve list data
- **Maps**: Store nested map structures
- **Nested Structures**: Handle complex hierarchical data

### 3. **Bulk Operations**
- **putAll()**: Add multiple key-value pairs at once
- **getAll()**: Retrieve multiple values by keys
- **deleteAll()**: Remove multiple entries efficiently

### 4. **List-like Operations**
- **add()**: Append items with auto-increment keys
- **addAll()**: Append multiple items
- **getAt()**: Access values by index
- **putAt()**: Update values by index
- **deleteAt()**: Remove items by index
- **getRange()**: Retrieve a range of values
- **putRange()**: Update a range of values
- **deleteRange()**: Remove a range of values

### 5. **Type Safety**
- Generic type parameters: `Box<String>`, `Box<int>`, etc.
- Compile-time type checking
- Prevents type mismatches

### 6. **Custom Objects**
- Store custom Dart objects
- Automatic JSON serialization/deserialization
- Type registration with `Hive.registerAdapter()`

### 7. **Transactions**
- **Write Transactions**: Atomic batch updates
- **Read Transactions**: Consistent read snapshots
- **Rollback Support**: Automatic rollback on errors

### 8. **Watch Functionality**
- **Basic Watch**: Listen to all changes in a box
- **Key-specific Watch**: Monitor specific keys
- **Real-time Updates**: React to data changes immediately

### 9. **Detailed Watch** (Advanced)
- **Field-level Tracking**: See exactly what changed
- **Change Types**: Insert, Update, Delete
- **Full Document Access**: Get complete objects
- **Custom Parsing**: Parse documents into typed objects
- **DocumentSerializable**: Type-safe document handling

### 10. **Range Operations**
- Get values between specific keys
- Update ranges efficiently
- Delete ranges atomically

### 11. **Key Operations**
- Get key by index with `keyAt()`
- Range queries with `getBetween()`
- Sorted key access

### 12. **Utility Operations**
- **clear()**: Remove all entries
- **close()**: Close a box
- **deleteFromDisk()**: Remove box file completely
- **isEmpty/isNotEmpty**: Check box state

## Running the Example

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

3. Tap the "Run All Demos" button to execute all feature demonstrations

4. Switch between tabs to see:
   - **Logs Tab**: General operation logs
   - **Watch Tab**: Basic watch notifications
   - **Detailed Watch Tab**: Advanced change tracking with field details

## Code Structure

### Main Components

- **HiveDemoScreen**: Main UI component with tabs
- **Person Class**: Simple custom object example
- **User Class**: DocumentSerializable implementation for detailed watch

### Key Methods

- `_demonstrateBasicOperations()`: Basic CRUD operations
- `_demonstrateComplexTypes()`: Lists and maps
- `_demonstrateBulkOperations()`: Batch operations
- `_demonstrateListOperations()`: Array-like usage
- `_demonstrateTypeSafety()`: Generic type parameters
- `_demonstrateCustomObjects()`: Storing custom classes
- `_demonstrateTransactions()`: Atomic operations
- `_demonstrateWatch()`: Basic change listening
- `_demonstrateDetailedWatch()`: Advanced change tracking
- `_demonstrateRangeOperations()`: Range queries and updates
- `_demonstrateKeyOperations()`: Key management
- `_demonstrateClear()`: Box clearing

## Watch Features in Detail

### Basic Watch
```dart
box.watch().listen((event) {
  print('Something changed!');
});
```

### Key-specific Watch
```dart
box.watch(key: 'myKey').listen((event) {
  print('myKey changed!');
});
```

### Detailed Watch
```dart
box.watchDetailed<User>(
  documentParser: (json) => User.fromJson(json),
).listen((change) {
  print('Type: ${change.changeType}');
  print('Object ID: ${change.objectId}');
  print('Fields changed: ${change.fieldChanges.length}');
  print('Full document: ${change.fullDocument.toJson()}');
});
```

## Custom Object Registration

```dart
// Register adapter before opening boxes
Hive.registerAdapter(
  'Person', 
  (json) => Person.fromJson(json as Map<String, dynamic>), 
  Person,
);

// Your class must have fromJson and toJson
class Person {
  final String name;
  final int age;

  Person({required this.name, required this.age});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] as String,
      age: json['age'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'age': age};
  }
}
```

## Detailed Watch Requirements

For `watchDetailed()` to work with typed objects:

1. Implement `DocumentSerializable` interface
2. Provide `toJson()` method
3. Use `documentParser` parameter to provide custom parsing

```dart
class User implements DocumentSerializable {
  final String name;
  final int age;

  User({required this.name, required this.age});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      age: json['age'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'name': name, 'age': age};
  }
}
```

## Platform Support

- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Linux
- ✅ Windows
- ⚠️ Web (limited - `watchDetailed()` not supported)

## Learn More

- [Hive Plus Documentation](https://pub.dev/packages/hive_plus_secure)
- [Main README](../README.md)

## Tips

1. Always initialize `Hive.defaultDirectory` before opening boxes
2. Register adapters before using custom objects
3. Use typed boxes (`Box<T>`) for better type safety
4. Close boxes when no longer needed
5. Use transactions for batch operations
6. Clean up watch subscriptions in `dispose()`
7. Use `clear(notify: false)` to clear without triggering watchers
