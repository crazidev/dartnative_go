// D4rt Bridge - Generated file, do not edit
// Dartscript registration for dartnative_go
// Generated: 2026-09-18T05:43:29.596946 by tom_d4rt_generator 1.26.2

/// D4rt Bridge Registration for dartnative_go
library;

import 'package:tom_d4rt/d4rt.dart';
import 'dartnative_bridges.b.dart' as dartnative_ui_bridges;
import 'relaxers.b.dart' as relaxer_factories;

/// Combined bridge registration for dartnative_go.
class DartnativeGoBridges {
  /// Register all bridges with D4rt interpreter.
  static void register([D4rt? interpreter]) {
    final d4rt = interpreter ?? D4rt();

    dartnative_ui_bridges.DartnativeUiBridge.registerBridges(
      d4rt,
      'package:dartnative/dartnative.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel in dartnative_ui_bridges.DartnativeUiBridge.subPackageBarrels()) {
      dartnative_ui_bridges.DartnativeUiBridge.registerBridges(d4rt, barrel);
    }

    // RC-2: Register generic constructor factories
    relaxer_factories.registerGenericConstructors();
    // GEN-079: Register relaxer wrapper factories
    relaxer_factories.registerRelaxers();
  }

  /// Get import block for all modules.
  static String getImportBlock() {
    final buffer = StringBuffer();
    buffer.writeln(dartnative_ui_bridges.DartnativeUiBridge.getImportBlock());
    return buffer.toString();
  }
}
