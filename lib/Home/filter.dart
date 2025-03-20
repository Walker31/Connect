import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Filters",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade900,
            ),
          ),
          const SizedBox(height: 16),

          // Age Range Filter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Age Range"),
              DropdownButton<int>(
                value: 18,
                items: List.generate(10, (index) => 18 + index)
                    .map((age) => DropdownMenuItem(
                          value: age,
                          child: Text(age.toString()),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Location Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Show Nearby"),
              Switch(
                  value: toggle,
                  onChanged: (val) {
                    setState(() {
                      toggle = val;
                    });
                  }),
            ],
          ),
          const SizedBox(height: 20),

          // Apply Filters Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Apply Filters",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

// Function to show bottom sheet
void showFilterBottomSheet(BuildContext context, VoidCallback onApply) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return const FilterWidget();
    },
  );
}
