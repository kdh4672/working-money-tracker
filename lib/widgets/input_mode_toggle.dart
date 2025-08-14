import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/income_tracker.dart';
import '../providers/income_provider.dart';

class InputModeToggle extends StatelessWidget {
  const InputModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<IncomeProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                child: _buildModeButton(
                  context,
                  '시급 입력',
                  InputMode.hourly,
                  provider.tracker.inputMode == InputMode.hourly,
                  () => provider.setInputMode(InputMode.hourly),
                ),
              ),
              Expanded(
                child: _buildModeButton(
                  context,
                  '월급 입력',
                  InputMode.salary,
                  provider.tracker.inputMode == InputMode.salary,
                  () => provider.setInputMode(InputMode.salary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModeButton(
    BuildContext context,
    String text,
    InputMode mode,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF2A5298).withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? const Color(0xFF2A5298) : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}