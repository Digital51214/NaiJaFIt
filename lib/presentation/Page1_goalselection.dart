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

  final List<Map<String, dynamic>> _goalOptions = [
    {'id': 'lose_weight',     'title': 'Lose Weight',     'icon': Icons.trending_down},
    {'id': 'maintain_weight', 'title': 'Maintain Weight', 'icon': Icons.balance},
    {'id': 'gain_weight',     'title': 'Gain Weight',     'icon': Icons.trending_up},
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
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
        .drive(Tween(begin: 0.0, end: 1.0));
    _slide = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
        .drive(Tween(begin: const Offset(0, 0.08), end: Offset.zero));

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
    final user = AuthService.instance.currentUser;
    if (user != null) {
      try {
        await AuthService.instance.updateUserProfile(
          userId: user.id,
          fitnessGoal: _selectedGoal,
        );
      } catch (e) {
        debugPrint('Page1 API error: $e');
      }
    }
    widget.setLoading(false);
    widget.navigateNext();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'What Goals Do you want to\nachieve?',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: "Poppin",
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),

              SizedBox(height: 1.h),

              // Subtitle
              Text(
                'This Helps Naijafit top generate a plan for your calorie intake',
                style: TextStyle(
                  fontSize: 11.3.sp,
                  fontFamily: "Poppin",
                  color: Colors.grey[600],
                ),
              ),

              SizedBox(height: 3.h),

              // Goal Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 4.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 1.28,
                children: _goalOptions.map((goal) {
                  final isSelected = _selectedGoal == goal['id'];
                  return GestureDetector(
                    onTap: () => _selectGoal(goal['id']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFE8F5E9).withOpacity(0.7)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF47A312)
                              : Colors.grey[300]!,
                          width: isSelected ? 1.2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 13.5.w,
                            height: 13.5.w,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFC8E6C9)
                                  : const Color(0xFFF5F5F5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              goal['icon'] as IconData,
                              color: isSelected
                                  ? const Color(0xFF2E7D32)
                                  : Colors.black,
                              size: 6.5.w,
                            ),
                          ),

                          SizedBox(height: 0.8.h),

                          // Goal title
                          Text(
                            goal['title'],
                            style: TextStyle(
                              fontSize: 11.7.sp,
                              fontFamily: "Poppin",
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),

                          SizedBox(height: 0.1.h),

                          // Selected / Select label
                          Text(
                            isSelected ? 'Selected' : 'Select',
                            style: TextStyle(
                              fontSize: 8.5.sp,
                              fontFamily: "Poppin",
                              color: isSelected
                                  ? const Color(0xFF2E7D32)
                                  : Colors.grey[500],
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}