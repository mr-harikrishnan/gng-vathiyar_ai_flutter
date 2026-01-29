import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final List<String> languages;
  final Function(String?)? onChanged;
  final bool loading;
  final String? value;

  const Dropdown(
      {super.key,
      required this.languages,
      this.onChanged,
      this.loading = false,
      this.value});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // This gives left and right gap to the FULL widget
      color: Colors.white,
      child: DropdownButtonFormField<String>(
        value: widget.value,
        hint: const Text('All Languages'),
        isExpanded: true, // Makes dropdown full width

        items: widget.languages.map((lang) {
          return DropdownMenuItem<String>(
            value: lang,
            child: Padding(
              // This gives left and right gap INSIDE dropdown list
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(lang),
            ),
          );
        }).toList(),

        onChanged: widget.loading ? null : widget.onChanged,

        icon: widget.loading
            ? Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(right: 12),
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(
                    height: 24,
                    child: VerticalDivider(thickness: 1, color: Colors.grey),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),

        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFF009688),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
