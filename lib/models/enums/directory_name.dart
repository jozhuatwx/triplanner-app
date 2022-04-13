enum DirectoryName {
  trips,
}

extension DirectoryNameExtension on DirectoryName {
  String get value {
    switch (this) {
      case DirectoryName.trips:
        return 'trips';
      default:
        throw ('Invalid directory name.');
    }
  }
}
