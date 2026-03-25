import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Page3ChallengeIdentification extends StatefulWidget {
  final Function(bool) onNextEnabled;
  final Function(String, dynamic) onDataUpdate;
  final Function(VoidCallback) registerNextCallback;
  final Function(bool) setLoading;
  final VoidCallback navigateNext;

  const Page3ChallengeIdentification({
    super.key,
    required this.onNextEnabled,
    required this.onDataUpdate,
    required this.registerNextCallback,
    required this.setLoading,
    required this.navigateNext,
  });

  @override
  State<Page3ChallengeIdentification> createState() =>
      _Page3ChallengeIdentificationState();
}

class _Page3ChallengeIdentificationState
    extends State<Page3ChallengeIdentification>
    with SingleTickerProviderStateMixin {
  int? _selectedIndex;

  final List<Map<String, dynamic>> _challenges = [
    {
      'id': 'poor_portion',
      'title': 'Lack for portion control',
      'sub': 'Difficulty managing serving sizes',
      'image': 'assets/images/Vector1.png',
    },
    {
      'id': 'unhealthy',
      'title': 'Unhealthy eating habits',
      'sub': 'Consuming processed or junk foods regularly',
      'image': 'assets/images/Vector2.png',
    },
    {
      'id': 'low_activity',
      'title': 'Lack of physical activities',
      'sub': 'sedentary lifestyle with minimal exercise',
      'image': 'assets/images/Vector3.png',
    },
    {
      'id': 'poor_portion',
      'title': 'Nature of my job and daily schedules',
      'sub': 'Busy schedule affecting meal planning',
      'image': 'assets/images/Vector1.png',
    },
    {
      'id': 'unhealthy',
      'title': 'Lack of consistency',
      'sub': 'Frequent junk or processed food',
      'image': 'assets/images/Vector2.png',
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

  void _select(int index) {
    setState(() => _selectedIndex = index);
    widget.onDataUpdate('challenge', _challenges[index]['id']);
    widget.onNextEnabled(true);
  }

  Future<void> _handleNext() async {
    if (_selectedIndex == null) return;
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
                "What's the biggest challenge\nyou have in reaching your\ngoal?",
                style: TextStyle(
                  fontSize: 19.sp,
                  fontFamily: "Poppin",
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),

              SizedBox(height: 1.h),

              // Subtitle
              Text(
                'Select the challenge that resonates most with you',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: "Poppin",
                  color: Colors.grey[600],
                ),
              ),

              SizedBox(height: 3.h),

              // Challenge Cards
              ...List.generate(_challenges.length, (i) {
                final c = _challenges[i];
                final isSelected = _selectedIndex == i;
                return Padding(
                  padding: EdgeInsets.only(bottom: 1.5.h),
                  child: GestureDetector(
                    onTap: () => _select(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.1.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2E7D32)
                              : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            c['image'],
                            width: 6.w,
                            height: 7.w,
                            fit: BoxFit.contain,
                          ),

                          SizedBox(width: 3.w),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Card title
                                Text(
                                  c['title'],
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: "Poppin",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                // Card subtitle
                                Text(
                                  c['sub'],
                                  style: TextStyle(
                                    fontSize: 8.4.sp,
                                    fontFamily: "Poppin",
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Selection circle
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 5.2.w,
                            height: 5.2.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? const Color(0xFF2E7D32)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF2E7D32)
                                    : Colors.grey[400]!,
                                width: 1.5,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}