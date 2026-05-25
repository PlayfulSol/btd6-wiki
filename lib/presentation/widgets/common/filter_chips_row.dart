import 'package:flutter/material.dart';

class FilterChipsRow extends StatefulWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;
  final Color Function(BuildContext, String) colorForOption;

  const FilterChipsRow({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.colorForOption,
  });

  @override
  State<FilterChipsRow> createState() => _FilterChipsRowState();
}

class _FilterChipsRowState extends State<FilterChipsRow> {
  final _controller = ScrollController();
  bool _fadeLeft = false;
  bool _fadeRight = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    // Check after layout whether content overflows
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final pos = _controller.position;
    setState(() {
      _fadeLeft = pos.pixels > 0;
      _fadeRight = pos.pixels < pos.maxScrollExtent;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leftStop = _fadeLeft ? 0.12 : 0.0;
    final rightStop = _fadeRight ? 0.88 : 1.0;

    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: const [
          Colors.transparent,
          Colors.white,
          Colors.white,
          Colors.transparent,
        ],
        stops: [0.0, leftStop, rightStop, 1.0],
      ).createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: widget.options.map((option) {
            final isSelected = option == widget.selected;
            final color = widget.colorForOption(context, option);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (_) => widget.onSelect(option),
                selectedColor: color.withValues(alpha: 0.18),
                checkmarkColor: color,
                side: BorderSide(
                  color: isSelected
                      ? color
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
                labelStyle: TextStyle(
                  color: isSelected ? color : null,
                  fontWeight: isSelected ? FontWeight.w600 : null,
                ),
                showCheckmark: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
