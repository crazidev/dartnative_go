import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/dap/dap_server.dart';
import 'package:dartnative_go/src/dap/protocol.dart';
import 'package:dartnative_go/src/dap/variable_store.dart';
import 'package:test/test.dart';

class MockIOSink implements IOSink {
  final StringBuffer buffer = StringBuffer();
  final Completer<void> _doneCompleter = Completer<void>();

  @override
  void add(List<int> data) {
    buffer.write(utf8.decode(data));
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  void write(Object? obj) {
    buffer.write(obj);
  }

  @override
  void writeAll(Iterable objects, [String separator = '']) {
    buffer.writeAll(objects, separator);
  }

  @override
  void writeln([Object? obj = '']) {
    buffer.writeln(obj);
  }

  @override
  void writeCharCode(int charCode) {
    buffer.writeCharCode(charCode);
  }

  @override
  Future<void> addStream(Stream<List<int>> stream) async {
    await for (final data in stream) {
      add(data);
    }
  }

  @override
  Future<void> flush() async {}

  @override
  Future<void> close() async {
    if (!_doneCompleter.isCompleted) _doneCompleter.complete();
  }

  @override
  Future<void> get done => _doneCompleter.future;

  @override
  Encoding encoding = utf8;
}

void main() {
  group('DapVariableStore', () {
    late DapVariableStore store;

    setUp(() {
      store = DapVariableStore();
    });

    test('creates scalar variables with reference 0', () {
      final intVar = store.createVariable('myInt', 42);
      expect(intVar['name'], 'myInt');
      expect(intVar['value'], '42');
      expect(intVar['type'], 'int');
      expect(intVar['variablesReference'], 0);

      final strVar = store.createVariable('myStr', 'hello');
      expect(strVar['value'], '"hello"');
      expect(strVar['type'], 'String');
      expect(strVar['variablesReference'], 0);

      final nullVar = store.createVariable('myNull', null);
      expect(nullVar['value'], 'null');
      expect(nullVar['type'], 'Null');
      expect(nullVar['variablesReference'], 0);
    });

    test('creates expandable Map variables and retrieves children', () {
      final map = {'title': 'Buy milk', 'count': 3};
      final mapVar = store.createVariable('note', map);
      expect(mapVar['type'], 'Map');
      final ref = mapVar['variablesReference'] as int;
      expect(ref, greaterThan(0));

      final children = store.getChildVariables(ref);
      expect(children.length, 2);
      expect(children.any((c) => c['name'] == 'title' && c['value'] == '"Buy milk"'), isTrue);
      expect(children.any((c) => c['name'] == 'count' && c['value'] == '3'), isTrue);
    });

    test('creates expandable List variables and retrieves children', () {
      final list = ['Apple', 'Banana', 'Orange'];
      final listVar = store.createVariable('fruits', list);
      expect(listVar['type'], 'List');
      final ref = listVar['variablesReference'] as int;
      expect(ref, greaterThan(0));

      final children = store.getChildVariables(ref);
      expect(children.length, 3);
      expect(children[0]['name'], '[0]');
      expect(children[0]['value'], '"Apple"');
      expect(children[1]['name'], '[1]');
      expect(children[1]['value'], '"Banana"');
    });
  });

  group('DartNativeDapServer', () {
    late StreamController<List<int>> inController;
    late MockIOSink outSink;
    late DartNativeDapServer server;

    setUp(() {
      inController = StreamController<List<int>>();
      outSink = MockIOSink();
      server = DartNativeDapServer(input: inController.stream, output: outSink);
    });

    tearDown(() async {
      await inController.close();
    });

    void sendDapRequest(Map<String, dynamic> requestJson) {
      final jsonStr = jsonEncode(requestJson);
      final bytes = utf8.encode(jsonStr);
      final message = 'Content-Length: ${bytes.length}\r\n\r\n$jsonStr';
      inController.add(utf8.encode(message));
    }

    List<Map<String, dynamic>> parseOutboundMessages() {
      final outputStr = outSink.buffer.toString();
      final messages = <Map<String, dynamic>>[];
      final regex = RegExp(r'Content-Length:\s*(\d+)\r\n\r\n');
      var index = 0;

      while (true) {
        final match = regex.firstMatch(outputStr.substring(index));
        if (match == null) break;

        final length = int.parse(match.group(1)!);
        final payloadStart = index + match.end;
        final payloadEnd = payloadStart + length;
        if (payloadEnd > outputStr.length) break;

        final jsonStr = outputStr.substring(payloadStart, payloadEnd);
        messages.add(jsonDecode(jsonStr) as Map<String, dynamic>);
        index = payloadEnd;
      }

      return messages;
    }

    test('handles initialize request and emits initialized event', () async {
      final serverFuture = server.start();

      sendDapRequest({
        'seq': 1,
        'type': 'request',
        'command': 'initialize',
        'arguments': {'clientID': 'vscode'},
      });

      // Allow event loop to process
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await inController.close();
      await serverFuture;

      final messages = parseOutboundMessages();
      expect(messages.length, greaterThanOrEqualTo(2));

      // 1. Response to initialize
      final initResponse = messages.firstWhere((m) => m['type'] == 'response' && m['command'] == 'initialize');
      expect(initResponse['success'], isTrue);
      expect(initResponse['body']['supportsRestartRequest'], isTrue);
      expect(initResponse['body']['supportsEvaluateForHovers'], isTrue);

      // 2. Event initialized
      final initEvent = messages.firstWhere((m) => m['type'] == 'event' && m['event'] == 'initialized');
      expect(initEvent, isNotNull);
    });

    test('handles setBreakpoints and threads requests', () async {
      final serverFuture = server.start();

      sendDapRequest({
        'seq': 1,
        'type': 'request',
        'command': 'initialize',
      });

      sendDapRequest({
        'seq': 2,
        'type': 'request',
        'command': 'setBreakpoints',
        'arguments': {
          'source': {'path': '/test/lib/todo_screen.dart'},
          'breakpoints': [{'line': 355}, {'line': 360}],
        },
      });

      sendDapRequest({
        'seq': 3,
        'type': 'request',
        'command': 'threads',
      });

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await inController.close();
      await serverFuture;

      final messages = parseOutboundMessages();

      final bpResponse = messages.firstWhere((m) => m['type'] == 'response' && m['command'] == 'setBreakpoints');
      expect(bpResponse['success'], isTrue);
      final bps = bpResponse['body']['breakpoints'] as List;
      expect(bps.length, 2);
      expect(bps[0]['verified'], isTrue);
      expect(bps[0]['line'], 355);

      final threadsResponse = messages.firstWhere((m) => m['type'] == 'response' && m['command'] == 'threads');
      expect(threadsResponse['success'], isTrue);
      final threads = threadsResponse['body']['threads'] as List;
      expect(threads.length, 1);
      expect(threads[0]['id'], 1);
      expect(threads[0]['name'], contains('DartNative'));
    });
  });
}
