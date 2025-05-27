import 'package:flutter/material.dart';

enum NavigationDisplayMode { iconsAndLabels, iconsOnly, labelsOnly }

class NavigationRailCustomSections extends StatefulWidget {
  final List<IconData> icons;
  final List<String> labels;
  final List<Widget> screens;
  final int initialIndex;
  final NavigationDisplayMode displayMode;

  NavigationRailCustomSections({
    required this.icons,
    required this.labels,
    required this.screens,
    this.initialIndex = 0,
    this.displayMode = NavigationDisplayMode.iconsAndLabels,
  }) : assert(
         icons.length == labels.length && labels.length == screens.length,
         "Icons, labels, and screens lists must have the same length.",
       );

  @override
  _NavigationRailCustomState createState() => _NavigationRailCustomState();
}

class _NavigationRailCustomState extends State<NavigationRailCustomSections> {
  late int selectedIndex;
  late List<bool> isHovered;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    isHovered = List.filled(widget.icons.length, false);
  }

  double getNavRailWidth() {
    double longestLabelWidth =
        widget.labels.fold(0.0, (double maxWidth, label) {
          final width = label.length * 8.0;
          return width > maxWidth ? width : maxWidth;
        }) +
        40;

    switch (widget.displayMode) {
      case NavigationDisplayMode.iconsAndLabels:
        return longestLabelWidth + 50;
      case NavigationDisplayMode.labelsOnly:
        return longestLabelWidth;
      case NavigationDisplayMode.iconsOnly:
        return 70;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        // Navigation rail section
        Container(
          color: Colors.transparent,
          width: getNavRailWidth(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < widget.icons.length; i++)
                MouseRegion(
                  onEnter: (_) => setState(() => isHovered[i] = true),
                  onExit: (_) => setState(() => isHovered[i] = false),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => selectedIndex = i);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isHovered[i]
                                ? Colors.grey.withOpacity(0.1)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (widget.displayMode !=
                              NavigationDisplayMode.labelsOnly)
                            Icon(
                              widget.icons[i],
                              color:
                                  selectedIndex == i
                                      ? Theme.of(context).colorScheme.primary
                                      : const Color.fromARGB(41, 32, 32, 32),
                              size: 24,
                            ),
                          if (widget.displayMode ==
                              NavigationDisplayMode.iconsAndLabels)
                            SizedBox(width: 15),
                          if (widget.displayMode !=
                              NavigationDisplayMode.iconsOnly)
                            Text(
                              widget.labels[i],
                              style: TextStyle(
                                color:
                                    selectedIndex == i
                                        ? Theme.of(context).colorScheme.primary
                                        : const Color.fromARGB(255, 32, 32, 32),
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              Spacer(),
            ],
          ),
        ),

        // Content section (✅ fixed)
        Flexible(fit: FlexFit.tight, child: widget.screens[selectedIndex]),
      ],
    );
  }
}
