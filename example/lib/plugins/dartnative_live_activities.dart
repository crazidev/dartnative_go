/// Live Activities demo — pick any of the plugin's built-in presets (or the
/// hand-built custom layout), then start / update / end the activity.
/// Requires a real device (or iOS 16.1+ simulator) for the native ActivityKit
/// calls; failures surface in the status line.
library;

import 'dart:async';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_live_activities/dartnative_live_activities.dart';

class LiveActivitiesDemo extends StatefulWidget {
  const LiveActivitiesDemo({super.key});

  @override
  State<LiveActivitiesDemo> createState() => _LiveActivitiesDemoState();
}

/// One row of the preset picker: a display name and a lazy factory, so a
/// preset is only built for the row actually picked.
class _PresetOption {
  const _PresetOption(this.name, this.build);

  /// How the row's preset is built; null for the hand-built custom layout.
  final LivePreset Function()? build;

  final String name;
}

/// The app logo asset, declared in `example/pubspec.yaml`, used as the icon
/// image for presets that take one.
const String _appIcon = 'assets/dn-logo.png';

/// Every preset the plugin ships (31), lightly customized, plus the original
/// hand-built layout as the first entry.
final List<_PresetOption> _presetOptions = [
  const _PresetOption('Custom (manual layout)', null),

  // == Generic trackers (src/presets/presets.dart) ==
  _PresetOption(
    'Trip',
    () => TripPreset(
      accent: Color(0xFF1F6FEB),
      stages: ['Assigned', 'On the way', 'Arrived'],
      icon: presetIcon('shippingbox', _appIcon),
      chip: LiveChip.countdown(LiveBind('eta')),
    ),
  ),
  _PresetOption(
    'Delivery',
    () => const DeliveryPreset(),
  ),
  _PresetOption('Courier', () => const CourierPreset()),
  _PresetOption('Pickup', () => const PickupPreset()),
  _PresetOption('Queue', () => const QueuePreset()),
  _PresetOption('Flight', () => const FlightPreset()),
  _PresetOption('Parking', () => const ParkingPreset()),
  _PresetOption('EV Charging', () => const EvChargingPreset()),
  _PresetOption('Workout', () => const WorkoutPreset()),
  _PresetOption('Cooking Timer', () => const CookingTimerPreset()),
  _PresetOption('Upload', () => const UploadPreset()),
  _PresetOption(
    'Technician',
    () => const TechnicianPreset(avatarText: 'DN'),
  ),
  _PresetOption('Transit', () => const TransitPreset()),
  _PresetOption('Waiting Room', () => const WaitingRoomPreset()),
  _PresetOption('Score', () => const ScorePreset()),

  // == Designs (src/presets/designs.dart) ==
  _PresetOption(
    'Ride Pickup',
    () => RidePickupPreset(
      brand: 'DN Rides',
      driverInitials: 'DN',
      // Buttons come back through LiveActivities.onAction (wired below).
      buttons: [presetButton("I'm here", null, id: 'arrived')],
    ),
  ),
  _PresetOption(
    'Store Pickup',
    () => const StorePickupPreset(store: 'DN Market'),
  ),
  _PresetOption('Run', () => const RunPreset(brand: 'DN Sprint')),
  _PresetOption(
    'Match',
    () => const MatchPreset(homeLabel: 'Dart', awayLabel: 'Swift'),
  ),
  _PresetOption('Stock', () => const StockPreset()),
  _PresetOption('Flight Path', () => const FlightPathPreset()),
  _PresetOption('Orbit', () => const OrbitPreset(sweep: 220)),
  _PresetOption('Charge', () => const ChargePreset()),
  _PresetOption('Fare Split', () => const FareSplitPreset(brand: 'DN Rides')),

  // == Run companions (src/presets/designs_run.dart) ==
  _PresetOption(
    'Ride Arrival',
    () => const RideArrivalPreset(brand: 'DN Rides'),
  ),
  _PresetOption(
    'Ride Trip',
    () => const RideTripPreset(brand: 'DN Rides', driverInitials: 'DN'),
  ),
  _PresetOption(
    'Delivery Order',
    () => const DeliveryOrderPreset(brand: 'DN Eats'),
  ),
  _PresetOption('Ride Pin', () => const RidePinPreset(brand: 'DN Rides')),
  _PresetOption('Ride Stop', () => const RideStopPreset(brand: 'DN Rides')),
  _PresetOption(
    'Ride Destination',
    () => const RideDestinationPreset(brand: 'DN Rides'),
  ),
  _PresetOption('Train', () => const TrainPreset(brand: 'DN Transit')),
];

class _LiveActivitiesDemoState extends State<LiveActivitiesDemo> {
  String _status = 'Ready';
  int _index = 0;
  StreamSubscription<String>? _actionsSub;

  @override
  void initState() {
    super.initState();
    // Preset buttons (see Ride Pickup) report their `id` here.
    _actionsSub = LiveActivities.onAction((id) {
      setState(() => _status = 'Button tapped: $id');
    });
  }

  @override
  void dispose() {
    _actionsSub?.cancel();
    super.dispose();
  }

  /// The hand-built custom layout (kept from the original demo).
  LiveLayout _buildLayout() {
    return LiveLayout(
      theme: LiveTheme(accent: Colors.red, background: LiveBackground.system),
      expanded: LiveExpanded(
        leading: LiveText.literal('DN Pizza', color: Colors.white),
        center: LiveText(LiveBind('title')),
        trailing: LiveText.countdown(LiveBind('readyAt')),
        bottom: LiveProgress.ring(value: LiveBind('progress')),
      ),
    );
  }

  /// State for the hand-built layout.
  Map<String, Object?> _manualState({bool advanced = false}) {
    final now = DateTime.now();
    return {
      'title': advanced ? 'In the oven' : 'Order placed',
      'readyAt':
          now
              .add(
                Duration(minutes: advanced ? 8 : 12),
              )
              .millisecondsSinceEpoch ~/
          1000,
      'progress': advanced ? 0.6 : 0.1,
    };
  }

  /// State for a preset. `sampleState()` is the stand-in for real data: its
  /// keys match exactly what the preset's layout binds to.
  Map<String, Object?> _stateFor(LivePreset preset, {bool advanced = false}) {
    final now = DateTime.now();
    final state = Map<String, Object?>.of(preset.sampleState(now: now));
    // Countdown chips bind to epoch seconds; make sure the field exists even
    // when the preset's own sample state does not carry one.
    state['eta'] =
        now
            .add(
              Duration(minutes: advanced ? 3 : 12),
            )
            .millisecondsSinceEpoch ~/
        1000;
    if (state['progress'] is num) {
      state['progress'] = advanced ? 0.9 : 0.4;
    }
    return state;
  }

  Future<void> _start() async {
    try {
      final option = _presetOptions[_index];
      final preset = option.build?.call();
      final layout = preset?.build() ?? _buildLayout();
      final state = preset != null ? _stateFor(preset) : _manualState();
      final customId = preset != null ? 'dn-${preset.spec.id}' : 'dn-pizza';
      final activity = await LiveActivities.start(
        layout: layout,
        state: state,
        customId: customId,
      );
      setState(() => _status = 'Started ${activity.id}');
    } catch (e) {
      setState(() => _status = 'Start failed: $e');
    }
  }

  Future<void> _update() async {
    try {
      final activity = (await LiveActivities.activeActivities()).firstOrNull;
      if (activity == null) {
        setState(() => _status = 'No active activity');
        return;
      }
      final preset = _presetOptions[_index].build?.call();
      final state = preset != null
          ? _stateFor(preset, advanced: true)
          : _manualState(advanced: true);
      await activity.update(state);
      setState(() => _status = 'Updated ${activity.id}');
    } catch (e) {
      setState(() => _status = 'Update failed: $e');
    }
  }

  Future<void> _end() async {
    try {
      await LiveActivities.endAll();
      setState(() => _status = 'Ended all');
    } catch (e) {
      setState(() => _status = 'End failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Activities')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: _presetOptions[_index].name,
              isExpanded: true,
              items: [
                for (final option in _presetOptions)
                  DropdownMenuItem(
                    value: option.name,
                    child: Text(option.name),
                  ),
              ],
              onChanged: (v) => setState(() {
                _index = _presetOptions.indexWhere((o) => o.name == v);
              }),
            ),
            const SizedBox(height: 24),
            Text(_status, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Button(title: 'Start Activity', onPressed: _start),
            const SizedBox(height: 12),
            Button(title: 'Update Activity', onPressed: _update),
            const SizedBox(height: 12),
            Button(title: 'End All', onPressed: _end),
          ],
        ),
      ),
    );
  }
}
