import 'package:kinly/contracts/house_norms/models.dart';

bool isHouseNormOutOfDate(HouseNormDocument document) {
  return document.status == 'out_of_date';
}

HouseNormContent? resolveHouseNormDisplayContent(HouseNormDocument document) {
  if (isHouseNormOutOfDate(document)) {
    return document.draftContent ?? document.publishedContent;
  }
  return document.publishedContent ?? document.draftContent;
}
