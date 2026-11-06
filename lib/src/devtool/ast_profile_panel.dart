import 'package:dartnative/dartnative.dart';

import '../runner/ast_profile.dart';

/// In-app AST bundle explorer for the DevTools sheet.
///
/// Renders the structured snapshot from `AstInterpreterRunner.lastAstProfile`:
/// bundle totals, per-package rollup, largest/slowest modules, largest
/// classes and bridged libraries. Pure presentation — the snapshot is built
/// on demand by the runner when the sheet opens.
class AstProfilePanel extends StatelessWidget {
  final AstProfileSnapshot? profile;

  const AstProfilePanel({super.key, required this.profile});

  static String _bytes(int bytes) => bytes >= 1024
      ? '${(bytes / 1024).toStringAsFixed(1)} KiB'
      : '$bytes B';

  static String _shortUri(String uri) {
    if (uri.startsWith('package:')) {
      final rest = uri.substring('package:'.length);
      final slash = rest.indexOf('/');
      if (slash < 0) return rest;
      return '${rest.substring(0, slash)}:${rest.substring(slash + 1)}';
    }
    return uri;
  }

  static const _labelStyle = TextStyle(
    color: Colors.white38,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static const _valueStyle = TextStyle(color: Colors.white, fontSize: 13);

  static const _dimStyle = TextStyle(color: Colors.white60, fontSize: 12);

  @override
  Widget build(BuildContext context) {
    final snapshot = profile;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('AST BUNDLE', style: _labelStyle),
              if (snapshot != null)
                Text(
                  snapshot.isHotReload ? 'hot reload' : 'initial',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          if (snapshot == null)
            const Text(
              'No bundle evaluated yet.',
              style: _dimStyle,
            )
          else ...[
            Text(
              '${snapshot.moduleCount} modules · '
              '${snapshot.hasSizeMetadata ? '${_bytes(snapshot.totalAstBytes)} AST · ' : ''}'
              '${snapshot.totalClasses} classes'
              '${snapshot.mainMs == null ? '' : ' · main ${snapshot.mainMs!.toStringAsFixed(1)}ms'}',
              style: _valueStyle,
            ),
            const SizedBox(height: 10),
            const Text('PACKAGES', style: _labelStyle),
            const SizedBox(height: 4),
            for (final pkg in snapshot.packages)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(pkg.package, style: _valueStyle),
                    ),
                    Text(
                      '${pkg.modules} mod${snapshot.hasSizeMetadata ? ' · ${_bytes(pkg.astBytes)}' : ''}',
                      style: _dimStyle,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            const Text('LARGEST MODULES', style: _labelStyle),
            const SizedBox(height: 4),
            for (final module in snapshot.modules.take(5))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _shortUri(module.uri),
                      style: _valueStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${snapshot.hasSizeMetadata ? '${_bytes(module.astBytes)} · ' : ''}${module.classCount} classes'
                      '${module.loadMicros == null ? '' : ' · ${(module.loadMicros! / 1000).toStringAsFixed(1)}ms'}',
                      style: _dimStyle,
                    ),
                  ],
                ),
              ),
            if (snapshot.slowestModules.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('SLOWEST LOADS', style: _labelStyle),
              const SizedBox(height: 4),
              for (final slow in snapshot.slowestModules.take(5))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _shortUri(slow.uri),
                          style: _valueStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${(slow.loadMicros / 1000).toStringAsFixed(1)}ms',
                        style: _dimStyle,
                      ),
                    ],
                  ),
                ),
            ],
            if (snapshot.largestClasses.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('LARGEST CLASSES', style: _labelStyle),
              const SizedBox(height: 4),
              for (final clazz in snapshot.largestClasses.take(5))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          clazz.name,
                          style: _valueStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        snapshot.hasSizeMetadata ? _bytes(clazz.astBytes) : '?',
                        style: _dimStyle,
                      ),
                    ],
                  ),
                ),
            ],
            if (snapshot.bridgedLibs.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('BRIDGED LIBS', style: _labelStyle),
              const SizedBox(height: 4),
              for (final lib in snapshot.bridgedLibs.take(5))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _shortUri(lib.uri),
                          style: _valueStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text('${lib.symbols} sym', style: _dimStyle),
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
