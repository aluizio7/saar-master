import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthYearPicker extends StatefulWidget {
  final Function(DateTime) onMonthYearSelected;

  MonthYearPicker({
    required this.onMonthYearSelected,
  });

  @override
  _MonthYearPickerState createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<MonthYearPicker> {
  DateTime selectedDate = DateTime.now();

  Future<void> _showMonthYearPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.green, // Cor do botão "Confirmar"
            hintColor: Colors.green, // Cor do botão "Cancel"
            colorScheme: ColorScheme.light(primary: Colors.green),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.onMonthYearSelected(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showMonthYearPicker(context);
      },
      child: Row(
        children: [
          Text(
            DateFormat('MMMM yyyy').format(selectedDate),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.calendar_today),
        ],
      ),
    );
  }
}