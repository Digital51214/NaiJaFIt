// import 'package:flutter/material.dart';
// import 'package:naijafit/presentation/Nagarionsays_screen.dart';
// import 'package:naijafit/presentation/Page1_goalselection.dart';
// import 'package:naijafit/presentation/Page2_goalsetting.dart';
// import 'package:naijafit/presentation/Page3_trackprogress.dart';
// import 'package:naijafit/presentation/Page4_challengeidentification.dart';
// import 'package:naijafit/presentation/Page5_wieghtlossexpectations.dart';
// import 'package:naijafit/presentation/Page6_professionalsupport.dart';
// import 'package:naijafit/presentation/Page7_personalstats.dart';
// import 'package:naijafit/presentation/Page8_activitycheck.dart';
// import 'package:naijafit/presentation/Page9_clorietarget.dart';
// import 'package:naijafit/widgets/custom_backbutton.dart';
// import 'package:sizer/sizer.dart';
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//   final int _totalPages = 9;
//
//   /// Shared data map - passes through all pages
//   final Map<String, dynamic> _onboardingData = {};
//
//   bool _isNextEnabled = false;
//   bool _isLoading = false;
//
//   VoidCallback? _pageNextCallback;
//
//   void _goToNextPage() {
//     if (_pageNextCallback != null) {
//       _pageNextCallback!();
//     } else {
//       _navigateNext();
//     }
//   }
//
//   void _navigateNext() {
//     if (_currentPage < _totalPages - 1) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       // Last page done - go to NigeriansAreSaying screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => WhatNigeriansAreSayingScreen(),
//         ),
//       );
//     }
//   }
//
//   void _goToPreviousPage() {
//     if (_currentPage > 0) {
//       _pageController.previousPage(
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       Navigator.of(context).pop();
//     }
//   }
//
//   void _onPageChanged(int index) {
//     setState(() {
//       _currentPage = index;
//       _pageNextCallback = null;
//
//       // Page 5 (WeightLossExpectations) and Page 9 (CalorieTarget) are auto-enabled
//       if (_currentPage == 4 || _currentPage == 8) {
//         _isNextEnabled = true;
//       } else {
//         _isNextEnabled = false;
//       }
//     });
//   }
//
//   void _updateNextEnabled(bool enabled) {
//     if (_isNextEnabled != enabled) {
//       setState(() => _isNextEnabled = enabled);
//     }
//   }
//
//   void _updateData(String key, dynamic value) {
//     setState(() => _onboardingData[key] = value);
//   }
//
//   void _registerNextCallback(VoidCallback callback) {
//     _pageNextCallback = callback;
//   }
//
//   void _setLoading(bool loading) {
//     if (_isLoading != loading) {
//       setState(() => _isLoading = loading);
//     }
//   }
//
//   bool get _isFinalPage => _currentPage == _totalPages - 1;
//   bool get _nextActive => _currentPage == 4 || _isNextEnabled;
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ─── Header ───────────────────────────────────────────────
//             Padding(
//               padding: EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   CustomBackButton(
//                     onTap: _goToPreviousPage,
//                   ),
//                   Image.asset(
//                     'assets/images/LOGO.png',
//                     height: 60,
//                     width: 60,
//                     fit: BoxFit.contain,
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(height: 1.5.h),
//
//             // ─── Step Indicator ───────────────────────────────────────
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 5.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Step ${_currentPage + 1} of $_totalPages',
//                     style: TextStyle(
//                       fontSize: 13.5.sp,
//                       fontFamily: "medium",
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(height: 1.2.h),
//                   Row(
//                     children: List.generate(_totalPages, (index) {
//                       return Expanded(
//                         child: AnimatedContainer(
//                           duration: const Duration(milliseconds: 350),
//                           curve: Curves.easeInOut,
//                           margin: EdgeInsets.only(
//                             right: index < _totalPages - 1 ? 1.5.w : 0,
//                           ),
//                           height: 4,
//                           decoration: BoxDecoration(
//                             color: index <= _currentPage
//                                 ? const Color(0xFF026F1A)
//                                 : Colors.grey[200],
//                             borderRadius: BorderRadius.circular(2),
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(height: 1.5.h),
//
//             // ─── Pages ────────────────────────────────────────────────
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 onPageChanged: _onPageChanged,
//                 children: [
//                   // Page 1: Goal Selection
//                   Page1GoalSelection(
//                     onNextEnabled: _updateNextEnabled,
//                     onDataUpdate: _updateData,
//                     registerNextCallback: _registerNextCallback,
//                     setLoading: _setLoading,
//                     navigateNext: _navigateNext,
//                   ),
//
//                   // Page 2: Goal Setting Details (weight + timeline)
//                   Page2GoalSettingDetails(
//                     onNextEnabled: _updateNextEnabled,
//                     onDataUpdate: _updateData,
//                     registerNextCallback: _registerNextCallback,
//                     setLoading: _setLoading,
//                     navigateNext: _navigateNext,
//                   ),
//
//                   // Page 3: Track Progress (3 switches)
//                   Page2GoalsettingPart2(
//                     onNextEnabled: _updateNextEnabled,
//                     onDataUpdate: _updateData,
//                     registerNextCallback: _registerNextCallback,
//                     setLoading: _setLoading,
//                     navigateNext: _navigateNext,
//                   ),
//
//                   // Page 4: Challenge Identification
//                   Page3ChallengeIdentification(
//                     onNextEnabled: _updateNextEnabled,
//                     onDataUpdate: _updateData,
//                     registerNextCallback: _registerNextCallback,
//                     setLoading: _setLoading,
//                     navigateNext: _navigateNext,
//                   ),
//
//                   // Page 5: Weight Loss Expectations (auto next enabled)
//                   Page4WeightLossExpectations(
//                     onNextEnabled: _updateNextEnabled,
//                     onDataUpdate: _updateData,
//                   ),
//
//                   // Page 6: Professional Support
//                   Page5ProfessionalSupport(
//                     onNextEnabled: _updateNextEnabled,
//                     onDataUpdate: _updateData,
//                     registerNextCallback: _registerNextCallback,
//                     setLoading: _setLoading,
//                     navigateNext: _navigateNext,
//                   ),
//
//                   // Page 7: Personal Stats (age, height, gender)
//                   Page6PersonalStats(
//                     onNextEnabled: _updateNextEnabled,
//                     onDataUpdate: _updateData,
//                     registerNextCallback: _registerNextCallback,
//                     setLoading: _setLoading,
//                     navigateNext: _navigateNext,
//                   ),
//
//                   // Page 8: Activity Level + Calorie Calculation
//                   Page8ActivityLevel(
//                     onNextEnabled: _updateNextEnabled,
//                     onDataUpdate: _updateData,
//                     registerNextCallback: _registerNextCallback,
//                     setLoading: _setLoading,
//                     navigateNext: _navigateNext,
//                     onboardingData: _onboardingData, // ✅ Pass full data for BMR calc
//                   ),
//
//                   // Page 9: Calorie Target Display (auto next enabled)
//                   Page7CalorieTargetDisplay(
//                     onboardingData: _onboardingData, // ✅ Pass full data for display
//                     onNextEnabled: _updateNextEnabled,
//                   ),
//                 ],
//               ),
//             ),
//
//             // ─── Next Button ──────────────────────────────────────────
//             Padding(
//               padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 child: ElevatedButton(
//                   onPressed: _nextActive && !_isLoading ? _goToNextPage : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF026F1A),
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 0,
//                       horizontal: 0,
//                     ),
//                     disabledBackgroundColor: Colors.grey[300],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(28),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                     width: 22,
//                     height: 22,
//                     child: CircularProgressIndicator(
//                       color: Colors.white,
//                       strokeWidth: 2,
//                     ),
//                   )
//                       : Text(
//                     _isFinalPage ? 'Get Started!' : 'Next',
//                     style: TextStyle(
//                       fontSize: 11.5.sp,
//                       fontFamily: "bold",
//                       fontWeight: FontWeight.w600,
//                       color: _nextActive
//                           ? Colors.white
//                           : Colors.grey[500],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:naijafit/presentation/LoadingScreen.dart';
import 'package:naijafit/presentation/Nagarionsays_screen.dart';
import 'package:naijafit/presentation/Page1_goalselection.dart';
import 'package:naijafit/presentation/Page2_goalsetting.dart';
import 'package:naijafit/presentation/Page3_trackprogress.dart';
import 'package:naijafit/presentation/Page4_challengeidentification.dart';
import 'package:naijafit/presentation/Page5_wieghtlossexpectations.dart';
import 'package:naijafit/presentation/Page6_professionalsupport.dart';
import 'package:naijafit/presentation/Page7_personalstats.dart';
import 'package:naijafit/presentation/Page8_activitycheck.dart';
import 'package:naijafit/presentation/Page9_clorietarget.dart';
import 'package:naijafit/widgets/custom_backbutton.dart';
import 'package:sizer/sizer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 9;

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Loadingscreen(),
        ),
      );
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
      _pageNextCallback = null;

      // Weight loss expectations and calorie target are auto-enabled
      if (_currentPage == 4 || _currentPage == 8) {
        _isNextEnabled = true;
      } else {
        _isNextEnabled = false;
      }
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

  bool get _isFinalPage => _currentPage == _totalPages - 1;
  bool get _nextActive => _currentPage == 4 || _isNextEnabled;

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
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(
                    onTap: _goToPreviousPage,
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

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step ${_currentPage + 1} of $_totalPages',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontFamily: "medium",
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
                                ? const Color(0xFF026F1A)
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

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: _onPageChanged,
                children: [
                  // Page 1: Goal Selection
                  Page1GoalSelection(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                  ),

                  // Page 2: Goal Setting Details
                  Page2GoalSettingDetails(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                  ),

                  // Page 3: Track Progress
                  Page2GoalsettingPart2(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                  ),

                  // Page 4: Challenge Identification
                  Page3ChallengeIdentification(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                  ),

                  // Page 5: Weight Loss Expectations
                  Page4WeightLossExpectations(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                  ),

                  // Page 6: Professional Support
                  Page5ProfessionalSupport(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                  ),

                  // Page 7: Activity Level
                  Page8ActivityLevel(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                    onboardingData: _onboardingData,
                  ),

                  // Page 8: Personal Stats
                  Page6PersonalStats(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                  ),

                  // Page 9: Calorie Target Display
                  Page7CalorieTargetDisplay(
                    onboardingData: _onboardingData,
                    onNextEnabled: _updateNextEnabled,
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _nextActive && !_isLoading ? _goToNextPage : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF026F1A),
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
                    _isFinalPage ? 'Get Started!' : 'Next',
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontFamily: "bold",
                      fontWeight: FontWeight.w600,
                      color: _nextActive
                          ? Colors.white
                          : Colors.grey[500],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
