import 'package:flutter/material.dart';
import 'package:genio_card/theme/ThemeHelper.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final T initialValue;
  final ValueChanged<T?>? onChanged;
  final String label;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.initialValue,
    this.onChanged,
    required this.label,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  late T selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 15,
              color: ThemeHelper.getSecondaryTextColor(context),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ThemeHelper.getCardColor(context),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                focusColor: ThemeHelper.getTextColor(context),
                value: selectedValue,
                items: widget.items.map((item) {
                  return DropdownMenuItem<T>(
                    value: item.value,
                    child: Text(
                      item.value.toString(),
                      style: TextStyle(
                        color: ThemeHelper.getTextColor(context),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedValue = value;
                    });
                    widget.onChanged?.call(value);
                  }
                },
                dropdownColor: ThemeHelper.getSquareCardColor(context),
                borderRadius: BorderRadius.circular(10),
                menuMaxHeight: 300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
