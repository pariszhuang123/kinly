import 'package:kinly/contracts/house_norms/models.dart';
import 'package:kinly/generated/l10n.dart';

List<HouseNormScenarioDefinition> houseNormScenarios() {
  return const [
    HouseNormScenarioDefinition(
      id: 'norms_property_context',
      domain: 'context',
      question: _propertyContextQuestion,
      options: [
        _propertyContextOption1,
        _propertyContextOption2,
        _propertyContextOption3,
      ],
    ),
    HouseNormScenarioDefinition(
      id: 'norms_relationship_model',
      domain: 'context',
      question: _relationshipModelQuestion,
      options: [
        _relationshipModelOption1,
        _relationshipModelOption2,
        _relationshipModelOption3,
      ],
    ),
    HouseNormScenarioDefinition(
      id: 'norms_rhythm_quiet',
      domain: 'rhythm',
      question: _rhythmQuestion,
      options: [_rhythmOption1, _rhythmOption2, _rhythmOption3],
    ),
    HouseNormScenarioDefinition(
      id: 'norms_shared_spaces',
      domain: 'spaces',
      question: _sharedSpacesQuestion,
      options: [_sharedSpacesOption1, _sharedSpacesOption2, _sharedSpacesOption3],
    ),
    HouseNormScenarioDefinition(
      id: 'norms_guests_social',
      domain: 'social',
      question: _guestsQuestion,
      options: [_guestsOption1, _guestsOption2, _guestsOption3],
    ),
    HouseNormScenarioDefinition(
      id: 'norms_responsibility_flow',
      domain: 'effort',
      question: _responsibilityQuestion,
      options: [
        _responsibilityOption1,
        _responsibilityOption2,
        _responsibilityOption3,
      ],
    ),
    HouseNormScenarioDefinition(
      id: 'norms_repair_style',
      domain: 'repair',
      question: _repairQuestion,
      options: [_repairOption1, _repairOption2, _repairOption3],
    ),
    HouseNormScenarioDefinition(
      id: 'norms_home_identity',
      domain: 'identity',
      question: _homeIdentityQuestion,
      options: [_homeIdentityOption1, _homeIdentityOption2, _homeIdentityOption3],
    ),
  ];
}

String _propertyContextQuestion(S s) => s.houseNormScenarioPropertyContextQuestion;
String _propertyContextOption1(S s) => s.houseNormScenarioPropertyContextOption1;
String _propertyContextOption2(S s) => s.houseNormScenarioPropertyContextOption2;
String _propertyContextOption3(S s) => s.houseNormScenarioPropertyContextOption3;

String _relationshipModelQuestion(S s) => s.houseNormScenarioRelationshipModelQuestion;
String _relationshipModelOption1(S s) => s.houseNormScenarioRelationshipModelOption1;
String _relationshipModelOption2(S s) => s.houseNormScenarioRelationshipModelOption2;
String _relationshipModelOption3(S s) => s.houseNormScenarioRelationshipModelOption3;

String _rhythmQuestion(S s) => s.houseNormScenarioRhythmQuestion;
String _rhythmOption1(S s) => s.houseNormScenarioRhythmOption1;
String _rhythmOption2(S s) => s.houseNormScenarioRhythmOption2;
String _rhythmOption3(S s) => s.houseNormScenarioRhythmOption3;

String _sharedSpacesQuestion(S s) => s.houseNormScenarioSharedSpacesQuestion;
String _sharedSpacesOption1(S s) => s.houseNormScenarioSharedSpacesOption1;
String _sharedSpacesOption2(S s) => s.houseNormScenarioSharedSpacesOption2;
String _sharedSpacesOption3(S s) => s.houseNormScenarioSharedSpacesOption3;

String _guestsQuestion(S s) => s.houseNormScenarioGuestsQuestion;
String _guestsOption1(S s) => s.houseNormScenarioGuestsOption1;
String _guestsOption2(S s) => s.houseNormScenarioGuestsOption2;
String _guestsOption3(S s) => s.houseNormScenarioGuestsOption3;

String _responsibilityQuestion(S s) => s.houseNormScenarioResponsibilityQuestion;
String _responsibilityOption1(S s) => s.houseNormScenarioResponsibilityOption1;
String _responsibilityOption2(S s) => s.houseNormScenarioResponsibilityOption2;
String _responsibilityOption3(S s) => s.houseNormScenarioResponsibilityOption3;

String _repairQuestion(S s) => s.houseNormScenarioRepairQuestion;
String _repairOption1(S s) => s.houseNormScenarioRepairOption1;
String _repairOption2(S s) => s.houseNormScenarioRepairOption2;
String _repairOption3(S s) => s.houseNormScenarioRepairOption3;

String _homeIdentityQuestion(S s) => s.houseNormScenarioHomeIdentityQuestion;
String _homeIdentityOption1(S s) => s.houseNormScenarioHomeIdentityOption1;
String _homeIdentityOption2(S s) => s.houseNormScenarioHomeIdentityOption2;
String _homeIdentityOption3(S s) => s.houseNormScenarioHomeIdentityOption3;
