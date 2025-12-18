import 'package:flutter/material.dart';
import '../../../app/helpers/icon_list.dart'; // Import helpers

class IconSelectionComponent extends StatelessWidget {
  final void Function(String iconKey) onIconSelected;

  const IconSelectionComponent({super.key, required this.onIconSelected});

  List<IconData> get _iconDataList => allMaterialIcons.values.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select an Icon')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: _iconDataList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (context, index) {
            final iconData = _iconDataList[index];
            return InkWell(
              onTap: () {
                final iconKey = iconDataToKey(iconData);
                onIconSelected(iconKey);
                Navigator.pop(context);
              },
              child: Card(
                elevation: 2.0,
                child: Center(
                  child: Icon(
                    iconData,
                    size: 30.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}