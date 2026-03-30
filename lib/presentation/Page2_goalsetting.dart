import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  State<Page2GoalSettingDetails> createState() =>
      _Page2GoalSettingDetailsState();
}

class _Page2GoalSettingDetailsState extends State<Page2GoalSettingDetails>
    with SingleTickerProviderStateMixin {
  final TextEditingController _currentWeightCtrl = TextEditingController();
  final TextEditingController _targetWeightCtrl = TextEditingController();

  final FocusNode _currentWeightFocus = FocusNode();
  final FocusNode _targetWeightFocus = FocusNode();

  double? _currentWeight;
  double? _targetWeight;
  String? _selectedTimeline;

  String _currentWeightUnit = 'KG';
  String _targetWeightUnit = 'KG';

  String? _currentWeightError;
  String? _targetWeightError;

  final LayerLink _layerLink1 = LayerLink();
  final LayerLink _layerLink2 = LayerLink();
  final LayerLink _timelineLink = LayerLink();

  OverlayEntry? _overlayEntry;
  bool _dropdownOpen = false;
  LayerLink? _activeLink;

  final List<String> _timelineOptions = [
    '4 Weeks',
    '8 Weeks',
    '12 Weeks',
    '16 Weeks',
  ];

  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  double get _minCurrent => _currentWeightUnit == 'KG' ? 30 : 66;
  double get _maxCurrent => _currentWeightUnit == 'KG' ? 300 : 661;
  double get _minTarget => _targetWeightUnit == 'KG' ? 30 : 66;
  double get _maxTarget => _targetWeightUnit == 'KG' ? 300 : 661;

  String get _currentHint => _currentWeightUnit == 'KG'
      ? 'Enter weight (30 to 300 kg)'
      : 'Enter weight (66 to 661 lbs)';

  String get _targetHint => _targetWeightUnit == 'KG'
      ? 'Enter weight (30 to 300 kg)'
      : 'Enter weight (66 to 661 lbs)';

  bool get _isFormValid =>
      _currentWeight != null &&
          _targetWeight != null &&
          _selectedTimeline != null &&
          _currentWeightError == null &&
          _targetWeightError == null;

  double? get _currentWeightDisplay => _currentWeight;
  double? get _targetWeightDisplay => _targetWeight;

  int get _timelineWeeks =>
      int.tryParse(_selectedTimeline?.split(' ').first ?? '') ?? 0;

  bool get _showProjectionCard =>
      _currentWeight != null &&
          _targetWeight != null &&
          _selectedTimeline != null &&
          _currentWeightError == null &&
          _targetWeightError == null;

  String get _projectionTitle {
    switch (_timelineWeeks) {
      case 4:
        return 'Aggressive Rate';
      case 8:
        return 'Fast Pace';
      case 12:
        return 'Balanced Rate';
      case 16:
        return 'Gradual Rate';
      default:
        return 'Goal Pace';
    }
  }

  String get _projectionMessage {
    switch (_timelineWeeks) {
      case 4:
        return 'Consider a longer timeline for sustainable results';
      case 8:
        return 'This pace is faster and may require stronger consistency';
      case 12:
        return 'This is a realistic and sustainable pace for most users';
      case 16:
        return 'A slower and more gradual approach for steady progress';
      default:
        return 'Choose a timeline that feels realistic and sustainable';
    }
  }

  Color get _projectionBgColor {
    switch (_timelineWeeks) {
      case 4:
        return const Color(0xFFFCEAEA);
      case 8:
        return const Color(0xFFFFF4E5);
      case 12:
        return const Color(0xFFEAF7EE);
      case 16:
        return const Color(0xFFEAF3FF);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  Color get _projectionTextColor {
    switch (_timelineWeeks) {
      case 4:
        return const Color(0xFFEF4444);
      case 8:
        return const Color(0xFFF59E0B);
      case 12:
        return const Color(0xFF16A34A);
      case 16:
        return const Color(0xFF2563EB);
      default:
        return Colors.black87;
    }
  }

  IconData get _projectionIcon {
    switch (_timelineWeeks) {
      case 4:
        return Icons.warning_rounded;
      case 8:
        return Icons.info_rounded;
      case 12:
        return Icons.check_circle_rounded;
      case 16:
        return Icons.track_changes_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  double get _projectionProgressValue {
    switch (_timelineWeeks) {
      case 4:
        return 0.95;
      case 8:
        return 0.72;
      case 12:
        return 0.52;
      case 16:
        return 0.34;
      default:
        return 0.0;
    }
  }

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
        .drive(Tween(begin: const Offset(0, 0.06), end: Offset.zero));

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
    _currentWeightFocus.dispose();
    _targetWeightFocus.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    _currentWeightFocus.unfocus();
    _targetWeightFocus.unfocus();
    FocusScope.of(context).unfocus();
  }

  void _checkForm() => widget.onNextEnabled(_isFormValid);

  void _onCurrentWeightChanged(String v) {
    final double? w = double.tryParse(v);
    setState(() {
      _currentWeight = w;
      if (v.isEmpty) {
        _currentWeightError = null;
      } else if (w == null) {
        _currentWeightError = 'Enter a valid number';
      } else if (w < _minCurrent || w > _maxCurrent) {
        _currentWeightError =
        'Enter between ${_minCurrent.toInt()} and ${_maxCurrent.toInt()} '
            '${_currentWeightUnit == 'KG' ? 'kg' : 'lbs'}';
      } else {
        _currentWeightError = null;
      }
    });
    _checkForm();
  }

  void _onTargetWeightChanged(String v) {
    final double? w = double.tryParse(v);
    setState(() {
      _targetWeight = w;
      if (v.isEmpty) {
        _targetWeightError = null;
      } else if (w == null) {
        _targetWeightError = 'Enter a valid number';
      } else if (w < _minTarget || w > _maxTarget) {
        _targetWeightError =
        'Enter between ${_minTarget.toInt()} and ${_maxTarget.toInt()} '
            '${_targetWeightUnit == 'KG' ? 'kg' : 'lbs'}';
      } else {
        _targetWeightError = null;
      }
    });
    _checkForm();
  }

  Future<void> _handleNext() async {
    if (!_isFormValid) return;

    _dismissKeyboard();

    widget.setLoading(true);

    final double currentWeightKg = _currentWeightUnit == 'KG'
        ? _currentWeight!
        : _currentWeight! / 2.205;
    final double targetWeightKg = _targetWeightUnit == 'KG'
        ? _targetWeight!
        : _targetWeight! / 2.205;

    widget.onDataUpdate('currentWeight', currentWeightKg);
    widget.onDataUpdate('targetWeight', targetWeightKg);
    widget.onDataUpdate('currentWeightRaw', _currentWeight);
    widget.onDataUpdate('targetWeightRaw', _targetWeight);
    widget.onDataUpdate('timeline', _selectedTimeline);
    widget.onDataUpdate('currentWeightUnit', _currentWeightUnit);
    widget.onDataUpdate('targetWeightUnit', _targetWeightUnit);

    final int timelineWeeks =
        int.tryParse(_selectedTimeline!.split(' ')[0]) ?? 8;
    widget.onDataUpdate('timelineWeeks', timelineWeeks);

    try {
      final user = AuthService.instance.currentUser;
      if (user != null) {
        await AuthService.instance.updateUserProfile(
          userId: user.id,
          weightUnit: _currentWeightUnit.toLowerCase(),
        );
      }
    } catch (e) {
      debugPrint('Page2 API error: $e');
    } finally {
      widget.setLoading(false);
    }

    widget.navigateNext();
  }

  void _toggleDropdown(LayerLink link) {
    _dismissKeyboard();
    if (_dropdownOpen && _activeLink == link) {
      _closeDropdown();
    } else {
      _closeDropdown();
      _activeLink = link;
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
    _activeLink = null;
    if (mounted) setState(() => _dropdownOpen = false);
  }

  void _selectUnit(String unit) {
    final LayerLink? wasActive = _activeLink;
    setState(() {
      if (wasActive == _layerLink1) {
        _currentWeightUnit = unit;
      } else if (wasActive == _layerLink2) {
        _targetWeightUnit = unit;
      }
    });
    _closeDropdown();

    if (wasActive == _layerLink1) {
      _onCurrentWeightChanged(_currentWeightCtrl.text);
    } else if (wasActive == _layerLink2) {
      _onTargetWeightChanged(_targetWeightCtrl.text);
    }

    widget.onDataUpdate('currentWeightUnit', _currentWeightUnit);
    widget.onDataUpdate('targetWeightUnit', _targetWeightUnit);
  }

  void _selectTimeline(String value) {
    setState(() => _selectedTimeline = value);
    widget.onDataUpdate('timeline', value);
    final int weeks = int.tryParse(value.split(' ')[0]) ?? 8;
    widget.onDataUpdate('timelineWeeks', weeks);
    _checkForm();
    _closeDropdown();
  }

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
              offset: const Offset(0, 6),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 38.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E2E2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _unitDropItem('KG', 'Kilogram', link),
                      Divider(height: 1, color: Colors.grey[200]),
                      _unitDropItem('LBS', 'Pound', link),
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
              offset: const Offset(0, 6),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 55.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E2E2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 14,
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
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.6.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFEAF3E6)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  opt,
                                  style: TextStyle(
                                    fontSize: 11.5.sp,
                                    fontFamily: 'regular',
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? const Color(0xFF47A312)
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check,
                                  size: 18,
                                  color: Color(0xFF0B7A22),
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

  Widget _unitDropItem(String label, String sub, LayerLink forLink) {
    final bool isSelected = forLink == _layerLink1
        ? _currentWeightUnit == label
        : _targetWeightUnit == label;

    return GestureDetector(
      onTap: () => _selectUnit(label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEAF3E6) : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontFamily: 'semibold',
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF47A312)
                          : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 0.2.h),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontFamily: 'semibold',
                      color: const Color(0xFF8A8A8A),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, size: 18, color: Color(0xFF0B7A22)),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectionCard() {
    final String currentUnit = _currentWeightUnit.toLowerCase();
    final String targetUnit = _targetWeightUnit.toLowerCase();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.show_chart_rounded,
                color: const Color(0xFF34A853),
                size: 24,
              ),
              SizedBox(width: 2.5.w),
              Text(
                'Progress Projection',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'bold',
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.2.h),

          Container(
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFF1F1F1),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _projectionProgressValue,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _projectionTextColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 1.2.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        fontFamily: 'regular',
                        color: const Color(0xFF8B8B8B),
                      ),
                    ),
                    SizedBox(height: 0.65.h),
                    Text(
                      '${_currentWeightDisplay!.toStringAsFixed(1)} $currentUnit',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'semibold',
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 25,
                  color: const Color(0xFF7C7C88),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Target',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        fontFamily: 'regular',
                        color: const Color(0xFF8B8B8B),
                      ),
                    ),
                    SizedBox(height: 0.65.h),
                    Text(
                      '${_targetWeightDisplay!.toStringAsFixed(1)} $targetUnit',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: 'semibold',
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF34A853),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.3.h),
            decoration: BoxDecoration(
              color: _projectionBgColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 02.h),
                  child: Icon(
                    _projectionIcon,
                    color: _projectionTextColor,
                    size: 26,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _projectionTitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'semibold',
                          fontWeight: FontWeight.w700,
                          color: _projectionTextColor,
                        ),
                      ),
                      SizedBox(height: 0.4.h),
                      Text(
                        _projectionMessage,
                        style: TextStyle(
                          fontSize: 9.2.sp,
                          fontFamily: 'regular',
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6E6E6E),
                          height: 1.4,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool timelineOpen = _dropdownOpen && _activeLink == _timelineLink;

    return GestureDetector(
      onTap: _dismissKeyboard,
      behavior: HitTestBehavior.translucent,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 5.5.w, vertical: 1.5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let's set your target",
                  style: TextStyle(
                    fontSize: 17.3.sp,
                    fontFamily: 'semibold',
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 1.6.h),
                Text(
                  'We will create a personalized plan based\non your goals',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'regular',
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6E6E6E),
                    height: 1.55,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Weight Details',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'medium',
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2.2.h),
                _weightField(
                  link: _layerLink1,
                  ctrl: _currentWeightCtrl,
                  focusNode: _currentWeightFocus,
                  hint: _currentHint,
                  unit: _currentWeightUnit,
                  errorText: _currentWeightError,
                  onChange: _onCurrentWeightChanged,
                ),
                SizedBox(height: _currentWeightError != null ? 0.5.h : 1.2.h),
                _weightField(
                  link: _layerLink2,
                  ctrl: _targetWeightCtrl,
                  focusNode: _targetWeightFocus,
                  hint: _targetHint,
                  unit: _targetWeightUnit,
                  errorText: _targetWeightError,
                  onChange: _onTargetWeightChanged,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Timeline to achieve your target',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'medium',
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2.2.h),
                CompositedTransformTarget(
                  link: _timelineLink,
                  child: GestureDetector(
                    onTap: () => _toggleDropdown(_timelineLink),
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 5.5.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDE8DF),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFFCDCDCD)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedTimeline ?? 'Select Timeline',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: 'semibold',
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF0B7A22),
                              ),
                            ),
                          ),
                          AnimatedRotation(
                            turns: timelineOpen ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF0B7A22),
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                if (_showProjectionCard) _buildProjectionCard(),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _weightField({
    required LayerLink link,
    required TextEditingController ctrl,
    required FocusNode focusNode,
    required String hint,
    required String unit,
    String? errorText,
    required Function(String) onChange,
  }) {
    final bool isThisOpen = _dropdownOpen && _activeLink == link;
    final bool hasError = errorText != null;

    return CompositedTransformTarget(
      link: link,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 45,
            child: TextField(
              controller: ctrl,
              focusNode: focusNode,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _dismissKeyboard(),
              onChanged: onChange,
              style: TextStyle(
                fontSize: 10.sp,
                fontFamily: 'regular',
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'regular',
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9B9B9B),
                ),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 0.5.h,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: hasError
                        ? Colors.red.shade400
                        : const Color(0xFFCDCDCD),
                    width: hasError ? 1.5 : 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: hasError
                        ? Colors.red.shade400
                        : const Color(0xFF0B7A22),
                    width: 1.5,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () => _toggleDropdown(link),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    padding: EdgeInsets.symmetric(horizontal: 4.2.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDE8DF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          unit,
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            fontFamily: 'semibold',
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF56A61F),
                          ),
                        ),
                        SizedBox(width: 1.2.w),
                        AnimatedRotation(
                          turns: isThisOpen ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF0B7A22),
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: EdgeInsets.only(left: 5.w, top: 0.4.h),
              child: Text(
                errorText!,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: Colors.red.shade600,
                  fontFamily: 'regular',
                ),
              ),
            ),
        ],
      ),
    );
  }
}