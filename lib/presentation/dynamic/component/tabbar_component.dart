import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';

tabBarComponent({required DynamicWidgetData data}) {
  final props = data.properties;

  // TAB TITLES
  final List<String> tabs =
      (props['tabs'] as List?)?.map((e) => e.toString()).toList() ?? [];

  // CHILDREN (ONE PAGE PER TAB)
  final List<DynamicWidgetData> children = (data.children)
      .cast<DynamicWidgetData>();

  // Ensure we don't overflow if tabs != children
  final int pageCount = tabs.isEmpty
      ? children.length
      : (tabs.length < children.length ? tabs.length : children.length);

  if (pageCount == 0) {
    return const SizedBox.shrink();
  }

  // BASIC PROPS
  final bool isScrollable = props['isScrollable'] ?? (tabs.length > 3);
  final bool useExpanded = props['isExpanded'] ?? true; // auto height
  final double tabViewHeight =
      (props['tabViewHeight'] as num?)?.toDouble() ?? 20.0;

  final Color? labelColor = props['labelColor'];
  final Color? unselectedLabelColor = props['unselectedLabelColor'];
  Color? indicatorColor = props['indicatorColor'];

  // CUSTOM INDICATOR STYLE
  // indicatorStyle: 'line' (default) | 'box'
  final String indicatorStyle = props['indicatorStyle'] ?? 'line';
  final double indicatorRadius =
      (props['indicatorRadius'] as num?)?.toDouble() ?? 999.0;
  final double indicatorWeight =
      (props['indicatorWeight'] as num?)?.toDouble() ?? 0.0;
  final String indicatorSizeStr = props['indicatorSize'] ?? 'tab';

  Decoration? indicatorDecoration;
  if (indicatorStyle == 'box') {
    indicatorDecoration = BoxDecoration(
      color: indicatorColor ?? Colors.blue,
      borderRadius: BorderRadius.circular(indicatorRadius - 3),
    );
    // When using decoration, TabBar ignores indicatorColor, so we null it out.
    indicatorColor = null;
  }

  final TabBarIndicatorSize indicatorSize = indicatorSizeStr == 'label'
      ? TabBarIndicatorSize.label
      : TabBarIndicatorSize.tab;

  final int initialIndex = (props['initialIndex'] ?? 0);
  final int safeInitialIndex = initialIndex.clamp(
    0,
    pageCount - 1,
  ); // avoid crash

  final tabBar = Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(indicatorRadius),
      color: props['backgroundColor'] ?? Colors.transparent,
      border: Border.all(color: props['indicatorColor']),
    ),
    child: TabBar(
      isScrollable: isScrollable,
      labelColor: labelColor ?? Colors.blue,
      unselectedLabelColor: unselectedLabelColor ?? Colors.grey,
      indicatorColor: indicatorColor,
      indicator: indicatorDecoration,
      splashBorderRadius: BorderRadius.circular(indicatorRadius - 3),
      indicatorPadding: EdgeInsets.all(props['indicatorPadding'] ?? 2),
      dividerColor: indicatorStyle == 'box'
          ? Colors.transparent
          : indicatorColor,
      indicatorWeight: indicatorWeight,
      indicatorSize: indicatorSize,
      tabs: List<Widget>.generate(
        pageCount,
        (index) =>
            Tab(text: index < tabs.length ? tabs[index] : 'Tab ${index + 1}'),
      ),
    ),
  );

  final tabBarView = TabBarView(
    children: List<Widget>.generate(pageCount, (index) {
      final childData = children[index];
      return DynamicWidgetFactory.createWidget(childData);
    }),
  );

  // AUTO HEIGHT HANDLING:
  // - useExpanded = true  -> Expanded(TabBarView) (full available height)
  // - useExpanded = false -> fixed height = tabViewHeight (for Scroll/Nested)
  final Widget body = useExpanded
      ? Expanded(child: tabBarView)
      : SizedBox(height: tabViewHeight, child: tabBarView);

  return DefaultTabController(
    length: pageCount,
    initialIndex: safeInitialIndex,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [tabBar, body],
    ),
  );
}
