import 'dart:async';

import 'package:hive_plus_secure/hive_plus_secure.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group('Box.watch()', () {
    test('watches String key changes', () async {
      final box = await openTestBox<String>();
      final events = <WatchEvent<String, String>>[];
      final subscription = box.watch<String>(key: 'testKey').listen(events.add);

      // Initial put
      box.put('testKey', 'value1');
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Update
      box.put('testKey', 'value2');
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Delete
      box.delete('testKey');
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await subscription.cancel();

      // Should have received events for the changes
      expect(events.length, greaterThan(0));

      // Verify we can access key and value properties
      if (events.isNotEmpty) {
        expect(events.first.key, equals('testKey'));
        expect(events.first.value, isA<String?>());
      }
    });

    test('watches int key changes', () async {
      final box = await openTestBox<String>();
      final events = <WatchEvent<int, String>>[];
      final subscription = box.watch<int>(key: 0).listen(events.add);

      // First add an item at index 0
      box.add('initial');
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Update at index 0
      box[0] = 'updated';
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await subscription.cancel();

      // Should have received events for the changes
      expect(events.length, greaterThan(0));

      // Verify we can access key and value properties
      if (events.isNotEmpty) {
        expect(events.first.key, equals(0));
        expect(events.first.value, isA<String?>());
      }
    });

    test('watches general changes', () async {
      final box = await openTestBox<String>();
      final events = <WatchEvent<Object, String>>[];
      final subscription = box.watch<Object>().listen(events.add);

      // Make various changes
      box.put('key1', 'value1');
      await Future<void>.delayed(const Duration(milliseconds: 100));

      box.add('value2');
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await subscription.cancel();

      // Should have received events for the changes
      expect(events.length, greaterThan(0));

      // Verify we can access key and value properties
      if (events.isNotEmpty) {
        expect(events.first.key, isA<Object>());
        expect(events.first.value, isA<String?>());
      }
    });

    test('demonstrates WatchEvent API usage', () async {
      final box = await openTestBox<String>();
      final events = <WatchEvent<String, String>>[];
      final subscription = box.watch<String>(key: 'demo').listen((event) {
        events.add(event);

        // Now users can access properties naturally:
        final key = event.key; // Type-safe key access
        final value = event.value; // Type-safe value access

        print('Key: $key, Value: $value');
      });

      box.put('demo', 'example');
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await subscription.cancel();

      expect(events.length, greaterThan(0));
      if (events.isNotEmpty) {
        final event = events.first;
        expect(event.key, equals('demo'));
        expect(event.value, equals('example'));
      }
    });
  });
}
