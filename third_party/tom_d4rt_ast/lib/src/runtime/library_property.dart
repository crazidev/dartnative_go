import 'callable.dart';

/// Library-scope getter/setter pair.
///
/// Dart allows a getter and a setter with the same name at library scope:
///
/// ```dart
/// PlaygroundPalette get playgroundPalette => _palette;
/// set playgroundPalette(PlaygroundPalette p) => _palette = p;
/// ```
///
/// Both declarations are `InterpretedFunction`s, and the environment binds
/// them by name — so the second `define` used to overwrite the first, leaving
/// either the getter or the setter unreachable (reads returned the setter
/// function object: `Cannot access property 'brightness' on function`).
///
/// This holder keeps both halves under one binding. The identifier read path
/// invokes [getter]; the assignment path invokes [setter]. Plain getters and
/// setters without a counterpart stay bare `InterpretedFunction`s, so the
/// common case allocates nothing extra.
class LibraryProperty {
  final InterpretedFunction? getter;
  final InterpretedFunction? setter;

  const LibraryProperty({this.getter, this.setter});

  /// The same property with [getter] replaced.
  LibraryProperty withGetter(InterpretedFunction? value) =>
      LibraryProperty(getter: value, setter: setter);

  /// The same property with [setter] replaced.
  LibraryProperty withSetter(InterpretedFunction? value) =>
      LibraryProperty(getter: getter, setter: value);
}
