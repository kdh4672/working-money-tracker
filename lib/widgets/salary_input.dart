import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/income_provider.dart';

class SalaryInput extends StatefulWidget {
  const SalaryInput({super.key});

  @override
  State<SalaryInput> createState() => _SalaryInputState();
}

class _SalaryInputState extends State<SalaryInput> {
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<IncomeProvider>();
    
    if (provider.tracker.monthlySalary > 0) {
      _salaryController.text = provider.tracker.monthlySalary.round().toString();
    }
    _hoursController.text = provider.tracker.monthlyHours.round().toString();
  }

  @override
  void dispose() {
    _salaryController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IncomeProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 월급 입력
            const Text(
              '월급 실수령액 (만원)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF555555),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _salaryController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: '예: 250',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF667EEA),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                final salary = double.tryParse(value) ?? 0;
                provider.setMonthlySalary(salary);
              },
            ),
            const SizedBox(height: 5),
            Text(
              '만원 단위로 입력해주세요 (예: 250만원)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            
            // 월 근무시간 입력
            const Text(
              '월 근무시간 (시간)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF555555),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _hoursController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: '176',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF667EEA),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                final hours = double.tryParse(value) ?? 176;
                provider.setMonthlyHours(hours);
              },
            ),
            const SizedBox(height: 5),
            Text(
              '기본: 월 22일 × 8시간 = 176시간',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            
            // 계산된 시급 표시
            if (provider.tracker.monthlySalary > 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE3F2FD), Color(0xFFF0F7FF)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2196F3), width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      '계산된 시급',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.formatCurrency(provider.tracker.calculatedHourlyWage),
                      style: const TextStyle(
                        fontSize: 24,
                        color: Color(0xFF0D47A1),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}