import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../services/auth_service.dart';

class Page2GoalSettingDetails extends StatefulWidget {
  final Function(bool) onNextEnabled;
  final Function(String, dynamic) onDataUpdate;
  final Function(VoidCallback) registerNextCallback;
  final Function(bool) setLoading;
  final VoidCallback navigateNext;

  const Page2GoalSettingDetails({
    super.key,
    required this.onNextEnabled,
    required this.onDataUpdate,
    required this.registerNextCallback,
    required this.setLoading,
    required this.navigateNext,
  });

  @override
  State<Page2GoalSettingDetails> createState() => _Page2GoalSettingDetailsState();
}

class _Page2GoalSettingDetailsState extends State<Page2GoalSettingDetails>
    with SingleTickerProviderStateMixin {
  final TextEditingController _currentWeightCtrl = TextEditingController();
  final TextEditingController _targetWeightCtrl  = TextEditingController();

  double? _currentWeight;
  double? _targetWeight;
  String? _selectedTimeline;
  String _currentWeightUnit = 'KG';
  String _targetWeightUnit  = 'KG';
  // ── dropdown state ──
  final LayerLink _layerLink1    = LayerLink();
  final LayerLink _layerLink2    = LayerLink();
  final LayerLink _timelineLink  = LayerLink();   // ✅ timeline ka link
  OverlayEntry?   _overlayEntry;
  bool            _dropdownOpen  = false;
  LayerLink?      _activeLink;

  bool _weeklyWeighIns      = true;
  bool _photoProgress       = false;
  bool _measurementTracking = false;

  final List<String> _timelineOptions = ['4 Weeks', '8 Weeks', '12 Weeks', '16 Weeks'];

  late final AnimationController _anim;
  late final Animation<double>   _fade;
  late final Animation<Offset>   _slide;

  bool get _isFormValid =>
      _currentWeight != null && _targetWeight != null && _selectedTimeline != null;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade  = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
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
    _closeDropdown();
    _anim.dispose();
    _currentWeightCtrl.dispose();
    _targetWeightCtrl.dispose();
    super.dispose();
  }

  void _checkForm() => widget.onNextEnabled(_isFormValid);

  Future<void> _handleNext() async {
    if (!_isFormValid) return;

    widget.setLoading(true);

    widget.onDataUpdate('currentWeight', _currentWeight);
    widget.onDataUpdate('targetWeight', _targetWeight);
    widget.onDataUpdate('timeline', _selectedTimeline);

    // ✅ Updated Units
    widget.onDataUpdate('currentWeightUnit', _currentWeightUnit);
    widget.onDataUpdate('targetWeightUnit', _targetWeightUnit);

    widget.onDataUpdate('weeklyWeighIns', _weeklyWeighIns);
    widget.onDataUpdate('photoProgress', _photoProgress);
    widget.onDataUpdate('measurementTracking', _measurementTracking);

    final user = AuthService.instance.currentUser;

    if (user != null) {
      try {
        await AuthService.instance.updateUserProfile(userId: user.id);
      } catch (e) {
        debugPrint('Page2 API error: $e');
      }
    }

    widget.setLoading(false);
    widget.navigateNext();
  }
  // ════════════════════════════════════════════
  // Dropdown logic — unit + timeline dono same system
  // ════════════════════════════════════════════
  void _toggleDropdown(LayerLink link) {
    if (_dropdownOpen && _activeLink == link) {
      _closeDropdown();
    } else {
      _closeDropdown();
      _activeLink   = link;
      _overlayEntry = link == _timelineLink
          ? _buildTimelineOverlay()
          : _buildUnitOverlay(link);
      Overlay.of(context).insert(_overlayEntry!);
      setState(() => _dropdownOpen = true);
    }
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _activeLink   = null;
    if (mounted) setState(() => _dropdownOpen = false);
  }

  void _selectUnit(String unit) {
    setState(() {
      if (_activeLink == _layerLink1) {
        _currentWeightUnit = unit;
      } else if (_activeLink == _layerLink2) {
        _targetWeightUnit = unit;
      }
    });

    widget.onDataUpdate('currentWeightUnit', _currentWeightUnit);
    widget.onDataUpdate('targetWeightUnit', _targetWeightUnit);

    _closeDropdown();
  }

  void _selectTimeline(String value) {
    setState(() => _selectedTimeline = value);
    widget.onDataUpdate('timeline', value);
    _checkForm();
    _closeDropdown();
  }

  // ── unit dropdown overlay ──
  OverlayEntry _buildUnitOverlay(LayerLink link) {
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
                  width: 38.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _unitDropItem('KG', 'Kilogram'),
                      Divider(height: 1, color: Colors.grey[100]),
                      _unitDropItem('LBS', 'Pound'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── timeline dropdown overlay ──
  OverlayEntry _buildTimelineOverlay() {
    return OverlayEntry(
      builder: (_) => GestureDetector(
        onTap: _closeDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.transparent)),
            CompositedTransformFollower(
              link: _timelineLink,
              showWhenUnlinked: false,
              followerAnchor: Alignment.topLeft,
              targetAnchor: Alignment.bottomLeft,
              offset: const Offset(0, 4),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _timelineOptions.map((opt) {
                      final bool isSelected = _selectedTimeline == opt;
                      return GestureDetector(
                        onTap: () => _selectTimeline(opt),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.4.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFE8F5E9)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  opt,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? const Color(0xFF2E7D32)
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check,
                                    color: Color(0xFF2E7D32), size: 16),
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

  Widget _unitDropItem(String label, String sub) {
    bool isSelected = false;

    if (_activeLink == _layerLink1) {
      isSelected = _currentWeightUnit == label;
    } else if (_activeLink == _layerLink2) {
      isSelected = _targetWeightUnit == label;
    }    return GestureDetector(
      onTap: () => _selectUnit(label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFF2E7D32)
                              : Colors.black87)),
                  Text(sub,
                      style: GoogleFonts.poppins(
                          fontSize: 9.sp, color: Colors.grey[500])),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: Color(0xFF2E7D32), size: 16),
          ],
        ),
      ),
    );
  }
  // ════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final bool timelineOpen = _dropdownOpen && _activeLink == _timelineLink;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Let's set your target",
                  style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
              SizedBox(height: 0.5.h),
              Text('We will create a personalized plan based on your goals',
                  style: GoogleFonts.poppins(
                      fontSize: 12.sp, color: Colors.grey[600])),
              SizedBox(height: 3.h),

              // ── Weight Details ──
              Text('Weight Details',
                  style: GoogleFonts.poppins(
                      fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 1.5.h),
              _weightField(
                link: _layerLink1,
                ctrl: _currentWeightCtrl,
                hint: 'Enter Weight....',
                unit: _currentWeightUnit,
                onChange: (v) {
                  setState(() => _currentWeight = double.tryParse(v));
                  _checkForm();
                },
              ),
              SizedBox(height: 1.h),
              _weightField(
                link: _layerLink2,
                ctrl: _targetWeightCtrl,
                hint: 'Target Weight....',
                unit: _targetWeightUnit,
                onChange: (v) {
                  setState(() => _targetWeight = double.tryParse(v));
                  _checkForm();
                },
              ),
              SizedBox(height: 3.h),

              // ── Timeline ──
              Text('Timeline',
                  style: GoogleFonts.poppins(
                      fontSize: 11.7.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 1.5.h),

              // ✅ Timeline dropdown — overlay, no bottom sheet
              CompositedTransformTarget(
                link: _timelineLink,
                child: GestureDetector(
                  onTap: () => _toggleDropdown(_timelineLink),
                  child: Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: const Color(0xFF2E7D32).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedTimeline ?? 'Select Timeline',
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            color: _selectedTimeline != null
                                ? Colors.black87
                                : const Color(0xFF2E7D32),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        AnimatedRotation(
                          turns: timelineOpen ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(Icons.keyboard_arrow_down,
                              color: Color(0xFF2E7D32)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.h),

              // ── Progress Tracking ──
              Text('Progress Tracking',
                  style: GoogleFonts.poppins(
                      fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 3.h),
              _trackingRow(
                  Icons.hourglass_bottom,
                  'Weekly Weighs-in',
                  'Track Your weight every week',
                  _weeklyWeighIns,
                      (v) => setState(() => _weeklyWeighIns = v)),
              SizedBox(height: 2.h),
              _trackingRow(
                  Icons.camera_alt_outlined,
                  'Photo Progress',
                  'Take progress photos',
                  _photoProgress,
                      (v) => setState(() => _photoProgress = v)),
              SizedBox(height: 2.h),
              _trackingRow(
                  Icons.straighten,
                  'Measurement Tracking',
                  'Track body measurements',
                  _measurementTracking,
                      (v) => setState(() => _measurementTracking = v)),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _weightField({
    required LayerLink link,
    required TextEditingController ctrl,
    required String hint,
    required String unit,
    required Function(String) onChange,
  }) {
    final bool isThisOpen = _dropdownOpen && _activeLink == link;
    return CompositedTransformTarget(
      link: link,
      child: Container(
        height: 45,
        width: double.infinity,
        child: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: onChange,
          style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400]),
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
                height: 29,
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
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                    SizedBox(width: 1.w),
                    AnimatedRotation(
                      turns: isThisOpen ? 0.5 : 0,
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

  Widget _trackingRow(IconData icon, String title, String sub, bool val,
      Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
            shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF2E7D32), size: 7.w),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 10.sp, fontWeight: FontWeight.w600)),
                Text(sub,
                    style: GoogleFonts.poppins(
                        fontSize: 9.sp, color: Colors.grey[500])),
              ],
            ),
          ),
          Switch(
              value: val,
              onChanged: onChanged,
              activeColor: const Color(0xFF2E7D32)),
        ],
      ),
    );
  }
}