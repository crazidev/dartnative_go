/// Canonical locations for AST build artifacts written by the dev server.
// Bundles live under `.dart_tool/` so `git add -A` can't accidentally commit them.
library;

/// Build-artifact directory, relative to the guest project root.
const String kAstBundleDir = '.dart_tool/bundles';

/// Relative path where the dev server writes the guest AST bundle.
const String kAstBundleRelativePath = '$kAstBundleDir/guest.ast';

/// Relative paths a guest bundle may be served from, in priority order.
// Legacy `assets/bundles/` and `build/` locations still work for older projects.
const List<String> kAstBundleCandidates = [
  kAstBundleRelativePath,
  'assets/bundles/guest.ast',
  'build/guest.ast',
];
