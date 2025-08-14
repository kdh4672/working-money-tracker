import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/income_provider.dart';

class WorkTimeSection extends StatelessWidget {
  const WorkTimeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<IncomeProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTimeInput(
                      context,
                      '출근 시간',
                      provider.tracker.workStartTime != null
                          ? TimeOfDay.fromDateTime(provider.tracker.workStartTime!)
                          : const TimeOfDay(hour: 9, minute: 0),
                      (time) => provider.setWorkStartTime(time),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildTimeInput(
                      context,
                      '퇴근 시간',
                      provider.tracker.workEndTime != null
                          ? TimeOfDay.fromDateTime(provider.tracker.workEndTime!)
                          : const TimeOfDay(hour: 18, minute: 0),
                      (time) => provider.setWorkEndTime(time),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '출근 시간부터 현재까지의 누적 수익을 계산합니다',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeInput(
    BuildContext context,
    String label,
    TimeOfDay initialTime,
    Function(TimeOfDay) onTimeChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: initialTime,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF667EEA),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (time != null) {
              onTimeChanged(time);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              initialTime.format(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF495057),
              ),
            ),
          ),
        ),
      ],
    );
  }
}