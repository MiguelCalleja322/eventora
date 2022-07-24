import 'package:eventora/models/events.dart';
import 'package:eventora/models/organizers.dart';

class Features {
  final List<dynamic>? features;

  Features({this.features});

  factory Features.fromJson(List<dynamic> json) {
    return Features(
        features: json.map((feature) => Feature.fromJson(feature)).toList());
  }
}

class Feature {
  Organizers? featuredOrganizers;
  Events? featuredUpcoming;
  Events? featuredEvents;

  Feature(
      {this.featuredOrganizers, this.featuredUpcoming, this.featuredEvents});

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      featuredOrganizers: Organizers.fromJson(json['organizers']),
      featuredUpcoming: Events.fromJson(json['upcoming']),
      featuredEvents: Events.fromJson(json['featured_events']),
    );
  }
}
