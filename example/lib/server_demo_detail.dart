// Server-only helper for the @ServerComponent live-device demo.
//
// This module is intentionally imported ONLY by server_demo_card.dart —
// never by main.dart or any client screen. It is the "unique code" that
// ships exclusively inside the component's delta bundle and is resolved
// from it at runtime.
String demoDetail() => 'fresh from the server';
