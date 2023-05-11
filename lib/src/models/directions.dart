import 'package:google_maps_flutter/google_maps_flutter.dart';

class DataInfo {
  late String text;
  late int value;

  DataInfo({
    required this.text,
    required this.value
  });

  DataInfo.fromJsonMap(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }
}

class Direction {

  late DataInfo distance;
  late DataInfo duration;
  late String startAddress;
  late String endAddress;
  late LatLng startLocation;
  late LatLng endLocation;

  Direction({
   required this.startAddress,
   required this.endAddress,
   required this.startLocation,
   required this.endLocation
  });

  Direction.fromJsonMap(Map<String, dynamic> json) {
    distance = new DataInfo.fromJsonMap(json['distance']);
    duration = new DataInfo.fromJsonMap(json['duration']);
    startAddress = json['start_address'];
    endAddress = json['end_address'];
    duration = new DataInfo.fromJsonMap(json['duration']);
    startLocation = new LatLng(json['start_location']['lat'], json['start_location']['lng']);
    endLocation = new LatLng(json['end_location']['lat'], json['end_location']['lng']);
  }

  Map<String, dynamic> toJson() => {
    'distance': distance.text,
    'duration': duration.text,
  };

}
