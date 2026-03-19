part of 'personal_directory_screen.dart';

enum _PersonalDirectoryBrowseSection { allergy, other }

class _PersonalDirectoryViewData {
  const _PersonalDirectoryViewData({
    required this.emergencyContact,
    required this.browseSection,
    required this.segments,
    required this.browsableNotes,
    required this.filteredBrowsableNotes,
    required this.visibleBrowseNotes,
    required this.hasActiveSearch,
  });

  final PersonalDirectoryNote? emergencyContact;
  final _PersonalDirectoryBrowseSection browseSection;
  final Map<_PersonalDirectoryBrowseSection, String> segments;
  final List<PersonalDirectoryNote> browsableNotes;
  final List<PersonalDirectoryNote> filteredBrowsableNotes;
  final List<PersonalDirectoryNote> visibleBrowseNotes;
  final bool hasActiveSearch;

  static _PersonalDirectoryViewData fromState({
    required BuildContext context,
    required PersonalDirectoryState state,
    required String query,
    required _PersonalDirectoryBrowseSection selectedSection,
    required List<PersonalDirectoryNote> Function(List<PersonalDirectoryNote>)
        filterNotes,
  }) {
    final filteredNotes = filterNotes(state.notes);
    final hasActiveSearch = query.trim().isNotEmpty;
    final visibleNotes = hasActiveSearch ? filteredNotes : state.notes;
    final emergencyContact =
        _findEmergencyContact(visibleNotes) ?? _findEmergencyContact(state.notes);
    final allergyNotes = _notesByType(
      visibleNotes,
      PersonalDirectoryNoteType.allergy,
    );
    final otherNotes = _notesByType(
      visibleNotes,
      PersonalDirectoryNoteType.other,
    );
    final browseSection = _resolveBrowseSection(
      selectedSection: selectedSection,
      allergyNotes: allergyNotes,
      otherNotes: otherNotes,
    );
    final s = S.of(context);
    return _PersonalDirectoryViewData(
      emergencyContact: emergencyContact,
      browseSection: browseSection,
      segments: <_PersonalDirectoryBrowseSection, String>{
        _PersonalDirectoryBrowseSection.allergy: s.personalDirectoryAllergyTitle,
        _PersonalDirectoryBrowseSection.other: s.personalDirectoryOtherTitle,
      },
      browsableNotes: state.notes.where(_isBrowsableNote).toList(growable: false),
      filteredBrowsableNotes:
          filteredNotes.where(_isBrowsableNote).toList(growable: false),
      visibleBrowseNotes: _visibleBrowseNotes(
        hasActiveSearch: hasActiveSearch,
        browseSection: browseSection,
        allergyNotes: allergyNotes,
        otherNotes: otherNotes,
      ),
      hasActiveSearch: hasActiveSearch,
    );
  }

  bool get hasNoBrowsableNotes => browsableNotes.isEmpty;

  bool get showSearchEmpty => hasActiveSearch && filteredBrowsableNotes.isEmpty;

  bool get showSegmentedControl {
    if (hasActiveSearch) return false;
    final hasAllergy = _containsType(
      browsableNotes,
      PersonalDirectoryNoteType.allergy,
    );
    final hasOther = _containsType(
      browsableNotes,
      PersonalDirectoryNoteType.other,
    );
    return hasAllergy && hasOther;
  }

  bool get showTypePill => false;

  String? get singleSectionTitle {
    if (hasActiveSearch || showSegmentedControl || visibleBrowseNotes.isEmpty) {
      return null;
    }
    final firstType = visibleBrowseNotes.first.noteType;
    return switch (firstType) {
      PersonalDirectoryNoteType.allergy =>
        segments[_PersonalDirectoryBrowseSection.allergy],
      PersonalDirectoryNoteType.other =>
        segments[_PersonalDirectoryBrowseSection.other],
      PersonalDirectoryNoteType.emergencyContact => null,
    };
  }

  String? get emergencyPhoneNumber {
    final phoneNumber = emergencyContact?.phoneNumber?.trim();
    if (phoneNumber == null || phoneNumber.isEmpty) return null;
    return phoneNumber;
  }

  static PersonalDirectoryNote? _findEmergencyContact(
    List<PersonalDirectoryNote> notes,
  ) {
    for (final note in notes) {
      if (note.noteType == PersonalDirectoryNoteType.emergencyContact) {
        return note;
      }
    }
    return null;
  }

  static List<PersonalDirectoryNote> _notesByType(
    List<PersonalDirectoryNote> notes,
    PersonalDirectoryNoteType type,
  ) {
    return notes.where((note) => note.noteType == type).toList(growable: false);
  }

  static _PersonalDirectoryBrowseSection _resolveBrowseSection({
    required _PersonalDirectoryBrowseSection selectedSection,
    required List<PersonalDirectoryNote> allergyNotes,
    required List<PersonalDirectoryNote> otherNotes,
  }) {
    if (selectedSection == _PersonalDirectoryBrowseSection.allergy &&
        allergyNotes.isNotEmpty) {
      return selectedSection;
    }
    if (selectedSection == _PersonalDirectoryBrowseSection.other &&
        otherNotes.isNotEmpty) {
      return selectedSection;
    }
    if (allergyNotes.isNotEmpty) {
      return _PersonalDirectoryBrowseSection.allergy;
    }
    return _PersonalDirectoryBrowseSection.other;
  }

  static List<PersonalDirectoryNote> _visibleBrowseNotes({
    required bool hasActiveSearch,
    required _PersonalDirectoryBrowseSection browseSection,
    required List<PersonalDirectoryNote> allergyNotes,
    required List<PersonalDirectoryNote> otherNotes,
  }) {
    if (hasActiveSearch) {
      return [...allergyNotes, ...otherNotes];
    }
    return switch (browseSection) {
      _PersonalDirectoryBrowseSection.allergy => allergyNotes,
      _PersonalDirectoryBrowseSection.other => otherNotes,
    };
  }

  static bool _isBrowsableNote(PersonalDirectoryNote note) {
    return note.noteType != PersonalDirectoryNoteType.emergencyContact;
  }

  static bool _containsType(
    List<PersonalDirectoryNote> notes,
    PersonalDirectoryNoteType type,
  ) {
    return notes.any((note) => note.noteType == type);
  }
}

String _noteTitle(PersonalDirectoryNote note) {
  return switch (note.noteType) {
    PersonalDirectoryNoteType.emergencyContact =>
      note.contactName ?? note.customTitle ?? note.label ?? '',
    PersonalDirectoryNoteType.allergy => note.label ?? '',
    PersonalDirectoryNoteType.other => note.customTitle ?? '',
  };
}
