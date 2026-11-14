import 'package:dartnative/dartnative.dart';

import '../runner/ast_profile.dart';
import 'package:dartnative_go_ui/dartnative_go_ui.dart';

/// In-app AST bundle explorer for the DevTools sheet.
///
/// Renders the structured snapshot from `AstInterpreterRunner.lastAstProfile`:
/// bundle totals, per-package rollup, largest/slowest modules, largest
/// classes and bridged libraries. Pure presentation — the snapshot is built
/// on demand by the runner when the sheet opens.
class AstProfilePanel extends StatelessWidget {
  final AstProfileSnapshot? profile;

  const AstProfilePanel({super.key, required this.profile});

  static String _bytes(int bytes) =>
      bytes >= 1024 ? '${(bytes / 1024).toStringAsFixed(1)} KiB' : '$bytes B';

  static String _shortUri(String uri) {
    if (uri.startsWith('package:')) {
      final rest = uri.substring('package:'.length);
      final slash = rest.indexOf('/');
      if (slash < 0) return rest;
      return '${rest.substring(0, slash)}:${rest.substring(slash + 1)}';
    }
    return uri;
  }

  static TextStyle _labelStyle(ShadcnThemeData theme) => TextStyle(
    color: theme.mutedForeground,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static TextStyle _valueStyle(ShadcnThemeData theme) =>
      TextStyle(color: theme.foreground, fontSize: 13);

  static TextStyle _dimStyle(ShadcnThemeData theme) =>
      TextStyle(color: theme.mutedForeground, fontSize: 12);

  @override
  Widget build(BuildContext context) {
    final snapshot = profile;
    final theme = context.theme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.secondary,
        borderRadius: theme.radius.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('AST BUNDLE', style: _labelStyle(theme)),
              if (snapshot != null)
                Text(
                  snapshot.isHotReload ? 'hot reload' : 'initial',
                  style: TextStyle(
                    color: theme.mutedForeground,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          if (snapshot == null)
            Text(
              'No bundle evaluated yet.',
              style: _dimStyle(theme),
            )
          else ...[
            Text(
              '${snapshot.moduleCount} modules · '
              '${snapshot.hasSizeMetadata ? '${_bytes(snapshot.totalAstBytes)} AST · ' : ''}'
              '${snapshot.totalClasses} classes'
              '${snapshot.mainMs == null ? '' : ' · main ${snapshot.mainMs!.toStringAsFixed(1)}ms'}',
              style: _valueStyle(theme),
            ),
            const SizedBox(height: 10),
            Text('PACKAGES', style: _labelStyle(theme)),
            const SizedBox(height: 4),
            for (final pkg in snapshot.packages)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(pkg.package, style: _valueStyle(theme)),
                    ),
                    Text(
                      '${pkg.modules} mod${snapshot.hasSizeMetadata ? ' · ${_bytes(pkg.astBytes)}' : ''}',
                      style: _dimStyle(theme),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            Text('LARGEST MODULES', style: _labelStyle(theme)),
            const SizedBox(height: 4),
            for (final module in snapshot.modules.take(5))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _shortUri(module.uri),
                      style: _valueStyle(theme),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${snapshot.hasSizeMetadata ? '${_bytes(module.astBytes)} · ' : ''}${module.classCount} classes'
                      '${module.loadMicros == null ? '' : ' · ${(module.loadMicros! / 1000).toStringAsFixed(1)}ms'}',
                      style: _dimStyle(theme),
                    ),
                  ],
                ),
              ),
            if (snapshot.slowestModules.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text('SLOWEST LOADS', style: _labelStyle(theme)),
              const SizedBox(height: 4),
              for (final slow in snapshot.slowestModules.take(5))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _shortUri(slow.uri),
                          style: _valueStyle(theme),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${(slow.loadMicros / 1000).toStringAsFixed(1)}ms',
                        style: _dimStyle(theme),
                      ),
                    ],
                  ),
                ),
            ],
            if (snapshot.largestClasses.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text('LARGEST CLASSES', style: _labelStyle(theme)),
              const SizedBox(height: 4),
              for (final clazz in snapshot.largestClasses.take(5))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          clazz.name,
                          style: _valueStyle(theme),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        snapshot.hasSizeMetadata ? _bytes(clazz.astBytes) : '?',
                        style: _dimStyle(theme),
                      ),
                    ],
                  ),
                ),
            ],
            if (snapshot.bridgedLibs.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text('BRIDGED LIBS', style: _labelStyle(theme)),
              const SizedBox(height: 4),
              for (final lib in snapshot.bridgedLibs.take(5))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _shortUri(lib.uri),
                          style: _valueStyle(theme),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text('${lib.symbols} sym', style: _dimStyle(theme)),
                    ],
                  ),
                ),
            ],
          ],
        ],
      ),
    );
  }
}
