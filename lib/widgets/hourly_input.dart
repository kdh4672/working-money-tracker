import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/income_provider.dart';

class HourlyInput extends StatefulWidget {
  const HourlyInput({super.key});

  @override
  State<HourlyInput> createState() => _HourlyInputState();
}

class _HourlyInputState extends State<HourlyInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<IncomeProvider>();
    if (provider.tracker.hourlyWage > 0) {
      _controller.text = provider.tracker.hourlyWage.round().toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IncomeProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '시급 (원)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF555555),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
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
                hintText: '예: 10000',
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
                final wage = double.tryParse(value) ?? 0;
                provider.setHourlyWage(wage);
              },
              onSubmitted: (value) {
                final error = provider.validateAndStart();
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}