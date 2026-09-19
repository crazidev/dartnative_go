import 'package:tom_d4rt/tom_d4rt.dart';
import 'package:dartnative_go/src/interpreter/auto_import_parser.dart';

void main() {
  print('Testing Hot Reload Module Cache invalidation...');

  // Generation 1: Submodule has print 'version 1'
  var sourcesV1 = {
    'main.dart': '''
import 'reset_button.dart';
String getCallbackMessage() {
  return ResetButton().onPressed();
}
''',
    'reset_button.dart': '''
class ResetButton {
  String onPressed() {
    return 'onPressed: reset count 1';
  }
}
''',
  };

  var interpreter = D4rt();
  var virtualV1 = AutoImportParser.buildVirtualSourceMap(sourcesV1);

  var res1 = interpreter.execute(
    source: virtualV1['main.dart']!,
    name: 'getCallbackMessage',
    library: 'package:guest_app/main.dart',
    sources: virtualV1,
  );
  assert(res1 == 'onPressed: reset count 1', 'Expected v1, got: $res1');
  print('✓ Gen 1 output: $res1');

  // Generation 2: Submodule updated to 'version 2' (like user's reset_button.dart)
  var sourcesV2 = {
    'main.dart': '''
import 'reset_button.dart';
String getCallbackMessage() {
  return ResetButton().onPressed();
}
''',
    'reset_button.dart': '''
class ResetButton {
  String onPressed() {
    return 'onPressed: reset count 2';
  }
}
''',
  };

  // Before our fix: Without interpreter.dispose(), ModuleLoader._moduleCache held old reset_button.dart!
  // With our fix: interpreter.dispose() drops ModuleLoader._moduleCache:
  interpreter.dispose();
  interpreter = D4rt();

  var virtualV2 = AutoImportParser.buildVirtualSourceMap(sourcesV2);
  var res2 = interpreter.execute(
    source: virtualV2['main.dart']!,
    name: 'getCallbackMessage',
    library: 'package:guest_app/main.dart',
    sources: virtualV2,
  );

  assert(res2 == 'onPressed: reset count 2', 'Expected v2 callback, got: $res2');
  print('✓ Gen 2 output after hot reload: $res2');

  print('\n🎉 Hot Reload Module Invalidation test passed successfully!');
}
