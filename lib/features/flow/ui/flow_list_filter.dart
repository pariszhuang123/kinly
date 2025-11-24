enum FlowListFilter {
  all,
  active,
  drafts;

  static FlowListFilter fromQueryParam(String? value) {
    switch (value) {
      case 'active':
        return FlowListFilter.active;
      case 'drafts':
        return FlowListFilter.drafts;
      default:
        return FlowListFilter.all;
    }
  }

  String toQueryParam() {
    switch (this) {
      case FlowListFilter.active:
        return 'active';
      case FlowListFilter.drafts:
        return 'drafts';
      case FlowListFilter.all:
        return 'all';
    }
  }
}
