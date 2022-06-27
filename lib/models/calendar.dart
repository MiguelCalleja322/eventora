class Calendar {
  final int id;
  final String model;
  final String title;
  final String description;

  final String dateTime;

  const Calendar(
      this.id, this.model, this.title, this.description, this.dateTime);

  @override
  String toString() => title;
}
