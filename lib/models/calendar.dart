class Calendar {
  final String title;
  final String description;

  final String dateTime;

  const Calendar(this.title, this.description, this.dateTime);

  @override
  String toString() => title;
}
