String normalizeSearchText(String value) {
  final buffer = StringBuffer();
  for (final rune in value.toLowerCase().runes) {
    final normalizedRune = _normalizeSearchRune(rune);
    if (normalizedRune != null) {
      buffer.writeCharCode(normalizedRune);
    }
  }
  return buffer.toString();
}

String buildSearchableText(Iterable<String?> values) {
  return values.whereType<String>().where((value) => value.isNotEmpty).join(' ');
}

bool matchesSearchQuery({
  required String query,
  required String searchableText,
}) {
  final normalizedQuery = normalizeSearchText(query);
  if (normalizedQuery.isEmpty) return true;
  return normalizeSearchText(searchableText).contains(normalizedQuery);
}

int? _normalizeSearchRune(int rune) {
  if (_isWhitespaceRune(rune) || _isPunctuationLikeRune(rune)) {
    return null;
  }
  final arabicRune = _normalizeArabicRune(rune);
  if (arabicRune != null) {
    return arabicRune;
  }
  if (_isSearchableRune(rune)) {
    return rune;
  }
  return null;
}

bool _isSearchableRune(int rune) {
  final isAsciiDigit = rune >= 48 && rune <= 57;
  final isAsciiLetter = rune >= 97 && rune <= 122;
  if (isAsciiDigit || isAsciiLetter) {
    return true;
  }
  if (rune <= 127) {
    return false;
  }
  if (_isWhitespaceRune(rune) || _isPunctuationLikeRune(rune)) {
    return false;
  }
  return true;
}

int? _normalizeArabicRune(int rune) {
  return switch (rune) {
    0x0610 || 0x0611 || 0x0612 || 0x0613 || 0x0614 || 0x0615 || 0x0616 ||
    0x0617 || 0x0618 || 0x0619 || 0x061A || 0x0640 || 0x064B || 0x064C ||
    0x064D || 0x064E || 0x064F || 0x0650 || 0x0651 || 0x0652 || 0x0653 ||
    0x0654 || 0x0655 || 0x0656 || 0x0657 || 0x0658 || 0x0659 || 0x065A ||
    0x065B || 0x065C || 0x065D || 0x065E || 0x065F || 0x0670 || 0x06D6 ||
    0x06D7 || 0x06D8 || 0x06D9 || 0x06DA || 0x06DB || 0x06DC || 0x06DF ||
    0x06E0 || 0x06E1 || 0x06E2 || 0x06E3 || 0x06E4 || 0x06E7 || 0x06E8 ||
    0x06EA || 0x06EB || 0x06EC || 0x06ED => null,
    0x0622 || 0x0623 || 0x0625 || 0x0671 => 0x0627,
    0x0629 => 0x0647,
    0x0649 => 0x064A,
    0x0624 => 0x0648,
    0x0626 => 0x064A,
    _ => null,
  };
}

bool _isWhitespaceRune(int rune) {
  return switch (rune) {
    0x0009 || 0x000A || 0x000B || 0x000C || 0x000D || 0x0020 || 0x0085 ||
    0x00A0 || 0x1680 || 0x2000 || 0x2001 || 0x2002 || 0x2003 || 0x2004 ||
    0x2005 || 0x2006 || 0x2007 || 0x2008 || 0x2009 || 0x200A || 0x2028 ||
    0x2029 || 0x202F || 0x205F || 0x3000 => true,
    _ => false,
  };
}

bool _isPunctuationLikeRune(int rune) {
  return (rune >= 0x2000 && rune <= 0x206F) ||
      (rune >= 0x3001 && rune <= 0x303F) ||
      (rune >= 0xFF01 && rune <= 0xFF0F) ||
      (rune >= 0xFF1A && rune <= 0xFF20) ||
      (rune >= 0xFF3B && rune <= 0xFF40) ||
      (rune >= 0xFF5B && rune <= 0xFF65);
}
