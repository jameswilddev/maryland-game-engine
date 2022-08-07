import 'package:flutter_test/flutter_test.dart';
import 'package:maryland_game_engine/data/stores/empty_store.dart';

void main() {
  final store = EmptyStore();

  group("u8s", () {
    test("defaults to 0", () {
      expect(store.u8s.value, equals(0));
    });
  });

  group("u16s", () {
    test("defaults to 0", () {
      expect(store.u16s.value, equals(0));
    });
  });

  group("u32s", () {
    test("defaults to 0", () {
      expect(store.u32s.value, equals(0));
    });
  });

  group("s8s", () {
    test("defaults to 0", () {
      expect(store.s8s.value, equals(0));
    });
  });

  group("s16s", () {
    test("defaults to 0", () {
      expect(store.s16s.value, equals(0));
    });
  });

  group("s32s", () {
    test("defaults to 0", () {
      expect(store.s32s.value, equals(0));
    });
  });

  group("f32s", () {
    test("defaults to 0", () {
      expect(store.f32s.value, equals(0));
    });
  });

  group("strings", () {
    test("defaults to 0", () {
      expect(store.strings.value, equals(""));
    });
  });
}
