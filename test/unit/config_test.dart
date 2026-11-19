import 'package:dartnative_go/src/prebuild/config.dart';
import 'package:dartnative_go/src/prebuild/project_creator.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('ColorValue', () {
    test('normalizes colours with and without a hash', () {
      expect(const ColorValue('E4ECF8').value, '#E4ECF8');
      expect(const ColorValue('#E4ECF8').value, '#E4ECF8');
      expect(const ColorValue('  #abcdef  ').value, '#abcdef');
      expect(const ColorValue('').value, '#000000');
    });

    test('compares by canonical value', () {
      expect(const ColorValue('FFFFFF'), const ColorValue('#FFFFFF'));
    });
  });

  test('AppIcon maps prefixed options into platform-only icons', () {
    const icon = AppIcon(
      source: 'assets/logo.svg',
      androidForeground: 'assets/android.svg',
      androidBackground: ColorValue('E4ECF8'),
      androidMonochrome: 'assets/mono.svg',
      androidSafeZone: AdaptiveSafeZone.inset(20),
      androidRound: true,
      androidLegacyPadding: 43,
      androidLegacy: true,
      androidImageFormat: AssetImageFormat.webp,
      iosBackground: ColorValue('#123456'),
      iosDark: 'assets/dark.svg',
      iosTinted: 'assets/tinted.svg',
      iosPadding: 8,
    );

    final android = icon.toAndroid();
    expect(android.foreground, 'assets/android.svg');
    expect(android.background.value, '#E4ECF8');
    expect(android.monochrome, 'assets/mono.svg');
    expect(android.safeZone, const AdaptiveSafeZone.inset(20));
    expect(android.safeZone.value, 'inset:20');
    expect(android.round, isTrue);
    expect(android.legacyPadding, 43);
    expect(android.legacy, isTrue);
    expect(android.imageFormat, AssetImageFormat.webp);

    final ios = icon.toIOS();
    expect(ios.image, 'assets/logo.svg');
    expect(ios.background.value, '#123456');
    expect(ios.dark, 'assets/dark.svg');
    expect(ios.backgroundDark.value, '#000000');
    expect(ios.tinted, 'assets/tinted.svg');
    expect(ios.padding, 8);
  });

  test('SplashConfig maps shared and prefixed options', () {
    const splash = SplashConfig(
      image: 'assets/splash.svg',
      backgroundColor: ColorValue('112233'),
      backgroundDark: ColorValue('#000000'),
      backgroundImage: 'assets/bg.png',
      imageDark: 'assets/splash-dark.svg',
      androidImageFit: SplashImageFit.asIs,
      androidImageFormat: AssetImageFormat.webp,
      androidAnimatedIcon: 'assets/anim.xml',
      androidIconBackground: ColorValue('#ABCDEF'),
      androidIconPadding: 30,
      androidBrandingText: 'My App',
      androidBrandingMode: BrandingMode.bottomRight,
      androidStatusBarColor: 'transparent',
      androidStatusBarIconBrightness: StatusBarIconBrightness.light,
      iosLogoSize: 128,
    );

    final android = splash.toAndroid();
    expect(android.background!.value, '#112233');
    expect(android.image, 'assets/splash.svg');
    expect(android.imageDark, 'assets/splash-dark.svg');
    expect(android.imageFit, SplashImageFit.asIs);
    expect(android.imageFormat, AssetImageFormat.webp);
    expect(android.animatedIcon, 'assets/anim.xml');
    expect(android.iconBackground!.value, '#ABCDEF');
    expect(android.iconPadding, 30);
    expect(android.brandingText, 'My App');
    expect(android.brandingModeValue, 'bottom_right');
    expect(android.statusBarColor, 'transparent');
    expect(android.statusBarIconBrightnessValue, 'light');

    final ios = splash.toIOS();
    expect(ios.background!.value, '#112233');
    expect(ios.backgroundImage, 'assets/bg.png');
    expect(ios.imageDark, 'assets/splash-dark.svg');
    expect(ios.logoSize, 128);
  });

  test('emits every platform option with quoted colours, no Flutter keys', () {
    const config = DngoConfig(
      app: AppConfig(
        name: 'App',
        bundleId: BundleId(ios: 'com.example.app', android: 'com.example.app'),
        version: AppVersion(name: '1.0.0', buildNumber: 1),
        icon: AppIcon(
          source: 'assets/logo.svg',
          androidBackground: ColorValue('E4ECF8'),
          androidSafeZone: AdaptiveSafeZone.inset(20),
          androidForegroundFormat: IconForegroundFormat.raster,
          androidRound: true,
          androidLegacyPadding: 43,
          androidMonochrome: 'assets/mono.svg',
          androidThemed: AndroidThemedIcon(
            light: 'assets/light.svg',
            dark: 'assets/themed-dark.svg',
            background: ColorValue('#FFFFFF'),
            backgroundDark: ColorValue('#000000'),
          ),
          iosBackground: ColorValue('#FFFFFF'),
          iosDark: 'assets/ios-dark.svg',
          iosBackgroundDark: ColorValue('#101010'),
          iosTinted: 'assets/tinted.svg',
          iosPadding: 5,
        ),
        splash: SplashConfig(
          image: 'assets/splash.svg',
          backgroundColor: ColorValue('112233'),
          backgroundDark: ColorValue('#000000'),
          backgroundImage: 'assets/bg.png',
          backgroundImageDark: 'assets/bg-dark.png',
          imageDark: 'assets/splash-dark.svg',
          androidImageFit: SplashImageFit.asIs,
          androidImageFormat: AssetImageFormat.webp,
          androidAnimatedIcon: 'assets/anim.xml',
          androidAnimatedIconDark: 'assets/anim-dark.xml',
          androidDuration: 1500,
          androidIconBackground: ColorValue('#ABCDEF'),
          androidIconBackgroundDark: ColorValue('#111111'),
          androidIconPadding: 30,
          androidGravity: 'bottom',
          androidFullscreen: true,
          androidScreenOrientation: 'portrait',
          androidStatusBarColor: 'transparent',
          androidStatusBarColorDark: '#0C1413',
          androidStatusBarIconBrightness: StatusBarIconBrightness.dark,
          androidNavigationBarColor: '#E4ECE8',
          androidNavigationBarIconBrightness: StatusBarIconBrightness.light,
          androidBranding: 'assets/wordmark.svg',
          androidBrandingText: 'My App',
          androidBrandingTextColor: ColorValue('#1F5560'),
          androidBrandingMode: BrandingMode.bottomLeft,
          androidBrandingFit: SplashImageFit.asIs,
          androidBrandingBottomPadding: 32,
          iosLogoSize: 128,
        ),
      ),
      platforms: PlatformsConfig(android: AndroidConfig(minSdk: 24)),
    );

    final yaml = config.toAdaptiveStudioYaml();
    expect(yaml, contains('min_sdk: 24'));
    expect(yaml, contains("background: '#E4ECF8'"));
    expect(yaml, contains("safe_zone: 'inset:20'"));
    expect(yaml, contains('round: true'));
    expect(yaml, contains('legacy_padding: 43'));
    expect(yaml, contains("monochrome: 'assets/mono.svg'"));
    expect(yaml, contains('foreground_format: raster'));
    expect(yaml, contains('themed:'));
    expect(yaml, contains("background_dark: '#101010'"));
    expect(yaml, contains('padding: 5'));
    expect(yaml, contains("background: '#112233'"));
    expect(yaml, contains('image_fit: as_is'));
    expect(yaml, contains('image_format: webp'));
    expect(yaml, contains("animated_icon: 'assets/anim.xml'"));
    expect(yaml, contains('duration: 1500'));
    expect(yaml, contains("icon_background: '#ABCDEF'"));
    expect(yaml, contains('icon_padding: 30'));
    expect(yaml, contains("gravity: 'bottom'"));
    expect(yaml, contains('fullscreen: true'));
    expect(yaml, contains("screen_orientation: 'portrait'"));
    expect(yaml, contains("status_bar_color: 'transparent'"));
    expect(yaml, contains("status_bar_icon_brightness: 'dark'"));
    expect(yaml, contains('branding_mode: bottom_left'));
    expect(yaml, contains('branding_bottom_padding: 32'));
    expect(yaml, contains('logo_size: 128'));
    expect(yaml, isNot(contains('flutter_splash')));
    expect(yaml, isNot(contains('logo_padding')));
    expect(yaml, isNot(contains('duration_ms')));

    final root =
        (loadYaml(yaml) as YamlMap)['flutter_adaptive_studio'] as YamlMap;
    final adaptive =
        ((root['android'] as YamlMap)['icon'] as YamlMap)['adaptive']
            as YamlMap;
    expect(adaptive['background'], '#E4ECF8');
    expect(adaptive['safe_zone'], 'inset:20');
    expect(adaptive['foreground_format'], 'raster');
    expect((root['ios'] as YamlMap)['icon'], isA<YamlMap>());
  });

  test('ignores commented-out icon and splash config', () {
    const source = '''
DngoConfig get dngoConfig => DngoConfig(
  app: AppConfig(
    name: 'App',
    bundleId: BundleId(ios: 'com.example.app', android: 'com.example.app'),
    version: AppVersion(name: '1.0.0', buildNumber: 1),
    // icon: AppIcon(source: 'assets/old.svg'),
    // splash: SplashConfig(
    //   image: 'assets/old.png',
    //   backgroundColor: ColorValue('#000000'),
    // ),
  ),
);
''';

    final config = DngoConfigParser.parse(source);
    expect(config.app.icon, isNull);
    expect(config.app.splash, isNull);
  });

  test('keeps double slashes inside string literals', () {
    const source = '''
DngoConfig get dngoConfig => DngoConfig(
  app: AppConfig(
    name: 'App',
    bundleId: BundleId(ios: 'com.example.app', android: 'com.example.app'),
    version: AppVersion(name: '1.0.0', buildNumber: 1),
    icon: AppIcon(source: 'https://example.com/logo.svg'),
  ),
);
''';

    final config = DngoConfigParser.parse(source);
    expect(config.app.icon!.source, 'https://example.com/logo.svg');
  });

  test('parses Android intent queries and iOS query schemes', () {
    const source = '''
DngoConfig get dngoConfig => DngoConfig(
  app: AppConfig(
    name: 'App',
    bundleId: BundleId(ios: 'com.example.app', android: 'com.example.app'),
    version: AppVersion(name: '1.0.0', buildNumber: 1),
  ),
  platforms: PlatformsConfig(
    ios: IosConfig(
      querySchemes: {'youtube', 'comgooglemaps', 'amazon'},
    ),
    android: AndroidConfig(
      intentQueries: [
        AndroidIntent.view(data: [AndroidIntentData.scheme('youtube')]),
        AndroidIntent(
          action: 'android.intent.action.VIEW',
          categories: {'android.intent.category.BROWSABLE'},
          data: [
            AndroidIntentData(
              scheme: 'https',
              host: 'youtube.com',
              pathPrefix: '/watch',
              mimeType: 'text/plain',
            ),
          ],
        ),
      ],
    ),
  ),
);
''';

    final config = DngoConfigParser.parse(source);
    expect(config.platforms.ios.querySchemes, {
      'youtube',
      'comgooglemaps',
      'amazon',
    });

    final intents = config.platforms.android.intentQueries;
    expect(intents, hasLength(2));
    expect(intents[0].action, AndroidIntent.viewAction);
    expect(intents[0].data.single.scheme, 'youtube');
    expect(
      intents[1].categories,
      contains(AndroidIntent.browsableCategory),
    );
    final data = intents[1].data.single;
    expect(data.scheme, 'https');
    expect(data.host, 'youtube.com');
    expect(data.pathPrefix, '/watch');
    expect(data.mimeType, 'text/plain');
  });

  test('round-trips intent queries and query schemes', () {
    const source = DngoConfig(
      app: AppConfig(
        name: 'App',
        bundleId: BundleId(ios: 'com.example.app', android: 'com.example.app'),
        version: AppVersion(name: '1.0.0', buildNumber: 1),
      ),
      platforms: PlatformsConfig(
        ios: IosConfig(querySchemes: {'youtube', 'amazon'}),
        android: AndroidConfig(
          intentQueries: [
            AndroidIntent.view(
              data: [
                AndroidIntentData(scheme: 'youtube'),
                AndroidIntentData(
                  scheme: 'https',
                  host: 'youtube.com',
                  pathPrefix: '/watch',
                ),
              ],
            ),
          ],
        ),
      ),
    );

    final rendered = renderConfig(source);
    expect(rendered, contains("querySchemes: {'amazon', 'youtube'}"));
    expect(rendered, contains('intentQueries: [AndroidIntent('));
    expect(rendered, contains("action: 'android.intent.action.VIEW'"));
    expect(rendered, contains("scheme: 'youtube'"));
    expect(rendered, contains("host: 'youtube.com'"));

    final parsed = DngoConfigParser.parse(rendered);
    expect(parsed.platforms.ios.querySchemes, {'youtube', 'amazon'});
    final intent = parsed.platforms.android.intentQueries.single;
    expect(intent.action, AndroidIntent.viewAction);
    expect(intent.data, hasLength(2));
    expect(intent.data.first.scheme, 'youtube');
    expect(intent.data.last.scheme, 'https');
    expect(intent.data.last.host, 'youtube.com');
    expect(intent.data.last.pathPrefix, '/watch');

    final json = parsed.toJson();
    expect(json['iosQuerySchemes'], ['amazon', 'youtube']);
    expect(json['androidIntentQueries'], isA<List<Object?>>());
  });

  test('parses Android activity intent filters', () {
    const source = '''
DngoConfig get dngoConfig => DngoConfig(
  app: AppConfig(
    name: 'App',
    bundleId: BundleId(ios: 'com.example.app', android: 'com.example.app'),
    version: AppVersion(name: '1.0.0', buildNumber: 1),
  ),
  platforms: PlatformsConfig(
    android: AndroidConfig(
      intentFilters: [
        AndroidIntentFilter.deepLink(
          scheme: 'dngo',
          host: 'open.example.com',
          pathPrefix: '/app',
          autoVerify: true,
        ),
        AndroidIntentFilter(
          activity: '.ShareActivity',
          action: 'android.intent.action.SEND',
          categories: {'android.intent.category.DEFAULT'},
          data: [AndroidIntentData(mimeType: 'text/plain')],
        ),
      ],
    ),
  ),
);
''';

    final filters = DngoConfigParser.parse(
      source,
    ).platforms.android.intentFilters;
    expect(filters, hasLength(2));

    final deepLink = filters.first;
    expect(deepLink.activity, isNull);
    expect(deepLink.autoVerify, isTrue);
    expect(deepLink.action, AndroidIntent.viewAction);
    expect(deepLink.categories, {
      AndroidIntent.defaultCategory,
      AndroidIntent.browsableCategory,
    });
    expect(deepLink.data.single.scheme, 'dngo');
    expect(deepLink.data.single.host, 'open.example.com');
    expect(deepLink.data.single.pathPrefix, '/app');

    final share = filters.last;
    expect(share.activity, '.ShareActivity');
    expect(share.action, 'android.intent.action.SEND');
    expect(share.data.single.mimeType, 'text/plain');
  });

  test('round-trips activity intent filters', () {
    final source = DngoConfig(
      app: const AppConfig(
        name: 'App',
        bundleId: BundleId(ios: 'com.example.app', android: 'com.example.app'),
        version: AppVersion(name: '1.0.0', buildNumber: 1),
      ),
      platforms: PlatformsConfig(
        android: AndroidConfig(
          intentFilters: [
            AndroidIntentFilter.deepLink(
              scheme: 'dngo',
              host: 'open.example.com',
              pathPrefix: '/app',
              autoVerify: true,
            ),
            const AndroidIntentFilter(
              activity: '.ShareActivity',
              action: 'android.intent.action.SEND',
              categories: {AndroidIntent.defaultCategory},
              data: [AndroidIntentData(mimeType: 'text/plain')],
            ),
          ],
        ),
      ),
    );

    final rendered = renderConfig(source);
    expect(rendered, contains('intentFilters: ['));
    expect(rendered, contains('AndroidIntentFilter.deepLink('));
    expect(rendered, contains("scheme: 'dngo'"));
    expect(rendered, contains('autoVerify: true'));
    expect(rendered, contains("activity: '.ShareActivity'"));

    final filters = DngoConfigParser.parse(
      rendered,
    ).platforms.android.intentFilters;
    expect(filters, hasLength(2));
    expect(filters.first.data.single.scheme, 'dngo');
    expect(filters.first.autoVerify, isTrue);
    expect(filters.last.activity, '.ShareActivity');
    expect(filters.last.data.single.mimeType, 'text/plain');
    expect(
      DngoConfigParser.parse(rendered).toJson()['androidIntentFilters'],
      isA<List<Object?>>(),
    );
  });

  test('round-trips iOS URL schemes and associated domains', () {
    const source = DngoConfig(
      app: AppConfig(
        name: 'App',
        bundleId: BundleId(ios: 'com.example.app', android: 'com.example.app'),
        version: AppVersion(name: '1.0.0', buildNumber: 1),
      ),
      platforms: PlatformsConfig(
        ios: IosConfig(
          querySchemes: {'youtube'},
          urlSchemes: {'dngo', 'dartnativego'},
          associatedDomains: {'applinks:example.com'},
        ),
      ),
    );

    final rendered = renderConfig(source);
    expect(rendered, contains("querySchemes: {'youtube'}"));
    expect(rendered, contains("urlSchemes: {'dartnativego', 'dngo'}"));
    expect(
      rendered,
      contains("associatedDomains: {'applinks:example.com'}"),
    );

    final ios = DngoConfigParser.parse(rendered).platforms.ios;
    expect(ios.querySchemes, {'youtube'});
    expect(ios.urlSchemes, {'dngo', 'dartnativego'});
    expect(ios.associatedDomains, {'applinks:example.com'});
  });

  test('parses platform-specific icons and splashes', () {
    const source = '''
DngoConfig get dngoConfig => DngoConfig(
  app: AppConfig(
    name: 'App',
    bundleId: BundleId(ios: 'com.example.app', android: 'com.example.app'),
    version: AppVersion(name: '1.0.0', buildNumber: 1),
    icon: AppIcon(
      source: 'assets/logo.svg',
      androidBackground: ColorValue('E4ECF8'),
      androidSafeZone: AdaptiveSafeZone.inset(25),
      androidRound: true,
      androidImageFormat: AssetImageFormat.webp,
      iosBackground: ColorValue('#123456'),
      iosDark: 'assets/dark.svg',
    ),
    splash: SplashConfig(
      image: 'assets/splash.svg',
      backgroundColor: ColorValue('112233'),
      androidImageFit: SplashImageFit.asIs,
      androidIconBackground: ColorValue('#ABCDEF'),
      iosLogoSize: 100,
    ),
  ),
  platforms: PlatformsConfig(
    ios: IosConfig(
      icon: IosAppIcon(
        image: 'assets/ios.svg',
        background: ColorValue('#FFFFFF'),
        dark: 'assets/ios-dark.svg',
        backgroundDark: ColorValue('#101010'),
        tinted: 'assets/tinted.svg',
        padding: 6,
      ),
      splash: IosSplash(
        background: ColorValue('#FFFFFF'),
        backgroundImage: 'assets/ios-bg.png',
        image: 'assets/ios-splash.svg',
        imageDark: 'assets/ios-splash-dark.svg',
        logoSize: 160,
      ),
    ),
    android: AndroidConfig(
      icon: AndroidAppIcon(
        foreground: 'assets/android.svg',
        background: ColorValue('#FF0000'),
        monochrome: 'assets/mono.svg',
        safeZone: AdaptiveSafeZone.inset(20),
        round: true,
        legacyPadding: 43,
        imageFormat: AssetImageFormat.webp,
      ),
      splash: AndroidSplash(
        background: ColorValue('#FF0000'),
        image: 'assets/android-splash.svg',
        imageFit: SplashImageFit.asIs,
        iconPadding: 30,
        brandingText: 'Android',
        brandingMode: BrandingMode.bottomRight,
        statusBarColor: 'transparent',
      ),
    ),
  ),
);
''';

    final config = DngoConfigParser.parse(source);
    expect(config.app.icon!.androidSafeZone.value, 'inset:25');
    expect(config.app.icon!.androidRound, isTrue);
    expect(config.app.icon!.androidImageFormat, AssetImageFormat.webp);
    expect(config.app.splash!.androidImageFit, SplashImageFit.asIs);
    expect(config.app.splash!.iosLogoSize, 100);

    final ios = config.iosIcon!;
    expect(ios.image, 'assets/ios.svg');
    expect(ios.background.value, '#FFFFFF');
    expect(ios.backgroundDark.value, '#101010');
    expect(ios.dark, 'assets/ios-dark.svg');
    expect(ios.tinted, 'assets/tinted.svg');
    expect(ios.padding, 6);

    final iosSplash = config.iosSplash!;
    expect(iosSplash.background!.value, '#FFFFFF');
    expect(iosSplash.backgroundImage, 'assets/ios-bg.png');
    expect(iosSplash.image, 'assets/ios-splash.svg');
    expect(iosSplash.imageDark, 'assets/ios-splash-dark.svg');
    expect(iosSplash.logoSize, 160);

    final android = config.androidIcon!;
    expect(android.foreground, 'assets/android.svg');
    expect(android.background.value, '#FF0000');
    expect(android.safeZone.value, 'inset:20');
    expect(android.round, isTrue);
    expect(android.legacyPadding, 43);
    expect(android.imageFormat, AssetImageFormat.webp);

    final androidSplash = config.androidSplash!;
    expect(androidSplash.background!.value, '#FF0000');
    expect(androidSplash.image, 'assets/android-splash.svg');
    expect(androidSplash.imageFit, SplashImageFit.asIs);
    expect(androidSplash.iconPadding, 30);
    expect(androidSplash.brandingText, 'Android');
    expect(androidSplash.brandingMode, BrandingMode.bottomRight);
    expect(androidSplash.statusBarColor, 'transparent');
  });

  test('renderConfig round-trips icons and splashes', () {
    const source = DngoConfig(
      app: AppConfig(
        name: 'Round Trip',
        bundleId: BundleId(ios: 'com.example.app', android: 'com.example.app'),
        version: AppVersion(name: '1.0.0', buildNumber: 1),
        icon: AppIcon(
          source: 'assets/logo.svg',
          androidBackground: ColorValue('#FF0000'),
          androidSafeZone: AdaptiveSafeZone.inset(20),
          androidRound: true,
          androidLegacyPadding: 43,
          androidImageFormat: AssetImageFormat.webp,
          iosBackground: ColorValue('#FFFFFF'),
          iosDark: 'assets/dark.svg',
          iosPadding: 5,
        ),
        splash: SplashConfig(
          image: 'assets/splash.svg',
          backgroundColor: ColorValue('112233'),
          androidImageFit: SplashImageFit.asIs,
          androidIconBackground: ColorValue('#ABCDEF'),
          androidBrandingText: 'My App',
          iosLogoSize: 128,
        ),
      ),
      platforms: PlatformsConfig(
        ios: IosConfig(
          icon: IosAppIcon(
            image: 'assets/ios.svg',
            dark: 'assets/ios-dark.svg',
            backgroundDark: ColorValue('#101010'),
            padding: 6,
          ),
          splash: IosSplash(
            background: ColorValue('#FFFFFF'),
            image: 'assets/ios-splash.svg',
            logoSize: 160,
          ),
        ),
        android: AndroidConfig(
          permissions: {
            AndroidPermission.camera,
            AndroidPermission.postNotifications,
            AndroidPermission.readMediaImages,
          },
          icon: AndroidAppIcon(
            foreground: 'assets/android.svg',
            background: ColorValue('#FF0000'),
            safeZone: AdaptiveSafeZone.inset(20),
            round: true,
            legacyPadding: 43,
          ),
          splash: AndroidSplash(
            background: ColorValue('#FF0000'),
            image: 'assets/android-splash.svg',
            imageFit: SplashImageFit.asIs,
            iconPadding: 30,
            brandingText: 'Android',
          ),
        ),
      ),
    );

    final rendered = renderConfig(source);
    expect(rendered, contains('permissions: {'));
    expect(rendered, contains('AndroidPermission.camera'));
    expect(rendered, contains('AndroidPermission.postNotifications'));
    final parsed = DngoConfigParser.parse(rendered);
    expect(parsed.platforms.android.permissions, {
      AndroidPermission.camera,
      AndroidPermission.postNotifications,
      AndroidPermission.readMediaImages,
    });
    expect(
      parsed.androidPermissions,
      containsAll([
        'android.permission.CAMERA',
        'android.permission.POST_NOTIFICATIONS',
        'android.permission.READ_MEDIA_IMAGES',
      ]),
    );
    expect(parsed.app.icon!.androidSafeZone.value, 'inset:20');
    expect(parsed.app.icon!.androidRound, isTrue);
    expect(parsed.app.icon!.androidLegacyPadding, 43);
    expect(parsed.app.icon!.iosPadding, 5);
    expect(parsed.app.splash!.backgroundColor.value, '#112233');
    expect(parsed.app.splash!.androidImageFit, SplashImageFit.asIs);
    expect(parsed.app.splash!.androidIconBackground!.value, '#ABCDEF');
    expect(parsed.app.splash!.iosLogoSize, 128);
    expect(parsed.iosIcon!.image, 'assets/ios.svg');
    expect(parsed.iosIcon!.backgroundDark.value, '#101010');
    expect(parsed.iosIcon!.padding, 6);
    expect(parsed.iosSplash!.logoSize, 160);
    expect(parsed.androidIcon!.safeZone.value, 'inset:20');
    expect(parsed.androidIcon!.legacyPadding, 43);
    expect(parsed.androidSplash!.imageFit, SplashImageFit.asIs);
    expect(parsed.androidSplash!.iconPadding, 30);
  });
}
