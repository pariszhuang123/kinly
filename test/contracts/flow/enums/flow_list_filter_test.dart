import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/flow/enums/flow_list_filter.dart';

void main() {
  group('FlowListFilter', () {
    group('toQueryParam', () {
      test('all returns "all"', () {
        expect(FlowListFilter.all.toQueryParam(), 'all');
      });

      test('active returns "active"', () {
        expect(FlowListFilter.active.toQueryParam(), 'active');
      });

      test('drafts returns "drafts"', () {
        expect(FlowListFilter.drafts.toQueryParam(), 'drafts');
      });
    });

    group('fromQueryParam', () {
      test('parses "all" to FlowListFilter.all', () {
        expect(FlowListFilter.fromQueryParam('all'), FlowListFilter.all);
      });

      test('parses "active" to FlowListFilter.active', () {
        expect(FlowListFilter.fromQueryParam('active'), FlowListFilter.active);
      });

      test('parses "drafts" to FlowListFilter.drafts', () {
        expect(FlowListFilter.fromQueryParam('drafts'), FlowListFilter.drafts);
      });

      test('returns all for null', () {
        expect(FlowListFilter.fromQueryParam(null), FlowListFilter.all);
      });

      test('returns all for unknown value', () {
        expect(FlowListFilter.fromQueryParam('unknown'), FlowListFilter.all);
      });

      test('returns all for empty string', () {
        expect(FlowListFilter.fromQueryParam(''), FlowListFilter.all);
      });
    });

    group('round-trip', () {
      test('all values survive round-trip', () {
        for (final filter in FlowListFilter.values) {
          final queryParam = filter.toQueryParam();
          final parsed = FlowListFilter.fromQueryParam(queryParam);
          expect(parsed, filter);
        }
      });
    });
  });
}
