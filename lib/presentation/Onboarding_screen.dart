import 'package:flutter/material.dart';
import 'package:naijafit/presentation/Page1_goalselection.dart';
import 'package:naijafit/presentation/Page2_goalsetting.dart';
import 'package:naijafit/presentation/Page3_challengeidentification.dart';
import 'package:naijafit/presentation/Page4_wieghtlossexpectations.dart';
import 'package:naijafit/presentation/Page5_professionalsupport.dart';
import 'package:naijafit/presentation/Page6_personalstats.dart';
import 'package:naijafit/presentation/Page7_clorietarget.dart';
import 'package:sizer/sizer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 7;

  final Map<String, dynamic> _onboardingData = {};

  bool _isNextEnabled = false;
  bool _isLoading = false;

  VoidCallback? _pageNextCallback;

  void _goToNextPage() {
    if (_pageNextCallback != null) {
      _pageNextCallback!();
    } else {
      _navigateNext();
    }
  }

  void _navigateNext() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context, rootNavigator: true)
          .pushNamed('/premium-subscription');
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      _isNextEnabled = index == 3;
      _pageNextCallback = null;
    });
  }

  void _updateNextEnabled(bool enabled) {
    if (_isNextEnabled != enabled) {
      setState(() => _isNextEnabled = enabled);
    }
  }

  void _updateData(String key, dynamic value) {
    setState(() => _onboardingData[key] = value);
  }

  void _registerNextCallback(VoidCallback callback) {
    _pageNextCallback = callback;
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      setState(() => _isLoading = loading);
    }
  }

  bool get _showSkip => _currentPage == 4;
  bool get _isLastPage => _currentPage == 6;
  bool get _nextActive =>
      _isNextEnabled || _currentPage == 3 || _currentPage == 6;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Static Header ──
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _goToPreviousPage,
                    child: Container(
                      width: 13.5.w,
                      height: 13.5.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Color(0xFF2E7D32),
                        size: 30,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/LOGO.png',
                    height: 60,
                    width: 60,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            SizedBox(height: 1.5.h),

            // ── Static Progress Bars ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step ${_currentPage + 1} of $_totalPages',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontFamily: "Poppin",
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.2.h),
                  Row(
                    children: List.generate(_totalPages, (index) {
                      return Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.only(
                            right: index < _totalPages - 1 ? 1.5.w : 0,
                          ),
                          height: 4,
                          decoration: BoxDecoration(
                            color: index <= _currentPage
                                ? const Color(0xFF2E7D32)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            SizedBox(height: 1.5.h),

            // ── Page Content Area ──
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: _onPageChanged,
                children: [
                  Page1GoalSelection(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                  ),
                  Page2GoalSettingDetails(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                  ),
                  Page3ChallengeIdentification(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                  ),
                  Page4WeightLossExpectations(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                  ),
                  Page5ProfessionalSupport(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                  ),
                  Page6PersonalStats(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                  ),
                  Page7CalorieTargetDisplay(
                    onboardingData: _onboardingData,
                    onNextEnabled: _updateNextEnabled,
                  ),
                ],
              ),
            ),

            // ── Static Bottom Button ──
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed:
                      _nextActive && !_isLoading ? _goToNextPage : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 0,
                        ),
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        _isLastPage ? 'Get Started!' : 'Next',
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontFamily: "Poppin",
                          fontWeight: FontWeight.w600,
                          color: _nextActive
                              ? Colors.white
                              : Colors.grey[500],
                        ),
                      ),
                    ),
                  ),

                  // Skip — only Page 5
                  if (_showSkip) ...[
                    SizedBox(height: 0.5.h),
                    TextButton(
                      onPressed: _navigateNext,
                      child: Text(
                        'Skip for now',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: "Poppin",
                          color: const Color(0xFF2E7D32),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],

                  // Save & Continue Later — only Page 7
                  if (_isLastPage) ...[
                    SizedBox(height: 0.5.h),
                    TextButton(
                      onPressed: _navigateNext,
                      child: Text(
                        'Save & Continue Later',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontFamily: "Poppin",
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}