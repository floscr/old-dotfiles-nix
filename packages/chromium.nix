self: super:

{
  chromium = super.unstable.chromium.override {
    commandLineArgs = ''--add-flags "--force-device-scale-factor=1.5" "--enable-native-notifications"'';
  };
}
