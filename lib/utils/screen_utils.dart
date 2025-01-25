import 'package:responsive_builder/responsive_builder.dart';

/// A utility function to get adaptive font size based on the device screen type.
/// - `desktopSize`: Font size for desktop devices.
/// - `tabletSize`: Font size for tablet devices.
/// - `mobileSize`: Font size for mobile devices.
double getFontSize(SizingInformation sizingInfo, double desktopSize, double tabletSize, double mobileSize) {
  switch (sizingInfo.deviceScreenType) {
    case DeviceScreenType.desktop:
      return desktopSize;
    case DeviceScreenType.tablet:
      return tabletSize;
    case DeviceScreenType.mobile:
    default:
      return mobileSize;
  }
}
