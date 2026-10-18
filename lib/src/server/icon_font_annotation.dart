/// Annotation marking a class as an icon-font registry.
///
/// Icon holders are classes whose `static const IconData` members form one
/// icon family (same idea as the SDK's `@staticIconProvider`, which this
/// complements):
///
/// ```dart
/// import 'package:dartnative_go/server.dart';
///
/// @IconFont(family: 'WeatherIcons', fontPackage: 'weather_icons')
/// abstract final class WeatherIcons {
///   static const IconData sunny = IconData(0xE001, fontFamily: 'WeatherIcons');
/// }
/// ```
///
/// Why annotate? The dev server discovers annotated registries from *any*
/// package in the bundle — including external ones whose sources guest-code
/// regex scans never see — and serves each family's font bytes on demand
/// (`GET /fonts/<family>.ttf`) instead of shipping every font. The
/// annotation is dependency-free: `package:dartnative_go/server.dart` is
/// injected into builds implicitly, so guests and icon packages need no
/// extra setup beyond the import.
///
/// Packages built on `package:dartnative` may instead use the SDK's
/// `@staticIconProvider` — the detector recognizes both. When both are
/// present, `@IconFont` wins because it carries the explicit [family].
class IconFont {
  /// Font family name as used in `IconData(fontFamily: ...)` and
  /// `TextStyle(fontFamily: ...)`. This is the key the dev server serves
  /// the font under (`/fonts/<family>.ttf`).
  final String family;

  /// Owning package, used to locate the `.ttf` on disk and to build the
  /// manifest entry. Defaults to the package that declares the class.
  final String? fontPackage;

  /// Optional `pubspec.yaml`-relative path of the font file
  /// (e.g. `fonts/WeatherIcons.ttf`). When set, the dev server prefers
  /// it over searching the package for a matching `.ttf`.
  final String? fontAsset;

  const IconFont({
    required this.family,
    this.fontPackage,
    this.fontAsset,
  });
}
