import 'package:flutter/material.dart';

class OrderStatusFilterBar extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onStatusSelected;

  const OrderStatusFilterBar({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = ['pending', 'shipped', 'delivered', 'cancelled'];
    final labels = ['Processing', 'Shipped', 'Delivered', 'Cancelled'];

    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final status = statuses[index];
          final label = labels[index];
          final isSelected = selectedStatus == status;

          return GestureDetector(
            onTap: () => onStatusSelected(status),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
