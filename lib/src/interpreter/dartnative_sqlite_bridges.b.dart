// D4rt Bridge - Generated file, do not edit
// Sources: 13 files
// Generated: 2026-11-24T16:20:37.755964 by tom_d4rt_generator 1.26.2

// ignore_for_file: experimental_member_use, unused_import, deprecated_member_use, prefer_function_declarations_over_variables, implementation_imports, sort_child_properties_last, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, invalid_use_of_protected_member, unnecessary_non_null_assertion, invalid_use_of_visible_for_testing_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_is_empty, unnecessary_question_mark, unreachable_switch_case, unintended_html_in_doc_comment, empty_constructor_bodies, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, must_call_super, no_logic_in_create_state, use_key_in_widget_constructors, annotate_overrides, non_const_argument_for_const_parameter, unnecessary_import

import 'package:tom_d4rt/d4rt.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'dart:async';

import 'package:dartnative_sqlite/src/sqlite_batch.dart'
    as $dartnative_sqlite_1;
import 'package:dartnative_sqlite/src/sqlite_database.dart'
    as $dartnative_sqlite_2;
import 'package:dartnative_sqlite/src/sqlite_schema.dart'
    as $dartnative_sqlite_3;
import 'package:dartnative_sqlite/src/unprotected_folder.dart'
    as $dartnative_sqlite_4;
import 'package:sqflite_common/sqlite_api.dart' as $sqflite_common_1;
import 'package:sqflite_common/src/database_executor_iterate_ext.dart'
    as $sqflite_common_2;
import 'package:sqflite_common/src/database_ext.dart' as $sqflite_common_3;
import 'package:sqflite_common/src/database_mixin.dart' as $sqflite_common_4;
import 'package:sqflite_common/src/logger/sqflite_logger.dart'
    as $sqflite_common_5;
import 'package:sqflite_common/src/sqflite_debug.dart' as $sqflite_common_6;
import 'package:sqflite_common/src/sql_builder.dart' as $sqflite_common_7;
import 'package:sqflite_common/src/sql_command_executor_ext.dart'
    as $sqflite_common_8;
import 'package:sqflite_common/src/transaction.dart' as $sqflite_common_9;
import 'package:sqflite_common/src/compat.dart' as $aux_sqflite_common_2;
import 'package:sqflite_common/src/database.dart' as $aux_sqflite_common;
import 'package:sqflite_common/src/sql_command.dart' as $aux_sqflite_common_3;

/// Bridge class for dartnative_sqlite module.
class DartnativeSqliteBridge {
  /// Returns all bridge class definitions.
  ///
  /// Eager — building every class. Prefer [bridgeClassThunks] +
  /// [bridgeClassTypes] for lazy registration (Step #17); this remains
  /// for diagnostics and callers that need the full list.
  static List<BridgedClass> bridgeClasses() {
    return [
      _createSqliteDatabaseBridge(),
      _createSqliteBridge(),
      _createSqliteBatchBridge(),
      _createMigrationStepBridge(),
      _createSqliteSchemaBridge(),
    ];
  }

  /// Returns deferred factory thunks keyed by class name.
  ///
  /// Each thunk builds one class's [BridgedClass] on demand. Plugs into
  /// the interpreter's lazy registry via [registerBridges] (Step #17).
  static Map<String, BridgedClass Function()> bridgeClassThunks() {
    return {
      'SqliteDatabase': _createSqliteDatabaseBridge,
      'Sqlite': _createSqliteBridge,
      'SqliteBatch': _createSqliteBatchBridge,
      'MigrationStep': _createMigrationStepBridge,
      'SqliteSchema': _createSqliteSchemaBridge,
    };
  }

  /// Returns native [Type]s keyed by class name, parallel to
  /// [bridgeClassThunks] (Step #17). Used to register the native-type
  /// lookup thunk without building the BridgedClass.
  static Map<String, Type> bridgeClassTypes() {
    return {
      'SqliteDatabase': $dartnative_sqlite_2.SqliteDatabase,
      'Sqlite': $dartnative_sqlite_2.Sqlite,
      'SqliteBatch': $dartnative_sqlite_1.SqliteBatch,
      'MigrationStep': $dartnative_sqlite_3.MigrationStep,
      'SqliteSchema': $dartnative_sqlite_3.SqliteSchema,
    };
  }

  /// Returns a map of class names to their canonical source URIs.
  ///
  /// Used for deduplication when the same class is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> classSourceUris() {
    return {
      'SqliteDatabase': 'package:dartnative_sqlite/src/sqlite_database.dart',
      'Sqlite': 'package:dartnative_sqlite/src/sqlite_database.dart',
      'SqliteBatch': 'package:dartnative_sqlite/src/sqlite_batch.dart',
      'MigrationStep': 'package:dartnative_sqlite/src/sqlite_schema.dart',
      'SqliteSchema': 'package:dartnative_sqlite/src/sqlite_schema.dart',
    };
  }

  /// Returns a map of class names to their flattened (transitive)
  /// native supertype names (superclasses, interfaces and mixins).
  ///
  /// Fed to `BridgedClass.registerSupertypes` so interpreted subclasses
  /// of bridged classes pass `is`/subtype checks against bridged
  /// ancestors and the interface-proxy supertype walk resolves up the
  /// chain.
  static Map<String, List<String>> classSupertypes() {
    return {};
  }

  /// Returns a map of type alias names to their target class names.
  ///
  /// Type aliases like `typedef MaterialStateProperty<T> = WidgetStateProperty<T>`
  /// are registered so that code using the alias name can resolve to the
  /// bridged class under its canonical name.
  static Map<String, String> classAliases() {
    return {};
  }

  /// Returns the list of function typedef names declared in this library.
  ///
  /// Function typedefs like `typedef VoidCallback = void Function()` are
  /// registered so that they can be used as type arguments in D4rt scripts.
  static List<String> functionTypedefs() {
    return [
      'SqfliteCursorRowCallback',
      'SqfliteLoggerEventFunction',
      'OnDatabaseVersionChangeFn',
      'OnDatabaseCreateFn',
      'OnDatabaseOpenFn',
      'OnDatabaseConfigureFn',
    ];
  }

  /// Returns all bridged enum definitions.
  static List<BridgedEnumDefinition> bridgedEnums() {
    return [
      BridgedEnumDefinition<$sqflite_common_7.ConflictAlgorithm>(
        name: 'ConflictAlgorithm',
        values: $sqflite_common_7.ConflictAlgorithm.values,
      ),
    ];
  }

  /// Returns a map of enum names to their canonical source URIs.
  ///
  /// Used for deduplication when the same enum is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> enumSourceUris() {
    return {
      'ConflictAlgorithm': 'package:sqflite_common/src/sql_builder.dart',
    };
  }

  /// Returns all bridged extension definitions.
  static List<BridgedExtensionDefinition> bridgedExtensions() {
    return [
      BridgedExtensionDefinition(
        name: 'SqfliteDatabaseExecutorIterateExt',
        onTypeName: 'DatabaseExecutor',
        methods: {
          'rawQueryIterate': (visitor, target, positional, named, typeArgs) {
            final t = target as $sqflite_common_1.DatabaseExecutor;
            D4.requireMinArgs(positional, 2, 'rawQueryIterate');
            final sql = D4.getRequiredArg<String>(
              positional,
              0,
              'sql',
              'rawQueryIterate',
            );
            final arguments = D4.getRequiredArg<List<Object?>?>(
              positional,
              1,
              'arguments',
              'rawQueryIterate',
            );
            final bufferSize = D4.getOptionalNamedArg<int?>(
              named,
              'bufferSize',
            );
            final onRowRaw = named['onRow'];
            return t.rawQueryIterate(
              sql,
              arguments,
              bufferSize: bufferSize,
              onRow:
                  ((Map<String, Object?> p0) {
                        return D4.extractBridgedArg<FutureOr<bool>>(
                              D4.callInterpreterCallback(visitor!, onRowRaw, [
                                p0,
                              ]),
                              'callback',
                              visitor,
                            )
                            as FutureOr<bool>;
                      })
                      as FutureOr<bool> Function(Map<String, Object?>),
            );
          },
          'queryIterate': (visitor, target, positional, named, typeArgs) {
            final t = target as $sqflite_common_1.DatabaseExecutor;
            D4.requireMinArgs(positional, 1, 'queryIterate');
            final table = D4.getRequiredArg<String>(
              positional,
              0,
              'table',
              'queryIterate',
            );
            final distinct = D4.getOptionalNamedArg<bool?>(named, 'distinct');
            final columns = D4.getOptionalNamedArg<List<String>?>(
              named,
              'columns',
            );
            final where = D4.getOptionalNamedArg<String?>(named, 'where');
            final whereArgs = D4.getOptionalNamedArg<List<Object?>?>(
              named,
              'whereArgs',
            );
            final groupBy = D4.getOptionalNamedArg<String?>(named, 'groupBy');
            final having = D4.getOptionalNamedArg<String?>(named, 'having');
            final orderBy = D4.getOptionalNamedArg<String?>(named, 'orderBy');
            final limit = D4.getOptionalNamedArg<int?>(named, 'limit');
            final offset = D4.getOptionalNamedArg<int?>(named, 'offset');
            final bufferSize = D4.getOptionalNamedArg<int?>(
              named,
              'bufferSize',
            );
            final onRowRaw = named['onRow'];
            return t.queryIterate(
              table,
              distinct: distinct,
              columns: columns,
              where: where,
              whereArgs: whereArgs,
              groupBy: groupBy,
              having: having,
              orderBy: orderBy,
              limit: limit,
              offset: offset,
              bufferSize: bufferSize,
              onRow:
                  ((Map<String, Object?> p0) {
                        return D4.extractBridgedArg<FutureOr<bool>>(
                              D4.callInterpreterCallback(visitor!, onRowRaw, [
                                p0,
                              ]),
                              'callback',
                              visitor,
                            )
                            as FutureOr<bool>;
                      })
                      as FutureOr<bool> Function(Map<String, Object?>),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'SqfliteDatabaseExecutorExt',
        onTypeName: 'DatabaseExecutor',
        methods: {
          'setVersion': (visitor, target, positional, named, typeArgs) {
            final t = target as $sqflite_common_1.DatabaseExecutor;
            return Function.apply(
              t.setVersion,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'getVersion': (visitor, target, positional, named, typeArgs) {
            final t = target as $sqflite_common_1.DatabaseExecutor;
            return Function.apply(
              t.getVersion,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'SqfliteDatabaseExt',
        onTypeName: 'Database',
        methods: {
          'setJournalMode': (visitor, target, positional, named, typeArgs) {
            final t = target as $sqflite_common_1.Database;
            return Function.apply(
              t.setJournalMode,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'OpenDatabaseOptionsLogger',
        onTypeName: 'OpenDatabaseOptions',
        methods: {
          'toMap': (visitor, target, positional, named, typeArgs) {
            final t = target as $sqflite_common_1.OpenDatabaseOptions;
            return Function.apply(
              t.toMap,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'SqfliteLoggerEventExt',
        onTypeName: 'SqfliteLoggerEvent',
        methods: {
          'dump': (visitor, target, positional, named, typeArgs) {
            final t = target as $sqflite_common_5.SqfliteLoggerEvent;
            final printRaw = named['print'];
            final noStopwatch = D4.getOptionalNamedArg<bool?>(
              named,
              'noStopwatch',
            );
            t.dump(
              print: printRaw == null
                  ? null
                  : (Object? p0) {
                      D4.callInterpreterCallback(visitor!, printRaw, [p0]);
                    },
              noStopwatch: noStopwatch,
            );
            return null;
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'SqfliteLoggerEventInternalExt',
        onTypeName: 'SqfliteLoggerEvent',
        methods: {
          'toMapNoStopwatch': (visitor, target, positional, named, typeArgs) {
            final t = target as $sqflite_common_5.SqfliteLoggerEvent;
            return Function.apply(
              t.toMapNoStopwatch,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'toMapNoOperations': (visitor, target, positional, named, typeArgs) {
            final t = target as $sqflite_common_5.SqfliteLoggerEvent;
            return Function.apply(
              t.toMapNoOperations,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'toMapNoOperationsNoStopwatch':
              (visitor, target, positional, named, typeArgs) {
                final t = target as $sqflite_common_5.SqfliteLoggerEvent;
                return Function.apply(
                  t.toMapNoOperationsNoStopwatch,
                  positional,
                  named.map((k, v) => MapEntry(Symbol(k), v)),
                );
              },
          'toLogString': (visitor, target, positional, named, typeArgs) {
            final t = target as $sqflite_common_5.SqfliteLoggerEvent;
            return Function.apply(
              t.toLogString,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'toStringNoStopwatch':
              (visitor, target, positional, named, typeArgs) {
                final t = target as $sqflite_common_5.SqfliteLoggerEvent;
                return Function.apply(
                  t.toStringNoStopwatch,
                  positional,
                  named.map((k, v) => MapEntry(Symbol(k), v)),
                );
              },
        },
      ),
      BridgedExtensionDefinition(
        name: 'DatabaseFactoryLoggerDebugExt',
        onTypeName: 'DatabaseFactory',
        methods: {
          'debugQuickLoggerWrapper':
              (visitor, target, positional, named, typeArgs) {
                final t = target as $sqflite_common_1.DatabaseFactory;
                return Function.apply(
                  t.debugQuickLoggerWrapper,
                  positional,
                  named.map((k, v) => MapEntry(Symbol(k), v)),
                );
              },
        },
      ),
      BridgedExtensionDefinition(
        name: 'SqfliteDatabaseMixinExt',
        onTypeName: 'SqfliteDatabase',
        getters: {
          'readOnly': (visitor, target) =>
              (target as $aux_sqflite_common.SqfliteDatabase).readOnly,
        },
        methods: {
          'txnGetVersion': (visitor, target, positional, named, typeArgs) {
            final t = target as $aux_sqflite_common.SqfliteDatabase;
            return Function.apply(
              t.txnGetVersion,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'txnSetVersion': (visitor, target, positional, named, typeArgs) {
            final t = target as $aux_sqflite_common.SqfliteDatabase;
            return Function.apply(
              t.txnSetVersion,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'getBaseDatabaseMethodArguments':
              (visitor, target, positional, named, typeArgs) {
                final t = target as $aux_sqflite_common.SqfliteDatabase;
                return Function.apply(
                  t.getBaseDatabaseMethodArguments,
                  positional,
                  named.map((k, v) => MapEntry(Symbol(k), v)),
                );
              },
          'getBaseDatabaseMethodArgumentsInTransactionChange':
              (visitor, target, positional, named, typeArgs) {
                final t = target as $aux_sqflite_common.SqfliteDatabase;
                return Function.apply(
                  t.getBaseDatabaseMethodArgumentsInTransactionChange,
                  positional,
                  named.map((k, v) => MapEntry(Symbol(k), v)),
                );
              },
          'addInTransactionChangeParam':
              (visitor, target, positional, named, typeArgs) {
                final t = target as $aux_sqflite_common.SqfliteDatabase;
                return Function.apply(
                  t.addInTransactionChangeParam,
                  positional,
                  named.map((k, v) => MapEntry(Symbol(k), v)),
                );
              },
          'txnBeginTransaction':
              (visitor, target, positional, named, typeArgs) {
                final t = target as $aux_sqflite_common.SqfliteDatabase;
                return Function.apply(
                  t.txnBeginTransaction,
                  positional,
                  named.map((k, v) => MapEntry(Symbol(k), v)),
                );
              },
        },
      ),
      BridgedExtensionDefinition(
        name: 'TransactionPrvExt',
        onTypeName: 'Transaction',
        methods: {
          'checkNotClosed': (visitor, target, positional, named, typeArgs) {
            final t = target as $sqflite_common_1.Transaction;
            return Function.apply(
              t.checkNotClosed,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'markClosed': (visitor, target, positional, named, typeArgs) {
            final t = target as $sqflite_common_1.Transaction;
            return Function.apply(
              t.markClosed,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'SqfliteDatabaseFactoryDebug',
        onTypeName: 'DatabaseFactory',
        methods: {
          'debugSetLogLevel': (visitor, target, positional, named, typeArgs) {
            final t = target as $sqflite_common_1.DatabaseFactory;
            return Function.apply(
              t.debugSetLogLevel,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'debugSetOptions': (visitor, target, positional, named, typeArgs) {
            final t = target as $sqflite_common_1.DatabaseFactory;
            return Function.apply(
              t.debugSetOptions,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
      BridgedExtensionDefinition(
        name: 'SqfliteSqlCommandExecutorExt',
        onTypeName: 'SqfliteSqlCommand',
        methods: {
          'query': (visitor, target, positional, named, typeArgs) {
            final t = target as $aux_sqflite_common_3.SqfliteSqlCommand;
            return Function.apply(
              t.query,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'iterate': (visitor, target, positional, named, typeArgs) {
            final t = target as $aux_sqflite_common_3.SqfliteSqlCommand;
            D4.requireMinArgs(positional, 1, 'iterate');
            final executor = D4
                .getRequiredArg<$sqflite_common_1.DatabaseExecutor>(
                  positional,
                  0,
                  'executor',
                  'iterate',
                );
            final bufferSize = D4.getOptionalNamedArg<int?>(
              named,
              'bufferSize',
            );
            final onRowRaw = named['onRow'];
            return t.iterate(
              executor,
              bufferSize: bufferSize,
              onRow:
                  ((Map<String, Object?> p0) {
                        return D4.extractBridgedArg<FutureOr<bool>>(
                              D4.callInterpreterCallback(visitor!, onRowRaw, [
                                p0,
                              ]),
                              'callback',
                              visitor,
                            )
                            as FutureOr<bool>;
                      })
                      as FutureOr<bool> Function(Map<String, Object?>),
            );
          },
          'queryIterate': (visitor, target, positional, named, typeArgs) {
            final t = target as $aux_sqflite_common_3.SqfliteSqlCommand;
            D4.requireMinArgs(positional, 1, 'queryIterate');
            final executor = D4
                .getRequiredArg<$sqflite_common_1.DatabaseExecutor>(
                  positional,
                  0,
                  'executor',
                  'queryIterate',
                );
            final bufferSize = D4.getOptionalNamedArg<int?>(
              named,
              'bufferSize',
            );
            final onRowRaw = named['onRow'];
            return t.queryIterate(
              executor,
              bufferSize: bufferSize,
              onRow:
                  ((Map<String, Object?> p0) {
                        return D4.extractBridgedArg<FutureOr<bool>>(
                              D4.callInterpreterCallback(visitor!, onRowRaw, [
                                p0,
                              ]),
                              'callback',
                              visitor,
                            )
                            as FutureOr<bool>;
                      })
                      as FutureOr<bool> Function(Map<String, Object?>),
            );
          },
          'insert': (visitor, target, positional, named, typeArgs) {
            final t = target as $aux_sqflite_common_3.SqfliteSqlCommand;
            return Function.apply(
              t.insert,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'update': (visitor, target, positional, named, typeArgs) {
            final t = target as $aux_sqflite_common_3.SqfliteSqlCommand;
            return Function.apply(
              t.update,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'delete': (visitor, target, positional, named, typeArgs) {
            final t = target as $aux_sqflite_common_3.SqfliteSqlCommand;
            return Function.apply(
              t.delete,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
          'execute': (visitor, target, positional, named, typeArgs) {
            final t = target as $aux_sqflite_common_3.SqfliteSqlCommand;
            return Function.apply(
              t.execute,
              positional,
              named.map((k, v) => MapEntry(Symbol(k), v)),
            );
          },
        },
      ),
    ];
  }

  /// Returns a map of extension identifiers to their canonical source URIs.
  static Map<String, String> extensionSourceUris() {
    return {
      'SqfliteDatabaseExecutorIterateExt@DatabaseExecutor':
          'package:sqflite_common/src/database_executor_iterate_ext.dart',
      'SqfliteDatabaseExecutorExt@DatabaseExecutor':
          'package:sqflite_common/sqlite_api.dart',
      'SqfliteDatabaseExt@Database':
          'package:sqflite_common/src/database_ext.dart',
      'OpenDatabaseOptionsLogger@OpenDatabaseOptions':
          'package:sqflite_common/src/logger/sqflite_logger.dart',
      'SqfliteLoggerEventExt@SqfliteLoggerEvent':
          'package:sqflite_common/src/logger/sqflite_logger.dart',
      'SqfliteLoggerEventInternalExt@SqfliteLoggerEvent':
          'package:sqflite_common/src/logger/sqflite_logger.dart',
      'DatabaseFactoryLoggerDebugExt@DatabaseFactory':
          'package:sqflite_common/src/logger/sqflite_logger.dart',
      'SqfliteDatabaseMixinExt@SqfliteDatabase':
          'package:sqflite_common/src/database_mixin.dart',
      'TransactionPrvExt@Transaction':
          'package:sqflite_common/src/transaction.dart',
      'SqfliteDatabaseFactoryDebug@DatabaseFactory':
          'package:sqflite_common/src/sqflite_debug.dart',
      'SqfliteSqlCommandExecutorExt@SqfliteSqlCommand':
          'package:sqflite_common/src/sql_command_executor_ext.dart',
    };
  }

  /// GEN-107: Library re-exports declared by the bridged source
  /// libraries. Each tuple mirrors a Dart `export '…'` directive.
  /// Consumed by `registerBridges` via `D4rt.registerLibraryReExport`
  /// (mirrored on `D4rtRunner` in tom_d4rt_ast).
  static List<
    ({String source, String target, Set<String>? show, Set<String>? hide})
  >
  bridgeReExports() {
    return [
      (
        source: 'package:dartnative_sqlite/dartnative_sqlite.dart',
        target: 'package:dartnative_sqlite/src/conflict_algorithm.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_sqlite/dartnative_sqlite.dart',
        target: 'package:dartnative_sqlite/src/sqlite_database.dart',
        show: {'SqliteDatabase', 'Sqlite'},
        hide: null,
      ),
      (
        source: 'package:dartnative_sqlite/dartnative_sqlite.dart',
        target: 'package:dartnative_sqlite/src/sqlite_batch.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_sqlite/dartnative_sqlite.dart',
        target: 'package:dartnative_sqlite/src/sqlite_schema.dart',
        show: null,
        hide: null,
      ),
      (
        source: 'package:dartnative_sqlite/dartnative_sqlite.dart',
        target: 'package:dartnative_sqlite/src/unprotected_folder.dart',
        show: {'createUnprotectedFolder'},
        hide: null,
      ),
      (
        source: 'package:sqflite_common/sql.dart',
        target: 'package:sqflite_common/src/sql_builder.dart',
        show: {'ConflictAlgorithm', 'escapeName', 'unescapeName'},
        hide: null,
      ),
      (
        source: 'package:sqflite_common/src/sqflite_debug.dart',
        target: 'package:sqflite_common/src/logger/sqflite_logger.dart',
        show: {'DatabaseFactoryLoggerDebugExt'},
        hide: null,
      ),
      (
        source: 'package:sqflite_common/sqlite_api.dart',
        target: 'package:sqflite_common/sql.dart',
        show: {'ConflictAlgorithm'},
        hide: null,
      ),
      (
        source: 'package:sqflite_common/sqlite_api.dart',
        target: 'package:sqflite_common/src/constant.dart',
        show: {
          'inMemoryDatabasePath',
          'sqfliteLogLevelNone',
          'sqfliteLogLevelSql',
          'sqfliteLogLevelVerbose',
        },
        hide: null,
      ),
      (
        source: 'package:sqflite_common/sqlite_api.dart',
        target: 'package:sqflite_common/src/database_executor_iterate_ext.dart',
        show: {'SqfliteDatabaseExecutorIterateExt', 'SqfliteCursorRowCallback'},
        hide: null,
      ),
      (
        source: 'package:sqflite_common/sqlite_api.dart',
        target: 'package:sqflite_common/src/database_ext.dart',
        show: {'SqfliteDatabaseExt'},
        hide: null,
      ),
      (
        source: 'package:sqflite_common/sqlite_api.dart',
        target: 'package:sqflite_common/src/exception.dart',
        show: {'DatabaseException'},
        hide: null,
      ),
      (
        source: 'package:sqflite_common/sqlite_api.dart',
        target: 'package:sqflite_common/src/sqflite_debug.dart',
        show: {'SqfliteDatabaseFactoryDebug', 'DatabaseFactoryLoggerDebugExt'},
        hide: null,
      ),
      (
        source: 'package:sqflite_common/sqlite_api.dart',
        target: 'package:sqflite_common/src/sql_command.dart',
        show: {'SqfliteSqlCommand', 'SqliteSqlCommandType'},
        hide: null,
      ),
      (
        source: 'package:sqflite_common/sqlite_api.dart',
        target: 'package:sqflite_common/src/sql_command_executor_ext.dart',
        show: {'SqfliteSqlCommandExecutorExt'},
        hide: null,
      ),
      (
        source: 'package:dartnative_sqlite/src/conflict_algorithm.dart',
        target: 'package:sqflite_common/sqlite_api.dart',
        show: {'ConflictAlgorithm'},
        hide: null,
      ),
    ];
  }

  /// Registers all bridges with an interpreter.
  ///
  /// [importPath] is the package import path that D4rt scripts will use
  /// to access these classes (e.g., 'package:tom_build/tom.dart').
  static void registerBridges(D4rt interpreter, String importPath) {
    // Step #17 — register deferred factory thunks (not pre-built
    // BridgedClass objects): a script touching N of the M classes
    // materializes ≈N (each thunk builds its class on first resolve).
    final classThunks = bridgeClassThunks();
    final classTypes = bridgeClassTypes();
    final classSources = classSourceUris();
    for (final entry in classThunks.entries) {
      interpreter.registerBridgedClassLazy(
        entry.key,
        classTypes[entry.key]!,
        entry.value,
        importPath,
        sourceUri: classSources[entry.key],
      );
    }

    // Register the flattened native supertype table so
    // interpreted subclasses pass subtype checks against bridged
    // ancestors. Idempotent — safe to call per barrel.
    BridgedClass.registerSupertypes(classSupertypes());

    // Register bridged enums with source URIs for deduplication
    final enums = bridgedEnums();
    final enumSources = enumSourceUris();
    for (final enumDef in enums) {
      interpreter.registerBridgedEnum(
        enumDef,
        importPath,
        sourceUri: enumSources[enumDef.name],
      );
    }

    // Register global functions with source URIs for deduplication
    final funcs = globalFunctions();
    final funcSources = globalFunctionSourceUris();
    final funcSigs = globalFunctionSignatures();
    for (final entry in funcs.entries) {
      interpreter.registertopLevelFunction(
        entry.key,
        entry.value,
        importPath,
        sourceUri: funcSources[entry.key],
        signature: funcSigs[entry.key],
      );
    }

    // Register bridged extensions with source URIs for deduplication
    final extensions = bridgedExtensions();
    final extSources = extensionSourceUris();
    for (final extDef in extensions) {
      final extKey = '${extDef.name ?? '<unnamed>'}@${extDef.onTypeName}';
      interpreter.registerBridgedExtension(
        extDef,
        importPath,
        sourceUri: extSources[extKey],
      );
    }

    // Register function typedefs for type resolution
    final typedefs = functionTypedefs();
    for (final name in typedefs) {
      interpreter.registerFunctionTypedef(name, importPath);
    }

    // GEN-107: Register library re-exports
    for (final r in bridgeReExports()) {
      interpreter.registerLibraryReExport(
        r.source,
        r.target,
        show: r.show,
        hide: r.hide,
      );
    }
  }

  /// Returns a map of global function names to their native implementations.
  static Map<String, NativeFunctionImpl> globalFunctions() {
    return {
      'createUnprotectedFolder': (visitor, positional, named, typeArgs) {
        final parent = D4.getRequiredNamedArg<String>(
          named,
          'parent',
          'createUnprotectedFolder',
        );
        final name = D4.getRequiredNamedArg<String>(
          named,
          'name',
          'createUnprotectedFolder',
        );
        return $dartnative_sqlite_4.createUnprotectedFolder(
          parent: parent,
          name: name,
        );
      },
    };
  }

  /// Returns a map of global function names to their canonical source URIs.
  ///
  /// Used for deduplication when the same function is exported through
  /// multiple barrels (e.g., tom_core_kernel and tom_core_server).
  static Map<String, String> globalFunctionSourceUris() {
    return {
      'createUnprotectedFolder':
          'package:dartnative_sqlite/src/unprotected_folder.dart',
    };
  }

  /// Returns a map of global function names to their display signatures.
  static Map<String, String> globalFunctionSignatures() {
    return {
      'createUnprotectedFolder':
          'Future<bool> createUnprotectedFolder({required String parent, required String name})',
    };
  }

  /// Returns the list of canonical source library URIs.
  ///
  /// These are the actual source locations of all elements in this bridge,
  /// used for deduplication when the same libraries are exported through
  /// multiple barrels.
  static List<String> sourceLibraries() {
    return [
      'package:dartnative_sqlite/src/sqlite_batch.dart',
      'package:dartnative_sqlite/src/sqlite_database.dart',
      'package:dartnative_sqlite/src/sqlite_schema.dart',
      'package:dartnative_sqlite/src/unprotected_folder.dart',
      'package:sqflite_common/src/sql_builder.dart',
    ];
  }

  /// Returns the import statement needed for D4rt scripts.
  ///
  /// Use this in your D4rt initialization script to make all
  /// bridged classes available to scripts.
  static String getImportBlock() {
    final imports = StringBuffer();
    imports.writeln(
      "import 'package:dartnative_sqlite/dartnative_sqlite.dart';",
    );
    imports.writeln("import 'package:sqflite_common/sqflite_common.dart';");
    return imports.toString();
  }

  /// Returns barrel import URIs for sub-packages discovered through re-exports.
  ///
  /// When a module follows re-exports into sub-packages (e.g., dcli re-exports
  /// dcli_core), D4rt scripts may import those sub-packages directly.
  /// These barrels need to be registered with the interpreter separately
  /// so that module resolution finds content for those URIs.
  static List<String> subPackageBarrels() {
    return [
      'package:sqflite_common/sqflite_common.dart',
    ];
  }

  /// Returns a list of bridged enum names.
  static List<String> get enumNames => [
    'ConflictAlgorithm',
  ];
}

// =============================================================================
// SqliteDatabase Bridge
// =============================================================================

BridgedClass _createSqliteDatabaseBridge() {
  return BridgedClass(
    nativeType: $dartnative_sqlite_2.SqliteDatabase,
    name: 'SqliteDatabase',
    isAssignable: (v) => v is $dartnative_sqlite_2.SqliteDatabase,
    constructors: {},
    getters: {
      'path': (visitor, target) => D4
          .validateTarget<$dartnative_sqlite_2.SqliteDatabase>(
            target,
            'SqliteDatabase',
          )
          .path,
      'isOpen': (visitor, target) => D4
          .validateTarget<$dartnative_sqlite_2.SqliteDatabase>(
            target,
            'SqliteDatabase',
          )
          .isOpen,
    },
    methods: {
      'execute': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_2.SqliteDatabase>(
          target,
          'SqliteDatabase',
        );
        D4.requireMinArgs(positional, 1, 'execute');
        final sql = D4.getRequiredArg<String>(positional, 0, 'sql', 'execute');
        final arguments = positional.length > 1
            ? D4.coerceListOrNull<Object?>(positional[1], 'arguments')
            : null;
        return t.execute(sql, arguments);
      },
      'rawQuery': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_2.SqliteDatabase>(
          target,
          'SqliteDatabase',
        );
        D4.requireMinArgs(positional, 1, 'rawQuery');
        final sql = D4.getRequiredArg<String>(positional, 0, 'sql', 'rawQuery');
        final arguments = positional.length > 1
            ? D4.coerceListOrNull<Object?>(positional[1], 'arguments')
            : null;
        return t.rawQuery(sql, arguments);
      },
      'rawInsert': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_2.SqliteDatabase>(
          target,
          'SqliteDatabase',
        );
        D4.requireMinArgs(positional, 1, 'rawInsert');
        final sql = D4.getRequiredArg<String>(
          positional,
          0,
          'sql',
          'rawInsert',
        );
        final arguments = positional.length > 1
            ? D4.coerceListOrNull<Object?>(positional[1], 'arguments')
            : null;
        return t.rawInsert(sql, arguments);
      },
      'rawUpdate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_2.SqliteDatabase>(
          target,
          'SqliteDatabase',
        );
        D4.requireMinArgs(positional, 1, 'rawUpdate');
        final sql = D4.getRequiredArg<String>(
          positional,
          0,
          'sql',
          'rawUpdate',
        );
        final arguments = positional.length > 1
            ? D4.coerceListOrNull<Object?>(positional[1], 'arguments')
            : null;
        return t.rawUpdate(sql, arguments);
      },
      'rawDelete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_2.SqliteDatabase>(
          target,
          'SqliteDatabase',
        );
        D4.requireMinArgs(positional, 1, 'rawDelete');
        final sql = D4.getRequiredArg<String>(
          positional,
          0,
          'sql',
          'rawDelete',
        );
        final arguments = positional.length > 1
            ? D4.coerceListOrNull<Object?>(positional[1], 'arguments')
            : null;
        return t.rawDelete(sql, arguments);
      },
      'query': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_2.SqliteDatabase>(
          target,
          'SqliteDatabase',
        );
        D4.requireMinArgs(positional, 1, 'query');
        final table = D4.getRequiredArg<String>(
          positional,
          0,
          'table',
          'query',
        );
        final distinct = D4.getOptionalNamedArg<bool?>(named, 'distinct');
        final columns = D4.coerceListOrNull<String>(
          named['columns'],
          'columns',
        );
        final where = D4.getOptionalNamedArg<String?>(named, 'where');
        final whereArgs = D4.coerceListOrNull<Object?>(
          named['whereArgs'],
          'whereArgs',
        );
        final groupBy = D4.getOptionalNamedArg<String?>(named, 'groupBy');
        final having = D4.getOptionalNamedArg<String?>(named, 'having');
        final orderBy = D4.getOptionalNamedArg<String?>(named, 'orderBy');
        final limit = D4.getOptionalNamedArg<int?>(named, 'limit');
        final offset = D4.getOptionalNamedArg<int?>(named, 'offset');
        return t.query(
          table,
          distinct: distinct,
          columns: columns,
          where: where,
          whereArgs: whereArgs,
          groupBy: groupBy,
          having: having,
          orderBy: orderBy,
          limit: limit,
          offset: offset,
        );
      },
      'insert': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_2.SqliteDatabase>(
          target,
          'SqliteDatabase',
        );
        D4.requireMinArgs(positional, 2, 'insert');
        final table = D4.getRequiredArg<String>(
          positional,
          0,
          'table',
          'insert',
        );
        if (positional.length <= 1) {
          throw ArgumentError(
            'insert: Missing required argument "values" at position 1',
          );
        }
        final values = D4.coerceMap<String, Object?>(positional[1], 'values');
        final conflictAlgorithm = D4
            .getOptionalNamedArg<$sqflite_common_7.ConflictAlgorithm?>(
              named,
              'conflictAlgorithm',
            );
        return t.insert(table, values, conflictAlgorithm: conflictAlgorithm);
      },
      'update': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_2.SqliteDatabase>(
          target,
          'SqliteDatabase',
        );
        D4.requireMinArgs(positional, 2, 'update');
        final table = D4.getRequiredArg<String>(
          positional,
          0,
          'table',
          'update',
        );
        if (positional.length <= 1) {
          throw ArgumentError(
            'update: Missing required argument "values" at position 1',
          );
        }
        final values = D4.coerceMap<String, Object?>(positional[1], 'values');
        final where = D4.getOptionalNamedArg<String?>(named, 'where');
        final whereArgs = D4.coerceListOrNull<Object?>(
          named['whereArgs'],
          'whereArgs',
        );
        final conflictAlgorithm = D4
            .getOptionalNamedArg<$sqflite_common_7.ConflictAlgorithm?>(
              named,
              'conflictAlgorithm',
            );
        return t.update(
          table,
          values,
          where: where,
          whereArgs: whereArgs,
          conflictAlgorithm: conflictAlgorithm,
        );
      },
      'delete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_2.SqliteDatabase>(
          target,
          'SqliteDatabase',
        );
        D4.requireMinArgs(positional, 1, 'delete');
        final table = D4.getRequiredArg<String>(
          positional,
          0,
          'table',
          'delete',
        );
        final where = D4.getOptionalNamedArg<String?>(named, 'where');
        final whereArgs = D4.coerceListOrNull<Object?>(
          named['whereArgs'],
          'whereArgs',
        );
        return t.delete(table, where: where, whereArgs: whereArgs);
      },
      'transaction': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_2.SqliteDatabase>(
          target,
          'SqliteDatabase',
        );
        D4.requireMinArgs(positional, 1, 'transaction');
        if (positional.isEmpty) {
          throw ArgumentError(
            'transaction: Missing required argument "action" at position 0',
          );
        }
        final actionRaw = positional[0];
        return t.transaction<Object?>(
          (($dartnative_sqlite_2.SqliteDatabase p0) {
                return Future.value(
                  D4.callInterpreterCallback(visitor!, actionRaw, [p0]),
                ).then((v) => v as dynamic);
              })
              as Future<dynamic> Function($dartnative_sqlite_2.SqliteDatabase),
        );
      },
      'batch': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_2.SqliteDatabase>(
          target,
          'SqliteDatabase',
        );
        return t.batch();
      },
      'close': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_2.SqliteDatabase>(
          target,
          'SqliteDatabase',
        );
        return t.close();
      },
    },
    methodSignatures: {
      'execute': 'Future<void> execute(String sql, [List<Object?>? arguments])',
      'rawQuery':
          'Future<List<Map<String, Object?>>> rawQuery(String sql, [List<Object?>? arguments])',
      'rawInsert':
          'Future<int> rawInsert(String sql, [List<Object?>? arguments])',
      'rawUpdate':
          'Future<int> rawUpdate(String sql, [List<Object?>? arguments])',
      'rawDelete':
          'Future<int> rawDelete(String sql, [List<Object?>? arguments])',
      'query':
          'Future<List<Map<String, Object?>>> query(String table, {bool? distinct, List<String>? columns, String? where, List<Object?>? whereArgs, String? groupBy, String? having, String? orderBy, int? limit, int? offset})',
      'insert':
          'Future<int> insert(String table, Map<String, Object?> values, {ConflictAlgorithm? conflictAlgorithm})',
      'update':
          'Future<int> update(String table, Map<String, Object?> values, {String? where, List<Object?>? whereArgs, ConflictAlgorithm? conflictAlgorithm})',
      'delete':
          'Future<int> delete(String table, {String? where, List<Object?>? whereArgs})',
      'transaction':
          'Future<T> transaction(Future<T> Function(SqliteDatabase txn) action)',
      'batch': 'SqliteBatch batch()',
      'close': 'Future<void> close()',
    },
    getterSignatures: {
      'path': 'String get path',
      'isOpen': 'bool get isOpen',
    },
  );
}

// =============================================================================
// Sqlite Bridge
// =============================================================================

BridgedClass _createSqliteBridge() {
  return BridgedClass(
    nativeType: $dartnative_sqlite_2.Sqlite,
    name: 'Sqlite',
    isAssignable: (v) => v is $dartnative_sqlite_2.Sqlite,
    constructors: {},
    staticMethods: {
      'ensureInitialized': (visitor, positional, named, typeArgs) {
        return $dartnative_sqlite_2.Sqlite.ensureInitialized();
      },
      'open': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'open');
        final path = D4.getRequiredArg<String>(positional, 0, 'path', 'open');
        final version = D4.getRequiredNamedArg<int>(named, 'version', 'open');
        final onConfigureRaw = named['onConfigure'];
        final onConfigure = onConfigureRaw == null
            ? null
            : (($dartnative_sqlite_2.SqliteDatabase p0) {
                    return Future.value(
                      D4.callInterpreterCallback(visitor!, onConfigureRaw, [
                        p0,
                      ]),
                    );
                  })
                  as Future<void> Function($dartnative_sqlite_2.SqliteDatabase);
        final onCreateRaw = named['onCreate'];
        final onCreate = onCreateRaw == null
            ? null
            : (($dartnative_sqlite_2.SqliteDatabase p0, int p1) {
                    return Future.value(
                      D4.callInterpreterCallback(visitor!, onCreateRaw, [
                        p0,
                        p1,
                      ]),
                    );
                  })
                  as Future<void> Function(
                    $dartnative_sqlite_2.SqliteDatabase,
                    int,
                  );
        final onUpgradeRaw = named['onUpgrade'];
        final onUpgrade = onUpgradeRaw == null
            ? null
            : (($dartnative_sqlite_2.SqliteDatabase p0, int p1, int p2) {
                    return Future.value(
                      D4.callInterpreterCallback(visitor!, onUpgradeRaw, [
                        p0,
                        p1,
                        p2,
                      ]),
                    );
                  })
                  as Future<void> Function(
                    $dartnative_sqlite_2.SqliteDatabase,
                    int,
                    int,
                  );
        final singleInstance = D4.getNamedArgWithDefault<bool>(
          named,
          'singleInstance',
          true,
        );
        return $dartnative_sqlite_2.Sqlite.open(
          path,
          version: version,
          onConfigure: onConfigure,
          onCreate: onCreate,
          onUpgrade: onUpgrade,
          singleInstance: singleInstance,
        );
      },
      'deleteDatabase': (visitor, positional, named, typeArgs) {
        D4.requireMinArgs(positional, 1, 'deleteDatabase');
        final path = D4.getRequiredArg<String>(
          positional,
          0,
          'path',
          'deleteDatabase',
        );
        return $dartnative_sqlite_2.Sqlite.deleteDatabase(path);
      },
      'getDatabasesPath': (visitor, positional, named, typeArgs) {
        return $dartnative_sqlite_2.Sqlite.getDatabasesPath();
      },
    },
    staticMethodSignatures: {
      'ensureInitialized': 'void ensureInitialized()',
      'open':
          'Future<SqliteDatabase> open(String path, {required int version, Future<void> Function(SqliteDatabase db)? onConfigure, Future<void> Function(SqliteDatabase db, int version)? onCreate, Future<void> Function(SqliteDatabase db, int oldVersion, int newVersion)? onUpgrade, bool singleInstance = true})',
      'deleteDatabase': 'Future<void> deleteDatabase(String path)',
      'getDatabasesPath': 'Future<String> getDatabasesPath()',
    },
  );
}

// =============================================================================
// SqliteBatch Bridge
// =============================================================================

BridgedClass _createSqliteBatchBridge() {
  return BridgedClass(
    nativeType: $dartnative_sqlite_1.SqliteBatch,
    name: 'SqliteBatch',
    isAssignable: (v) => v is $dartnative_sqlite_1.SqliteBatch,
    constructors: {
      '': (visitor, positional, named) {
        D4.requireMinArgs(positional, 1, 'SqliteBatch');
        final batch = D4.getRequiredArg<$sqflite_common_1.Batch>(
          positional,
          0,
          '_batch',
          'SqliteBatch',
        );
        return $dartnative_sqlite_1.SqliteBatch(batch);
      },
    },
    methods: {
      'execute': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_1.SqliteBatch>(
          target,
          'SqliteBatch',
        );
        D4.requireMinArgs(positional, 1, 'execute');
        final sql = D4.getRequiredArg<String>(positional, 0, 'sql', 'execute');
        final arguments = positional.length > 1
            ? D4.coerceListOrNull<Object?>(positional[1], 'arguments')
            : null;
        t.execute(sql, arguments);
        return null;
      },
      'insert': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_1.SqliteBatch>(
          target,
          'SqliteBatch',
        );
        D4.requireMinArgs(positional, 2, 'insert');
        final table = D4.getRequiredArg<String>(
          positional,
          0,
          'table',
          'insert',
        );
        if (positional.length <= 1) {
          throw ArgumentError(
            'insert: Missing required argument "values" at position 1',
          );
        }
        final values = D4.coerceMap<String, Object?>(positional[1], 'values');
        final conflictAlgorithm = D4
            .getOptionalNamedArg<$sqflite_common_7.ConflictAlgorithm?>(
              named,
              'conflictAlgorithm',
            );
        t.insert(table, values, conflictAlgorithm: conflictAlgorithm);
        return null;
      },
      'update': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_1.SqliteBatch>(
          target,
          'SqliteBatch',
        );
        D4.requireMinArgs(positional, 2, 'update');
        final table = D4.getRequiredArg<String>(
          positional,
          0,
          'table',
          'update',
        );
        if (positional.length <= 1) {
          throw ArgumentError(
            'update: Missing required argument "values" at position 1',
          );
        }
        final values = D4.coerceMap<String, Object?>(positional[1], 'values');
        final where = D4.getOptionalNamedArg<String?>(named, 'where');
        final whereArgs = D4.coerceListOrNull<Object?>(
          named['whereArgs'],
          'whereArgs',
        );
        final conflictAlgorithm = D4
            .getOptionalNamedArg<$sqflite_common_7.ConflictAlgorithm?>(
              named,
              'conflictAlgorithm',
            );
        t.update(
          table,
          values,
          where: where,
          whereArgs: whereArgs,
          conflictAlgorithm: conflictAlgorithm,
        );
        return null;
      },
      'delete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_1.SqliteBatch>(
          target,
          'SqliteBatch',
        );
        D4.requireMinArgs(positional, 1, 'delete');
        final table = D4.getRequiredArg<String>(
          positional,
          0,
          'table',
          'delete',
        );
        final where = D4.getOptionalNamedArg<String?>(named, 'where');
        final whereArgs = D4.coerceListOrNull<Object?>(
          named['whereArgs'],
          'whereArgs',
        );
        t.delete(table, where: where, whereArgs: whereArgs);
        return null;
      },
      'rawInsert': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_1.SqliteBatch>(
          target,
          'SqliteBatch',
        );
        D4.requireMinArgs(positional, 1, 'rawInsert');
        final sql = D4.getRequiredArg<String>(
          positional,
          0,
          'sql',
          'rawInsert',
        );
        final arguments = positional.length > 1
            ? D4.coerceListOrNull<Object?>(positional[1], 'arguments')
            : null;
        t.rawInsert(sql, arguments);
        return null;
      },
      'rawDelete': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_1.SqliteBatch>(
          target,
          'SqliteBatch',
        );
        D4.requireMinArgs(positional, 1, 'rawDelete');
        final sql = D4.getRequiredArg<String>(
          positional,
          0,
          'sql',
          'rawDelete',
        );
        final arguments = positional.length > 1
            ? D4.coerceListOrNull<Object?>(positional[1], 'arguments')
            : null;
        t.rawDelete(sql, arguments);
        return null;
      },
      'rawUpdate': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_1.SqliteBatch>(
          target,
          'SqliteBatch',
        );
        D4.requireMinArgs(positional, 1, 'rawUpdate');
        final sql = D4.getRequiredArg<String>(
          positional,
          0,
          'sql',
          'rawUpdate',
        );
        final arguments = positional.length > 1
            ? D4.coerceListOrNull<Object?>(positional[1], 'arguments')
            : null;
        t.rawUpdate(sql, arguments);
        return null;
      },
      'commit': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_1.SqliteBatch>(
          target,
          'SqliteBatch',
        );
        final noResult = D4.getNamedArgWithDefault<bool>(
          named,
          'noResult',
          false,
        );
        return t.commit(noResult: noResult);
      },
    },
    constructorSignatures: {
      '': 'SqliteBatch(Batch _batch)',
    },
    methodSignatures: {
      'execute': 'void execute(String sql, [List<Object?>? arguments])',
      'insert':
          'void insert(String table, Map<String, Object?> values, {ConflictAlgorithm? conflictAlgorithm})',
      'update':
          'void update(String table, Map<String, Object?> values, {String? where, List<Object?>? whereArgs, ConflictAlgorithm? conflictAlgorithm})',
      'delete':
          'void delete(String table, {String? where, List<Object?>? whereArgs})',
      'rawInsert': 'void rawInsert(String sql, [List<Object?>? arguments])',
      'rawDelete': 'void rawDelete(String sql, [List<Object?>? arguments])',
      'rawUpdate': 'void rawUpdate(String sql, [List<Object?>? arguments])',
      'commit': 'Future<List<Object?>> commit({bool noResult = false})',
    },
  );
}

// =============================================================================
// MigrationStep Bridge
// =============================================================================

BridgedClass _createMigrationStepBridge() {
  return BridgedClass(
    nativeType: $dartnative_sqlite_3.MigrationStep,
    name: 'MigrationStep',
    isAssignable: (v) => v is $dartnative_sqlite_3.MigrationStep,
    isAbstract: true,
    constructors: {},
    getters: {
      'version': (visitor, target) => D4
          .validateTarget<$dartnative_sqlite_3.MigrationStep>(
            target,
            'MigrationStep',
          )
          .version,
    },
    methods: {
      'execute': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_3.MigrationStep>(
          target,
          'MigrationStep',
        );
        D4.requireMinArgs(positional, 1, 'execute');
        final batch = D4.getRequiredArg<$dartnative_sqlite_1.SqliteBatch>(
          positional,
          0,
          'batch',
          'execute',
        );
        return t.execute(batch);
      },
    },
    methodSignatures: {
      'execute': 'Future<void> execute(SqliteBatch batch)',
    },
    getterSignatures: {
      'version': 'int get version',
    },
  );
}

// =============================================================================
// SqliteSchema Bridge
// =============================================================================

BridgedClass _createSqliteSchemaBridge() {
  return BridgedClass(
    nativeType: $dartnative_sqlite_3.SqliteSchema,
    name: 'SqliteSchema',
    isAssignable: (v) => v is $dartnative_sqlite_3.SqliteSchema,
    constructors: {
      '': (visitor, positional, named) {
        return $dartnative_sqlite_3.SqliteSchema();
      },
    },
    methods: {
      'add': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_3.SqliteSchema>(
          target,
          'SqliteSchema',
        );
        D4.requireMinArgs(positional, 1, 'add');
        final step = D4.getRequiredArg<$dartnative_sqlite_3.MigrationStep>(
          positional,
          0,
          'step',
          'add',
        );
        t.add(step);
        return null;
      },
      'create': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_3.SqliteSchema>(
          target,
          'SqliteSchema',
        );
        D4.requireMinArgs(positional, 2, 'create');
        final db = D4.getRequiredArg<$dartnative_sqlite_2.SqliteDatabase>(
          positional,
          0,
          'db',
          'create',
        );
        final version = D4.getRequiredArg<int>(
          positional,
          1,
          'version',
          'create',
        );
        return t.create(db, version);
      },
      'upgrade': (visitor, target, positional, named, typeArgs) {
        final t = D4.validateTarget<$dartnative_sqlite_3.SqliteSchema>(
          target,
          'SqliteSchema',
        );
        D4.requireMinArgs(positional, 3, 'upgrade');
        final db = D4.getRequiredArg<$dartnative_sqlite_2.SqliteDatabase>(
          positional,
          0,
          'db',
          'upgrade',
        );
        final oldVersion = D4.getRequiredArg<int>(
          positional,
          1,
          'oldVersion',
          'upgrade',
        );
        final newVersion = D4.getRequiredArg<int>(
          positional,
          2,
          'newVersion',
          'upgrade',
        );
        return t.upgrade(db, oldVersion, newVersion);
      },
    },
    constructorSignatures: {
      '': 'SqliteSchema()',
    },
    methodSignatures: {
      'add': 'void add(MigrationStep step)',
      'create': 'Future<void> create(SqliteDatabase db, int version)',
      'upgrade':
          'Future<void> upgrade(SqliteDatabase db, int oldVersion, int newVersion)',
    },
  );
}
