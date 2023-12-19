// ignore_for_file: file_names
class GpsPoint {
  double? longitude;
  double? latitude;
  GpsPoint({
    this.longitude = 79.4609576808001,
    this.latitude  = 43.9726680183837,
  });

  factory GpsPoint.parse(String pointStr) {
    String value = pointStr.trim();
    value = value.replaceAll("POINT(", "");
    value = value.replaceAll("(", "");
    value = value.replaceAll(")", "");
    GpsPoint point = GpsPoint();
    var pt = value.split(',');
    if(pt.length == 2) {
      point.longitude = double.parse(pt[0]);
      point.latitude  = double.parse(pt[1]);
    }
    return point;
  }

  @override
  String toString() {
    return "POINT($longitude $latitude)";
  }
}

