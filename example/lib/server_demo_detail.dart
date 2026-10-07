// Server-only helper for the @ServerComponent live-device demo.
//
// This module is intentionally imported ONLY by the server-component
// entries (server_demo_card.dart, server_demo_text.dart) — never by
// main.dart or any client screen. It is the "unique code" that ships
// inside each component's delta bundle and is resolved from it at runtime.
String demoDetail() => 'Demo Function on the server';
