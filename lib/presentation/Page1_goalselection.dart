import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../services/auth_service.dart';

class Page1GoalSelection extends StatefulWidget {
  final Function(bool) onNextEnabled;
  final Function(String, dynamic) onDataUpdate;
  final Function(VoidCallback) registerNextCallback;
  final Function(bool) setLoading;
  final VoidCallback navigateNext;

  const Page1GoalSelection({
    super.key,
    required this.onNextEnabled,
    required this.onDataUpdate,
    required this.registerNextCallback,
    required this.setLoading,
    required this.navigateNext,
  });

  @override
  State<Page1GoalSelection> createState() => _Page1GoalSelectionState();
}

class _Page1GoalSelectionState extends State<Page1GoalSelection>
    with SingleTickerProviderStateMixin {
  String? _selectedGoal;

  final List<Map<String, dynamic>> _goalOptions = const [
    {
      'id': 'lose_weight',
      'title': 'Lose Weight',
      'icon': Icons.trending_down_rounded,
    },
    {
      'id': 'maintain_weight',
      'title': 'Maintain Weight',
      'icon': Icons.balance_rounded,
    },
    {
      'id': 'gain_weight',
      'title': 'Gain Weight',
      'icon': Icons.trending_up_rounded,
    },
  ];

  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fade = CurvedAnimation(
      parent: _anim,
      curve: Curves.easeOut,
    ).drive(Tween(begin: 0.0, end: 1.0));

    _slide = CurvedAnimation(
      parent: _anim,
      curve: Curves.easeOut,
    ).drive(Tween(begin: const Offset(0, 0.06), end: Offset.zero));

    widget.registerNextCallback(_handleNext);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _anim.forward();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _selectGoal(String id) {
    setState(() => _selectedGoal = id);
    widget.onDataUpdate('fitnessGoal', id);
    widget.onNextEnabled(true);
  }

  Future<void> _handleNext() async {
    if (_selectedGoal == null) return;

    widget.setLoading(true);

    try {
      final user = AuthService.instance.currentUser;
      if (user != null) {
        await AuthService.instance.updateUserProfile(
          userId: user.id,
          fitnessGoal: _selectedGoal,
        );
      }
    } catch (e) {
      debugPrint('Page1GoalSelection Error: $e');
    } finally {
      widget.setLoading(false);
    }

    widget.navigateNext();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.5.w, vertical: 1.5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What goals do you want to\nachieve?',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontFamily: 'semibold',
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.28,
                ),
              ),

              SizedBox(height: 1.3.h),

              Text(
                'This helps Naijafit to generate a plan for your calorie intake',
                style: TextStyle(
                  fontSize: 11.7.sp,
                  fontFamily: 'regular',
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6E6E6E),
                  height: 1.55,
                ),
              ),

              SizedBox(height: 3.2.h),

              ..._goalOptions.map((goal) {
                final bool isSelected = _selectedGoal == goal['id'];

                return Padding(
                  padding: EdgeInsets.only(bottom: 2.1.h),
                  child: GestureDetector(
                    onTap: () => _selectGoal(goal['id']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.3.w,
                        vertical: 2.3.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFEAF3E6)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(6.w),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xff47A312)
                              : const Color(0xFFD2D2D2),
                          width: isSelected ? 1.5 : 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 13.w,
                            height: 13.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDCE8D5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              goal['icon'] as IconData,
                              size: 6.w,
                              color: isSelected
                                  ? const Color(0xFF0B7A22)
                                  : Colors.black,
                            ),
                          ),

                          SizedBox(width: 4.5.w),

                          Expanded(
                            child: Text(
                              goal['title'],
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontFamily: 'medium',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          Text(
                            isSelected ? 'Selected' : 'Select',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'medium',
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: const Color(0xff47A312),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
