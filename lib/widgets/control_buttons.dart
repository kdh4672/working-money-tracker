import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/income_provider.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<IncomeProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              text: '시작',
              color: const LinearGradient(
                colors: [Color(0xFF48BB78), Color(0xFF38A169)],
              ),
              enabled: !provider.tracker.isRunning,
              onPressed: () {
                final error = provider.validateAndStart();
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error),
                      backgroundColor: Colors.red[400],
                    ),
                  );
                }
              },
            ),
            const SizedBox(width: 10),
            _buildButton(
              text: '정지',
              color: const LinearGradient(
                colors: [Color(0xFFE53E3E), Color(0xFFC53030)],
              ),
              enabled: provider.tracker.isRunning,
              onPressed: () => provider.stop(),
            ),
            const SizedBox(width: 10),
            _buildButton(
              text: '리셋',
              color: const LinearGradient(
                colors: [Color(0xFFED8936), Color(0xFFDD6B20)],
              ),
              enabled: true,
              onPressed: () => provider.reset(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButton({
    required String text,
    required LinearGradient color,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          gradient: enabled ? color : null,
          color: enabled ? null : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: enabled ? Colors.white : Colors.grey[600],
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}