DateTime dateOnly(DateTime value) => DateTime(value.year, value.month, value.day);

DateTime todayDateOnly([DateTime? now]) => dateOnly(now ?? DateTime.now());
