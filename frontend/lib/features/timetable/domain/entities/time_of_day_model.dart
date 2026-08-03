class TimeOfDayModel {
  final int hour;
  final int minute;

  const TimeOfDayModel({required this.hour, required this.minute})
    : assert(hour >= 0 && hour < 24),
      assert(minute >= 0 && hour < 60);

  String format24Hour() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  String toString() => format24Hour();
}
