// lib/widgets/horizontal_tab_bar.dart
import 'package:flutter/material.dart';

// Custom scroll tab widget like your image
class HorizontalTabBar extends StatefulWidget {
  final List<String> tabs;
  final ValueChanged<int> onChanged;

  const HorizontalTabBar({
    super.key,
    required this.tabs,
    required this.onChanged,
  });

  @override
  State<HorizontalTabBar> createState() => _HorizontalTabBarState();
}

class _HorizontalTabBarState extends State<HorizontalTabBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Horizontal scroll
        itemCount: widget.tabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index; // Update selected tab
              });
              widget.onChanged(index); // Send value to parent
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? Colors.teal // Active line color
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                widget.tabs[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.teal : Colors.black54,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
