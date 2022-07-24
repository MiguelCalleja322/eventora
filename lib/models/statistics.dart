import 'package:eventora/models/events.dart';

class Statistics {
  final List<dynamic>? statistics;

  Statistics({this.statistics});

  factory Statistics.fromJson(List<dynamic> json) {
    return Statistics(
        statistics:
            json.map((statistic) => Statistic.fromJson(statistic)).toList());
  }
}

class Statistic {
  Events? mostLiked;
  Events? mostInteresting;
  Events? mostAttended;

  Statistic({this.mostLiked, this.mostInteresting, this.mostAttended});

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      mostLiked: Events.fromJson(json['most_liked']),
      mostInteresting: Events.fromJson(json['most_interesting']),
      mostAttended: Events.fromJson(json['most_attendees']),
    );
  }
}
