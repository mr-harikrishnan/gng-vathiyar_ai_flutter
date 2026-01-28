// lib/widgets/search_bar_widget.dart

import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String)? onChanged;
  final bool loading;

  const SearchBarWidget({
    super.key,
    this.onChanged,
    this.loading = false,
  });

  @override
  State<SearchBarWidget> createState() =>
      _SearchBarWidgetState();
}

class _SearchBarWidgetState
    extends State<SearchBarWidget> {
  final TextEditingController _controller =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    // Runs for every letter
    _controller.addListener(() {
      if (widget.onChanged != null) {
        widget.onChanged!(
          _controller.text,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: "Search",
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(8),
          borderSide:
              const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(8),
          borderSide:
              const BorderSide(
            color: Color(0xFF009688),
            width: 2,
          ),
        ),

        // Icon before text
        prefixIcon: widget.loading
            ? Container(
                width: 20,
                height: 20,
                margin:
                    const EdgeInsets.only(
                  left: 12,
                  right: 8,
                ),
                child:
                    const CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Icon(
                Icons.search,
              ),
      ),
    );
  }
}
