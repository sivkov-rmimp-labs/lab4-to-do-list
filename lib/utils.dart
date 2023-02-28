extension DateTimeExtensions on DateTime {
  static const russianMonths = [
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];

  String toRussianDateOnly() {
    return '$day ${russianMonths[month - 1]} $year';
  }

  DateTime removeTimeComponent() {
    return DateTime(year, month, day);
  }
}

extension StringExtensions on String {
  String truncateIfLonger(int maxLength) {
    if (length > maxLength) {
      return '${substring(0, maxLength)}...';
    }
    return this;
  }
}