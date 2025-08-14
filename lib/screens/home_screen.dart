import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import '../providers/income_provider.dart';
import '../models/income_tracker.dart';
import '../widgets/input_mode_toggle.dart';
import '../widgets/hourly_input.dart';
import '../widgets/salary_input.dart';
import '../widgets/work_time_section.dart';
import '../widgets/income_display.dart';
import '../widgets/control_buttons.dart';
import '../widgets/stats_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 앱 시작 시 화면이 꺼지지 않도록 설정
    Wakelock.enable();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IncomeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: provider.isWidgetMode
              ? _buildWidgetModeContent(provider)
              : _buildNormalModeContent(provider),
        );
      },
    );
  }

  Widget _buildNormalModeContent(IncomeProvider provider) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3C72), Color(0xFF2A5298), Color(0xFF667EEA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(45),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.98),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 25,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 제목
                    const Text(
                      '⚡ 워킹 머니 트래커',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A365D),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '지금 이 순간에도 당신은 돈을 벌고 있습니다',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    
                    // 입력 섹션
                    Column(
                      children: [
                        const InputModeToggle(),
                        const SizedBox(height: 20),
                        
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: provider.tracker.inputMode == InputMode.hourly
                              ? const HourlyInput()
                              : const SalaryInput(),
                        ),
                        const SizedBox(height: 20),
                        
                        const WorkTimeSection(),
                        const SizedBox(height: 20),
                        
                        const ControlButtons(),
                      ],
                    ),
                    const SizedBox(height: 30),
                    
                    // 수익 표시
                    const IncomeDisplay(),
                    
                    // 통계 섹션
                    const StatsSection(),
                    const SizedBox(height: 25),
                    
                    // 하단 정보
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF2A5298).withOpacity(0.08),
                            const Color(0xFF1A365D).withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2A5298).withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '💪 시간은 곧 돈! 당신의 노력이 숫자로 보여집니다',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () => provider.toggleWidgetMode(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                ),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF667EEA).withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Text(
                                '📱 위젯 모드',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetModeContent(IncomeProvider provider) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3C72), Color(0xFF2A5298), Color(0xFF667EEA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 나가기 버튼
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => provider.exitWidgetMode(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: const Text(
                      '× 일반 모드',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // 제목
              const Text(
                '⚡ 워킹 머니 트래커',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              const Text(
                '지금 이 순간에도 당신은 돈을 벌고 있습니다',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // 위젯 모드용 수익 표시
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(35),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: provider.tracker.isWorkFinished
                    ? _buildWidgetCelebrationContent(provider)
                    : _buildWidgetWorkingContent(provider),
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetWorkingContent(IncomeProvider provider) {
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
              fontSize: 42,
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

  Widget _buildWidgetCelebrationContent(IncomeProvider provider) {
    return Column(
      children: [
        const Text(
          '🎉',
          style: TextStyle(fontSize: 48),
        ),
        const SizedBox(height: 15),
        const Text(
          '오늘 하루 정말 고생하셨습니다!',
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
      ],
    );
  }
}