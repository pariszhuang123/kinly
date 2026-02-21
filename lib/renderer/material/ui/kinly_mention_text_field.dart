import 'package:flutter/material.dart';

import '../theme/color_tokens.dart';
import '../theme/kinly_palette.dart';
import '../theme/opacity.dart';
import '../theme/radius.dart';
import '../theme/spacing.dart';
import '../theme/typography_tokens.dart';
import 'kinly_circle_avatar.dart';
import '../../../generated/l10n.dart';

class KinlyMentionOption {
  const KinlyMentionOption({
    required this.id,
    required this.displayName,
    this.avatarUrl,
  });

  final String id;
  final String displayName;
  final String? avatarUrl;
}

/// Text field that shows mention suggestions when "@" is typed.
class KinlyMentionTextField extends StatefulWidget {
  const KinlyMentionTextField({
    super.key,
    required this.mentionables,
    required this.selectedIds,
    required this.onSelectedChanged,
    this.inputKey,
    this.label,
    this.hintText,
    this.initialText,
    this.onTextChanged,
    this.maxSelections = 5,
    this.maxLines = 1,
    this.enabled = true,
    this.mentionsEnabled = true,
  });

  final List<KinlyMentionOption> mentionables;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectedChanged;
  final Key? inputKey;
  final String? label;
  final String? hintText;
  final String? initialText;
  final ValueChanged<String>? onTextChanged;
  final int maxSelections;
  final int maxLines;
  final bool enabled;
  final bool mentionsEnabled;

  @override
  State<KinlyMentionTextField> createState() => _KinlyMentionTextFieldState();
}

class _KinlyMentionTextFieldState extends State<KinlyMentionTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  String _query = '';
  bool _hasActiveTrigger = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText ?? '');
    _focusNode = FocusNode();
    _hasActiveTrigger = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final colors =
        theme.extension<KinlyColorTokens>() ??
        KinlyPalette.build(theme.brightness).colorTokens;
    final opacities = theme.extension<KinlyOpacity>()!;
    final corners = theme.extension<Corners>();
    final type = theme.extension<KinlyTypography>();

    final selected = widget.selectedIds;
    final filtered = _filteredOptions()
        .where((option) => !selected.contains(option.id))
        .toList(growable: false);
    final canSelectMore = selected.length < widget.maxSelections;
    final resolvedHint =
        widget.hintText ?? S.of(context).mentionFieldHint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: EdgeInsetsDirectional.only(bottom: spacing?.xs ?? 4),
            child: Text(
              widget.label!,
              style: type?.titleMedium ?? theme.textTheme.titleMedium,
            ),
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            borderRadius: BorderRadius.circular(corners?.large ?? 16),
            border: Border.all(
              color: colors.outline.withValues(alpha: opacities.alphaMuted),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(spacing?.sm ?? 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  key: widget.inputKey,
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  decoration: InputDecoration(
                    hintText: resolvedHint,
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: _handleTextChanged,
                  maxLines: widget.maxLines,
                  onTapOutside: (_) => _focusNode.unfocus(),
                ),
                if (selected.isNotEmpty) ...[
                  SizedBox(height: spacing?.xs ?? 4),
                  Wrap(
                    spacing: spacing?.xs ?? 4,
                    runSpacing: spacing?.xs ?? 4,
                    children: selected
                        .map(
                          (id) => InputChip(
                            label: Text(_displayNameFor(id) ?? id),
                            onDeleted:
                                widget.enabled
                                    ? () => _removeSelection(id)
                                    : null,
                          ),
                        )
                        .toList(growable: false),
                  ),
                ],
                if (_shouldShowMenu() && filtered.isNotEmpty) ...[
                  SizedBox(height: spacing?.xs ?? 4),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 220),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      separatorBuilder:
                          (_, __) => SizedBox(height: spacing?.xxs ?? 2),
                      itemBuilder: (context, index) {
                        final option = filtered[index];
                        return ListTile(
                          dense: true,
                          leading: KinlyCircleAvatar(
                            avatarUrl: option.avatarUrl,
                            radius: 18,
                          ),
                          title: Text(
                            option.displayName,
                            style:
                                type?.bodyMedium ?? theme.textTheme.bodyMedium,
                          ),
                          onTap: () => _addSelection(option.id),
                        );
                      },
                    ),
                  ),
                ],
                if (widget.maxSelections > 1 && !canSelectMore)
                  Padding(
                    padding: EdgeInsets.only(top: spacing?.xs ?? 4),
                    child: Text(
                      'You can mention up to ${widget.maxSelections}.',
                      style: (type?.labelSmall ??
                              theme.textTheme.labelSmall ??
                              const TextStyle())
                          .copyWith(
                            color: colors.onSurface.withValues(
                              alpha: opacities.alphaFaint,
                            ),
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleTextChanged(String value) {
    setState(() {
      _query = _extractQuery(value);
    });
    widget.onTextChanged?.call(value);
  }

  bool _shouldShowMenu() {
    return widget.enabled &&
        widget.mentionsEnabled &&
        widget.mentionables.isNotEmpty &&
        _hasActiveTrigger &&
        widget.selectedIds.length < widget.maxSelections;
  }

  List<KinlyMentionOption> _filteredOptions() {
    final q = _query.toLowerCase();
    if (!_hasActiveTrigger) return const [];
    if (q.isEmpty) return widget.mentionables;
    return widget.mentionables
        .where(
          (option) =>
              option.displayName.toLowerCase().contains(q) ||
              option.id.toLowerCase().contains(q),
        )
        .toList(growable: false);
  }

  String _extractQuery(String text) {
    final lastAt = text.lastIndexOf('@');
    if (!widget.mentionsEnabled || lastAt == -1) {
      _hasActiveTrigger = false;
      return '';
    }
    final substring = text.substring(lastAt + 1);
    if (substring.contains(' ')) {
      _hasActiveTrigger = false;
      return '';
    }
    _hasActiveTrigger = true;
    return substring;
  }

  void _addSelection(String id) {
    if (widget.selectedIds.length >= widget.maxSelections) return;
    final next = {...widget.selectedIds, id};
    widget.onSelectedChanged(next);

    final text = _controller.text;
    final lastAt = text.lastIndexOf('@');
    if (lastAt != -1) {
      final newText = text.substring(0, lastAt);
      _controller.text = newText;
      _controller.selection = TextSelection.collapsed(offset: newText.length);
      widget.onTextChanged?.call(newText);
    }

    setState(() {
      _hasActiveTrigger = false;
      _query = '';
    });
  }

  void _removeSelection(String id) {
    final next = {...widget.selectedIds}..remove(id);
    widget.onSelectedChanged(next);
  }

  String? _displayNameFor(String id) {
    return widget.mentionables
        .firstWhere(
          (opt) => opt.id == id,
          orElse: () => KinlyMentionOption(id: id, displayName: id),
        )
        .displayName;
  }
}
