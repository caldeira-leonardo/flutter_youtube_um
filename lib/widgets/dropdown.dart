import 'package:flutter/material.dart';

class Dropdown extends StatelessWidget {
  final List<String> items;
  final dropValue = ValueNotifier('');

  Dropdown({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dropValue,
      builder: (BuildContext context, String value, _) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            icon: const Icon(Icons.drive_eta),
            hint: const Text('Escolha a marca'),
            decoration: InputDecoration(
              label: const Text('Label'),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
            value: (value.isEmpty) ? null : value,
            onChanged: (escolha) => dropValue.value = escolha.toString(),
            items: items
                .map((op) => DropdownMenuItem(
                      value: op,
                      child: Text(op),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}
