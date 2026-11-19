/// Android manifest permissions available to `AndroidConfig.permissions`.
///
/// The enum covers the common runtime permissions plus the permissions added in
/// recent Android releases (12 through 16.1). Each value is the full
/// `android.permission.*` name, so it can be written to the manifest directly.
enum AndroidPermission {
  // ---------------------------------------------------------------------------
  // Camera, microphone, sensors and location
  // ---------------------------------------------------------------------------
  camera('android.permission.CAMERA'),
  recordAudio('android.permission.RECORD_AUDIO'),
  bodySensors('android.permission.BODY_SENSORS'),
  activityRecognition('android.permission.ACTIVITY_RECOGNITION'),
  accessCoarseLocation('android.permission.ACCESS_COARSE_LOCATION'),
  accessFineLocation('android.permission.ACCESS_FINE_LOCATION'),
  accessBackgroundLocation('android.permission.ACCESS_BACKGROUND_LOCATION'),
  accessMediaLocation('android.permission.ACCESS_MEDIA_LOCATION'),

  // ---------------------------------------------------------------------------
  // Contacts, calendar, phone and SMS
  // ---------------------------------------------------------------------------
  readContacts('android.permission.READ_CONTACTS'),
  writeContacts('android.permission.WRITE_CONTACTS'),
  getAccounts('android.permission.GET_ACCOUNTS'),
  readCalendar('android.permission.READ_CALENDAR'),
  writeCalendar('android.permission.WRITE_CALENDAR'),
  readPhoneState('android.permission.READ_PHONE_STATE'),
  readPhoneNumbers('android.permission.READ_PHONE_NUMBERS'),
  callPhone('android.permission.CALL_PHONE'),
  answerPhoneCalls('android.permission.ANSWER_PHONE_CALLS'),
  readCallLog('android.permission.READ_CALL_LOG'),
  writeCallLog('android.permission.WRITE_CALL_LOG'),
  readSms('android.permission.READ_SMS'),
  sendSms('android.permission.SEND_SMS'),
  receiveSms('android.permission.RECEIVE_SMS'),
  receiveMms('android.permission.RECEIVE_MMS'),

  // ---------------------------------------------------------------------------
  // Storage and media
  // ---------------------------------------------------------------------------
  readExternalStorage('android.permission.READ_EXTERNAL_STORAGE'),
  writeExternalStorage('android.permission.WRITE_EXTERNAL_STORAGE'),
  manageExternalStorage('android.permission.MANAGE_EXTERNAL_STORAGE'),
  readMediaImages('android.permission.READ_MEDIA_IMAGES'),
  readMediaVideo('android.permission.READ_MEDIA_VIDEO'),
  readMediaAudio('android.permission.READ_MEDIA_AUDIO'),
  readMediaVisualUserSelected(
    'android.permission.READ_MEDIA_VISUAL_USER_SELECTED',
  ),

  // ---------------------------------------------------------------------------
  // Notifications, alarms and authentication
  // ---------------------------------------------------------------------------
  postNotifications('android.permission.POST_NOTIFICATIONS'),
  postPromotedNotifications(
    'android.permission.POST_PROMOTED_NOTIFICATIONS',
  ),
  scheduleExactAlarm('android.permission.SCHEDULE_EXACT_ALARM'),
  useExactAlarm('android.permission.USE_EXACT_ALARM'),
  useBiometric('android.permission.USE_BIOMETRIC'),
  useFingerprint('android.permission.USE_FINGERPRINT'),

  // ---------------------------------------------------------------------------
  // Connectivity and nearby devices
  // ---------------------------------------------------------------------------
  internet('android.permission.INTERNET'),
  accessNetworkState('android.permission.ACCESS_NETWORK_STATE'),
  accessWifiState('android.permission.ACCESS_WIFI_STATE'),
  changeWifiState('android.permission.CHANGE_WIFI_STATE'),
  changeNetworkState('android.permission.CHANGE_NETWORK_STATE'),
  nfc('android.permission.NFC'),
  bluetooth('android.permission.BLUETOOTH'),
  bluetoothAdmin('android.permission.BLUETOOTH_ADMIN'),
  bluetoothScan('android.permission.BLUETOOTH_SCAN'),
  bluetoothAdvertise('android.permission.BLUETOOTH_ADVERTISE'),
  bluetoothConnect('android.permission.BLUETOOTH_CONNECT'),
  nearbyWifiDevices('android.permission.NEARBY_WIFI_DEVICES'),
  uwbRanging('android.permission.UWB_RANGING'),
  ranging('android.permission.RANGING'),

  // ---------------------------------------------------------------------------
  // Background work and system UI
  // ---------------------------------------------------------------------------
  foregroundService('android.permission.FOREGROUND_SERVICE'),
  foregroundServiceCamera('android.permission.FOREGROUND_SERVICE_CAMERA'),
  foregroundServiceConnectedDevice(
    'android.permission.FOREGROUND_SERVICE_CONNECTED_DEVICE',
  ),
  foregroundServiceDataSync(
    'android.permission.FOREGROUND_SERVICE_DATA_SYNC',
  ),
  foregroundServiceHealth('android.permission.FOREGROUND_SERVICE_HEALTH'),
  foregroundServiceLocation(
    'android.permission.FOREGROUND_SERVICE_LOCATION',
  ),
  foregroundServiceMediaPlayback(
    'android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK',
  ),
  foregroundServiceMediaProcessing(
    'android.permission.FOREGROUND_SERVICE_MEDIA_PROCESSING',
  ),
  foregroundServiceMediaProjection(
    'android.permission.FOREGROUND_SERVICE_MEDIA_PROJECTION',
  ),
  foregroundServiceMicrophone(
    'android.permission.FOREGROUND_SERVICE_MICROPHONE',
  ),
  foregroundServicePhoneCall(
    'android.permission.FOREGROUND_SERVICE_PHONE_CALL',
  ),
  foregroundServiceRemoteMessaging(
    'android.permission.FOREGROUND_SERVICE_REMOTE_MESSAGING',
  ),
  foregroundServiceSpecialUse(
    'android.permission.FOREGROUND_SERVICE_SPECIAL_USE',
  ),
  foregroundServiceSystemExempted(
    'android.permission.FOREGROUND_SERVICE_SYSTEM_EXEMPTED',
  ),
  receiveBootCompleted('android.permission.RECEIVE_BOOT_COMPLETED'),
  wakeLock('android.permission.WAKE_LOCK'),
  vibrate('android.permission.VIBRATE'),
  useFullScreenIntent('android.permission.USE_FULL_SCREEN_INTENT'),
  requestIgnoreBatteryOptimizations(
    'android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
  ),
  requestInstallPackages('android.permission.REQUEST_INSTALL_PACKAGES'),
  queryAllPackages('android.permission.QUERY_ALL_PACKAGES'),
  systemAlertWindow('android.permission.SYSTEM_ALERT_WINDOW'),

  // ---------------------------------------------------------------------------
  // Sensors, screen capture and settings (newer releases)
  // ---------------------------------------------------------------------------
  highSamplingRateSensors(
    'android.permission.HIGH_SAMPLING_RATE_SENSORS',
  ),
  bodySensorsBackground('android.permission.BODY_SENSORS_BACKGROUND'),
  detectScreenCapture('android.permission.DETECT_SCREEN_CAPTURE'),
  detectScreenRecording('android.permission.DETECT_SCREEN_RECORDING'),
  readSystemPreferences('android.permission.READ_SYSTEM_PREFERENCES'),
  writeSystemPreferences('android.permission.WRITE_SYSTEM_PREFERENCES'),
  readSyncSettings('android.permission.READ_SYNC_SETTINGS'),
  writeSyncSettings('android.permission.WRITE_SYNC_SETTINGS');

  const AndroidPermission(this.value);

  /// Full manifest name, e.g. `android.permission.CAMERA`.
  final String value;
}
