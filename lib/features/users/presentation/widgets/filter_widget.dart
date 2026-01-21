import 'package:flutter/material.dart';
import '../user_controller.dart';

class FilterWidget extends StatelessWidget {
  final UsersFilter selected;
  final ValueChanged<UsersFilter> onChanged;

  const FilterWidget({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget chip(String text, UsersFilter value) {
      final isSelected = selected == value;

      return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: 14, 
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2E6AE6) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF2E6AE6) : Colors.black12,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                offset: const Offset(0, 2),
                color: Colors.black.withValues(alpha: 0.04),
              ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          chip('All', UsersFilter.all),
          const SizedBox(width: 8),
          chip('Active', UsersFilter.active),
          const SizedBox(width: 8),
          chip('Inactive', UsersFilter.inactive),
        ],
      ),
    );
  }
}
