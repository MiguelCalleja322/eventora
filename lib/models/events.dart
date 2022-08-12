class Events {
  final List<Event>? events;

  Events({this.events});

  factory Events.fromJson(List<dynamic> json) {
    return Events(
        events: json
            .map((upcomingEvent) => Event.fromJson(upcomingEvent))
            .toList());
  }
}

class Event {
  String? title;
  String? description;
  String? scheduleStart;
  String? bgcolor;
  List<dynamic>? images;
  String? slug;
  int? isAvailable;
  int? fees;
  String? eventType;
  String? registrationLink;
  List<dynamic>? features;
  String? scheduleEnd;
  int? eventLikesCount;
  int? attendeesCount;
  int? interestsCount;

  Event({
    this.title,
    this.description,
    this.scheduleStart,
    this.scheduleEnd,
    this.bgcolor,
    this.fees,
    this.images,
    this.features,
    this.slug,
    this.registrationLink,
    this.eventType,
    this.isAvailable,
    this.eventLikesCount,
    this.attendeesCount,
    this.interestsCount,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      description: json['description'],
      scheduleStart: json['schedule_start'],
      bgcolor: json['bgcolor'],
      images: json['images'],
      slug: json['slug'],
      isAvailable: json['is_available'],
      fees: json['fees'],
      eventType: json['event_type'],
      registrationLink: json['registration_link'],
      features: json['features'],
      scheduleEnd: json['schedule_end'],
    );
  }
}
