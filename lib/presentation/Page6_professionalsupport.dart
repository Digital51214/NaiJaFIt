import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../services/auth_service.dart';

class Page5ProfessionalSupport extends StatefulWidget {
  final Function(bool) onNextEnabled;
  final Function(String, dynamic) onDataUpdate;
  final Function(VoidCallback) registerNextCallback;
  final Function(bool) setLoading;
  final VoidCallback navigateNext;

  const Page5ProfessionalSupport({
    super.key,
    required this.onNextEnabled,
    required this.onDataUpdate,
    required this.registerNextCallback,
    required this.setLoading,
    required this.navigateNext,
  });

  @override
  State<Page5ProfessionalSupport> createState() =>
      _Page5ProfessionalSupportState();
}

class _Page5ProfessionalSupportState extends State<Page5ProfessionalSupport>
    with SingleTickerProviderStateMixin {
  String? _selectedOption;

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

  void _select(String value) {
    setState(() => _selectedOption = value);
    widget.onDataUpdate('professionalSupport', value);
    widget.onNextEnabled(true);
  }

  Future<void> _handleNext() async {
    if (_selectedOption == null) return;
    widget.setLoading(true);
    final user = AuthService.instance.currentUser;
    if (user != null) {
      try {
        await AuthService.instance.updateUserProfile(userId: user.id);
      } catch (e) {
        debugPrint('Page5 API error: $e');
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
                'Do you currently work with a\ndiet coach or nutritionist?',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),

              SizedBox(height: 1.h),

              // Subtitle
              Text(
                'This helps NaijaFit complement rather than replace professional guidance',
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontFamily: "Poppins",
                  color: Colors.grey[600],
                ),
              ),

              SizedBox(height: 3.h),

              _optionCard(
                'yes',
                'Yes',
                'I work with a professional',
                Icons.check,
                Colors.green,
              ),

              SizedBox(height: 1.h),

              _optionCard(
                'no',
                'No',
                "I don't currently work with anyone",
                Icons.close,
                Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionCard(
      String value,
      String title,
      String sub,
      IconData icon,
      Color iconColor,
      ) {
    final isSelected = _selectedOption == value;
    return GestureDetector(
      onTap: () => _select(value),
      child: AnimatedContainer(
        height: 70,
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 6.w),

            SizedBox(width: 3.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Card subtitle
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontFamily: "Poppins",
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            // Selection circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFF2E7D32)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2E7D32)
                      : Colors.black,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}