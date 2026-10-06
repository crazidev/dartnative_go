/// Server Components for DartNative Go.
///
/// Annotate a widget class with `@Server` or `@ServerComponent` to mark it
/// as a server-rendered component. The bundler splits these into separate
/// AST bundles fetched on demand at runtime.
///
/// ## Quick start
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
library;

export 'src/server/server_annotation.dart';
