/// Terminal output, streaming action formatter, and interactive keys for
/// `dngo start`.
library;

import 'dart:async';
import 'dart:io';

import '../../runner/logger.dart';
import '../diagnostics/asset_detector.dart';
import '../diagnostics/icon_font_detector.dart';
import '../diagnostics/pubspec_validator.dart';
import '../diagnostics/version_info.dart';
import '../packaging/ast_builder.dart' show formatByteSize;
import 'dev_socket_hub.dart';
import 'loading_page.dart';
import 'qr_code.dart';

/// ANSI color palette for dev server terminal output.
class TerminalPalette {
  const TerminalPalette({required this.enabled});

  factory TerminalPalette.auto() =>
      TerminalPalette(enabled: _detectAnsiSupport());

  final bool enabled;

  String get reset => enabled ? '\x1B[0m' : '';
  String get bold => enabled ? '\x1B[1m' : '';
  String get dim => enabled ? '\x1B[90m' : '';
  String get green => enabled ? '\x1B[32m' : '';
  String get cyan => enabled ? '\x1B[36m' : '';
  String get magenta => enabled ? '\x1B[35m' : '';
  String get yellow => enabled ? '\x1B[33m' : '';
  String get red => enabled ? '\x1B[31m' : '';

  String boldText(String s) => '$bold$s$reset';
  String dimText(String s) => '$dim$s$reset';
  String greenText(String s) => '$green$s$reset';
  String cyanText(String s) => '$cyan$s$reset';
  String magentaText(String s) => '$magenta$s$reset';
  String yellowText(String s) => '$yellow$s$reset';
  String redText(String s) => '$red$s$reset';

  static final _ansiPattern = RegExp(r'\x1B\[[0-9;]*[A-Za-z]');

  /// Strips ANSI escape sequences so column widths can be measured accurately.
  static String stripAnsi(String input) => input.replaceAll(_ansiPattern, '');

  static bool _detectAnsiSupport() {
    if (Platform.environment.containsKey('NO_COLOR')) return false;
    try {
      return stdout.supportsAnsiEscapes;
    } catch (_) {
      return true;
    }
  }
}

/// Snapshot of startup metadata rendered by [formatStartupScreen].
class StartupScreenInfo {
  const StartupScreenInfo({
    required this.projectPath,
    required this.serverUrl,
    required this.deepLink,
    required this.validation,
    required this.assets,
    required this.iconFonts,
    this.versions = DngoVersionInfo.current,
    this.rebuildAst = true,
    this.enableQrCode = true,
    this.verbose = false,
    this.devLogs = false,
  });

  final String projectPath;
  final String serverUrl;
  final String deepLink;
  final PubspecValidationResult validation;
  final ProjectAssets assets;
  final IconFontReport iconFonts;
  final DngoVersionInfo versions;
  final bool rebuildAst;
  final bool enableQrCode;
  final bool verbose;
  final bool devLogs;

  /// The single URL shown in Normal mode and encoded in the QR code.
  String get loadingUrl => '$serverUrl$kDngoLoadingPath';

  String get wsUrl => '${serverUrl.replaceFirst('http', 'ws')}/ws';

  StartupScreenInfo copyWith({bool? verbose, bool? devLogs}) =>
      StartupScreenInfo(
        projectPath: projectPath,
        serverUrl: serverUrl,
        deepLink: deepLink,
        validation: validation,
        assets: assets,
        iconFonts: iconFonts,
        versions: versions,
        rebuildAst: rebuildAst,
        enableQrCode: enableQrCode,
        verbose: verbose ?? this.verbose,
        devLogs: devLogs ?? this.devLogs,
      );
}

TerminalPalette _paletteFor(bool? useColor) => useColor == null
    ? TerminalPalette.auto()
    : TerminalPalette(enabled: useColor);

/// Formats the complete startup screen (Normal or Verbose).
String formatStartupScreen(StartupScreenInfo info, {bool? useColor}) {
  final c = _paletteFor(useColor);
  final buf = StringBuffer();

  // 1. Project details first, framed in `====` lines with colors.
  final projectLinePlain = 'Starting project: ${info.projectPath}';
  final projectLine =
      '${c.cyan}${c.bold}Starting project:${c.reset} ${c.boldText(info.projectPath)}';

  final versionPlainParts = <String>[
    '${info.validation.appName} (${info.validation.appVersion})',
    'dngo v${info.versions.dngoVersion}',
    'DartNative v${info.versions.dartNativeVersion}',
    if (info.verbose) 'runtime v${info.versions.runtimeVersion}',
  ];
  final versionStyledParts = <String>[
    '${c.boldText(info.validation.appName)} ${c.cyanText('(${info.validation.appVersion})')}',
    c.greenText('dngo v${info.versions.dngoVersion}'),
    c.cyanText('DartNative v${info.versions.dartNativeVersion}'),
    if (info.verbose) c.dimText('runtime v${info.versions.runtimeVersion}'),
  ];
  final tags = <String>[
    if (info.verbose) '${c.green}${c.bold}[VERBOSE]${c.reset}',
    if (info.devLogs) '${c.yellow}${c.bold}[DEV]${c.reset}',
  ];
  final tagPlain = [
    if (info.verbose) '[VERBOSE]',
    if (info.devLogs) '[DEV]',
  ];
  final versionLinePlain =
      '${versionPlainParts.join('  ·  ')}${tagPlain.isEmpty ? '' : '  ${tagPlain.join(' ')}'}';
  final tagSuffix = tags.isEmpty ? '' : '  ${tags.join(' ')}';
  final versionLine =
      '${versionStyledParts.join(c.dimText('  ·  '))}$tagSuffix';

  final maxHeaderWidth = projectLinePlain.length > versionLinePlain.length
      ? projectLinePlain.length
      : versionLinePlain.length;
  final ruleWidth = maxHeaderWidth < 52
      ? 52
      : (maxHeaderWidth > 76 ? 76 : maxHeaderWidth);
  final rule = c.dimText('=' * ruleWidth);

  buf.writeln(rule);
  buf.writeln(projectLine);
  buf.writeln(versionLine);
  buf.writeln(rule);
  buf.writeln();

  // 2. QR code (above the details block when enabled, never side-by-side).
  if (info.enableQrCode) {
    final qrLines = QrCode(info.loadingUrl)
        .renderToTerminal()
        .split('\n')
        .where((line) => line.isNotEmpty);
    for (final line in qrLines) {
      buf.writeln(line);
    }
    buf.writeln();
    buf.writeln(
      '${c.dimText('›')} Scan the QR code above to open in ${c.boldText('DartNative Go')}.',
    );
    buf.writeln(
      '${c.dimText('›')} ${c.dimText('Local:')} ${c.cyanText(info.loadingUrl)}',
    );
  } else {
    buf.writeln(
      '${c.dimText('›')} ${c.dimText('Local:')} ${c.cyanText(info.loadingUrl)}',
    );
  }

  // 3. Verbose endpoints or compact warning, plus essential shortcuts.
  if (info.verbose) {
    buf.writeln(
      '${c.dimText('›')} ${c.dimText('Server:'.padRight(10))} ${info.serverUrl}',
    );
    buf.writeln(
      '${c.dimText('›')} ${c.dimText('WebSocket:'.padRight(10))} ${info.wsUrl}',
    );
    buf.writeln(
      '${c.dimText('›')} ${c.dimText('Deep link:'.padRight(10))} ${info.deepLink}',
    );
    buf.writeln(
      '${c.dimText('›')} ${c.dimText('AST watch:'.padRight(10))} '
      '${info.rebuildAst ? c.cyanText('on') + c.dimText(' (rebuild on save)') : c.dimText('off (--no-rebuild-ast)')}',
    );
  } else {
    final warning = _formatCompactPluginWarning(info.validation, c);
    if (warning != null) {
      buf.writeln();
      buf.writeln(warning);
    }
  }

  final verboseState = info.verbose ? c.greenText(' (on)') : '';
  buf.writeln();
  buf.writeln(
    '${c.dimText('›')} Press ${c.cyanText('r')} ${c.dimText('│')} hot reload',
  );
  buf.writeln(
    '${c.dimText('›')} Press ${c.cyanText('R')} ${c.dimText('│')} hot restart',
  );
  buf.writeln(
    '${c.dimText('›')} Press ${c.cyanText('v')} ${c.dimText('│')} verbose$verboseState',
  );
  buf.writeln(
    '${c.dimText('›')} Press ${c.cyanText('h')} ${c.dimText('│')} more commands',
  );

  // 4. Verbose-only diagnostic details below the shortcuts block.
  if (info.verbose) {
    final details = formatVerboseDiagnostics(info, useColor: useColor);
    if (details.isNotEmpty) {
      buf.writeln();
      buf.write(details);
    }
  }

  return buf.toString();
}

String? _formatCompactPluginWarning(
  PubspecValidationResult validation,
  TerminalPalette c,
) {
  final unsupported = validation.unsupportedNativePlugins.length;
  final mismatches = validation.versionMismatches.length;
  if (unsupported == 0 && mismatches == 0) return null;

  final parts = <String>[
    if (unsupported > 0)
      '$unsupported unsupported native plugin${unsupported == 1 ? '' : 's'}',
    if (mismatches > 0)
      '$mismatches version mismatch${mismatches == 1 ? '' : 'es'}',
  ];
  return '${c.yellowText('⚠')} ${c.yellowText(parts.join(' · '))} '
      '${c.dimText('(press v for details)')}';
}

/// Formats compact verbose-only startup details: Plugins + Assets & Fonts.
String formatVerboseDiagnostics(StartupScreenInfo info, {bool? useColor}) {
  final c = _paletteFor(useColor);
  final buf = StringBuffer();

  final pluginsBlock = _formatPluginsTree(info.validation, c);
  if (pluginsBlock.isNotEmpty) {
    buf.write(pluginsBlock);
  }

  final assetsBlock = _formatAssetsAndFontsTree(info.assets, info.iconFonts, c);
  if (assetsBlock.isNotEmpty) {
    if (buf.isNotEmpty) buf.writeln();
    buf.write(assetsBlock);
  }

  return buf.toString();
}

/// Formats verbose connection endpoints (used when toggling `v` on live).
String formatVerboseEndpoints(StartupScreenInfo info, {bool? useColor}) {
  final c = _paletteFor(useColor);
  final buf = StringBuffer();
  buf.writeln(c.boldText('Endpoints'));
  buf.writeln(
    '  ${c.dimText('├─')} ${c.dimText('server'.padRight(9))} ${c.cyanText(info.serverUrl)}',
  );
  buf.writeln(
    '  ${c.dimText('├─')} ${c.dimText('ws'.padRight(9))} ${c.cyanText(info.wsUrl)}',
  );
  buf.writeln(
    '  ${c.dimText('├─')} ${c.dimText('deeplink'.padRight(9))} ${c.cyanText(info.deepLink)}',
  );
  buf.writeln(
    '  ${c.dimText('└─')} ${c.dimText('ast watch'.padRight(9))} '
    '${info.rebuildAst ? c.cyanText('on') + c.dimText(' (rebuild on save)') : c.dimText('off')}',
  );
  return buf.toString();
}

String _formatPluginsTree(
  PubspecValidationResult validation,
  TerminalPalette c,
) {
  final entries =
      <({String label, List<String> lines, bool isWarn, bool isErr})>[];

  if (validation.validSupportedPlugins.isNotEmpty) {
    final names = validation.validSupportedPlugins.keys
        .map(_shortPluginName)
        .toList();
    entries.add((
      label:
          '${c.greenText('✓')} ${validation.validSupportedPlugins.length} supported',
      lines: _wrapItems(names, maxWidth: 56),
      isWarn: false,
      isErr: false,
    ));
  }

  if (validation.versionMismatches.isNotEmpty) {
    final items = validation.versionMismatches
        .map(
          (m) =>
              '${_shortPluginName(m.pluginName)} (${m.declaredConstraint} → ${m.requiredConstraint})',
        )
        .toList();
    entries.add((
      label:
          '${c.yellowText('⚠')} ${validation.versionMismatches.length} mismatch',
      lines: _wrapItems(items, maxWidth: 56),
      isWarn: true,
      isErr: false,
    ));
  }

  if (validation.unsupportedNativePlugins.isNotEmpty) {
    final names = validation.unsupportedNativePlugins
        .map(_shortPluginName)
        .toList();
    entries.add((
      label:
          '${c.redText('✖')} ${validation.unsupportedNativePlugins.length} unsupported',
      lines: _wrapItems(names, maxWidth: 56),
      isWarn: false,
      isErr: true,
    ));
  }

  if (entries.isEmpty) return '';

  final buf = StringBuffer();
  buf.writeln(c.boldText('Plugins'));
  const labelWidth = 17;
  for (var i = 0; i < entries.length; i++) {
    final entry = entries[i];
    final isLast = i == entries.length - 1;
    final branch = c.dimText(isLast ? '└─' : '├─');
    final cont = c.dimText(isLast ? '  ' : '│ ');
    final paddedLabel = _padVisibleRight(entry.label, labelWidth);
    final firstLine = entry.lines.isEmpty ? '' : entry.lines.first;
    buf.writeln('  $branch $paddedLabel $firstLine');
    final indent = ' ' * (labelWidth + 1);
    for (var j = 1; j < entry.lines.length; j++) {
      buf.writeln('  $cont $indent${entry.lines[j]}');
    }
  }
  return buf.toString();
}

String _formatAssetsAndFontsTree(
  ProjectAssets assets,
  IconFontReport iconFonts,
  TerminalPalette c,
) {
  final rows = <({String key, String value})>[];

  if (assets.hasIcon && assets.iconPath != null) {
    rows.add((key: 'icon', value: assets.iconPath!));
  }
  if (assets.hasSplash && assets.splashPath != null) {
    final bg = assets.hasConfiguredSplashColor
        ? ' (${assets.splashBackgroundColor}'
              '${assets.splashBackgroundColorDark != null ? ' / ${assets.splashBackgroundColorDark}' : ''})'
        : '';
    rows.add((key: 'splash', value: '${assets.splashPath!}$bg'));
  }

  // Filter out 0-glyph noise (e.g. interpolated strings like `Figtree-$weight`,
  // `Courier`, `monospace`) from icon-font summary.
  final iconParts = <String>[];
  final sortedFamilies = iconFonts.families.toList()..sort();
  for (final family in sortedFamilies) {
    final count =
        (iconFonts.glyphsByFamily[family]?.length ?? 0) +
        (iconFonts.codePointsByFamily[family]?.length ?? 0);
    if (count <= 0) continue;
    iconParts.add('$family ($count)');
  }
  if (iconParts.isNotEmpty) {
    rows.add((key: 'icons', value: iconParts.join(' · ')));
  }

  if (iconFonts.customFonts.isNotEmpty) {
    rows.add((
      key: 'fonts',
      value: _summarizeCustomFonts(iconFonts.customFonts),
    ));
  }

  if (rows.isEmpty) return '';

  final buf = StringBuffer();
  buf.writeln(c.boldText('Assets & Fonts'));
  for (var i = 0; i < rows.length; i++) {
    final row = rows[i];
    final isLast = i == rows.length - 1;
    final branch = c.dimText(isLast ? '└─' : '├─');
    buf.writeln('  $branch ${c.dimText(row.key.padRight(7))} ${row.value}');
  }
  return buf.toString();
}

/// Groups custom font families like `Figtree-Regular`, `Figtree-Bold` into
/// `Figtree (Regular, Bold)` for compact display.
String _summarizeCustomFonts(List<CustomFontDecl> fonts) {
  final grouped = <String, List<String>>{};
  final standalone = <String>[];

  for (final font in fonts) {
    final dash = font.family.lastIndexOf('-');
    if (dash > 0 && dash < font.family.length - 1) {
      final base = font.family.substring(0, dash);
      final style = font.family.substring(dash + 1);
      grouped.putIfAbsent(base, () => <String>[]).add(style);
    } else {
      standalone.add(font.family);
    }
  }

  final parts = <String>[];
  for (final entry in grouped.entries) {
    if (entry.value.length == 1) {
      parts.add('${entry.key}-${entry.value.first}');
    } else {
      parts.add('${entry.key} (${entry.value.join(', ')})');
    }
  }
  parts.addAll(standalone);
  return parts.join(' · ');
}

String _shortPluginName(String name) =>
    name.startsWith('dartnative_') ? name.substring('dartnative_'.length) : name;

List<String> _wrapItems(List<String> items, {required int maxWidth}) {
  if (items.isEmpty) return const [];
  final lines = <String>[];
  var current = StringBuffer();
  for (var i = 0; i < items.length; i++) {
    final item = items[i];
    final sep = i < items.length - 1 ? ', ' : '';
    final piece = '$item$sep';
    if (current.isNotEmpty && current.length + piece.length > maxWidth) {
      lines.add(current.toString().trimRight());
      current = StringBuffer();
    }
    current.write(piece);
  }
  if (current.isNotEmpty) {
    lines.add(current.toString().trimRight());
  }
  return lines;
}

String _padVisibleRight(String text, int width) {
  final visibleLen = TerminalPalette.stripAnsi(text).length;
  if (visibleLen >= width) return text;
  return '$text${' ' * (width - visibleLen)}';
}

/// Formats the full interactive command list in a single column (shown on `h`).
String formatCommandsHelp({required bool verbose, bool? useColor}) {
  final c = _paletteFor(useColor);
  final vState = verbose ? c.greenText('on') : c.dimText('off');
  final sep = c.dimText('│');
  final bullet = c.dimText('›');
  return '\n${c.boldText('Commands')}\n'
      '  $bullet Press ${c.cyanText('r')} $sep hot reload\n'
      '  $bullet Press ${c.cyanText('R')} $sep hot restart\n'
      '  $bullet Press ${c.cyanText('v')} $sep toggle verbose ($vState)\n'
      '  $bullet Press ${c.cyanText('q')} $sep show QR code\n'
      '  $bullet Press ${c.cyanText('c')} $sep clear screen\n'
      '  $bullet Press ${c.cyanText('h')} $sep show commands\n'
      '  $bullet ${c.dimText('Ctrl+C')}  $sep quit\n';
}

/// Formats the standalone QR block shown when pressing `q`.
String formatQrBlock(String loadingUrl, {bool? useColor}) {
  final c = _paletteFor(useColor);
  final buf = StringBuffer()
    ..writeln()
    ..write(QrCode(loadingUrl).renderToTerminal())
    ..writeln()
    ..writeln(
      '${c.dimText('›')} Scan the QR code above to open in ${c.boldText('DartNative Go')}.',
    )
    ..writeln(
      '${c.dimText('›')} ${c.dimText('Local:')} ${c.cyanText(loadingUrl)}',
    );
  return buf.toString();
}

// ---------------------------------------------------------------------------
// Action & Telemetry Formatters
// ---------------------------------------------------------------------------

const _kSpinnerFrames = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];

/// Formats one frame of the in-progress bundling status line.
String formatBundlingStatus({
  int frameIndex = 0,
  int? elapsedMs,
  bool? useColor,
}) {
  final c = _paletteFor(useColor);
  final glyph = _kSpinnerFrames[frameIndex % _kSpinnerFrames.length];
  final elapsed = (elapsedMs != null && elapsedMs >= 100)
      ? ' ${c.dimText('${(elapsedMs / 1000).toStringAsFixed(1)}s')}'
      : '';
  return '${c.cyanText(glyph)} ${c.dimText('Bundling guest.ast…')}$elapsed';
}

/// Formats one frame of an in-progress sub-branch spinner (e.g.
/// `  └─ launch  ⠙ launching… 1.2s` or `  └─ device  ⠙ reloading… 0.2s`).
String formatPendingBranch({
  required String label,
  required String actionText,
  int frameIndex = 0,
  int? elapsedMs,
  bool? useColor,
}) {
  final c = _paletteFor(useColor);
  final glyph = _kSpinnerFrames[frameIndex % _kSpinnerFrames.length];
  final elapsed = (elapsedMs != null && elapsedMs >= 100)
      ? ' ${c.dimText('${(elapsedMs / 1000).toStringAsFixed(1)}s')}'
      : '';
  return '  ${c.dimText('└─')} ${c.dimText(label.padRight(7))} '
      '${c.cyanText(glyph)} ${c.dimText(actionText)}$elapsed';
}

/// Formats the completed initial bundle summary.
String formatBundledResult({
  required int elapsedMs,
  required int moduleCount,
  required int byteSize,
  String? etag,
  bool devLogs = false,
  bool? useColor,
}) {
  final c = _paletteFor(useColor);
  final details = <String>[
    '$moduleCount module${moduleCount == 1 ? '' : 's'}',
    formatByteSize(byteSize),
    if (devLogs && etag != null && etag.isNotEmpty) 'etag=$etag',
  ];
  return '${c.greenText('✓')} ${c.boldText('Bundled guest.ast')} ${c.dimText('(${elapsedMs}ms)')}\n'
      '  ${c.dimText('└─')} ${details.join(' · ')}';
}

/// Formats a warning block with an icon and indented sub-detail.
String formatWarningBlock(String title, String detail, {bool? useColor}) {
  final c = _paletteFor(useColor);
  return '${c.yellowText('⚠')} ${c.yellowText(title)}\n'
      '  ${c.dimText('└─')} ${c.dimText(detail)}';
}

/// Formats an error block with a red icon and indented lines.
String formatErrorBlock(String title, String message, {bool? useColor}) {
  final c = _paletteFor(useColor);
  final lines = message.trimRight().split('\n');
  final buf = StringBuffer()..writeln('${c.redText('✖')} ${c.redText(title)}');
  for (var i = 0; i < lines.length; i++) {
    final isLast = i == lines.length - 1;
    final prefix = i == 0
        ? c.dimText(lines.length == 1 ? '└─' : '├─')
        : c.dimText(isLast ? '└─' : '│ ');
    buf.writeln('  $prefix ${lines[i]}');
  }
  return buf.toString().trimRight();
}

/// Formats device connection / disconnection notices.
String formatDeviceConnected(
  int activeCount, {
  String? deviceName,
  bool? useColor,
}) {
  final c = _paletteFor(useColor);
  final namePart = (deviceName != null && deviceName.trim().isNotEmpty)
      ? ' ${c.dimText('·')} ${deviceName.trim()}'
      : '';
  return '${c.greenText('●')} ${c.boldText('Device connected')}$namePart ${c.dimText('($activeCount active)')}';
}

String formatDeviceDisconnected(
  int activeCount, {
  String? deviceName,
  bool? useColor,
}) {
  final c = _paletteFor(useColor);
  final namePart = (deviceName != null && deviceName.trim().isNotEmpty)
      ? ' · ${deviceName.trim()}'
      : '';
  return '${c.dimText('○')} ${c.dimText('Device disconnected$namePart ($activeCount active)')}';
}

String formatServedBranch({
  required String artifactName,
  required int byteSize,
  String? etag,
  bool devLogs = false,
  bool isLast = true,
  bool? useColor,
}) {
  final c = _paletteFor(useColor);
  final branch = c.dimText(isLast ? '└─' : '├─');
  final extra = (devLogs && etag != null && etag.isNotEmpty)
      ? ' · etag=$etag'
      : '';
  return '  $branch ${c.dimText('served')}  $artifactName (${formatByteSize(byteSize)}$extra)';
}

/// Formats the header line of a hot reload block.
String formatHotReloadHeader({
  List<String> changedFiles = const [],
  String? assetPath,
  bool manual = false,
  int? totalMs,
  bool? useColor,
}) {
  final c = _paletteFor(useColor);
  final String subject;
  if (assetPath != null && assetPath.isNotEmpty) {
    subject = assetPath;
  } else if (manual || changedFiles.isEmpty) {
    subject = 'manual';
  } else if (changedFiles.length == 1) {
    subject = _basename(changedFiles.first);
  } else {
    subject = '${changedFiles.length} files';
  }
  final duration = totalMs != null ? ' ${c.dimText('(${totalMs}ms)')}' : '';
  return '${c.cyanText('↻')} ${c.boldText('Hot reload')} ${c.dimText('·')} $subject$duration';
}

/// Formats the optional `file` / `files` sub-branch of a hot reload block.
///
/// Returns `null` when a single file is already named in the header and
/// [verbose] is false.
String? formatHotReloadFilesBranch({
  required List<String> changedFiles,
  required bool verbose,
  required bool isLast,
  bool? useColor,
}) {
  if (changedFiles.isEmpty) return null;
  if (changedFiles.length == 1 && !verbose) return null;

  final c = _paletteFor(useColor);
  final branch = c.dimText(isLast ? '└─' : '├─');
  final cont = c.dimText(isLast ? '  ' : '│ ');

  if (changedFiles.length == 1) {
    return '  $branch ${c.dimText('file'.padRight(7))} ${changedFiles.first}';
  }

  if (!verbose) {
    final names = changedFiles.take(3).map(_basename).toList();
    final overflow = changedFiles.length - names.length;
    final suffix = overflow > 0 ? c.dimText(' (+$overflow more)') : '';
    return '  $branch ${c.dimText('files'.padRight(7))} ${names.join(', ')}$suffix';
  }

  final buf = StringBuffer();
  buf.writeln('  $branch ${c.dimText('files'.padRight(7))} ${changedFiles.first}');
  for (var i = 1; i < changedFiles.length; i++) {
    buf.writeln('  $cont ${' ' * 7} ${changedFiles[i]}');
  }
  return buf.toString().trimRight();
}

/// Formats the `server` sub-branch of a hot reload block.
String formatHotReloadServerBranch({
  required int rebuildMs,
  required bool cached,
  int? patchBytes,
  int? bundleBytes,
  int? changedModules,
  int? totalModules,
  int? totalPrepMs,
  required bool isLast,
  bool devLogs = false,
  bool? useColor,
}) {
  final c = _paletteFor(useColor);
  final branch = c.dimText(isLast ? '└─' : '├─');
  final parts = <String>[];
  if (cached) {
    parts.add('cached (${rebuildMs}ms)');
  } else {
    parts.add('rebuild ${rebuildMs}ms');
  }
  if (patchBytes != null && patchBytes > 0) {
    parts.add('patch ${formatByteSize(patchBytes)}');
  } else if (bundleBytes != null && bundleBytes > 0) {
    parts.add('bundle ${formatByteSize(bundleBytes)}');
  }

  var moduleInfo = '';
  if (totalModules != null && totalModules > 0) {
    if (changedModules != null && changedModules > 0 && changedModules < totalModules) {
      moduleInfo = ' ($changedModules/$totalModules modules)';
    } else {
      moduleInfo = ' ($totalModules modules)';
    }
  }
  if (devLogs && totalPrepMs != null) {
    parts.add('prep ${totalPrepMs}ms');
  }

  return '  $branch ${c.dimText('server'.padRight(7))} ${parts.join(' · ')}${c.dimText(moduleInfo)}';
}

/// Formats the header line of a hot restart block.
String formatHotRestartHeader({int? totalMs, bool? useColor}) {
  final c = _paletteFor(useColor);
  final duration = totalMs != null ? ' ${c.dimText('(${totalMs}ms)')}' : '';
  return '${c.magentaText('⟳')} ${c.boldText('Hot restart')}$duration';
}

/// Formats the `device` timing sub-branch for reload or restart.
String formatDeviceTimingBranch({
  required int totalMs,
  Map<String, int> timings = const {},
  double? mainMs,
  String summaryVerb = 'reassembled',
  required bool isLast,
  bool devLogs = false,
  bool? useColor,
}) {
  final c = _paletteFor(useColor);
  final branch = c.dimText(isLast ? '└─' : '├─');

  final visible = <String>[];
  timings.forEach((key, value) {
    // Hide internal generation-tracker step unless devLogs is enabled.
    if (!devLogs && key == 'track') return;
    visible.add('$key ${value}ms');
  });
  if (mainMs != null) {
    visible.add('main ${mainMs.toStringAsFixed(1)}ms');
  }

  final body = visible.isEmpty
      ? '$summaryVerb in ${c.boldText('${totalMs}ms')}'
      : '${visible.join(' · ')} ${c.dimText('(')}${c.boldText('${totalMs}ms')}${c.dimText(')')}';
  return '  $branch ${c.dimText('device'.padRight(7))} $body';
}

/// Formats a compact `⚡ Perf` summary block from raw `[Perf]` lines.
String formatPerfBlock(String rawMessage, {bool? useColor}) {
  final c = _paletteFor(useColor);
  final lines = rawMessage.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
  if (lines.isEmpty) return '';

  // Expected line 0:
  // [Perf] 2001ms: frames=1 builds=111 (96.8ms) paints=0 (0.0ms) recreates=0 (0.0ms) setState=0 inh=0/0 zones=1 | perFrame max 96.8ms /111 builds, slow(>16ms)=1, maxGap=0.0ms
  final first = lines.first.replaceFirst(RegExp(r'^\[Perf\]\s*'), '');
  final wallMatch = RegExp(r'^(\d+)ms:').firstMatch(first);
  final framesMatch = RegExp(r'frames=(\d+)').firstMatch(first);
  final buildsMatch = RegExp(r'builds=(\d+)\s*\(([^)]+)\)').firstMatch(first);
  final slowMatch = RegExp(r'slow\(>16ms\)=(\d+)').firstMatch(first);

  String header;
  if (wallMatch != null && framesMatch != null && buildsMatch != null) {
    final wallMs = int.tryParse(wallMatch.group(1)!) ?? 0;
    final wallLabel = wallMs >= 1000
        ? '${(wallMs / 1000).toStringAsFixed(1)}s'
        : '${wallMs}ms';
    final frames = int.tryParse(framesMatch.group(1)!) ?? 0;
    final builds = buildsMatch.group(1)!;
    final buildTime = buildsMatch.group(2)!;
    final slow = int.tryParse(slowMatch?.group(1) ?? '0') ?? 0;
    final slowTag = slow > 0 ? ', ${c.yellowText('$slow slow >16ms')}' : '';
    header =
        '${c.yellowText('⚡')} ${c.boldText('Perf')} ${c.dimText('($wallLabel)')} · '
        '$frames frame${frames == 1 ? '' : 's'} · $builds builds ($buildTime$slowTag)';
  } else {
    header = '${c.yellowText('⚡')} ${c.boldText('Perf')} $first';
  }

  final subLines = <String>[];
  for (var i = 1; i < lines.length; i++) {
    final cleaned = lines[i].replaceFirst(RegExp(r'^\[Perf\]\s*'), '');
    if (cleaned.startsWith('top builds:')) {
      final items = cleaned
          .substring('top builds:'.length)
          .trim()
          .split(', ')
          .take(4)
          .map((item) => item.replaceAll(RegExp(r'\(max [^)]+\)'), '').replaceAll('=', ' ('))
          .map((item) => item.contains('(') ? '$item)' : item)
          .toList();
      if (items.isNotEmpty) {
        subLines.add(items.join(' · '));
      }
    } else if (cleaned.isNotEmpty) {
      subLines.add(cleaned);
    }
  }

  if (subLines.isEmpty) return header;
  final buf = StringBuffer()..writeln(header);
  for (var i = 0; i < subLines.length; i++) {
    final isLast = i == subLines.length - 1;
    final branch = c.dimText(isLast ? '└─' : '├─');
    buf.writeln('  $branch ${c.dimText(subLines[i])}');
  }
  return buf.toString().trimRight();
}

// ---------------------------------------------------------------------------
// Compact AST Profile Collector & Table Formatter (Hot Restart Only)
// ---------------------------------------------------------------------------

class AstProfileEntry {
  const AstProfileEntry({
    required this.target,
    this.loadMs,
    this.astLabel,
  });

  final String target;
  final double? loadMs;
  final String? astLabel;
}

class AstProfileSummary {
  const AstProfileSummary({
    this.moduleCount,
    this.classCount,
    this.mainMs,
    this.entries = const [],
  });

  final int? moduleCount;
  final int? classCount;
  final double? mainMs;
  final List<AstProfileEntry> entries;

  bool get isEmpty =>
      moduleCount == null && classCount == null && entries.isEmpty;
}

/// Collects `[AstInterpreter] [PROFILE]` lines emitted during a single
/// evaluation so they can be rendered as one compact table on Hot Restart.
class AstProfileCollector {
  int? _moduleCount;
  int? _classCount;
  double? _mainMs;

  final Map<String, double> _moduleLoadMs = {};
  final List<({String uri, double loadMs, String astLabel})> _slowModules = [];
  final List<({String uri, String className, String astLabel})> _largestClasses =
      [];

  bool get hasData =>
      _moduleCount != null ||
      _slowModules.isNotEmpty ||
      _largestClasses.isNotEmpty;

  void reset() {
    _moduleCount = null;
    _classCount = null;
    _mainMs = null;
    _moduleLoadMs.clear();
    _slowModules.clear();
    _largestClasses.clear();
  }

  static final _bundleRe = RegExp(
    r'bundle:\s*modules=(\d+),.*?classes=(\d+),\s*mainCallSync=([^\s,]+)',
  );
  static final _moduleRe = RegExp(
    r'^module\s+(\S+):\s*AST=([^,]+),.*?loadTotal=([0-9.]+)ms',
  );
  static final _slowModuleRe = RegExp(
    r'^slow module\s+(\S+):\s*loadTotal=([0-9.]+)ms.*?AST=([^\s,]+)',
  );
  static final _classRe = RegExp(
    r'^class\s+(.+?)::([^\s:]+):\s*AST=([^\s,]+)',
  );

  /// Consumes the body after `[AstInterpreter] [PROFILE] `.
  void addLine(String profileBody) {
    final trimmed = profileBody.trim();
    final bundleMatch = _bundleRe.firstMatch(trimmed);
    if (bundleMatch != null) {
      _moduleCount = int.tryParse(bundleMatch.group(1)!);
      _classCount = int.tryParse(bundleMatch.group(2)!);
      final mainStr = bundleMatch.group(3)!;
      if (mainStr.endsWith('ms')) {
        _mainMs = double.tryParse(mainStr.substring(0, mainStr.length - 2));
      }
      return;
    }

    final modMatch = _moduleRe.firstMatch(trimmed);
    if (modMatch != null) {
      final uri = modMatch.group(1)!;
      final load = double.tryParse(modMatch.group(3)!);
      if (load != null) _moduleLoadMs[uri] = load;
      return;
    }

    final slowMatch = _slowModuleRe.firstMatch(trimmed);
    if (slowMatch != null) {
      final uri = slowMatch.group(1)!;
      final load = double.tryParse(slowMatch.group(2)!) ?? 0;
      final astLabel = _normalizeKiB(slowMatch.group(3)!);
      _moduleLoadMs.putIfAbsent(uri, () => load);
      _slowModules.add((uri: uri, loadMs: load, astLabel: astLabel));
      return;
    }

    final classMatch = _classRe.firstMatch(trimmed);
    if (classMatch != null) {
      _largestClasses.add((
        uri: classMatch.group(1)!,
        className: classMatch.group(2)!,
        astLabel: _normalizeKiB(classMatch.group(3)!),
      ));
    }
  }

  /// Builds the deduplicated compact summary (top 3 slow modules + top 3
  /// largest classes, directory + class name in one column).
  AstProfileSummary buildSummary({int maxSlow = 3, int maxClasses = 3}) {
    final entries = <AstProfileEntry>[];
    final seenTargets = <String>{};

    for (final slow in _slowModules.take(maxSlow)) {
      final shortPath = _shortenModuleUri(slow.uri);
      if (seenTargets.add(shortPath)) {
        entries.add(
          AstProfileEntry(
            target: shortPath,
            loadMs: slow.loadMs,
            astLabel: slow.astLabel,
          ),
        );
      }
    }

    for (final clazz in _largestClasses.take(maxClasses)) {
      final shortPath = _shortenModuleUri(clazz.uri, stripDartExt: true);
      final combined = '$shortPath::${clazz.className}';
      if (seenTargets.add(combined)) {
        entries.add(
          AstProfileEntry(
            target: combined,
            loadMs: _moduleLoadMs[clazz.uri],
            astLabel: clazz.astLabel,
          ),
        );
      }
    }

    return AstProfileSummary(
      moduleCount: _moduleCount,
      classCount: _classCount,
      mainMs: _mainMs,
      entries: entries,
    );
  }

  static String _shortenModuleUri(String uri, {bool stripDartExt = false}) {
    var out = uri;
    if (out.startsWith('package:')) {
      final slash = out.indexOf('/');
      if (slash != -1) out = out.substring(slash + 1);
    }
    if (out.startsWith('screens/')) {
      out = out.substring('screens/'.length);
    }
    if (stripDartExt && out.endsWith('.dart')) {
      out = out.substring(0, out.length - '.dart'.length);
    }
    return out;
  }

  static String _normalizeKiB(String raw) {
    final m = RegExp(r'^([0-9.]+)(KiB|B|MiB)$').firstMatch(raw);
    if (m == null) return raw;
    final val = double.tryParse(m.group(1)!);
    final unit = m.group(2)!;
    if (val == null) return raw;
    if (unit == 'KiB' && val >= 10) {
      return '${val.round()} KiB';
    }
    return '${m.group(1)} $unit';
  }
}

/// Formats the compact single-column-target profile table shown under
/// Hot Restart in verbose mode.
String formatProfileBranch(
  AstProfileSummary summary, {
  bool isLast = true,
  bool? useColor,
}) {
  if (summary.entries.isEmpty) return '';
  final c = _paletteFor(useColor);
  final branch = c.dimText(isLast ? '└─' : '├─');
  const maxTargetWidth = 42;
  const loadWidth = 9;
  const astWidth = 8;

  final buf = StringBuffer();
  buf.writeln('  $branch ${c.dimText('profile')}');
  buf.writeln(
    '       ${c.dimText('Module / Class'.padRight(maxTargetWidth))} '
    '${c.dimText('Load'.padLeft(loadWidth))} '
    '${c.dimText('AST'.padLeft(astWidth))}',
  );

  for (final entry in summary.entries) {
    final target = _truncate(entry.target, maxTargetWidth).padRight(maxTargetWidth);
    final loadStr = entry.loadMs != null
        ? '${entry.loadMs!.toStringAsFixed(1)}ms'
        : '—';
    final astStr = entry.astLabel ?? '—';
    buf.writeln(
      '       $target '
      '${loadStr.padLeft(loadWidth)} '
      '${c.dimText(astStr.padLeft(astWidth))}',
    );
  }
  return buf.toString().trimRight();
}

String _truncate(String s, int maxLen) {
  if (s.length <= maxLen) return s;
  return '${s.substring(0, maxLen - 1)}…';
}

String _basename(String path) {
  final norm = path.replaceAll(r'\', '/');
  final idx = norm.lastIndexOf('/');
  return idx == -1 ? norm : norm.substring(idx + 1);
}

// ---------------------------------------------------------------------------
// Streaming Action Coordinator (Option A)
// ---------------------------------------------------------------------------

enum _ActiveAction { none, connected, reload, restart }

/// Coordinates streaming server + device logs so each action prints one clean
/// colored block with `├─` / `└─` sub-branches instead of raw bracketed spam.
class DevServerConsole {
  DevServerConsole({
    void Function(String line)? sink,
    this.useColor,
  }) : _sink = sink ?? print;

  final void Function(String line) _sink;
  final bool? useColor;

  _ActiveAction _activeAction = _ActiveAction.none;
  final AstProfileCollector _profileCollector = AstProfileCollector();
  bool _inlineSpinnerOpen = false;
  Timer? _spinnerTimer;
  Stopwatch? _spinnerStopwatch;
  int _spinnerFrame = 0;
  bool _gotStructuredStats = false;
  bool _gotLaunchStats = false;
  bool _connectBundlePrinted = false;
  ({
    String name,
    int byteSize,
    int? moduleCount,
    int? assetCount,
    int? serveMs,
    DateTime at,
  })? _recentServedBundle;

  bool get _verbose => DartGoLogger.verbose;
  bool get _devLogs => DartGoLogger.devLogs;

  /// Releases any active spinner timer (call on server shutdown).
  void dispose() {
    _stopSpinner();
  }

  void _emit(String text) {
    if (_inlineSpinnerOpen) {
      _clearInlineLine();
    }
    _sink(text);
  }

  void _stopSpinner() {
    _spinnerTimer?.cancel();
    _spinnerTimer = null;
    _spinnerStopwatch?.stop();
    _spinnerStopwatch = null;
  }

  void _clearInlineLine() {
    _stopSpinner();
    _inlineSpinnerOpen = false;
    try {
      if (identical(_sink, print) && stdout.hasTerminal) {
        stdout.write('\r\x1B[2K');
      }
    } catch (_) {}
  }

  /// Starts an animated single-line spinner on interactive terminals.
  ///
  /// When [leadingNewline] is true, prints a blank line before the spinner so
  /// clearing and replacing the spinner preserves visual spacing above.
  void _startInlineSpinner(
    String Function(int frame, int elapsedMs) render, {
    bool leadingNewline = false,
    Duration maxDuration = const Duration(seconds: 30),
  }) {
    _stopSpinner();
    try {
      if (identical(_sink, print) && stdout.hasTerminal) {
        _spinnerFrame = 0;
        _spinnerStopwatch = Stopwatch()..start();
        if (leadingNewline) stdout.write('\n');
        stdout.write(render(0, 0));
        _inlineSpinnerOpen = true;
        _spinnerTimer = Timer.periodic(const Duration(milliseconds: 80), (_) {
          if (!_inlineSpinnerOpen) return;
          final elapsed = _spinnerStopwatch?.elapsedMilliseconds ?? 0;
          if (elapsed >= maxDuration.inMilliseconds) {
            _clearInlineLine();
            return;
          }
          _spinnerFrame = (_spinnerFrame + 1) % _kSpinnerFrames.length;
          try {
            stdout.write('\r\x1B[2K${render(_spinnerFrame, elapsed)}');
          } catch (_) {
            _stopSpinner();
          }
        });
      }
    } catch (_) {}
  }

  void printStartup(StartupScreenInfo info) {
    _stopSpinner();
    _inlineSpinnerOpen = false;
    if (identical(_sink, print)) {
      try {
        if (stdout.hasTerminal) stdout.write('\x1B[2J\x1B[0;0H');
      } catch (_) {}
    }
    _activeAction = _ActiveAction.none;
    _sink(formatStartupScreen(info, useColor: useColor).trimRight());
  }

  void beginBundling() {
    _startInlineSpinner(
      (frame, elapsed) => formatBundlingStatus(
        frameIndex: frame,
        elapsedMs: elapsed,
        useColor: useColor,
      ),
      leadingNewline: true,
    );
    if (!_inlineSpinnerOpen) {
      _emit('\n${formatBundlingStatus(useColor: useColor)}');
    }
  }

  void endBundlingSuccess({
    required int elapsedMs,
    required int moduleCount,
    required int byteSize,
    String? etag,
  }) {
    final wasInline = _inlineSpinnerOpen;
    if (wasInline) _clearInlineLine();
    final prefix = wasInline ? '' : '\n';
    _activeAction = _ActiveAction.none;
    _sink(
      '$prefix${formatBundledResult(elapsedMs: elapsedMs, moduleCount: moduleCount, byteSize: byteSize, etag: etag, devLogs: _devLogs, useColor: useColor)}',
    );
  }

  void endBundlingWarning(String title, String detail) {
    final wasInline = _inlineSpinnerOpen;
    if (wasInline) _clearInlineLine();
    final prefix = wasInline ? '' : '\n';
    _activeAction = _ActiveAction.none;
    _sink('$prefix${formatWarningBlock(title, detail, useColor: useColor)}');
  }

  void onDeviceConnected(int activeCount, {String? deviceName}) {
    _activeAction = _ActiveAction.connected;
    _gotLaunchStats = false;
    _connectBundlePrinted = false;
    _profileCollector.reset();

    final c = _paletteFor(useColor);
    final buf = StringBuffer()
      ..writeln()
      ..write(
        formatDeviceConnected(
          activeCount,
          deviceName: deviceName,
          useColor: useColor,
        ),
      );

    // If the device fetched `guest.ast` right before upgrading `/ws`, stream
    // the bundle line immediately (works in Normal mode and for older shells).
    final recent = _recentServedBundle;
    if (recent != null &&
        DateTime.now().difference(recent.at) < const Duration(seconds: 10)) {
      _recentServedBundle = null;
      _connectBundlePrinted = true;
      final parts = <String>[
        recent.name,
        formatByteSize(recent.byteSize),
        if (recent.moduleCount != null && recent.moduleCount! > 0)
          '${recent.moduleCount} module${recent.moduleCount == 1 ? '' : 's'}',
        if (recent.assetCount != null && recent.assetCount! > 0)
          '${recent.assetCount} asset${recent.assetCount == 1 ? '' : 's'}',
        if (recent.serveMs != null && recent.serveMs! > 0)
          'served ${recent.serveMs}ms',
      ];
      buf.writeln();
      buf.write(
        '  ${c.dimText('├─')} ${c.dimText('bundle'.padRight(7))} ${parts.join(' · ')}',
      );
    }

    _emit(buf.toString());
    _startInlineSpinner(
      (frame, elapsed) => formatPendingBranch(
        label: 'launch',
        actionText: 'launching…',
        frameIndex: frame,
        elapsedMs: elapsed,
        useColor: useColor,
      ),
    );
  }

  void onDeviceDisconnected(int activeCount, {String? deviceName}) {
    _activeAction = _ActiveAction.none;
    _connectBundlePrinted = false;
    _emit(
      '\n${formatDeviceDisconnected(activeCount, deviceName: deviceName, useColor: useColor)}',
    );
  }

  /// Renders initial device launch metrics (`bundle` + `launch` timings)
  /// directly under `● Device connected` in both Normal and Verbose modes.
  void onDeviceLaunch({
    String? mode,
    required int totalMs,
    required Map<String, int> timings,
    int? bundleBytes,
    int? moduleCount,
    int? assetCount,
  }) {
    _gotLaunchStats = true;
    final summary = _profileCollector.hasData
        ? _profileCollector.buildSummary()
        : const AstProfileSummary();
    _profileCollector.reset();

    final c = _paletteFor(useColor);
    final buf = StringBuffer();

    if (!_connectBundlePrinted) {
      final bundleParts = <String>[
        if (mode != null && mode.isNotEmpty) mode,
        if (bundleBytes != null && bundleBytes > 0) formatByteSize(bundleBytes),
        if (moduleCount != null && moduleCount > 0)
          '$moduleCount module${moduleCount == 1 ? '' : 's'}'
        else if (summary.moduleCount != null)
          '${summary.moduleCount} modules',
        if (_verbose && summary.classCount != null)
          '${summary.classCount} classes',
        if (assetCount != null && assetCount > 0)
          '$assetCount asset${assetCount == 1 ? '' : 's'}',
      ];

      if (bundleParts.isNotEmpty) {
        buf.writeln(
          '  ${c.dimText('├─')} ${c.dimText('bundle'.padRight(7))} ${bundleParts.join(' · ')}',
        );
      }
    }

    final timingParts = <String>[];
    for (final entry in timings.entries) {
      // Hide `ws` handshake time unless verbose/devLogs; keep fetch/sync/exec/mount.
      if (!_verbose && !_devLogs && entry.key == 'ws') continue;
      timingParts.add('${entry.key} ${entry.value}ms');
    }
    if (_verbose && summary.mainMs != null) {
      timingParts.add('main ${summary.mainMs!.toStringAsFixed(1)}ms');
    }

    final launchBody = timingParts.isEmpty
        ? 'ready in ${c.boldText('${totalMs}ms')}'
        : '${timingParts.join(' · ')} ${c.dimText('(')}${c.boldText('${totalMs}ms')}${c.dimText(')')}';
    buf.write(
      '  ${c.dimText('└─')} ${c.dimText('launch'.padRight(7))} $launchBody',
    );

    _emit(buf.toString());
    _activeAction = _ActiveAction.none;
    _connectBundlePrinted = false;
  }

  void onArtifactServed({
    required String name,
    required int byteSize,
    String? etag,
    int? moduleCount,
    int? assetCount,
    int? serveMs,
    bool isPatch = false,
    bool isFont = false,
  }) {
    // Patch size is already included in the `↻ Hot reload` server sub-line;
    // only emit raw HTTP patch logs in devLogs mode.
    if (isPatch && !_devLogs) return;
    // On-demand font serving is verbose/dev noise.
    if (isFont && !_verbose && !_devLogs) return;

    // Remember full bundle serves so `onDeviceConnected` can immediately attach
    // the bundle summary (devices fetch `/guest.ast` right before `/ws`).
    if (!isPatch && !isFont && name == 'guest.ast') {
      _recentServedBundle = (
        name: name,
        byteSize: byteSize,
        moduleCount: moduleCount,
        assetCount: assetCount,
        serveMs: serveMs,
        at: DateTime.now(),
      );
    }

    if (_activeAction == _ActiveAction.connected && !isPatch && !isFont) {
      if (!_connectBundlePrinted) {
        _connectBundlePrinted = true;
        _emit(
          formatServedBranch(
            artifactName: name,
            byteSize: byteSize,
            etag: etag,
            devLogs: _devLogs,
            isLast: false,
            useColor: useColor,
          ),
        );
      }
      return;
    }

    if (_devLogs) {
      final c = _paletteFor(useColor);
      final extra = (etag != null && etag.isNotEmpty) ? ' · etag=$etag' : '';
      _emit(
        '  ${c.dimText('·')} ${c.dimText('served')} $name (${formatByteSize(byteSize)}$extra)',
      );
    }
  }

  /// Starts a streaming hot reload block after server prep completes.
  void beginCodeReload({
    required List<String> changedFiles,
    required int rebuildMs,
    required bool cached,
    int? patchBytes,
    int? bundleBytes,
    int? totalModules,
    int? totalPrepMs,
    required int connectedClients,
  }) {
    _profileCollector.reset();
    _gotStructuredStats = false;
    final hasDevices = connectedClients > 0;
    final buf = StringBuffer()
      ..writeln()
      ..writeln(
        formatHotReloadHeader(changedFiles: changedFiles, useColor: useColor),
      );

    final filesBranch = formatHotReloadFilesBranch(
      changedFiles: changedFiles,
      verbose: _verbose,
      isLast: false,
      useColor: useColor,
    );
    if (filesBranch != null) buf.writeln(filesBranch);

    buf.writeln(
      formatHotReloadServerBranch(
        rebuildMs: rebuildMs,
        cached: cached,
        patchBytes: patchBytes,
        bundleBytes: bundleBytes,
        changedModules: changedFiles.length,
        totalModules: totalModules,
        totalPrepMs: totalPrepMs,
        isLast: false,
        devLogs: _devLogs,
        useColor: useColor,
      ),
    );

    if (!hasDevices) {
      final c = _paletteFor(useColor);
      buf.write(
        '  ${c.dimText('└─')} ${c.dimText('device'.padRight(7))} ${c.dimText('no devices connected')}',
      );
      _activeAction = _ActiveAction.none;
      _emit(buf.toString().trimRight());
    } else {
      _activeAction = _ActiveAction.reload;
      _emit(buf.toString().trimRight());
      _startInlineSpinner(
        (frame, elapsed) => formatPendingBranch(
          label: 'device',
          actionText: 'reloading…',
          frameIndex: frame,
          elapsedMs: elapsed,
          useColor: useColor,
        ),
      );
    }
  }

  void beginManualReload({required int connectedClients}) {
    _profileCollector.reset();
    _gotStructuredStats = false;
    final buf = StringBuffer()
      ..writeln()
      ..writeln(formatHotReloadHeader(manual: true, useColor: useColor));
    if (connectedClients <= 0) {
      final c = _paletteFor(useColor);
      buf.write(
        '  ${c.dimText('└─')} ${c.dimText('device'.padRight(7))} ${c.dimText('no devices connected')}',
      );
      _activeAction = _ActiveAction.none;
      _emit(buf.toString().trimRight());
    } else {
      _activeAction = _ActiveAction.reload;
      _emit(buf.toString().trimRight());
      _startInlineSpinner(
        (frame, elapsed) => formatPendingBranch(
          label: 'device',
          actionText: 'reloading…',
          frameIndex: frame,
          elapsedMs: elapsed,
          useColor: useColor,
        ),
      );
    }
  }

  void beginAssetReload({
    required String assetPath,
    required int connectedClients,
  }) {
    _profileCollector.reset();
    _gotStructuredStats = false;
    final buf = StringBuffer()
      ..writeln()
      ..writeln(
        formatHotReloadHeader(assetPath: assetPath, useColor: useColor),
      );
    if (connectedClients <= 0) {
      final c = _paletteFor(useColor);
      buf.write(
        '  ${c.dimText('└─')} ${c.dimText('device'.padRight(7))} ${c.dimText('no devices connected')}',
      );
      _activeAction = _ActiveAction.none;
      _emit(buf.toString().trimRight());
    } else {
      _activeAction = _ActiveAction.reload;
      _emit(buf.toString().trimRight());
      _startInlineSpinner(
        (frame, elapsed) => formatPendingBranch(
          label: 'device',
          actionText: 'syncing…',
          frameIndex: frame,
          elapsedMs: elapsed,
          useColor: useColor,
        ),
      );
    }
  }

  void beginHotRestart({required int connectedClients}) {
    _profileCollector.reset();
    _gotStructuredStats = false;
    final buf = StringBuffer()
      ..writeln()
      ..writeln(formatHotRestartHeader(useColor: useColor));
    if (connectedClients <= 0) {
      final c = _paletteFor(useColor);
      buf.write(
        '  ${c.dimText('└─')} ${c.dimText('device'.padRight(7))} ${c.dimText('no devices connected')}',
      );
      _activeAction = _ActiveAction.none;
      _emit(buf.toString().trimRight());
    } else {
      _activeAction = _ActiveAction.restart;
      _emit(buf.toString().trimRight());
      _startInlineSpinner(
        (frame, elapsed) => formatPendingBranch(
          label: 'device',
          actionText: 'restarting…',
          frameIndex: frame,
          elapsedMs: elapsed,
          useColor: useColor,
        ),
      );
    }
  }

  void onRebuildFailed(int elapsedMs, String error) {
    _activeAction = _ActiveAction.none;
    _emit(
      '\n${formatWarningBlock('Rebuild failed (${elapsedMs}ms)', error, useColor: useColor)}',
    );
  }

  /// Handles structured reload/restart completion telemetry sent by newer
  /// mobile shells (`type: 'reload_stats'` / `'restart_stats'`).
  void onStructuredReloadOrRestart({
    required bool isRestart,
    required int totalMs,
    required Map<String, int> timings,
  }) {
    _gotStructuredStats = true;
    if (isRestart) {
      _finishRestart(totalMs: totalMs, timings: timings);
    } else {
      _finishReload(totalMs: totalMs, timings: timings);
    }
  }

  void onVerboseToggled(
    bool enabled, {
    StartupScreenInfo? startupInfo,
    bool fromApp = false,
  }) {
    final c = _paletteFor(useColor);
    final origin = fromApp ? ' (from app)' : '';
    final status = enabled
        ? '${c.greenText('●')} ${c.boldText('Verbose mode ON')}${c.dimText(origin)}'
        : '${c.dimText('○')} ${c.dimText('Verbose mode OFF$origin')}';
    _emit('\n$status');

    if (enabled && startupInfo != null) {
      final info = startupInfo.copyWith(verbose: true);
      _emit(formatVerboseEndpoints(info, useColor: useColor).trimRight());
      final diag = formatVerboseDiagnostics(info, useColor: useColor).trimRight();
      if (diag.isNotEmpty) {
        _emit('\n$diag');
      }
    }
  }

  void onWarning(String title, String detail) {
    _emit('\n${formatWarningBlock(title, detail, useColor: useColor)}');
  }

  void onError(String title, String message) {
    _emit('\n${formatErrorBlock(title, message, useColor: useColor)}');
  }

  /// Parses, filters, and formats a `type: 'log'` message sent from the device.
  void onDeviceLog(String message, {String level = 'INFO'}) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;

    // 1. Errors always display prominently in red.
    if (level == 'ERROR' || trimmed.startsWith('[ERROR]')) {
      final body = trimmed.replaceFirst(RegExp(r'^\[ERROR\]\s*'), '');
      _emit('\n${formatErrorBlock('Device error', body, useColor: useColor)}');
      return;
    }

    // 2. Collect `[AstInterpreter] [PROFILE] ...` lines without raw spam.
    final profileIdx = trimmed.indexOf('[PROFILE] ');
    if (trimmed.startsWith('[AstInterpreter]') && profileIdx != -1) {
      final body = trimmed.substring(profileIdx + '[PROFILE] '.length);
      if (_activeAction != _ActiveAction.reload) {
        _profileCollector.addLine(body);
      }
      if (_devLogs) {
        final c = _paletteFor(useColor);
        _emit('  ${c.dimText('[dev] $trimmed')}');
      }
      return;
    }

    // 3. Reload completion log: `[RELOAD] AST finished in 299ms (fetch=8ms, ...)`
    final reloadMatch = _reloadLogRe.firstMatch(trimmed);
    if (reloadMatch != null) {
      if (_gotStructuredStats) {
        _gotStructuredStats = false;
        return;
      }
      final totalMs = int.tryParse(reloadMatch.group(2)!) ?? 0;
      final timings = _parseTimingsMap(reloadMatch.group(3));
      _finishReload(totalMs: totalMs, timings: timings);
      return;
    }

    // 4. Restart completion log:
    //    `[RESTART] AST finished in 485ms (...)` or
    //    `[Runner] [TIME] Hot Restart (AST) ready in 485ms`
    final restartMatch =
        _restartLogRe.firstMatch(trimmed) ?? _legacyRestartRe.firstMatch(trimmed);
    if (restartMatch != null) {
      if (_gotStructuredStats) {
        _gotStructuredStats = false;
        return;
      }
      final totalMs = int.tryParse(restartMatch.group(2)!) ?? 0;
      final timings = restartMatch.groupCount >= 3
          ? _parseTimingsMap(restartMatch.group(3))
          : const <String, int>{};
      _finishRestart(totalMs: totalMs, timings: timings);
      return;
    }

    // 4b. Legacy initial launch summary from older mobile shells:
    //     `[Runner] [PROFILE] project launch: bundleFetch=..., evaluation=..., total=...`
    final legacyLaunch = _legacyLaunchRe.firstMatch(trimmed);
    if (legacyLaunch != null) {
      if (_gotLaunchStats) {
        if (_devLogs) {
          final c = _paletteFor(useColor);
          _emit('  ${c.dimText('[dev] $trimmed')}');
        }
        return;
      }
      final rawMap = _parseTimingsMap(legacyLaunch.group(1));
      final totalMs = rawMap['total'] ?? 0;
      final timings = <String, int>{
        if (rawMap.containsKey('bundleFetch')) 'fetch': rawMap['bundleFetch']!,
        if ((rawMap['iconFonts'] ?? 0) > 0) 'sync': rawMap['iconFonts']!,
        if (rawMap.containsKey('websocket')) 'ws': rawMap['websocket']!,
        if (rawMap.containsKey('evaluation')) 'exec': rawMap['evaluation']!,
      };
      onDeviceLaunch(totalMs: totalMs, timings: timings);
      return;
    }

    // 5. Internal engine/protocol timing logs — dev-only.
    if (_isDevInternalLog(trimmed)) {
      if (_devLogs) {
        final c = _paletteFor(useColor);
        _emit('  ${c.dimText('[dev] $trimmed')}');
      }
      return;
    }

    // 6. Frame perf summaries — verbose/dev only.
    if (trimmed.startsWith('[Perf]')) {
      if (_verbose || _devLogs) {
        _emit('\n${formatPerfBlock(trimmed, useColor: useColor)}');
      }
      return;
    }

    // 7. Regular guest app `print(...)` / info logs.
    final c = _paletteFor(useColor);
    _emit('${c.cyanText('›')} $trimmed');
  }

  void _finishReload({
    required int totalMs,
    required Map<String, int> timings,
  }) {
    // Never print AST profile tables on hot reload.
    _profileCollector.reset();

    if (_activeAction == _ActiveAction.reload) {
      _emit(
        formatDeviceTimingBranch(
          totalMs: totalMs,
          timings: timings,
          isLast: true,
          devLogs: _devLogs,
          useColor: useColor,
        ),
      );
      _activeAction = _ActiveAction.none;
      return;
    }

    // Standalone reload initiated from device DevTools.
    final buf = StringBuffer()
      ..writeln()
      ..writeln(formatHotReloadHeader(totalMs: totalMs, useColor: useColor))
      ..write(
        formatDeviceTimingBranch(
          totalMs: totalMs,
          timings: timings,
          isLast: true,
          devLogs: _devLogs,
          useColor: useColor,
        ),
      );
    _emit(buf.toString());
    _activeAction = _ActiveAction.none;
  }

  void _finishRestart({
    required int totalMs,
    required Map<String, int> timings,
  }) {
    final summary = (_verbose && _profileCollector.hasData)
        ? _profileCollector.buildSummary()
        : const AstProfileSummary();
    _profileCollector.reset();

    final hasProfile = !summary.isEmpty && summary.entries.isNotEmpty;
    final c = _paletteFor(useColor);
    final buf = StringBuffer();

    if (_activeAction != _ActiveAction.restart) {
      buf.writeln();
      buf.writeln(
        formatHotRestartHeader(totalMs: totalMs, useColor: useColor),
      );
    }

    if (summary.moduleCount != null || summary.classCount != null) {
      final parts = <String>[
        if (summary.moduleCount != null) '${summary.moduleCount} modules',
        if (summary.classCount != null) '${summary.classCount} classes',
      ];
      buf.writeln(
        '  ${c.dimText('├─')} ${c.dimText('bundle'.padRight(7))} ${parts.join(' · ')}',
      );
    }

    buf.writeln(
      formatDeviceTimingBranch(
        totalMs: totalMs,
        timings: timings,
        mainMs: _verbose ? summary.mainMs : null,
        summaryVerb: 'restarted',
        isLast: !hasProfile,
        devLogs: _devLogs,
        useColor: useColor,
      ),
    );

    if (hasProfile) {
      buf.writeln(
        formatProfileBranch(summary, isLast: true, useColor: useColor),
      );
    }

    _emit(buf.toString().trimRight());
    _activeAction = _ActiveAction.none;
  }

  static final _reloadLogRe = RegExp(
    r'^\[RELOAD\]\s+(\w+)\s+finished in\s+(\d+)ms(?:\s*\(([^)]*)\))?',
  );
  static final _restartLogRe = RegExp(
    r'^\[RESTART\]\s+(\w+)\s+finished in\s+(\d+)ms(?:\s*\(([^)]*)\))?',
  );
  static final _legacyRestartRe = RegExp(
    r'^\[Runner\]\s+\[TIME\]\s+Hot Restart\s*\(([^)]+)\)\s+ready in\s+(\d+)ms(?:\s*\(([^)]*)\))?',
  );
  static final _legacyLaunchRe = RegExp(
    r'^(?:\[Runner\]\s+)?\[PROFILE\]\s+project launch:\s*(.+)$',
  );

  static Map<String, int> _parseTimingsMap(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const {};
    final result = <String, int>{};
    for (final part in raw.split(',')) {
      final kv = part.trim().split('=');
      if (kv.length != 2) continue;
      final key = kv[0].trim();
      final valStr = kv[1].trim().replaceAll(RegExp(r'ms$'), '');
      final val = int.tryParse(valStr);
      if (val != null) result[key] = val;
    }
    return result;
  }

  static bool _isDevInternalLog(String line) {
    if (line.startsWith('[BundleLoader] [TIME]')) return true;
    if (line.startsWith('[AstInterpreter] [TIME]')) return true;
    if (line.startsWith('[D4rtProfiler]')) return true;
    if (line.startsWith('[PROFILE] project preparation:')) return true;
    if (line.startsWith('[Runner] [PROFILE] project preparation:')) return true;
    return false;
  }
}

// ---------------------------------------------------------------------------
// Backwards-compatible helpers + Interactive Stdin Commands
// ---------------------------------------------------------------------------

void printBanner([DngoVersionInfo versions = DngoVersionInfo.current]) {
  final c = TerminalPalette.auto();
  print(
    '${c.boldText('DartNative Go')}  ·  dngo v${versions.dngoVersion}  ·  '
    'DartNative v${versions.dartNativeVersion}',
  );
}

void printConnectionInfo(String serverUrl) {
  final c = TerminalPalette.auto();
  print('${c.dimText('Local')}  ${c.cyanText('$serverUrl$kDngoLoadingPath')}');
}

void printDeepLink(String link) {
  final c = TerminalPalette.auto();
  print('${c.dimText('Link')}   ${c.cyanText(link)}');
}

void printHelpHint() {
  final c = TerminalPalette.auto();
  print('${c.dimText('Press h for commands')}\n');
}

void printQr(String serverUrl) {
  final url = serverUrl.endsWith(kDngoLoadingPath)
      ? serverUrl
      : '$serverUrl$kDngoLoadingPath';
  print(formatQrBlock(url));
}

/// Single-key commands read from stdin while the server runs.
class StdinCommands {
  StdinCommands({
    required this.serverUrl,
    required this.hub,
    required this.onStop,
    this.console,
    this.startupInfo,
  });

  final String serverUrl;
  final DevSocketHub hub;
  final DevServerConsole? console;
  final StartupScreenInfo? startupInfo;

  /// Called on Ctrl+C; must release the server.
  final void Function() onStop;

  StreamSubscription<List<int>>? _sub;

  void start() {
    try {
      if (stdin.hasTerminal) {
        stdin.lineMode = false;
        stdin.echoMode = false;
      }
    } catch (_) {}
    _sub = stdin.listen((bytes) {
      for (final byte in bytes) {
        if (byte == 3) {
          onStop();
          exit(0);
        }
        // `R` (hot restart) is case-sensitive; every other command is
        // accepted in either case, as before.
        final ch = String.fromCharCode(byte);
        _handle(ch == 'R' ? ch : ch.toLowerCase());
      }
    });
  }

  void stop() {
    try {
      if (stdin.hasTerminal) {
        stdin.lineMode = true;
        stdin.echoMode = true;
      }
    } catch (_) {}
    _sub?.cancel();
  }

  void _handle(String key) {
    switch (key) {
      case 'h':
        print(formatCommandsHelp(verbose: DartGoLogger.verbose));
      case 'r':
        console?.beginManualReload(connectedClients: hub.clientCount);
        hub.broadcastReload();
      case 'R':
        console?.beginHotRestart(connectedClients: hub.clientCount);
        hub.broadcastRestart();
      case 'v':
        final enabled = DartGoLogger.toggleVerbose();
        hub.broadcast({'type': 'set_verbose', 'enabled': enabled});
        if (console != null) {
          console!.onVerboseToggled(enabled, startupInfo: startupInfo);
        } else {
          print('\n[VERBOSE] ${verboseLabel(enabled)}\n');
        }
      case 'q':
        printQr(serverUrl);
      case 'c':
        if (console != null && startupInfo != null) {
          console!.printStartup(
            startupInfo!.copyWith(
              verbose: DartGoLogger.verbose,
              devLogs: DartGoLogger.devLogs,
            ),
          );
        } else {
          print('\x1B[2J\x1B[0;0H');
          printConnectionInfo(serverUrl);
          printHelpHint();
        }
    }
  }
}
