import 'package:eventora/models/events.dart';

class Feeds {
  final List<dynamic>? feeds;

  Feeds({this.feeds});

  factory Feeds.fromJson(List<dynamic> json) {
    return Feeds(feeds: json.map((feature) => Feed.fromJson(feature)).toList());
  }
}

class Feed {
  Events? events;

  Feed({this.events});

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(events: Events.fromJson(json['event_categories']['events']));
  }
}
