// lib/widgets/drop_down.dart

import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/app-colors.dart';

class Dropdown extends StatefulWidget {
  final List<String> languages;
  final Function(String?)? onChanged;
  final String? value;

  const Dropdown({
    super.key,
    required this.languages,
    this.onChanged,
    this.value,
  });

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: DropdownButtonFormField<String>(
        value: widget.value,
        hint: const Text('All Languages'),
        isExpanded: true,

        // Build dropdown items
        items: widget.languages.map((lang) {
          return DropdownMenuItem<String>(
            value: lang,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(lang),
            ),
          );
        }).toList(),

        // Always enabled
        onChanged: widget.onChanged,

        // Static arrow icon (no loader)
        icon: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(
              height: 24,
              child: VerticalDivider(thickness: 1, color: AppColors.greylight),
            ),
            SizedBox(width: 8),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),

        // Input decoration
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.greylight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
