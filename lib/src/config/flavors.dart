enum Flavor {
  dev,
  uat,
  prod,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'StartFront Dev';
      case Flavor.uat:
        return 'StartFront UAT';
      case Flavor.prod:
        return 'StartFront';
    }
  }

}
