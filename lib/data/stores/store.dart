import 'package:maryland_game_engine/data/primitives/entity_id.dart';
import 'package:maryland_game_engine/data/primitives/u8.dart';
import 'package:maryland_game_engine/data/primitives/u16.dart';
import 'package:maryland_game_engine/data/primitives/u32.dart';
import 'package:maryland_game_engine/data/primitives/s8.dart';
import 'package:maryland_game_engine/data/primitives/s16.dart';
import 'package:maryland_game_engine/data/primitives/s32.dart';
import 'package:maryland_game_engine/data/primitives/f32.dart';

import 'entity_attribute_value/entity_attribute_value_store.dart';
import 'entity_attribute_value/flag/flag_entity_attribute_value_store.dart';
import 'entity_attribute_value/reference/reference_entity_attribute_value_store.dart';

/// An in-memory [Store] of multiple data types.
abstract class Store<
  TU8s extends EntityAttributeValueStore<U8>,
  TU16s extends EntityAttributeValueStore<U16>,
  TU32s extends EntityAttributeValueStore<U32>,
  TS8s extends EntityAttributeValueStore<S8>,
  TS16s extends EntityAttributeValueStore<S16>,
  TS32s extends EntityAttributeValueStore<S32>,
  TF32s extends EntityAttributeValueStore<F32>,
  TStrings extends EntityAttributeValueStore<String>,
  TReferences extends ReferenceEntityAttributeValueStore,
  TFlags extends FlagEntityAttributeValueStore
> {
  /// The [U8]s within the [Store].  All values default to 0.
  final TU8s u8s;

  /// The [U16]s within the [Store].  All values default to 0.
  final TU16s u16s;

  /// The [U32]s within the [Store].  All values default to 0.
  final TU32s u32s;

  /// The [S8]s within the [Store].  All values default to 0.
  final TS8s s8s;

  /// The [S16]s within the [Store].  All values default to 0.
  final TS16s s16s;

  /// The [S32]s within the [Store].  All values default to 0.
  final TS32s s32s;

  /// The [F32]s within the [Store].  All values default to 0.
  final TF32s f32s;

  /// The [F32]s within the [Store].  All values default to an empty string.
  final TStrings strings;

  /// The [EntityId]s within the [Store].
  final TReferences references;

  /// The flags within the [Store].
  final TFlags flags;

  /// Creates a new [Store] composed of the given sub-stores.
  Store(this.u8s, this.u16s, this.u32s, this.s8s, this.s16s, this.s32s, this.f32s, this.strings, this.references, this.flags);
}
