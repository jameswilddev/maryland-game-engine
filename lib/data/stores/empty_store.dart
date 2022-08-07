import 'package:maryland_game_engine/data/primitives/u8.dart';
import 'package:maryland_game_engine/data/primitives/u16.dart';
import 'package:maryland_game_engine/data/primitives/u32.dart';
import 'package:maryland_game_engine/data/primitives/s8.dart';
import 'package:maryland_game_engine/data/primitives/s16.dart';
import 'package:maryland_game_engine/data/primitives/s32.dart';
import 'package:maryland_game_engine/data/primitives/f32.dart';
import 'package:maryland_game_engine/data/stores/entity_attribute_value/empty_entity_attribute_value_store.dart';
import 'package:maryland_game_engine/data/stores/entity_attribute_value/reference/empty_reference_entity_attribute_value_store.dart';

import 'entity_attribute_value/flag/empty_flag_entity_attribute_value_store.dart';
import 'store.dart';

/// An empty in-memory [Store] of multiple data types.
class EmptyStore extends Store<
  EmptyEntityAttributeValueStore<U8>,
  EmptyEntityAttributeValueStore<U16>,
  EmptyEntityAttributeValueStore<U32>,
  EmptyEntityAttributeValueStore<S8>,
  EmptyEntityAttributeValueStore<S16>,
  EmptyEntityAttributeValueStore<S32>,
  EmptyEntityAttributeValueStore<F32>,
  EmptyEntityAttributeValueStore<String>,
  EmptyReferenceEntityAttributeValueStore,
  EmptyFlagEntityAttributeValueStore
> {
  /// Creates a new [Store] which contains all-empty stores.
  EmptyStore() : super(
    EmptyEntityAttributeValueStore<U8>(0),
    EmptyEntityAttributeValueStore<U16>(0),
    EmptyEntityAttributeValueStore<U32>(0),
    EmptyEntityAttributeValueStore<S8>(0),
    EmptyEntityAttributeValueStore<S16>(0),
    EmptyEntityAttributeValueStore<S32>(0),
    EmptyEntityAttributeValueStore<F32>(0),
    EmptyEntityAttributeValueStore<String>(""),
    EmptyReferenceEntityAttributeValueStore(),
    EmptyFlagEntityAttributeValueStore(),
  );
}
