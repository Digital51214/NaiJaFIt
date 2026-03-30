import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

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

  final FocusNode _ageFocus = FocusNode();
  final FocusNode _heightFocus = FocusNode();

  int? _age;
  double? _height;
  String _heightUnit = 'Cm';
  String _ageUnit = 'Yrs';
  String? _gender;

  final List<Map<String, dynamic>> _genderOptions = [
    {'id': 'male', 'label': 'Male', 'icon': Icons.male},
    {'id': 'female', 'label': 'Female', 'icon': Icons.female},
    {'id': 'other', 'label': 'Other', 'icon': Icons.transgender},
  ];

  final LayerLink _ageLink = LayerLink();
  final LayerLink _heightLink = LayerLink();

  OverlayEntry? _overlayEntry;
  LayerLink? _activeLink;
  bool _dropdownOpen = false;

  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  bool get _isAgeValid {
    if (_age == null) return false;
    if (_ageUnit == 'Yrs') return _age! >= 10 && _age! <= 80;
    if (_ageUnit == 'Mon') return _age! >= 120 && _age! <= 960;
    return false;
  }

  bool get _isHeightValid {
    if (_height == null) return false;
    if (_heightUnit == 'Cm') return _height! >= 91 && _height! <= 305;
    if (_heightUnit == 'Ft') return _height! >= 3 && _height! <= 10;
    return false;
  }

  bool get _isFormValid => _isAgeValid && _isHeightValid && _gender != null;

  String get _ageHint {
    if (_ageUnit == 'Yrs') return 'Enter age 10 to 80 yrs';
    return 'Enter age 120 to 960 months';
  }

  String get _heightHint {
    if (_heightUnit == 'Cm') return 'Enter height 91 to 305 cm';
    return 'Enter height 3 to 10 ft';
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
    _ageFocus.unfocus();
    _heightFocus.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
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
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _ageFocus.dispose();
    _heightFocus.dispose();
    super.dispose();
  }

  void _checkForm() => widget.onNextEnabled(_isFormValid);

  Future<void> _handleNext() async {
    if (!_isFormValid) return;

    _dismissKeyboard();
    await Future.delayed(const Duration(milliseconds: 250));

    final double heightCm =
    _heightUnit == 'Cm' ? _height! : _height! * 30.48;

    widget.onDataUpdate('age', _age);
    widget.onDataUpdate('height', heightCm);
    widget.onDataUpdate('heightRaw', _height);
    widget.onDataUpdate('heightUnit', _heightUnit);
    widget.onDataUpdate('ageUnit', _ageUnit);
    widget.onDataUpdate('gender', _gender);

    widget.navigateNext();
  }

  void _toggleDropdown(LayerLink link) {
    _dismissKeyboard();
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
    if (mounted) setState(() => _dropdownOpen = false);
  }

  void _selectDropdownValue(String value) {
    _dismissKeyboard();
    setState(() {
      if (_activeLink == _heightLink) {
        _heightUnit = value;
        _heightCtrl.clear();
        _height = null;
      } else if (_activeLink == _ageLink) {
        _ageUnit = value;
        _ageCtrl.clear();
        _age = null;
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
    } else {
      items = ['Yrs', 'Mon'];
      selectedValue = _ageUnit;
    }

    return OverlayEntry(
      builder: (_) => GestureDetector(
        onTap: () {
          _dismissKeyboard();
          _closeDropdown();
        },
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
                  width: 35.w,
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
                    children: items.map((item) {
                      final bool selected = selectedValue == item;
                      return GestureDetector(
                        onTap: () => _selectDropdownValue(item),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFEAF3E6)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 11.5.sp,
                                    fontFamily: "semibold",
                                    fontWeight: FontWeight.w500,
                                    color: selected
                                        ? const Color(0xFF0B7A22)
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              if (selected)
                                const Icon(
                                  Icons.check,
                                  color: Color(0xFF0B7A22),
                                  size: 18,
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
    required FocusNode focusNode,
    required String hint,
    required String unit,
    required Function(String) onChanged,
    String? errorText,
  }) {
    final bool isOpen = _dropdownOpen && _activeLink == link;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: link,
          child: SizedBox(
            height: 45,
            width: double.infinity,
            child: TextField(
              controller: ctrl,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: onChanged,
              textInputAction: TextInputAction.done,
              onTapOutside: (_) => _dismissKeyboard(),
              onEditingComplete: _dismissKeyboard,
              onSubmitted: (_) => _dismissKeyboard(),
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: "medium",
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 11.8.sp,
                  fontFamily: "regular",
                  color: const Color(0xFF9A9A9A),
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 6.w, vertical: 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: errorText != null
                        ? Colors.red
                        : const Color(0xFFD0D0D0),
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: errorText != null
                        ? Colors.red
                        : const Color(0xFFD0D0D0),
                    width: 1.2,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () => _toggleDropdown(link),
                  child: Container(
                    margin:
                    const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
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
                            fontSize: 11.sp,
                            fontFamily: "semibold",
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF56A61F),
                          ),
                        ),
                        SizedBox(width: 1.2.w),
                        AnimatedRotation(
                          turns: isOpen ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF0B7A22),
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 4.w),
            child: Text(
              errorText,
              style: TextStyle(
                fontSize: 9.5.sp,
                fontFamily: "regular",
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }

  String? get _ageErrorText {
    if (_ageCtrl.text.isEmpty) return null;
    if (!_isAgeValid) {
      if (_ageUnit == 'Yrs') return 'Age must be between 10 and 80 years';
      return 'Age must be between 120 and 960 months';
    }
    return null;
  }

  String? get _heightErrorText {
    if (_heightCtrl.text.isEmpty) return null;
    if (!_isHeightValid) {
      if (_heightUnit == 'Cm') return 'Height must be between 91 and 305 cm';
      return 'Height must be between 3 and 10 ft';
    }
    return null;
  }

  Widget _genderCard(Map<String, dynamic> g) {
    final isSelected = _gender == g['id'];

    return GestureDetector(
      onTap: () {
        _dismissKeyboard();
        setState(() => _gender = g['id']);
        widget.onDataUpdate('gender', g['id']);
        _checkForm();
      },
      child: AnimatedContainer(
        height: 73,
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.5.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEAF3E6) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF026F1A)
                : const Color(0xFFE1E1E1),
            width: isSelected ? 1.5 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: const BoxDecoration(
                color: Color(0xFFDCE8D5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                g['icon'] as IconData,
                size: 7.5.w,
                color: isSelected ? const Color(0xFF0B7A22) : Colors.black,
              ),
            ),
            SizedBox(width: 4.5.w),
            Expanded(
              child: Text(
                g['label'],
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: "medium",
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              isSelected ? 'Selected' : 'Select',
              style: TextStyle(
                fontSize: 11.8.sp,
                fontFamily: "medium",
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: const Color(0xFF56B327),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      behavior: HitTestBehavior.translucent,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding:
            EdgeInsets.symmetric(horizontal: 5.5.w, vertical: 1.5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tell Us About Yourself',
                  style: TextStyle(
                    fontSize: 16.5.sp,
                    fontFamily: "semibold",
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 1.2.h),
                Text(
                  'This will help us a lot to tailor a very well\nplan for you',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: "regular",
                    color: const Color(0xFF6E6E6E),
                    height: 1.55,
                  ),
                ),
                SizedBox(height: 3.8.h),
                _inputField(
                  link: _ageLink,
                  ctrl: _ageCtrl,
                  focusNode: _ageFocus,
                  hint: _ageHint,
                  unit: _ageUnit,
                  errorText: _ageErrorText,
                  onChanged: (v) {
                    setState(() => _age = int.tryParse(v));
                    _checkForm();
                  },
                ),
                SizedBox(height: 1.h),
                _inputField(
                  link: _heightLink,
                  ctrl: _heightCtrl,
                  focusNode: _heightFocus,
                  hint: _heightHint,
                  unit: _heightUnit,
                  errorText: _heightErrorText,
                  onChanged: (v) {
                    setState(() => _height = double.tryParse(v));
                    _checkForm();
                  },
                ),
                SizedBox(height: 2.3.h),
                ..._genderOptions.map((g) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: _genderCard(g),
                  );
                }).toList(),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}