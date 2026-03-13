import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

/// Page 6 — Personal Stats
class Page6PersonalStats extends StatefulWidget {
  final Function(bool) onNextEnabled;
  final Function(String, dynamic) onDataUpdate;
  final Function(VoidCallback) registerNextCallback;
  final Function(bool) setLoading;
  final VoidCallback navigateNext;

  const Page6PersonalStats({
    super.key,
    required this.onNextEnabled,
    required this.onDataUpdate,
    required this.registerNextCallback,
    required this.setLoading,
    required this.navigateNext,
  });

  @override
  State<Page6PersonalStats> createState() => _Page6PersonalStatsState();
}

class _Page6PersonalStatsState extends State<Page6PersonalStats>
    with SingleTickerProviderStateMixin {
  final TextEditingController _ageCtrl = TextEditingController();
  final TextEditingController _heightCtrl = TextEditingController();

  int? _age;
  double? _height;
  String _heightUnit = 'Cm';
  String _weightUnit = 'KG';
  String? _activityLevel;
  String? _gender;

  final List<String> _activityOptions = [
    'Sedentary',
    'Lightly Active',
    'Moderately Active',
    'Very Active',
    'Extremely Active',
  ];

  final List<Map<String, dynamic>> _genderOptions = [
    {'id': 'male', 'label': 'Male', 'icon': Icons.male},
    {'id': 'female', 'label': 'Female', 'icon': Icons.female},
    {'id': 'other', 'label': 'Other', 'icon': Icons.person_outline},
  ];

  // ── Dropdown system
  final LayerLink _ageLink = LayerLink();
  final LayerLink _heightLink = LayerLink();
  final LayerLink _activityLink = LayerLink();

  OverlayEntry? _overlayEntry;
  LayerLink? _activeLink;
  bool _dropdownOpen = false;

  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  bool get _isFormValid =>
      _age != null &&
          _height != null &&
          _activityLevel != null &&
          _gender != null;

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
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _closeDropdown();
    super.dispose();
  }

  void _checkForm() => widget.onNextEnabled(_isFormValid);

  Future<void> _handleNext() async {
    if (!_isFormValid) return;

    // BMR calculation
    final double heightCm =
    _heightUnit == 'Cm' ? _height! : _height! * 30.48; // Ft → Cm
    double bmr = _gender == 'male'
        ? (10 * 70) + (6.25 * heightCm) - (5 * _age!) + 5
        : (10 * 70) + (6.25 * heightCm) - (5 * _age!) - 161;

    double mult = 1.2;
    switch (_activityLevel?.toLowerCase()) {
      case 'lightly active':
        mult = 1.375;
        break;
      case 'moderately active':
        mult = 1.55;
        break;
      case 'very active':
        mult = 1.725;
        break;
      case 'extremely active':
        mult = 1.9;
        break;
    }

    final int cals = (bmr * mult).round();

    widget.onDataUpdate('age', _age);
    widget.onDataUpdate('height', _height);
    widget.onDataUpdate('heightUnit', _heightUnit);
    widget.onDataUpdate('weightUnit', _weightUnit);
    widget.onDataUpdate('activityLevel', _activityLevel);
    widget.onDataUpdate('gender', _gender);
    widget.onDataUpdate('dailyCalories', cals);

    widget.navigateNext();
  }

  // ── Dropdown functions
  void _toggleDropdown(LayerLink link) {
    if (_dropdownOpen && _activeLink == link) {
      _closeDropdown();
    } else {
      _closeDropdown();
      _activeLink = link;
      _overlayEntry = _buildDropdownOverlay(link);
      Overlay.of(context).insert(_overlayEntry!);
      setState(() => _dropdownOpen = true);
    }
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _activeLink = null;
    if (mounted) {
      setState(() => _dropdownOpen = false);
    }
  }

  void _selectDropdownValue(String value) {
    setState(() {
      if (_activeLink == _heightLink) {
        _heightUnit = value;
      } else if (_activeLink == _ageLink) {
        _weightUnit = value;
      } else if (_activeLink == _activityLink) {
        _activityLevel = value;
        widget.onDataUpdate('activityLevel', value);
      }
    });

    _checkForm();
    _closeDropdown();
  }

  OverlayEntry _buildDropdownOverlay(LayerLink link) {
    List<String> items;
    String selectedValue;

    if (link == _heightLink) {
      items = ['Cm', 'Ft'];
      selectedValue = _heightUnit;
    } else if (link == _ageLink) {
      items = ['KG', 'LBS'];
      selectedValue = _weightUnit;
    } else {
      items = _activityOptions;
      selectedValue = _activityLevel ?? '';
    }

    return OverlayEntry(
      builder: (_) => GestureDetector(
        onTap: _closeDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.transparent)),
            CompositedTransformFollower(
              link: link,
              showWhenUnlinked: false,
              followerAnchor: Alignment.topRight,
              targetAnchor: Alignment.bottomRight,
              offset: const Offset(0, 4),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: link == _activityLink ? 90.w : 35.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: items.map((item) {
                      final bool selected = selectedValue == item;

                      return GestureDetector(
                        onTap: () => _selectDropdownValue(item),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.4.h,
                          ),
                          color: selected
                              ? const Color(0xFFE8F5E9)
                              : Colors.white,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: selected
                                        ? const Color(0xFF2E7D32)
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              if (selected)
                                const Icon(
                                  Icons.check,
                                  color: Color(0xFF2E7D32),
                                  size: 16,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required LayerLink link,
    required TextEditingController ctrl,
    required String hint,
    required String unit,
    required Function(String) onChanged,
  }) {
    final bool isOpen = _dropdownOpen && _activeLink == link;

    return CompositedTransformTarget(
      link: link,
      child: SizedBox(
        height: 45,
        width: double.infinity,
        child: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[400],
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            suffixIcon: GestureDetector(
              onTap: () => _toggleDropdown(link),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 7),
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      unit,
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                    SizedBox(width: 1.w),
                    AnimatedRotation(
                      turns: isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF2E7D32),
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _activityDropdownField() {
    final bool isOpen = _dropdownOpen && _activeLink == _activityLink;

    return CompositedTransformTarget(
      link: _activityLink,
      child: GestureDetector(
        onTap: () => _toggleDropdown(_activityLink),
        child: Container(
          height: 45,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _activityLevel ?? 'Activity Level',
                style: GoogleFonts.poppins(
                  fontSize: 8.3.sp,
                  color: _activityLevel != null
                      ? Colors.black87
                      : const Color(0xFF2E7D32),
                  fontWeight: FontWeight.w500,
                ),
              ),
              AnimatedRotation(
                turns: isOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
              Text(
                'Tell Us About Yourself',
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'This will help us a lot to tailor a very well plan for you',
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 3.h),

              // Age field
              _inputField(
                link: _ageLink,
                ctrl: _ageCtrl,
                hint: 'Age....',
                unit: _weightUnit,
                onChanged: (v) {
                  setState(() => _age = int.tryParse(v));
                  _checkForm();
                },
              ),
              SizedBox(height: 1.h),

              // Height field
              _inputField(
                link: _heightLink,
                ctrl: _heightCtrl,
                hint: 'Height....',
                unit: _heightUnit,
                onChanged: (v) {
                  setState(() => _height = double.tryParse(v));
                  _checkForm();
                },
              ),
              SizedBox(height: 1.h),

              // Activity Level dropdown
              _activityDropdownField(),
              SizedBox(height: 3.h),

              // Gender cards
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _genderOptions.length,
                  separatorBuilder: (_, __) => SizedBox(width: 3.w),
                  itemBuilder: (context, index) {
                    final g = _genderOptions[index];
                    final isSelected = _gender == g['id'];

                    return GestureDetector(
                      onTap: () {
                        setState(() => _gender = g['id']);
                        widget.onDataUpdate('gender', g['id']);
                        _checkForm();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 120,
                        width: 140,
                        padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE8F5E9)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2E7D32)
                                : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFC8E6C9)
                                    : Colors.grey[100],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                g['icon'] as IconData,
                                color: const Color(0xFF2E7D32),
                                size: 6.w,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              g['label'],
                              style: GoogleFonts.poppins(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              isSelected ? 'Selected' : 'Select',
                              style: GoogleFonts.poppins(
                                fontSize: 9.sp,
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
                  },
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}