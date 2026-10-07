/// Host `ServerComponentView` for guest code.
///
/// ```dart
/// import 'package:dartnative_go/server_component.dart';
///
/// ServerComponentView(
///   componentId: 'profile_card',
///   props: const {'userId': 7},
/// )
/// ```
///
/// Unlike `package:dartnative_go/server.dart` (the dependency-free
/// annotation, which the bundler inlines), this library exposes the real
/// host widget and is therefore NEVER bundled: its URI is listed in the
/// bundler's bridged libraries, so guest imports resolve at runtime to the
/// bridge registered by `AstInterpreterRunner` (see
/// `lib/src/interpreter/ast/server_component_bridge.dart`). Guest projects
/// need a `dartnative_go` path dependency only for analyzer/IDE resolution.
library;

export 'src/widgets/server_component_view.dart';
