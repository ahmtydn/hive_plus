import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_plus_secure/hive_plus_secure.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive with default directory
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;

  // Register custom adapter for Person class
  Hive.registerAdapter(
    'Person',
    (json) => Person.fromJson(json as Map<String, dynamic>),
    Person,
  );

  // Register custom adapter for User class
  Hive.registerAdapter(
    'User',
    (json) => User.fromJson(json as Map<String, dynamic>),
    User,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Plus Demo',
      theme: ThemeData(primarySwatch: Colors.amber, useMaterial3: true),
      home: const HiveDemoScreen(),
    );
  }
}

class HiveDemoScreen extends StatefulWidget {
  const HiveDemoScreen({super.key});

  @override
  State<HiveDemoScreen> createState() => _HiveDemoScreenState();
}

class _HiveDemoScreenState extends State<HiveDemoScreen> {
  late Box<dynamic> defaultBox;
  late Box<String> typedBox;
  late Box<dynamic> watchBox;
  late Box<dynamic> detailedWatchBox;

  final List<String> _logs = [];
  final List<String> _watchLogs = [];
  final List<String> _detailedWatchLogs = [];

  StreamSubscription<void>? _watchSubscription;
  StreamSubscription<ChangeDetail<User>>? _detailedWatchSubscription;

  @override
  void initState() {
    super.initState();
    _initializeBoxes();
  }

  void _initializeBoxes() {
    try {
      // Open default box (unencrypted)
      defaultBox = Hive.box(name: 'demo_box');
      _addLog('✅ Default box opened: ${defaultBox.name}');

      // Open typed box with String type
      typedBox = Hive.box<String>(name: 'typed_box');
      _addLog('✅ Typed box opened: ${typedBox.name}');

      // Open box for watching
      watchBox = Hive.box(name: 'watch_box');
      _addLog('✅ Watch box opened: ${watchBox.name}');

      // Open box for detailed watching (User objects only)
      detailedWatchBox = Hive.box(name: 'detailed_watch_box');
      _addLog('✅ Detailed watch box opened: ${detailedWatchBox.name}');

      // Set up basic watch
      _watchSubscription = watchBox.watch().listen((event) {
        _addWatchLog('📡 Change detected in watch_box');
      });

      // Set up detailed watch with User type
      _detailedWatchSubscription = detailedWatchBox
          .watchDetailed<User>(documentParser: (json) => User.fromJson(json))
          .listen(
            (change) {
              _addDetailedWatchLog(
                '🔍 Detailed change: ${change.changeType.name}\n'
                '   Object ID: ${change.objectId}\n'
                '   Field changes: ${change.fieldChanges.length}\n'
                '   Full document: ${change.fullDocument.toJson()}',
              );
            },
            onError: (error) {
              _addDetailedWatchLog('❌ Watch error: $error');
            },
          );
    } catch (e) {
      _addLog('❌ Error initializing boxes: $e');
    }
  }

  void _addLog(String message) {
    setState(() {
      _logs.add(message);
    });
  }

  void _addWatchLog(String message) {
    setState(() {
      _watchLogs.add(message);
    });
  }

  void _addDetailedWatchLog(String message) {
    setState(() {
      _detailedWatchLogs.add(message);
    });
  }

  // Basic operations
  void _demonstrateBasicOperations() {
    _addLog('\n--- Basic Operations ---');

    // Put and get
    defaultBox.put('name', 'John Doe');
    defaultBox.put('age', 30);
    defaultBox.put('isActive', true);

    _addLog('Put: name = ${defaultBox.get('name')}');
    _addLog('Put: age = ${defaultBox.get('age')}');
    _addLog('Put: isActive = ${defaultBox.get('isActive')}');

    // Using [] operator
    defaultBox['email'] = 'john@example.com';
    _addLog('Using []: email = ${defaultBox['email']}');

    // Default value
    final city = defaultBox.get('city', defaultValue: 'Unknown');
    _addLog('Get with default: city = $city');

    // Contains key
    _addLog('Contains "name": ${defaultBox.containsKey('name')}');
    _addLog('Contains "unknown": ${defaultBox.containsKey('unknown')}');

    // Keys and length
    _addLog('Keys: ${defaultBox.keys}');
    _addLog('Length: ${defaultBox.length}');
  }

  // Complex data types
  void _demonstrateComplexTypes() {
    _addLog('\n--- Complex Data Types ---');

    // Lists
    defaultBox.put('hobbies', ['Reading', 'Coding', 'Gaming']);
    _addLog('List: ${defaultBox.get('hobbies')}');

    // Maps
    defaultBox.put('address', {
      'street': '123 Main St',
      'city': 'New York',
      'zip': '10001',
    });
    _addLog('Map: ${defaultBox.get('address')}');

    // Nested structures
    defaultBox.put('profile', {
      'user': 'John',
      'settings': {'theme': 'dark', 'notifications': true},
      'tags': ['developer', 'flutter'],
    });
    _addLog('Nested: ${defaultBox.get('profile')}');
  }

  // Bulk operations
  void _demonstrateBulkOperations() {
    _addLog('\n--- Bulk Operations ---');

    // putAll
    defaultBox.putAll({'color': 'blue', 'size': 'large', 'quantity': 5});
    _addLog('putAll completed: ${defaultBox.keys}');

    // getAll
    final values = defaultBox.getAll(['color', 'size', 'unknown']);
    _addLog('getAll: $values');

    // deleteAll
    final deleted = defaultBox.deleteAll(['color', 'size']);
    _addLog('deleteAll: $deleted items deleted');
  }

  // List-like operations
  void _demonstrateListOperations() {
    _addLog('\n--- List-like Operations ---');

    final box = Hive.box(name: 'list_box');

    // Add items
    box.add('Apple');
    box.add('Banana');
    box.add('Cherry');
    _addLog('Added 3 items');

    // Get by index
    _addLog('Index 0: ${box.getAt(0)}');
    _addLog('Index 1: ${box[1]}');

    // Update by index
    box.putAt(1, 'Blueberry');
    _addLog('Updated index 1: ${box.getAt(1)}');

    // Get range
    final range = box.getRange(0, 2);
    _addLog('Range [0-2]: $range');

    // Delete by index
    box.deleteAt(0);
    _addLog('Deleted index 0, length: ${box.length}');

    // Add all
    box.addAll(['Date', 'Elderberry', 'Fig']);
    _addLog('Added 3 more, length: ${box.length}');
  }

  // Type safety
  void _demonstrateTypeSafety() {
    _addLog('\n--- Type Safety ---');

    typedBox.put('greeting', 'Hello World');
    typedBox.put('farewell', 'Goodbye');

    _addLog('Typed box (String): ${typedBox.get('greeting')}');
    _addLog('All keys: ${typedBox.keys}');

    // This would cause a compile-time error:
    // typedBox.put('number', 123); // ❌ Error!
  }

  // Custom objects
  void _demonstrateCustomObjects() {
    _addLog('\n--- Custom Objects ---');

    final person1 = Person(name: 'Alice', age: 28, email: 'alice@example.com');

    final person2 = Person(name: 'Bob', age: 35, email: 'bob@example.com');

    defaultBox.put('person1', person1);
    defaultBox.put('person2', person2);

    final retrieved = defaultBox.get('person1') as Person?;
    _addLog('Person: ${retrieved?.toJson()}');
  }

  // Transactions
  void _demonstrateTransactions() {
    _addLog('\n--- Transactions ---');

    // Write transaction
    defaultBox.write(() {
      defaultBox.put('tx1', 'value1');
      defaultBox.put('tx2', 'value2');
      defaultBox.put('tx3', 'value3');
    });
    _addLog('Write transaction completed');

    // Read transaction
    final result = defaultBox.read(() {
      return defaultBox.getAll(['tx1', 'tx2', 'tx3']);
    });
    _addLog('Read transaction result: $result');

    // Atomic transaction (with error)
    try {
      defaultBox.put('counter', 0);
      defaultBox.write(() {
        defaultBox.put('counter', 1);
        throw Exception('Rollback test');
      });
    } catch (e) {
      _addLog(
        'Transaction rolled back: counter = ${defaultBox.get('counter')}',
      );
    }
  }

  // Watch functionality
  void _demonstrateWatch() {
    _addLog('\n--- Watch Operations ---');

    // Make changes to trigger watch
    watchBox.put('test_key', 'test_value');
    watchBox.put('another_key', 123);
    watchBox.delete('test_key');

    _addLog('Made changes to watch_box - check Watch Logs tab');
  }

  // Detailed watch with User objects
  void _demonstrateDetailedWatch() {
    _addLog('\n--- Detailed Watch Operations ---');

    final user1 = User(name: 'Charlie', age: 25, email: 'charlie@example.com');
    final user2 = User(name: 'Diana', age: 30, email: 'diana@example.com');

    detailedWatchBox.put('user1', user1);
    detailedWatchBox.put('user2', user2);

    // Update user
    final updatedUser = User(
      name: 'Charlie',
      age: 26,
      email: 'charlie@example.com',
    );
    detailedWatchBox.put('user1', updatedUser);

    // Delete user
    detailedWatchBox.delete('user2');

    _addLog('Made changes with User objects - check Detailed Watch tab');
  }

  // Range operations
  void _demonstrateRangeOperations() {
    _addLog('\n--- Range Operations ---');

    final box = Hive.box(name: 'range_box');

    // Clear and setup
    box.clear(notify: false);
    box.addAll([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

    // Get range
    final range = box.getRange(2, 5);
    _addLog('Range [2-5]: $range');

    // Put range
    box.putRange(0, 3, ['a', 'b', 'c']);
    _addLog('After putRange [0-3]: ${box.getRange(0, 5)}');

    // Delete range
    box.deleteRange(1, 3);
    _addLog('After deleteRange [1-3], length: ${box.length}');
  }

  // Key operations
  void _demonstrateKeyOperations() {
    _addLog('\n--- Key Operations ---');

    defaultBox.putAll({'alpha': 1, 'beta': 2, 'gamma': 3, 'delta': 4});

    // Get key at index
    _addLog('Key at index 0: ${defaultBox.keyAt(0)}');

    // Get between keys
    final between = defaultBox.getBetween(startKey: 'beta', endKey: 'delta');
    _addLog('Between beta-delta: $between');
  }

  // Clear operations
  void _demonstrateClear() {
    _addLog('\n--- Clear Operations ---');

    final box = Hive.box(name: 'clear_box');
    box.putAll({'a': 1, 'b': 2, 'c': 3});
    _addLog('Before clear: ${box.length} items');

    box.clear();
    _addLog('After clear: ${box.length} items');
  }

  void _runAllDemos() {
    _logs.clear();
    _demonstrateBasicOperations();
    _demonstrateComplexTypes();
    _demonstrateBulkOperations();
    _demonstrateListOperations();
    _demonstrateTypeSafety();
    _demonstrateCustomObjects();
    _demonstrateTransactions();
    _demonstrateRangeOperations();
    _demonstrateKeyOperations();
    _demonstrateWatch();
    _demonstrateDetailedWatch();
    _demonstrateClear();
  }

  @override
  void dispose() {
    _watchSubscription?.cancel();
    _detailedWatchSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hive Plus Comprehensive Demo'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Logs'),
              Tab(icon: Icon(Icons.visibility), text: 'Watch'),
              Tab(icon: Icon(Icons.search), text: 'Detailed Watch'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLogView(_logs),
            _buildLogView(_watchLogs),
            _buildLogView(_detailedWatchLogs),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: _runAllDemos,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Run All Demos'),
              heroTag: 'run_all',
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _logs.clear();
                  _watchLogs.clear();
                  _detailedWatchLogs.clear();
                });
              },
              heroTag: 'clear',
              child: const Icon(Icons.clear),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogView(List<String> logs) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              logs[index],
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
          ),
        );
      },
    );
  }
}

// Custom class example
class Person {
  final String name;
  final int age;
  final String email;

  Person({required this.name, required this.age, required this.email});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] as String,
      age: json['age'] as int,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'age': age, 'email': email};
  }
}

// User class for detailed watch demonstration
class User implements DocumentSerializable {
  final String? name;
  final int? age;
  final String? email;

  User({this.name, this.age, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String?,
      age: json['age'] as int?,
      email: json['email'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'name': name, 'age': age, 'email': email};
  }
}
