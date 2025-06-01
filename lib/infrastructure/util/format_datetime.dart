import 'package:intl/intl.dart';

String formatDateTime({DateTime? dateTime}) =>
    DateFormat('dd/MM/yyyy').format(dateTime!);

String formatDateAsString({required String date}) {
  DateTime dateTime = DateTime.parse(date);

  return DateFormat('MMM dd, yyyy').format(dateTime);
}

String formatDateAsList({required List<DateTime?> dates}) {
  final dateFormatter = DateFormat('MMM dd, yyyy'); // Define the desired format
  return dates.map((date) {
    if (date != null) {
      return dateFormatter.format(date); // Format each date
    }
    return 'Invalid Date';
  }).join("   >   "); // Join dates with a comma and space
}

String formatDate({required DateTime dateTime}) =>
    DateFormat('MMM dd, yyyy').format(dateTime);

String formatDateTimeHour({DateTime? dateTime}) =>
    DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime!);

String formatYearMonthDateHour({DateTime? dateTime}) =>
    DateFormat('yyyy-MM-dd').format(dateTime!);
