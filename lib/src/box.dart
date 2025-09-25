part of hive_plus_secure;

/// A box contains and manages a collection of key-value pairs.
abstract interface class Box<E> {
  /// Whether this box is currently open.
  ///
  /// Most of the operations on a box require it to be open.
  bool get isOpen;

  /// The name of the box.
  String get name;

  /// The location of the box in the file system. In the browser, this is null.
  String? get directory;

  /// The number of entries in the box.
  int get length;

  /// Whether the box is empty.
  bool get isEmpty;

  /// Whether the box is not empty.
  bool get isNotEmpty;

  /// Start a read transaction on the box.
  ///
  /// Transactions provides and atomic view on the box. All read operations
  /// inside the transaction will see the same state of the box.
  T read<T>(T Function() callback);

  /// Start a write transaction on the box.
  ///
  /// Transactions provides and atomic view on the box. All read operations
  /// inside the transaction will see the same state of the box.
  T write<T>(T Function() callback);

  /// All the keys in the box.
  ///
  /// The keys are sorted by their insertion order.
  List<String> get keys;

  /// Get the n-th key in the box.
  String? keyAt(int index);

  /// Checks whether the box contains the [key].
  bool containsKey(String key);

  // Returns the value associated with the given [key]. If the key does not
  /// exist, `null` is returned.
  ///
  /// If [defaultValue] is specified, it is returned in case the key does not
  /// exist.
  E? get(String key, {E? defaultValue});

  /// Returns the value associated with the n-th key.
  E getAt(int index);

  /// Returns the value associated with the given [key]. The key can either be
  /// a [String] or an [int] to get an entry by its index.
  E? operator [](Object key);

  /// Returns all values associated with the given [keys] or `null` if a key
  /// does not exist.
  List<E?> getAll(Iterable<String> keys);

  /// Returns all values in the given range.
  ///
  /// Throws a [RangeError] if [start] or [end] are out of bounds.
  List<E> getRange(int start, int end);

  /// Returns all values between [startKey] and [endKey] (inclusive).
  List<E> getBetween({String? startKey, String? endKey});

  /// Saves the [key] - [value] pair.
  void put(String key, E value);

  /// Associates the [value] with the n-th key. An exception is raised if the
  /// key does not exist.
  void putAt(int index, E value);

  /// Saves the [key] - [value] pair. The key can either be a [String] or an
  /// [int] to save an entry by its index.
  void operator []=(Object key, E value);

  /// Saves all the key - value pairs in the [entries] map.
  void putAll(Map<String, E> entries);

  /// Overwrites the values in the given range with the given [values].
  void putRange(int start, int end, Iterable<E> values);

  /// Saves the [value] with an auto-increment key.
  void add(E value);

  /// Saves all the [values] with auto-increment keys.
  void addAll(Iterable<E> values);

  /// Deletes the given [key] from the box.
  ///
  /// If it does not exist, nothing happens.
  bool delete(String key);

  /// Deletes the n-th key from the box.
  ///
  /// If it does not exist, nothing happens.
  void deleteAt(int index);

  /// Deletes all the given [keys] from the box.
  ///
  /// If a key does not exist, it is skipped.
  int deleteAll(Iterable<String> keys);

  /// Deletes all the entries in the given range.
  void deleteRange(int start, int end);

  /// Removes all entries from the box.
  void clear({bool notify = true});

  /// Closes the box.
  ///
  /// Be careful, this closes all instances of this box. You have to make sure
  /// that you don't access the box anywhere else after that.
  void close();

  /// Removes the file which contains the box and closes the box.
  ///
  /// If a box is still open in another isolate, it will not be deleted.
  void deleteFromDisk();

  /// Returns a broadcast stream of change events.
  ///
  /// If the [key] parameter is provided, only events for the specified key are
  /// broadcasted.
  ///
  /// Type parameter [K] must be either [String] or [int].
  ///
  /// Example:
  /// ```dart
  /// box.watch<String>(key: 'myKey').listen((event) {
  ///   print('Key: ${event.key}, Value: ${event.value}');
  /// });
  /// ```
  Stream<void> watch<K extends Object>({K? key});

  /// Watch the collection for detailed changes with field-level tracking.
  ///
  /// Returns a stream of [ChangeDetail] objects that contain comprehensive
  /// information about each change that occurs in the collection, including:
  /// - The type of change (insert, update, delete)
  /// - Individual field changes with before/after values
  /// - Complete document representation (if T extends DocumentSerializable)
  /// - Object ID and collection name
  ///
  /// **Type Parameter:**
  /// - `T`: The type to parse fullDocument into. Must extend
  /// [DocumentSerializable]
  ///   to enable automatic JSON parsing, or use
  /// custom parsing with documentParser.
  ///
  /// **Platform Support:**
  /// This method is not supported on web platforms and will throw an
  /// [UnsupportedError] if called on web.
  ///
  /// **Usage Examples:**
  ///
  /// Basic usage without document parsing:
  /// ```dart
  /// collection.watchDetailed<dynamic>().listen((change) {
  ///   print('Change type: ${change.changeType}');
  ///   print('Object ID: ${change.objectId}');
  ///   print('Field changes: ${change.fieldChanges.length}');
  /// });
  /// ```
  ///
  /// With custom document parsing:
  /// ```dart
  /// class User extends DocumentSerializable {
  ///   final String name;
  ///   final int age;
  ///
  ///   User({required this.name, required this.age});
  ///
  ///   factory User.fromJsonString(String json) {
  ///     final map = jsonDecode(json);
  ///     return User(name: map['name'], age: map['age']);
  ///   }
  ///
  ///   @override
  ///   Map<String, dynamic> toJson() => {'name': name, 'age': age};
  /// }
  ///
  /// collection.watchDetailed<User>().listen((change) {
  ///   if (change.fullDocument != null) {
  ///     print('User name: ${change.fullDocument!.name}');
  ///     print('User age: ${change.fullDocument!.age}');
  ///   }
  /// });
  /// ```
  ///
  /// **Performance Considerations:**
  /// - Detailed watchers have more overhead than regular watchers
  /// - Field-level change tracking requires additional processing
  /// - The stream automatically handles cleanup when canceled
  ///
  /// **Change Types:**
  /// - [ChangeType.insert]: New object was added to the collection
  /// - [ChangeType.update]: Existing object was modified
  /// - [ChangeType.delete]: Object was removed from the collection
  ///
  /// **Thread Safety:**
  /// This method is thread-safe and can be called from any isolate.
  /// The returned stream will emit changes that occur across all isolates.
  ///
  /// @throws UnsupportedError if called on web platforms
  /// @returns A stream of [ChangeDetail] objects representing database changes
  Stream<ChangeDetail<T>> watchDetailed<T extends DocumentSerializable>({
    T Function(Map<String, dynamic>)? documentParser,
  });
}
