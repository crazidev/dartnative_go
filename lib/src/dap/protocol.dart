import 'dart:convert';

/// Representation of a DAP (Debug Adapter Protocol) message.
abstract class DapMessage {
  final int seq;
  final String type;

  DapMessage({required this.seq, required this.type});

  Map<String, dynamic> toJson();

  @override
  String toString() => jsonEncode(toJson());
}

/// A DAP Request message from the client (IDE).
class DapRequest extends DapMessage {
  final String command;
  final Map<String, dynamic>? arguments;

  DapRequest({
    required super.seq,
    required this.command,
    this.arguments,
  }) : super(type: 'request');

  factory DapRequest.fromJson(Map<String, dynamic> json) {
    return DapRequest(
      seq: json['seq'] as int? ?? 0,
      command: json['command'] as String? ?? '',
      arguments: json['arguments'] is Map
          ? (json['arguments'] as Map).cast<String, dynamic>()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'seq': seq,
        'type': type,
        'command': command,
        if (arguments != null) 'arguments': arguments,
      };
}

/// A DAP Response message sent to the client (IDE).
class DapResponse extends DapMessage {
  final int requestSeq;
  final bool success;
  final String command;
  final String? message;
  final Map<String, dynamic>? body;

  DapResponse({
    required super.seq,
    required this.requestSeq,
    required this.command,
    this.success = true,
    this.message,
    this.body,
  }) : super(type: 'response');

  factory DapResponse.success({
    required int seq,
    required DapRequest request,
    Map<String, dynamic>? body,
  }) {
    return DapResponse(
      seq: seq,
      requestSeq: request.seq,
      command: request.command,
      success: true,
      body: body,
    );
  }

  factory DapResponse.error({
    required int seq,
    required DapRequest request,
    required String message,
  }) {
    return DapResponse(
      seq: seq,
      requestSeq: request.seq,
      command: request.command,
      success: false,
      message: message,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'seq': seq,
        'type': type,
        'request_seq': requestSeq,
        'success': success,
        'command': command,
        if (message != null) 'message': message,
        if (body != null) 'body': body,
      };
}

/// A DAP Event message sent asynchronously to the client (IDE).
class DapEvent extends DapMessage {
  final String event;
  final Map<String, dynamic>? body;

  DapEvent({
    required super.seq,
    required this.event,
    this.body,
  }) : super(type: 'event');

  @override
  Map<String, dynamic> toJson() => {
        'seq': seq,
        'type': type,
        'event': event,
        if (body != null) 'body': body,
      };
}
