# 1.1.3
### Improvements
- Updated dependency `isar_plus` to version `^1.0.13`

# 1.1.2
### Improvements
- Updated dependency `isar_plus` to version `^1.0.12` for improved stability and performance.


# 1.1.1

### Improvements

- **Watcher Functionality**: Added `WatcherDetails` class for improved watcher management
- **Box Implementation**: Enhanced box implementation with better watcher support
- **Code Organization**: Improved internal structure and removed obsolete test files

# 1.1.0

### Features

- **Enhanced Watch API**: Implemented generic `watch()` method with type-safe key parameters
  - Added `WatchEvent<K, E>` class for better API ergonomics with `.key` and `.value` properties
  - Support for both String and int key types with proper generic constraints
  - Replaced tuple return type `(K, E?)` with user-friendly `WatchEvent<K, E>`
  - Example usage:
    ```dart
    box.watch<String>(key: 'myKey').listen((event) {
      String key = event.key;     // Type-safe key access
      String? value = event.value; // Type-safe value access
      print('Key: $key, Value: $value');
    });
    ```

### Breaking Changes

- `Box.watch()` method now returns `Stream<WatchEvent<K, E>>` instead of `Stream<(K, E?)>`
- Users should update their watch handlers to use `.key` and `.value` properties

# 1.0.0

### Hive Plus Fork 

This package is a maintained fork of the original Hive package. The original Hive package is no longer actively maintained, so this fork continues development and maintenance.

Key changes in this fork:
- Package renamed from `hive` to `hive_plus`
- Updated repository and homepage links  
- Continued maintenance and bug fixes
- Library name changed to `hive_plus`

This is a complete rewrite of Hive. It is not compatible with older versions of Hive yet.

Hive Plus now uses Isar internally which brings all the benefits of a native database to Hive.

### Enchantments

- Much more resource efficiency
- Support for access from multiple isolates
- Support for transactions
- No more issues with concurrent access and corruption
- Vastly reduced startup time
- No more code generation

# Original Hive Changelog (DEPRECATED)

_All versions below are from the original Hive package and are deprecated. Use hive_plus instead._

# _4.0.0-dev.0 (Original Hive - DEPRECATED)_

⚠️ THIS VERSION OF HIVE IS UNSTABLE AND NOT READY FOR PRODUCTION USE ⚠️
⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

This is a complete rewrite of Hive. It is not compatible with older versions of Hive yet.

Hive now uses Isar internally which brings all the benefits of a native database to Hive.

### Enchantments

- Much more resource efficiency
- Support for access from multiple isolates
- Support for transactions
- No more issues with concurrent access and corruption
- Vastly reduced startup time
- No more code generation

# _3.0.0-dev (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Enchantments

- Implemented in-memory storage backend
- Added `notify` parameter to public APIs
- Web Worker support
- Threaded AesCipher support (requires hive_flutter >=2.0.0-dev)

# _2.2.3 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Enhancements

- Exposed `resetAdapters` method for testing - [#1014](https://github.com/hivedb/hive/pull/1014)
- Removed unnecessary print statement - [#1015](https://github.com/hivedb/hive/pull/1015)

# _2.2.2 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Fixes

- Register DateTime adapter on web - [#983](https://github.com/hivedb/hive/pull/983)

# _2.2.1 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Fixes

- Retracted hive@2.2.0 from pub.dev
- Fixed hive web backend null value exception - [#968](https://github.com/hivedb/hive/pull/968)

# _2.2.0 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Enhancements

- Added multiple storage backends for web - [#956](https://github.com/hivedb/hive/pull/956)

# _2.1.0 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Fixes

- Do not return uninitialized box - [#916](https://github.com/hivedb/hive/pull/916)

### Enhancements

- Adapter type inheritance - [#927](https://github.com/hivedb/hive/pull/927)
- UTF8 keys - [#928](https://github.com/hivedb/hive/pull/928)

# _2.0.6 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Fixes

- Fixed issue caused database to crash when executing crash recovery - [#914](https://github.com/hivedb/hive/pull/914)

# _2.0.5 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Enhancements

- Get IndexedDB selectively based on window property - [#802](https://github.com/hivedb/hive/pull/802)
- Added `path` parameter to `boxExists` and `deleteBoxFromDisk` methods - [#776](https://github.com/hivedb/hive/pull/776)
- Added `flush` method to boxes - [#852](https://github.com/hivedb/hive/pull/852)

### Fixes

- Don't loose track of box objects if init crashes - [#846](https://github.com/hivedb/hive/pull/846)

# _2.0.4 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Enhancements

- Adds default value support to hive_generator generated class adapters

# _2.0.3 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Fixes

- Fix regression where lists are no longer growable - [#631](https://github.com/hivedb/hive/pull/631)

# _2.0.2 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Fixes

- `HiveObjectMixin` not assigning box to object - [#618](https://github.com/hivedb/hive/issues/618)

# _2.0.1 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Fixes

- `BoxEvent` value is `null` when watching a `LazyBox` - [#592](https://github.com/hivedb/hive/pull/592)
- Allow calling `.init()` multiple times, instead of throwing error Hive will print warning to console
- Hive will warn developers when registering adapters for `dynamic` type

# _2.0.0 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Fixes

- Stable null-safety version

# _1.6.0-nullsafety.2 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Fixes

- Added `defaultValue` property to `@HiveField()` annotation - [#557](https://github.com/hivedb/hive/pull/557)

# _1.6.0-nullsafety.1 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Fixes

- Changed `meta` dependency version to `^1.3.0-nullsafety` to support null-safety

# _1.6.0-nullsafety.0 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Breaking changes

- Migrate to null-safety - [#521](https://github.com/hivedb/hive/pull/521)
- Update minimum Dart sdk constraint to 2.12.0-0.
- In order to generate null-safe code use hive_generator >= 0.9.0-nullsafety.0

# _1.5.0-pre (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Enhancements

- Timezone support for DateTime - [#419](https://github.com/hivedb/hive/issues/419)

# _1.4.4+1 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Fixes

- Browser support for `BackendManager.boxExists(boxName, path)` - [#451](https://github.com/hivedb/hive/issues/451)

# _1.4.4 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Fixes

- Edge browser support - [#357](https://github.com/hivedb/hive/issues/357)

# _1.4.3 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Enhancements

- Added `Hive.ignoreTypeId(typeId)` - [#397](https://github.com/hivedb/hive/pull/397)

### Fixes

- `open(Lazy)Box` can potentially open a box twice - [#345](https://github.com/hivedb/hive/issues/345)
- Remove extra byte reservation in writeBoolLis - [#398](https://github.com/hivedb/hive/pull/398)

# _1.4.2 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Fixes

- Fixed dependency issues and minor improvements

# _1.4.1+1 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Other

- Added docs to all public members

# _1.4.1 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Enhancements

- Minor performance improvements

### Fixes

- When a database operation failed, subsequent operations would not be performed

### Other

- Fixed GitHub homepage path

# _1.4.0+1 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Enhancements

- Minor performance improvements

### Fixes

- Allow more versions of `crypto`

# _1.4.0 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Enhancements

- ~1000% encryption / decryption performance improvement
- Added option to implement custom encryption algorithm
- Added `box.valuesBetween(startKey, endKey)`
- Allow tree shaking to drop encryption engine if no encryption is used

### Fixes

- `Hive.deleteBoxFromDisk()` did not work for boxes with upper-case names

### More

- Deprecated `encryptionKey` parameter. Use `Hive.openBox('name', encryptionCipher: HiveAesCipher(yourKey))`.
- Dropped `pointycastle` dependency
- Dropped `path` dependency

# _1.3.0 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

_Use latest version of `hive_generator`_

### Breaking changes

- `TypeAdapters` and `@HiveType()` now require a `typeId`
- `Hive.registerAdapter()` does not need a `typeId` anymore.
- Removed `BinaryReader.readAsciiString()`
- Removed `BinaryWriter.writeAsciiString()`

### Enhancements

- New documentation with tutorials and live code

### Fixes

- `box.clear()` resets auto increment counter

### More

- Not calling `Hive.init()` results in better exception

# _1.2.0 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Breaking changes

- Removed the `Hive.path` getter
- Removed `Hive.openBoxFromBytes()` (use the `bytes` parameter of `Hive.openBox()` instead)
- `LazyBox` and `Box` now have a common parent class: `BoxBase`
- Lazy boxes need to be opened using `Hive.openLazyBox()`
- Open lazy boxes can be acquired using `Hive.lazyBox()`
- Box name bug resolved (more information below)

### Enhancements

- Support for relationships, `HiveLists` (see docs for details)
- Support for inheritance
- Lazy boxes can now have a type argument `LazyBox<YourModel>`
- Added method to delete boxes without opening them `Hive.deleteBoxFromDisk()`
- Added `path` parameter to open boxes in a custom path
- Improved documentation

### Fixes

- `HiveObjects` have not been initialized correctly in lazy boxes
- Fixed bug where uppercase box name resulted in an uppercase filename
- Fixed compaction bug which caused corrupted boxes
- Fixed bug which did not allow the key `0xFFFFFFFF`
- Fixed bug where not all `BoxEvent`s have been broadcasted

### More

- Changed type of `encryptionKey` from `Uint8List` to `List<int>`

### Important:

Due to a bug in previous Hive versions, boxes whose name contains uppercase characters were stored in a file that also contains upper case characters (e.g. 'myBox' -> 'myBox.hive').

To avoid different behavior on case sensitive file systems, Hive should store files with lower case names. This bug has been resolved in version 1.2.0.

If your box name contains upper case characters, the new version will not find a box stored by an older version. Please rename the hive file manually in that case.  
This also applies to the web version.

# _1.1.1 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Breaking changes

- `object.delete()` now throws exception if object is not stored in a box

### Fixes

- Fixed bug where `object.save()` would fail on subsequent calls

# _1.1.0+2 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Fixes

- Fixed bug that it was not possible to open typed boxes (`Box<E>`)

# _1.1.0+1 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Fixes

- Fixed bug that corrupted boxes were not detected

# _1.1.0 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

### Breaking changes

- Changed return type of `addAll()` from `List<int>` to `Iterable<int>`.
- Removed the option to register `TypeAdapters` for a specific box. E.g. `box.registerTypeAdapter()`.
- `getAt()`, `putAt()`, `deleteAt()` and `keyAt()` no longer allow indices out of range.

### Enhancements

- Added `HiveObject`
- Boxes have now an optional type parameter `Box<E>`
- Support opening boxes from assets

### Fixes

- Fixed bug which was caused by not awaiting write operations
- Fixed bug where custom compaction strategy was not applied
- Hive now locks box files while they are open to prevent concurrent access from multiple processes

### More

- Improved performance of `putAll()`, `deleteAll()`, `add()`, `addAll()`
- Changed `values` parameter of `addAll()` from `List` to `Iterable`
- Improved documentation
- Preparation for queries

# _1.0.0 (Original Hive - DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

- First stable release

# _0.5.1+1 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

- Change `keys` parameter of `deleteAll` from `List` to `Iterable`
- Fixed bug in `BinaryWriter`

# _0.5.1 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

- Fixed `Hive.init()` bug in browser
- Fixed a bug with large lists or strings
- Improved box opening time in the browser
- Improved general write performance
- Improved docs
- Added integration tests

# _0.5.0 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

- Added `keyComparator` parameter for custom key order
- Added `isEmpty` and `isNotEmpty` getters to box
- Added support for reading and writing subclasses
- Removed length limitation for Lists, Maps, and Strings
- Greatly improved performance of storing Uint8Lists in browser
- Removed CRC check in the browser (not needed)
- Improved documentation
- TypeIds are now allowed in the range of 0-223
- Fixed compaction
- Fixed writing longer Strings
- **Breaking:** Binary format changed

# _0.4.1+1 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

- Document all public APIs
- Fixed flutter_web error

# _0.4.1 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

- Allow different versions of the `path` package

# _0.4.0 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

- Added `BigInt` support
- Added `compactionStrategy` parameter
- Added automatic crash recovery
- Added `add()` and `addAll()` for auto-increment keys
- Added `getAt()`, `putAt()` and `deleteAt()` for working with indices
- Support for int (32 bit unsigned) keys
- Non-lazy boxes now notify their listeners immediately about changes
- Bugfixes
- More tests
- **Breaking:** Open boxes with `openBox()`
- **Breaking:** Writing `null` is no longer equivalent to deleting a key
- **Breaking:** Temporarily removed support for transactions. New API design needed. Will be coming back in a future version.
- **Breaking:** Binary format changed
- **Breaking:** API changes

# _0.3.0+1 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

- Bugfix: `Hive['yourBox']` didn't work with uppercase box names

# _0.3.0 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

- Big step towards stable API
- Support for transactions
- Annotations for hive_generator
- Bugfixes
- Improved web support
- **Breaking:** `inMemory` -> `lazy`
- **Breaking:** Binary format changed

# _0.2.0 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

- Support for dart2js
- Improved performance
- Added `inMemory` option
- **Breaking:** Minor API changes
- **Breaking:** Changed Endianness to little
- **Breaking:** Removed Migrator

# _0.1.1 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

- Downgrade to `meta: ^1.1.6` to support flutter

# _0.1.0 (DEPRECATED)_

⚠️ **DEPRECATED: Use hive_plus instead** ⚠️

- First release
