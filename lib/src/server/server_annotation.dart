/// Annotation marking a widget class as a server-rendered component.
///
/// Server components are bundled separately from the client app and fetched
/// on demand. Their AST bundles contain only the code unique to that component
/// — shared libraries and client modules are resolved from the host app's
/// already-loaded interpreter.
///
/// ## Usage
/// ```dart
/// import 'package:dartnative_go/server.dart';
///
/// @ServerComponent(id: 'profile_card')
/// class ProfileCard extends StatelessWidget {
///   final int userId;
///   const ProfileCard({required this.userId});
///   // ...
/// }
/// ```
///
/// The [id] must match the component identifier used by the
/// `ServerComponentView` host widget at the mount point.
class ServerComponent {
  /// Unique identifier for this component. Must match the `componentId`
  /// parameter of the `ServerComponentView` host widget.
  final String id;

  /// Version hint for cache invalidation. Increment when the component's
  /// public interface changes (props, behavior contract).
  final int version;

  const ServerComponent({required this.id, this.version = 1});
}

/// Shorthand alias for [ServerComponent].
///
/// Classes annotated with `@Server` are treated as server components,
/// exactly like `@ServerComponent(...)`.
class Server {
  /// Unique identifier for this component.
  final String id;

  /// Version hint for cache invalidation.
  final int version;

  const Server({required this.id, this.version = 1});
}
