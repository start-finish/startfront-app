import 'dart:developer';

import 'infrastructure/util/format_datetime.dart';

const int totalWidth = 100; // Consistent width for all logs

/// Helper to create a perfectly centered line with balanced spacing
String createCenteredLine(String content) {
  int contentLength = content.length;
  int sidePadding = (totalWidth - contentLength) ~/ 2;
  String line = '${' ' * sidePadding}$content${' ' * sidePadding}';

  // Ensure the line is exactly totalWidth by balancing odd length differences
  if (line.length < totalWidth) {
    line += ' ';
  }

  return line;
}

/// Helper to generate a line with no content, perfectly aligned
String createEmptyLine() {
  return createCenteredLine('');
}

/// Logs a block with a centered date and name ensuring perfect spacing
void printLogFormat(String name) {
  String formattedDateTime = formatDateTimeHour(dateTime: DateTime.now());

  // Generate formatted lines with equal padding
  String dateTimeLine = createCenteredLine(formattedDateTime);
  String nameLine = createCenteredLine(name.toUpperCase());
  String emptyLine = createEmptyLine();

  // Print the log with perfectly aligned and equal spacing
  log('', name: '\x1B[95m#\x1B[0m' * totalWidth);
  log('', name: emptyLine);
  log('', name: '\x1B[95m$dateTimeLine\x1B[0m');
  log('', name: emptyLine);
  log('', name: '\x1B[95m~\x1B[0m' * totalWidth);
  log('', name: emptyLine);
  log('', name: '\x1B[95m$nameLine\x1B[0m');
  log('', name: emptyLine);
  log('', name: '\x1B[95m#\x1B[0m' * totalWidth);
}

/// Logs a simplified request/response block ensuring equal padding
void printRequestLog(String name, bool isError) {
  String nameLine = createCenteredLine(name);
  String emptyLine = createEmptyLine();

  // Consistent and balanced spacing for all logs
  log('',
      name: (isError ? '\x1B[32m#\x1B[0m' : '\x1B[31m#\x1B[0m') * totalWidth);
  log('', name: emptyLine);
  log('',
      name: isError ? '\x1B[32m$nameLine\x1B[0m' : '\x1B[31m$nameLine\x1B[0m');
  log('', name: emptyLine);
  log('',
      name: (isError ? '\x1B[32m#\x1B[0m' : '\x1B[31m#\x1B[0m') * totalWidth);
  log('', name: '-' * totalWidth);
}
