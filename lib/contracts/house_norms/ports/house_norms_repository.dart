import '../models.dart';

abstract class HouseNormsRepository {
  Future<HouseNormDocument?> getForHome({
    required String homeId,
    required String locale,
  });

  Future<HouseNormDocument> generateForHome({
    required String homeId,
    String templateKey = 'house_norms_v1',
    required String locale,
    required Map<String, int> inputs,
    bool force = false,
  });

  Future<HouseNormDocument> editSectionText({
    required String homeId,
    required String locale,
    required String sectionKey,
    required String text,
    String? changeSummary,
  });

  Future<HouseNormDocument> publishForHome({
    required String homeId,
    required String locale,
  });

  Future<void> recordView({required String homeId});
}
