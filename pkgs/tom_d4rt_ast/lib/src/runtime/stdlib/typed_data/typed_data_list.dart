import 'dart:typed_data';
import 'package:tom_d4rt_ast/runtime.dart';

/// The `dart:typed_data` list-view root.
///
/// `TypedDataList` implements `TypedData` and `List`, declaring no members of
/// its own, but interpreted code names it — as a type bound (for example the
/// typed queue superclass in `package:typed_data`) and in `is` checks.
/// Without this bridge those uses throw `Undefined variable: TypedDataList`.
///
/// **Deliberately has no `isAssignable`**, for the reason spelled out on
/// [TypedDataTypedData]: the predicate decides bridge *ownership*, and a root
/// claiming `(v) => v is TypedDataList` would compete with the eleven concrete
/// views for dispatch. Subtype answers come from the hierarchy edges in
/// `typed_data_hierarchy.dart`.
class TypedDataListTypedData {
  static BridgedClass get definition => BridgedClass(
    nativeType: TypedData,
    name: 'TypedDataList',
    typeParameterCount: 1,
    getters: {
      'buffer': (visitor, target) => (target as TypedData).buffer,
      'lengthInBytes': (visitor, target) => (target as TypedData).lengthInBytes,
      'offsetInBytes': (visitor, target) => (target as TypedData).offsetInBytes,
      'elementSizeInBytes': (visitor, target) =>
          (target as TypedData).elementSizeInBytes,
    },
  );
}
