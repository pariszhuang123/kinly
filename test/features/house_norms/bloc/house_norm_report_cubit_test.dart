import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/house_norms/models.dart';
import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';
import 'package:kinly/features/house_norms/bloc/house_norm_report_cubit.dart';

class _MockHouseNormsRepository extends Mock implements HouseNormsRepository {}

void main() {
  late _MockHouseNormsRepository repository;

  const homeId = 'home-1';
  const locale = 'en';

  setUp(() {
    repository = _MockHouseNormsRepository();
    when(
      () => repository.getForHome(
        homeId: any(named: 'homeId'),
        locale: any(named: 'locale'),
      ),
    ).thenAnswer((_) async => _buildHouseNormDocument(status: 'published'));
    when(
      () => repository.editSectionText(
        homeId: any(named: 'homeId'),
        locale: any(named: 'locale'),
        sectionKey: any(named: 'sectionKey'),
        text: any(named: 'text'),
        changeSummary: any(named: 'changeSummary'),
      ),
    ).thenAnswer((_) async => _buildHouseNormDocument(status: 'out_of_date'));
    when(
      () => repository.publishForHome(
        homeId: any(named: 'homeId'),
        locale: any(named: 'locale'),
      ),
    ).thenAnswer((_) async => _buildHouseNormDocument(status: 'published'));
  });

  HouseNormReportCubit buildCubit({bool isOwner = true}) {
    return HouseNormReportCubit(
      repository: repository,
      homeId: homeId,
      locale: locale,
      isOwner: isOwner,
    );
  }

  test('initial state is loading', () {
    final cubit = buildCubit();
    expect(cubit.state.status, HouseNormReportStatus.loading);
    cubit.close();
  });

  blocTest<HouseNormReportCubit, HouseNormReportState>(
    'load emits loading then ready',
    build: buildCubit,
    act: (cubit) => cubit.load(),
    expect:
        () => [
          isA<HouseNormReportState>().having(
            (s) => s.status,
            'status',
            HouseNormReportStatus.loading,
          ),
          isA<HouseNormReportState>().having(
            (s) => s.status,
            'status',
            HouseNormReportStatus.ready,
          ),
        ],
  );

  blocTest<HouseNormReportCubit, HouseNormReportState>(
    'load emits empty when no document',
    build: () {
      when(
        () => repository.getForHome(
          homeId: any(named: 'homeId'),
          locale: any(named: 'locale'),
        ),
      ).thenAnswer((_) async => null);
      return buildCubit();
    },
    act: (cubit) => cubit.load(),
    expect:
        () => [
          isA<HouseNormReportState>().having(
            (s) => s.status,
            'status',
            HouseNormReportStatus.loading,
          ),
          isA<HouseNormReportState>().having(
            (s) => s.status,
            'status',
            HouseNormReportStatus.empty,
          ),
        ],
  );

  blocTest<HouseNormReportCubit, HouseNormReportState>(
    'publish succeeds for owner',
    build: buildCubit,
    seed: () => HouseNormReportState.ready(_buildHouseNormDocument(status: 'out_of_date'), isOwner: true),
    act: (cubit) async {
      final ok = await cubit.publish();
      expect(ok, isTrue);
    },
    expect:
        () => [
          isA<HouseNormReportState>().having(
            (s) => s.status,
            'status',
            HouseNormReportStatus.busy,
          ),
          isA<HouseNormReportState>().having(
            (s) => s.status,
            'status',
            HouseNormReportStatus.ready,
          ),
        ],
  );

  blocTest<HouseNormReportCubit, HouseNormReportState>(
    'publish returns false for non-owner',
    build: () => buildCubit(isOwner: false),
    seed: () => HouseNormReportState.ready(_buildHouseNormDocument(status: 'out_of_date'), isOwner: false),
    act: (cubit) async {
      final ok = await cubit.publish();
      expect(ok, isFalse);
    },
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => repository.publishForHome(
          homeId: any(named: 'homeId'),
          locale: any(named: 'locale'),
        ),
      );
    },
  );
}

HouseNormDocument _buildHouseNormDocument({required String status}) {
  return HouseNormDocument(
    homeId: 'home-1',
    templateKey: 'house_norms_v1',
    status: status,
    inputs: const {},
    draftContent: const HouseNormContent(
      summary: HouseNormSummary(
        title: 'House norms',
        subtitle: 'Shared defaults',
        framing: 'A shared starting point.',
      ),
      context: 'Context',
      sections: [
        HouseNormSection(
          sectionKey: 'norms_rhythm_quiet',
          title: 'Rhythm',
          text: 'We usually wind down.',
        ),
      ],
    ),
    draftUpdatedAt: DateTime.utc(2026, 1, 1),
    publishedContent: status == 'published'
        ? const HouseNormContent(
            summary: HouseNormSummary(
              title: 'House norms',
              subtitle: 'Shared defaults',
              framing: 'Published framing.',
            ),
            context: 'Context',
            sections: [
              HouseNormSection(
                sectionKey: 'norms_rhythm_quiet',
                title: 'Rhythm',
                text: 'Published text.',
              ),
            ],
          )
        : null,
    publishedAt: status == 'published' ? DateTime.utc(2026, 1, 1) : null,
    publishedVersion: status == 'published' ? 'v1' : null,
    isPublished: status == 'published',
    hasUnpublishedChanges: status == 'out_of_date',
    lastEditedAt: null,
    lastEditedBy: null,
    homePublicId: status == 'published' ? 'home_public_1' : null,
    publicUrl: status == 'published'
        ? 'https://go.makinglifeeasie.com/norms/home_public_1'
        : null,
    showPublishButton: status != 'published',
    showRepublishButton: status == 'out_of_date',
    showPublicUrl: status == 'published' || status == 'out_of_date',
  );
}
