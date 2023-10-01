import 'package:flutter/material.dart';
import 'package:youtube_download/Pages/HomePage.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(SearchType, String) onStartSearch;
  const CustomSearchBar({super.key, required this.onStartSearch});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  TextEditingController controller = TextEditingController();

  void _startSearch(String text) {
    widget.onStartSearch(SearchType.search, text);
  }

  Widget _getClearTextIcon() {
    if (controller.text.isEmpty) return const SizedBox.shrink();

    return IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        controller.clear();
        setState(() {});
      },
    );
  }

  Widget _getSearchIcon() {
    if (controller.text.isEmpty) return const SizedBox.shrink();
    return IconButton(
      onPressed: () => _startSearch(controller.text),
      icon: const Icon(Icons.search),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: (value) => setState(() {}),
            onSubmitted: (String text) => _startSearch(text),
            decoration: InputDecoration(
              suffixIcon: _getClearTextIcon(),
              hintText: "Cerca su youtube",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            ),
            cursorColor: Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
        _getSearchIcon(),
      ],
    );
  }
}
