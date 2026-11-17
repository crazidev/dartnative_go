# Native bottomsheet

Interactive tutorial for `package:native_bottomsheet/native_bottomsheet.dart`. Native sheets on iOS (`UISheetPresentationController`, iOS 15+) and Android (Compose `ModalBottomSheet`, Material 3). Package version **0.1.0**.

Render every fenced code block with word wrap off. The block scrolls horizontally for long lines and vertically when the sample is taller than the block. Do not reflow a source line onto the next row.

The highlighted line is the feature the current step teaches. When the user changes a control, rewrite that line to the new value before they press Try it, so the preview and the code show the same call.

---

# Page plan

The page is one scroll. The header and the feature list are static. Each lesson below them is a section with explanation, a live code block, controls where the lesson has them, and a Try it button that presents a real sheet.

## Header

- **Logo.** Plugin mark for Native Bottomsheet.
- **Title.** Native Bottomsheet
- **Description.** Native bottom sheets for DartNative — `UISheetPresentationController` on iOS, Compose `ModalBottomSheet` on Android.
- **Version.** 0.1.0

## Features

List these, then show the example call:

- Present a native sheet with `showBottomSheet`
- Rest at one or more detents, including content height
- Snap between detents from inside the sheet
- Show or hide the grabber
- Set the sheet background, the content text color, and the corner radius

```dart
final sheet = showBottomSheet(
  context,
  detents: const [DNSheetDetent.contentFit],
  initialDetent: DNSheetDetent.contentFit,
  showGrabber: true,
  backgroundColor: const Color(0xFF18181A),
  builder: (context, controller) {
    return FitContentSheet(controller: controller);
  },
  onDismissed: () => sheetIsOpen = false,
);
```

This sample is the overview. It does not open a sheet. The lessons below are the interactive parts.

---

# 1. Show a bottomsheet

`showBottomSheet` presents a native sheet and returns a `DNSheetController` immediately, before the present animation finishes. The builder receives the context and that controller. This lesson uses a single `contentFit` detent so the sheet hugs the line of text.

## Code

Highlight the string in the `Text`.

```dart
final sheet = showBottomSheet(
  context,
  detents: const [DNSheetDetent.contentFit],
  initialDetent: DNSheetDetent.contentFit,
  showGrabber: true,
  builder: (context, controller) {
    return const Text('this is a bottomsheet');
  },
  onDismissed: () => sheetIsOpen = false,
);
```

## Try it

Label: **Try it**

Opens a content-fit sheet whose only content is the text `this is a bottomsheet`.

---

# 2. Detents

A detent is a height the sheet rests at. Pass every height the user can drag to in `detents`. `initialDetent` is the height it opens at. `controller.snapTo` moves to one of those heights from a button inside the sheet. `snapTo` only accepts a detent that was in the original list.

This lesson offers three heights:

- `DNSheetDetent.fraction(0.35)` — 35% of the available height
- `DNSheetDetent.medium` — half height (iOS `.medium()`, Android partially expanded)
- `DNSheetDetent.large` — full height (iOS `.large()`, Android expanded)

The sheet opens at large. On iOS 15, a fraction below 0.6 falls back to medium. iOS 16+ and Android use the fraction as given.

## Code

Highlight the `snapTo` argument. When the user taps a detent button inside the sheet, rewrite that argument to the detent they chose. The `detents` list stays the same.

```dart
final sheet = showBottomSheet(
  context,
  detents: const [
    DNSheetDetent.fraction(0.35),
    DNSheetDetent.medium,
    DNSheetDetent.large,
  ],
  initialDetent: DNSheetDetent.large,
  showGrabber: true,
  builder: (context, controller) {
    return DetentPickerSheet(controller: controller);
  },
);

// Highlighted line. Rewrites when a button inside the sheet is tapped.
sheet.snapTo(DNSheetDetent.large);
```

Rewrites:

- 35% → `sheet.snapTo(DNSheetDetent.fraction(0.35));`
- Medium → `sheet.snapTo(DNSheetDetent.medium);`
- Large → `sheet.snapTo(DNSheetDetent.large);`

## Try it

Label: **Try it**

Opens the sheet at large. The sheet body asks the user to switch heights, then shows three buttons: **35%**, **Medium**, and **Large**. Each button calls `controller.snapTo` with that detent. Tapping one also updates the highlighted `snapTo` line on the lesson.

Suggested body copy: "Switch the height to see how detents work."

---

# 3. Appearance

Grabber, colors, and corner radius are arguments on `showBottomSheet`. They apply when the sheet is presented, so the user sets them on the lesson, reads the updated call, then presses the button to preview that exact call.

This lesson is three steps on one sheet configuration. Each step introduces one customization, shows the call with that argument highlighted, and has its own preview button. Later steps keep the values chosen in earlier steps, so the code the user previews is the full current configuration.

Shared starting values:

- `showGrabber: true`
- `backgroundColor: const Color(0xFF18181A)`
- text color `const Color(0xFFFFFFFF)` on the `Text` inside the builder
- `cornerRadius: 28`

There is no cross-platform text-color argument on `showBottomSheet`. The text color is the `Text` style in the builder, which is what both platforms paint. `backgroundColor` paints the sheet container on iOS and Android. `cornerRadius: null` keeps the system radius on iOS and 28 dp on Android.

## Step 1 — Grabber

`showGrabber` shows the drag pill. iOS maps it to `prefersGrabberVisible`. Android uses the Material 3 drag handle.

Control: a switch, default on.

Highlight `showGrabber`. The line is `showGrabber: true` or `showGrabber: false` to match the switch.

```dart
final sheet = showBottomSheet(
  context,
  detents: const [DNSheetDetent.contentFit],
  initialDetent: DNSheetDetent.contentFit,
  showGrabber: true, // highlight; true or false from the switch
  backgroundColor: const Color(0xFF18181A),
  cornerRadius: 28,
  builder: (context, controller) {
    return const Text(
      'this is a bottomsheet',
      style: TextStyle(color: Color(0xFFFFFFFF)),
    );
  },
  onDismissed: () => sheetIsOpen = false,
);
```

Preview button: **Try it**. Opens the sheet with the current grabber value.

## Step 2 — Colors

Two color pickers:

- **Background** writes `backgroundColor`
- **Text** writes the `Color` in the `Text` style

Highlight both color lines. Each picker rewrites its line to `const Color(0xFFRRGGBB)` using the selected color. The grabber line stays on the value from step 1.

```dart
final sheet = showBottomSheet(
  context,
  detents: const [DNSheetDetent.contentFit],
  initialDetent: DNSheetDetent.contentFit,
  showGrabber: true,
  backgroundColor: const Color(0xFF18181A), // highlight; background picker
  cornerRadius: 28,
  builder: (context, controller) {
    return const Text(
      'this is a bottomsheet',
      style: TextStyle(color: Color(0xFFFFFFFF)), // highlight; text picker
    );
  },
  onDismissed: () => sheetIsOpen = false,
);
```

Preview button: **Preview**. Opens the sheet with the current grabber, background, and text color.

## Step 3 — Corner radius

Three choices. Selecting one rewrites `cornerRadius`.

- **12** — tight
- **28** — default (selected initially)
- **40** — round

Highlight `cornerRadius`. Grabber and both colors stay on the values from the previous steps.

```dart
final sheet = showBottomSheet(
  context,
  detents: const [DNSheetDetent.contentFit],
  initialDetent: DNSheetDetent.contentFit,
  showGrabber: true,
  backgroundColor: const Color(0xFF18181A),
  cornerRadius: 28, // highlight; 12, 28, or 40
  builder: (context, controller) {
    return const Text(
      'this is a bottomsheet',
      style: TextStyle(color: Color(0xFFFFFFFF)),
    );
  },
  onDismissed: () => sheetIsOpen = false,
);
```

Preview button: **Preview**. Opens the sheet with the current grabber, colors, and radius.

---

# Live code rules

- One highlighted region per step. Lesson 2 highlights `snapTo`. Grabber highlights `showGrabber`. Colors highlight `backgroundColor` and the `Text` color. Radius highlights `cornerRadius`.
- Rewrite the highlighted code when the control changes. Do not wait for the preview button.
- The preview button presents `showBottomSheet` with the values currently in the code block.
- Appearance steps share one configuration. Changing the grabber in step 1 changes `showGrabber` in the step 2 and step 3 samples too.
- Sheet copy for lessons 1 and 3 is the text `this is a bottomsheet`, colored by the text picker in lesson 3.
- Sheet copy for lesson 2 asks the user to switch heights, then shows the three detent buttons.
