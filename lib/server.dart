/// Server Components for DartNative Go.
///
/// Annotate a widget class with `@Server` or `@ServerComponent` to mark it
/// as a server-rendered component. The bundler splits these into separate
/// AST bundles fetched on demand at runtime.
///
/// ## Quick start (guest code)
/// ```dart
/// import 'package:dartnative_go/server.dart';
///
/// @Server(id: 'profile_card')
/// class ProfileCard extends StatelessWidget {
///   final String userId;
///   const ProfileCard({required this.userId});
///   // ...
/// }
/// ```
///
/// No guest dependency is needed for this import: the dev server and
/// `tool/` builds inject these exact sources into the bundler implicitly
/// (see `lib/src/cli/server_annotation_source.dart`). The annotated
/// module must still be reachable from the guest entrypoint for the
/// bundler to discover it (v1).
library;

export 'src/server/server_annotation.dart';
export 'src/server/icon_font_annotation.dart';
