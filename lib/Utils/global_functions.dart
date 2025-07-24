class GlobalFunctions {
  static T? parse<T>(dynamic value) {
    if (value == null) return null;

    // int
    if (T == int) {
      if (value is int) return value as T;
      if (value is double) return value.toInt() as T;
      if (value is String) return int.tryParse(value) as T?;
    }

    // double
    if (T == double) {
      if (value is double) return value as T;
      if (value is int) return value.toDouble() as T;
      if (value is String) return double.tryParse(value) as T?;
    }

    // String
    if (T == String) {
      return value.toString() as T;
    }

    // DateTime
    if (T == DateTime) {
      if (value is DateTime) return value as T;
      if (value is String) return DateTime.tryParse(value) as T?;
    }

    // bool
    if (T == bool) {
      if (value is bool) return value as T;
      if (value is String) {
        final lower = value.toLowerCase();
        if (lower == 'true' || lower == '1') return true as T;
        if (lower == 'false' || lower == '0') return false as T;
      }
      if (value is int) return (value == 1) as T;
    }

    // List
    if (T == List) {
      if (value is List) return value as T;
    }

    // Map
    if (T == Map) {
      if (value is Map) return value as T;
    }

    // Fallback
    try {
      return value as T;
    } catch (_) {
      return null;
    }
  }
}
