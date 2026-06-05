import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;
  final VoidCallback onBegin;
  final VoidCallback onSignIn;

  const OnboardingScreen({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.onBegin,
    required this.onSignIn,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF131D24) : Colors.transparent,
          body: MaestronesiaBackground(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    // Title Area
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Expertise,\nSimplified.',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Connect with world-class experts for real-time guidance and professional consultation.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Role Selection
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SELECT YOUR ROLE',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildRoleCard(
                                roleName: 'client',
                                label: 'Client',
                                icon: Icons.person_outline,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildRoleCard(
                                roleName: 'expert',
                                label: 'Expert',
                                icon: Icons.workspace_premium_outlined,
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Action Buttons
                    Column(
                      children: [
                        if (widget.selectedRole != 'client' && widget.selectedRole != 'expert')
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1.5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'BEGIN JOURNEY',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.0,
                              ),
                            ),
                          )
                        else
                          MaestronesiaButton(
                            onPressed: widget.onBegin,
                            isSelected: !isDark,
                            child: const Text(
                              'BEGIN JOURNEY',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already a member? ',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            GestureDetector(
                              onTap: widget.onSignIn,
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppColors.gold,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                padding: const EdgeInsets.only(bottom: 2),
                                child: const Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleCard({
    required String roleName,
    required String label,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = widget.selectedRole == roleName;
    return GestureDetector(
      onTap: () => widget.onRoleChanged(roleName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: isDark
              ? (isSelected ? AppColors.gold.withOpacity(0.05) : AppColors.surface)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark
                ? (isSelected ? AppColors.gold : Colors.white.withOpacity(0.05))
                : Colors.white.withOpacity(0.05),
            width: isDark ? 2.0 : 1.0,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: isSelected ? AppColors.gold : AppColors.textSecondary,
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 12,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: AppColors.gold, width: 2)
                      : Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                ),
                child: isSelected
                    ? Container(
                        margin: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
