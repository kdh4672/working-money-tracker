import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/income_provider.dart';

class IncomeDisplay extends StatelessWidget {
  const IncomeDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<IncomeProvider>(
      builder: (context, provider, child) {
        if (!provider.tracker.isRunning) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(35),
          margin: const EdgeInsets.only(bottom: 30),
          decoration: BoxDecoration(
            gradient: provider.tracker.isWorkFinished
                ? const LinearGradient(
                    colors: [
                      Color(0xFF8B5CF6),
                      Color(0xFF7C3AED),
                      Color(0xFF6D28D9)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [
                      Color(0xFF00B4DB),
                      Color(0xFF0083B0),
                      Color(0xFF005A8A)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: provider.tracker.isWorkFinished
                    ? const Color(0xFF8B5CF6).withOpacity(0.4)
                    : const Color(0xFF00B4DB).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: provider.tracker.isWorkFinished
              ? _buildCelebrationContent(provider)
              : _buildWorkingContent(provider),
        );
      },
    );
  }

  Widget _buildWorkingContent(IncomeProvider provider) {
    return Column(
      children: [
        const Text(
          '지금까지 번 돈',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          child: Text(
            provider.formatCurrency(provider.tracker.totalEarned),
            key: ValueKey(provider.tracker.totalEarned.round()),
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '매 초마다 ${provider.formatCurrency(provider.tracker.perSecondIncome)}씩 벌고 있어요! 🔥',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCelebrationContent(IncomeProvider provider) {
    return Column(
      children: [
        const Text(
          '🎉',
          style: TextStyle(fontSize: 48),
        ),
        const SizedBox(height: 15),
        const Text(
          '오늘 하루 정말\n고생하셨습니다!',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        Text(
          '오늘 총 ${provider.formatCurrency(provider.tracker.totalEarned)}을 버셨어요!',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        const Text(
          '💪 내일도 화이팅!\n좋은 하루 되세요',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
