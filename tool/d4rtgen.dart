// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:tom_build_base/tom_build_base_v2.dart';
import 'package:tom_d4rt_generator/src/v2/d4rtgen_executor.dart';
import 'package:tom_d4rt_generator/src/v2/d4rtgen_tool.dart';

void main(List<String> args) async {
  final runner = ToolRunner(
    tool: d4rtgenTool,
    executors: createD4rtgenExecutors(),
  );

  final runArgs = args.isEmpty ? ['--project=.'] : args;
  final result = await runner.run(runArgs);

  if (!result.success) {
    exitCode = 1;
  }
}
