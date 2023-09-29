import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchByLink extends StatefulWidget {
  const SearchByLink({super.key});

  @override
  State<SearchByLink> createState() => _SearchByLinkState();
}

class _SearchByLinkState extends State<SearchByLink> {
  TextEditingController controller = TextEditingController();

  void copyFromClicpBoard() async {
    controller.text = (await Clipboard.getData("text/plain"))!.text!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cerca per link'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width - 20,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: controller,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: copyFromClicpBoard,
          child: const Text('Copia dalla clipboard'),
        ),
        TextButton(
          child: const Text('Cerca'),
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
        ),
      ],
    );
  }
}
