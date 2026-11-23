/// DartNative Go host API.
///
/// Guests and the host UI import [host_api.dart]. The native shell installs
/// a [DartGoHostBinding]; interpreted guests reach the same methods through
/// the host bridge so `dart_go start` can preview the UI without a native
/// rebuild.
library;

export 'host_api.dart';
export 'version.dart';
