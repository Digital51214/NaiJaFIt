import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

// ✅ Import all 7 page content widgets
import '../Page1_goalselection.dart';
import '../Page2_goalsetting.dart';
import '../Page3_challengeidentification.dart';
import '../Page4_wieghtlossexpectations.dart';
import '../Page5_professionalsupport.dart';
import '../Page6_personalstats.dart';
import '../Page7_clorietarget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 7;

  // ✅ Shared data across all pages
  final Map<String, dynamic> _onboardingData = {};

  bool _isNextEnabled = false;
  bool _isLoading = false;

  // ✅ Each page registers its own save+navigate logic here
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
      _isNextEnabled = index == 3; // page 4 always enabled (no selection needed)
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
  bool get _nextActive => _isNextEnabled || _currentPage == 3 || _currentPage == 6;

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

            // ══════════════════════════════════════════════
            // ✅ STATIC HEADER — always stays, never animates
            // ══════════════════════════════════════════════
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
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
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

            // ══════════════════════════════════════════════
            // ✅ STATIC PROGRESS BARS — bar fills on page change
            // ══════════════════════════════════════════════
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step ${_currentPage + 1} of $_totalPages',
                    style: GoogleFonts.poppins(
                      fontSize: 13.5.sp,
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

            // ══════════════════════════════════════════════
            // ✅ ONLY THIS PART SLIDES — page content area
            // ══════════════════════════════════════════════
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: _onPageChanged,
                children: [

                  // ── Page 1: Goal Selection ──
                  Page1GoalSelection(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                  ),

                  // ── Page 2: Goal Setting Details ──
                  Page2GoalSettingDetails(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                  ),

                  // ── Page 3: Challenge Identification ──
                  Page3ChallengeIdentification(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                  ),

                  // ── Page 4: Weight Loss Expectations ──
                  Page4WeightLossExpectations(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                  ),

                  // ── Page 5: Professional Support ──
                  Page5ProfessionalSupport(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                  ),

                  // ── Page 6: Personal Stats ──
                  Page6PersonalStats(
                    onNextEnabled: _updateNextEnabled,
                    onDataUpdate: _updateData,
                    registerNextCallback: _registerNextCallback,
                    setLoading: _setLoading,
                    navigateNext: _navigateNext,
                  ),

                  // ── Page 7: Calorie Target Display ──
                  Page7CalorieTargetDisplay(
                    onboardingData: _onboardingData,
                    onNextEnabled: _updateNextEnabled,
                  ),
                ],
              ),
            ),

            // ══════════════════════════════════════════════
            // ✅ STATIC BOTTOM BUTTON — always stays fixed
            // ══════════════════════════════════════════════
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _nextActive && !_isLoading ? _goToNextPage : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        padding: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
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
                        style: GoogleFonts.poppins(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                          color: _nextActive ? Colors.white : Colors.grey[500],
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
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
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
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
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





































// import 'package:flutter/material.dart';
// class OnboardingFlow extends StatefulWidget {
//   const OnboardingFlow({super.key});
//
//   @override
//   State<OnboardingFlow> createState() => _OnboardingFlowState();
// }
//
// class _OnboardingFlowState extends State<OnboardingFlow> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//   final int _totalPages = 7;
//
//   void _nextPage() {
//     if (_currentPage < _totalPages - 1) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 350),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       // Last page: Get Started
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Onboarding Complete! 🎉')),
//       );
//     }
//   }
//
//   void _prevPage() {
//     if (_currentPage > 0) {
//       _pageController.previousPage(
//         duration: const Duration(milliseconds: 350),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ── Top Bar ──
//             _OnboardingTopBar(
//               currentPage: _currentPage,
//               totalPages: _totalPages,
//               onBack: _prevPage,
//             ),
//
//             // ── Page Content ──
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 onPageChanged: (index) =>
//                     setState(() => _currentPage = index),
//                 children: [
//                   // ── Replace these with your own page widgets ──
//                   Step1GoalsPage(),
//                   Step2TargetPage(),
//                   Step3ChallengePage(),
//                   Step4ExpectPage(),
//                   Step5CoachPage(),
//                   Step6AboutYouPage(),
//                   Step7PlanPage(onGetStarted: _nextPage),
//                 ],
//               ),
//             ),
//
//             // ── Bottom Button (hidden on step 7, which has its own button) ──
//             if (_currentPage < 6)
//               _OnboardingNextButton(
//                 label: 'Next',
//                 onTap: _nextPage,
//                 showSkip: _currentPage == 4,
//                 onSkip: _nextPage,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────
// // SHARED WIDGETS
// // ─────────────────────────────────────────────
//
// const kGreen = Color(0xFF2D7A3A);
// const kLightGreen = Color(0xFFE8F5EB);
// const kBorderColor = Color(0xFFE0E0E0);
//
// /// Top bar with back button, step indicator and logo
// class _OnboardingTopBar extends StatelessWidget {
//   final int currentPage;
//   final int totalPages;
//   final VoidCallback onBack;
//
//   const _OnboardingTopBar({
//     required this.currentPage,
//     required this.totalPages,
//     required this.onBack,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Back button
//               GestureDetector(
//                 onTap: onBack,
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: kBorderColor),
//                   ),
//                   child: const Icon(Icons.chevron_left,
//                       color: kGreen, size: 22),
//                 ),
//               ),
//               // Logo placeholder
//               Container(
//                 width: 44,
//                 height: 44,
//                 decoration: BoxDecoration(
//                   color: kLightGreen,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.eco, color: kGreen, size: 24),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           Text(
//             'Step ${currentPage + 1} of $totalPages',
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 8),
//           // Progress Bar
//           Row(
//             children: List.generate(totalPages, (i) {
//               final filled = i <= currentPage;
//               return Expanded(
//                 child: Container(
//                   margin: EdgeInsets.only(right: i < totalPages - 1 ? 4 : 0),
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: filled ? kGreen : const Color(0xFFD9D9D9),
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Green "Next" bottom button
// class _OnboardingNextButton extends StatelessWidget {
//   final String label;
//   final VoidCallback onTap;
//   final bool showSkip;
//   final VoidCallback? onSkip;
//
//   const _OnboardingNextButton({
//     required this.label,
//     required this.onTap,
//     this.showSkip = false,
//     this.onSkip,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
//       child: Column(
//         children: [
//           SizedBox(
//             width: double.infinity,
//             height: 54,
//             child: ElevatedButton(
//               onPressed: onTap,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kGreen,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 elevation: 0,
//               ),
//               child: Text(label,
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.w600)),
//             ),
//           ),
//           if (showSkip) ...[
//             const SizedBox(height: 10),
//             GestureDetector(
//               onTap: onSkip,
//               child: const Text(
//                 'Skip for now',
//                 style: TextStyle(
//                   color: kGreen,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────
// // STEP 1 – Goals
// // ─────────────────────────────────────────────
// class Step1GoalsPage extends StatefulWidget {
//   const Step1GoalsPage({super.key});
//
//   @override
//   State<Step1GoalsPage> createState() => _Step1GoalsPageState();
// }
//
// class _Step1GoalsPageState extends State<Step1GoalsPage> {
//   String? _selected = 'lose';
//
//   final _goals = [
//     {'id': 'lose', 'label': 'Lose Weight', 'icon': Icons.trending_down},
//     {'id': 'maintain', 'label': 'Maintain Weight', 'icon': Icons.balance},
//     {'id': 'gain', 'label': 'Gain Weight', 'icon': Icons.trending_up},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'What Goals Do you want to achieve?',
//             style: TextStyle(
//                 fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'This Helps Naijafit top generate a plan for your calorie intake',
//             style: TextStyle(fontSize: 13, color: Colors.black54),
//           ),
//           const SizedBox(height: 24),
//           Wrap(
//             spacing: 14,
//             runSpacing: 14,
//             children: _goals.map((g) {
//               final isSelected = _selected == g['id'];
//               return GestureDetector(
//                 onTap: () => setState(() => _selected = g['id'] as String),
//                 child: Container(
//                   width: (MediaQuery.of(context).size.width - 54) / 2,
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: isSelected ? kLightGreen : Colors.white,
//                     border: Border.all(
//                       color: isSelected ? kGreen : kBorderColor,
//                       width: isSelected ? 1.5 : 1,
//                     ),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: 38,
//                         height: 38,
//                         decoration: BoxDecoration(
//                           color: isSelected ? kGreen.withOpacity(0.15) : kLightGreen,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(g['icon'] as IconData,
//                             color: kGreen, size: 20),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(g['label'] as String,
//                           style: const TextStyle(
//                               fontSize: 14, fontWeight: FontWeight.w600)),
//                       const SizedBox(height: 2),
//                       Text(
//                         isSelected ? 'Selected' : 'Select',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: isSelected ? kGreen : Colors.black45,
//                           fontWeight: isSelected
//                               ? FontWeight.w600
//                               : FontWeight.normal,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────
// // STEP 2 – Set Target
// // ─────────────────────────────────────────────
// class Step2TargetPage extends StatefulWidget {
//   const Step2TargetPage({super.key});
//
//   @override
//   State<Step2TargetPage> createState() => _Step2TargetPageState();
// }
//
// class _Step2TargetPageState extends State<Step2TargetPage> {
//   final _weightCtrl = TextEditingController();
//   final _targetCtrl = TextEditingController();
//   String _weightUnit = 'KG';
//   String _targetUnit = 'KG';
//   String? _timeline;
//   bool _weeklyWeighIn = true;
//   bool _photoProgress = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("Let's set your target",
//               style:
//               TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 6),
//           const Text(
//               'We will create a personalized plan based on your goals',
//               style: TextStyle(fontSize: 13, color: Colors.black54)),
//           const SizedBox(height: 22),
//           const Text('Weight Details',
//               style:
//               TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
//           const SizedBox(height: 10),
//           _WeightField(
//               controller: _weightCtrl,
//               hint: 'Enter Weight....',
//               unit: _weightUnit,
//               onUnitChanged: (v) => setState(() => _weightUnit = v!)),
//           const SizedBox(height: 10),
//           _WeightField(
//               controller: _targetCtrl,
//               hint: 'Target Weight....',
//               unit: _targetUnit,
//               onUnitChanged: (v) => setState(() => _targetUnit = v!)),
//           const SizedBox(height: 16),
//           const Text('Timeline',
//               style:
//               TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
//           const SizedBox(height: 10),
//           _GreenDropdown(
//             hint: 'Select Timeline',
//             value: _timeline,
//             items: const ['4 Weeks', '8 Weeks', '12 Weeks', '16 Weeks'],
//             onChanged: (v) => setState(() => _timeline = v),
//           ),
//           const SizedBox(height: 16),
//           const Text('Progress Tracking',
//               style:
//               TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
//           const SizedBox(height: 10),
//           _ToggleRow(
//             icon: Icons.hourglass_empty,
//             title: 'Weekly Weighs-in',
//             subtitle: 'Track Your weight every week',
//             value: _weeklyWeighIn,
//             onChanged: (v) => setState(() => _weeklyWeighIn = v),
//           ),
//           const SizedBox(height: 8),
//           _ToggleRow(
//             icon: Icons.camera_alt_outlined,
//             title: 'Photo Progress',
//             subtitle: 'Take weekly progress photos',
//             value: _photoProgress,
//             onChanged: (v) => setState(() => _photoProgress = v),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }
//
// class _WeightField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hint;
//   final String unit;
//   final ValueChanged<String?> onUnitChanged;
//
//   const _WeightField({
//     required this.controller,
//     required this.hint,
//     required this.unit,
//     required this.onUnitChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         border: Border.all(color: kBorderColor),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: controller,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: hint,
//                 hintStyle:
//                 const TextStyle(color: Colors.black38, fontSize: 14),
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 14),
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             decoration: BoxDecoration(
//               color: kLightGreen,
//               borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(10),
//                   bottomRight: Radius.circular(10)),
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: unit,
//                 style: const TextStyle(
//                     color: kGreen,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600),
//                 items: ['KG', 'LBS']
//                     .map((u) =>
//                     DropdownMenuItem(value: u, child: Text(u)))
//                     .toList(),
//                 onChanged: onUnitChanged,
//                 icon: const Icon(Icons.keyboard_arrow_down,
//                     color: kGreen, size: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _GreenDropdown extends StatelessWidget {
//   final String hint;
//   final String? value;
//   final List<String> items;
//   final ValueChanged<String?> onChanged;
//
//   const _GreenDropdown({
//     required this.hint,
//     required this.value,
//     required this.items,
//     required this.onChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       padding: const EdgeInsets.symmetric(horizontal: 14),
//       decoration: BoxDecoration(
//         color: kLightGreen,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: value,
//           hint: Text(hint,
//               style: const TextStyle(color: kGreen, fontSize: 14)),
//           isExpanded: true,
//           icon: const Icon(Icons.keyboard_arrow_down, color: kGreen),
//           items: items
//               .map((i) => DropdownMenuItem(value: i, child: Text(i)))
//               .toList(),
//           onChanged: onChanged,
//         ),
//       ),
//     );
//   }
// }
//
// class _ToggleRow extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final bool value;
//   final ValueChanged<bool> onChanged;
//
//   const _ToggleRow({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.value,
//     required this.onChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 42,
//           height: 42,
//           decoration: BoxDecoration(
//               color: kLightGreen,
//               borderRadius: BorderRadius.circular(10)),
//           child: Icon(icon, color: kGreen, size: 22),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title,
//                   style: const TextStyle(
//                       fontSize: 14, fontWeight: FontWeight.w600)),
//               Text(subtitle,
//                   style: const TextStyle(
//                       fontSize: 12, color: Colors.black45)),
//             ],
//           ),
//         ),
//         Switch(
//           value: value,
//           onChanged: onChanged,
//           activeColor: kGreen,
//         ),
//       ],
//     );
//   }
// }
//
// // ─────────────────────────────────────────────
// // STEP 3 – Challenge  (placeholder — customize content)
// // ─────────────────────────────────────────────
// class Step3ChallengePage extends StatefulWidget {
//   const Step3ChallengePage({super.key});
//
//   @override
//   State<Step3ChallengePage> createState() => _Step3ChallengePageState();
// }
//
// class _Step3ChallengePageState extends State<Step3ChallengePage> {
//   int? _selected;
//
//   final _challenges = [
//     {'icon': Icons.restaurant_menu, 'title': 'Poor Portion Control', 'sub': 'Struggle with serving sizes'},
//     {'icon': Icons.fastfood, 'title': 'Unhealthy Food Choices', 'sub': 'Hard to pick nutritious options'},
//     {'icon': Icons.directions_run, 'title': 'Lack of Physical Activity', 'sub': 'Struggle staying active'},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "What's the biggest challenge you have in reaching your goal?",
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           const Text('Select the challenge that resonates most with you',
//               style: TextStyle(fontSize: 13, color: Colors.black54)),
//           const SizedBox(height: 24),
//           ..._challenges.asMap().entries.map((entry) {
//             final i = entry.key;
//             final c = entry.value;
//             final isSelected = _selected == i;
//             return GestureDetector(
//               onTap: () => setState(() => _selected = i),
//               child: Container(
//                 margin: const EdgeInsets.only(bottom: 12),
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                 decoration: BoxDecoration(
//                   color: isSelected ? kLightGreen : Colors.white,
//                   border: Border.all(
//                       color: isSelected ? kGreen : kBorderColor,
//                       width: isSelected ? 1.5 : 1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(c['icon'] as IconData, color: kGreen, size: 26),
//                     const SizedBox(width: 14),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(c['title'] as String,
//                               style: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600)),
//                           Text(c['sub'] as String,
//                               style: const TextStyle(
//                                   fontSize: 12, color: Colors.black45)),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       width: 22,
//                       height: 22,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                             color: isSelected ? kGreen : kBorderColor,
//                             width: 2),
//                         color: isSelected ? kGreen : Colors.transparent,
//                       ),
//                       child: isSelected
//                           ? const Icon(Icons.check,
//                           color: Colors.white, size: 14)
//                           : null,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────
// // STEP 4 – What to Expect
// // ─────────────────────────────────────────────
// class Step4ExpectPage extends StatelessWidget {
//   const Step4ExpectPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('What to expect with NaijaFit?',
//               style:
//               TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           const Text(
//             'Evidence-based results from our community of successful users. Real data, realistic expectations',
//             style: TextStyle(fontSize: 13, color: Colors.black54),
//           ),
//           const SizedBox(height: 20),
//           // Success Rate Card
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: kLightGreen,
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Success Rates by Weight Loss Goal',
//                     style: TextStyle(
//                         fontSize: 14, fontWeight: FontWeight.w700)),
//                 const SizedBox(height: 4),
//                 const Text('Based on 12-16 week programs',
//                     style:
//                     TextStyle(fontSize: 12, color: Colors.black54)),
//                 const SizedBox(height: 14),
//                 _ProgressRow(
//                     icon: Icons.trending_down,
//                     label: '5Kg Loss',
//                     weeks: '12 - 14 Weeks',
//                     progress: 0.75),
//                 const SizedBox(height: 10),
//                 _ProgressRow(
//                     icon: Icons.trending_up,
//                     label: '10Kg Loss',
//                     weeks: '12 - 16 Weeks',
//                     progress: 0.55),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           // Feature Chips
//           Row(
//             children: const [
//               Expanded(
//                 child: _FeatureChip(
//                     icon: Icons.bar_chart,
//                     title: 'Daily Chart',
//                     subtitle: 'Track Meals and progress'),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _FeatureChip(
//                     icon: Icons.camera_alt_outlined,
//                     title: 'Weekly',
//                     subtitle: 'Visual progress tracking'),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _FeatureChip(
//                     icon: Icons.emoji_events_outlined,
//                     title: 'Streak',
//                     subtitle: 'Stay consistent'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }
//
// class _ProgressRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String weeks;
//   final double progress;
//
//   const _ProgressRow(
//       {required this.icon,
//         required this.label,
//         required this.weeks,
//         required this.progress});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, color: kGreen, size: 18),
//             const SizedBox(width: 8),
//             Text(label,
//                 style: const TextStyle(
//                     fontSize: 13, fontWeight: FontWeight.w600)),
//             const Spacer(),
//             Text(weeks,
//                 style: const TextStyle(
//                     fontSize: 12, color: Colors.black54)),
//           ],
//         ),
//         const SizedBox(height: 6),
//         LinearProgressIndicator(
//           value: progress,
//           backgroundColor: Colors.white,
//           color: kGreen,
//           minHeight: 6,
//           borderRadius: BorderRadius.circular(4),
//         ),
//       ],
//     );
//   }
// }
//
// class _FeatureChip extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//
//   const _FeatureChip(
//       {required this.icon,
//         required this.title,
//         required this.subtitle});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: kLightGreen,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//                 color: kGreen.withOpacity(0.15),
//                 shape: BoxShape.circle),
//             child: Icon(icon, color: kGreen, size: 20),
//           ),
//           const SizedBox(height: 8),
//           Text(title,
//               style: const TextStyle(
//                   fontSize: 12, fontWeight: FontWeight.w700)),
//           const SizedBox(height: 2),
//           Text(subtitle,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 10, color: Colors.black45)),
//         ],
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────
// // STEP 5 – Diet Coach
// // ─────────────────────────────────────────────
// class Step5CoachPage extends StatefulWidget {
//   const Step5CoachPage({super.key});
//
//   @override
//   State<Step5CoachPage> createState() => _Step5CoachPageState();
// }
//
// class _Step5CoachPageState extends State<Step5CoachPage> {
//   String? _selected;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Do you currently work with a diet coach or nutritionist?',
//             style:
//             TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'This helps NaijaFit complement rather than replace professional guidance',
//             style: TextStyle(fontSize: 13, color: Colors.black54),
//           ),
//           const SizedBox(height: 24),
//           _CoachOption(
//             icon: Icons.check,
//             iconColor: kGreen,
//             title: 'Yes',
//             subtitle: 'I work with a professional',
//             isSelected: _selected == 'yes',
//             onTap: () => setState(() => _selected = 'yes'),
//           ),
//           const SizedBox(height: 12),
//           _CoachOption(
//             icon: Icons.close,
//             iconColor: Colors.red,
//             title: 'No',
//             subtitle: "I don't currently work with anyone",
//             isSelected: _selected == 'no',
//             onTap: () => setState(() => _selected = 'no'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _CoachOption extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor;
//   final String title;
//   final String subtitle;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const _CoachOption({
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.subtitle,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding:
//         const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: isSelected ? kLightGreen : Colors.white,
//           border: Border.all(
//               color: isSelected ? kGreen : kBorderColor,
//               width: isSelected ? 1.5 : 1),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: iconColor, size: 22),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title,
//                       style: const TextStyle(
//                           fontSize: 14, fontWeight: FontWeight.w600)),
//                   Text(subtitle,
//                       style: const TextStyle(
//                           fontSize: 12, color: Colors.black45)),
//                 ],
//               ),
//             ),
//             Container(
//               width: 22,
//               height: 22,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                     color: isSelected ? kGreen : kBorderColor, width: 2),
//                 color: isSelected ? kGreen : Colors.transparent,
//               ),
//               child: isSelected
//                   ? const Icon(Icons.check,
//                   color: Colors.white, size: 14)
//                   : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────
// // STEP 6 – About You
// // ─────────────────────────────────────────────
// class Step6AboutYouPage extends StatefulWidget {
//   const Step6AboutYouPage({super.key});
//
//   @override
//   State<Step6AboutYouPage> createState() => _Step6AboutYouPageState();
// }
//
// class _Step6AboutYouPageState extends State<Step6AboutYouPage> {
//   final _ageCtrl = TextEditingController();
//   final _heightCtrl = TextEditingController();
//   String _heightUnit = 'Cm';
//   String? _activityLevel;
//   String _gender = 'male';
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Tell Us About Yourself',
//               style:
//               TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 6),
//           const Text('This will help us a lot to tailor a very well plan for you',
//               style: TextStyle(fontSize: 13, color: Colors.black54)),
//           const SizedBox(height: 20),
//           // Age
//           Container(
//             height: 50,
//             decoration: BoxDecoration(
//               border: Border.all(color: kBorderColor),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _ageCtrl,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       hintText: 'Age....',
//                       hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 14),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 14),
//                   decoration: BoxDecoration(
//                     color: kLightGreen,
//                     borderRadius: const BorderRadius.only(
//                         topRight: Radius.circular(10),
//                         bottomRight: Radius.circular(10)),
//                   ),
//                   child: const Text('KG',
//                       style: TextStyle(
//                           color: kGreen,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600)),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 10),
//           // Height
//           _WeightField(
//             controller: _heightCtrl,
//             hint: 'Height....',
//             unit: _heightUnit,
//             onUnitChanged: (v) => setState(() => _heightUnit = v!),
//           ),
//           const SizedBox(height: 10),
//           // Activity Level
//           _GreenDropdown(
//             hint: 'Activity Level',
//             value: _activityLevel,
//             items: const [
//               'Sedentary',
//               'Lightly Active',
//               'Moderately Active',
//               'Very Active'
//             ],
//             onChanged: (v) => setState(() => _activityLevel = v),
//           ),
//           const SizedBox(height: 20),
//           // Gender Selector
//           Row(
//             children: [
//               _GenderCard(
//                 icon: Icons.male,
//                 label: 'Male',
//                 isSelected: _gender == 'male',
//                 onTap: () => setState(() => _gender = 'male'),
//               ),
//               const SizedBox(width: 12),
//               _GenderCard(
//                 icon: Icons.female,
//                 label: 'Female',
//                 isSelected: _gender == 'female',
//                 onTap: () => setState(() => _gender = 'female'),
//               ),
//               const SizedBox(width: 12),
//               _GenderCard(
//                 icon: Icons.transgender,
//                 label: 'Other',
//                 isSelected: _gender == 'other',
//                 onTap: () => setState(() => _gender = 'other'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }
//
// class _GenderCard extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const _GenderCard({
//     required this.icon,
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 90,
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(
//           color: isSelected ? kLightGreen : Colors.white,
//           border: Border.all(
//               color: isSelected ? kGreen : kBorderColor,
//               width: isSelected ? 1.5 : 1),
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Column(
//           children: [
//             Container(
//               width: 42,
//               height: 42,
//               decoration: BoxDecoration(
//                   color: isSelected
//                       ? kGreen.withOpacity(0.15)
//                       : kLightGreen,
//                   shape: BoxShape.circle),
//               child: Icon(icon, color: kGreen, size: 22),
//             ),
//             const SizedBox(height: 8),
//             Text(label,
//                 style: const TextStyle(
//                     fontSize: 13, fontWeight: FontWeight.w600)),
//             const SizedBox(height: 2),
//             Text(
//               isSelected ? 'Selected' : 'Select',
//               style: TextStyle(
//                 fontSize: 11,
//                 color: isSelected ? kGreen : Colors.black45,
//                 fontWeight: isSelected
//                     ? FontWeight.w600
//                     : FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────
// // STEP 7 – Personalized Plan
// // ─────────────────────────────────────────────
// class Step7PlanPage extends StatefulWidget {
//   final VoidCallback onGetStarted;
//
//   const Step7PlanPage({super.key, required this.onGetStarted});
//
//   @override
//   State<Step7PlanPage> createState() => _Step7PlanPageState();
// }
//
// class _Step7PlanPageState extends State<Step7PlanPage> {
//   bool _macroExpanded = false;
//   bool _summaryExpanded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Your Personalized plan',
//                     style: TextStyle(
//                         fontSize: 22, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 6),
//                 const Text(
//                     'This is your personalized plan and summary fo your target and details',
//                     style:
//                     TextStyle(fontSize: 13, color: Colors.black54)),
//                 const SizedBox(height: 20),
//                 // Calorie Card
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 28),
//                   decoration: BoxDecoration(
//                     color: kLightGreen,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     children: const [
//                       Text('Your Daily Calorie Target',
//                           style: TextStyle(
//                               fontSize: 13, color: Colors.black54)),
//                       SizedBox(height: 6),
//                       Text('2057',
//                           style: TextStyle(
//                               fontSize: 48,
//                               fontWeight: FontWeight.bold,
//                               color: kGreen)),
//                       Text('Calories',
//                           style: TextStyle(
//                               fontSize: 14, color: Colors.black54)),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 // Macro Breakdown
//                 _ExpandableSection(
//                   title: 'Macro Breakdown',
//                   isExpanded: _macroExpanded,
//                   onTap: () =>
//                       setState(() => _macroExpanded = !_macroExpanded),
//                   child: Column(
//                     children: const [
//                       _MacroRow(label: 'Carbs', value: '257g', percent: 0.50),
//                       SizedBox(height: 8),
//                       _MacroRow(label: 'Protein', value: '154g', percent: 0.30),
//                       SizedBox(height: 8),
//                       _MacroRow(label: 'Fats', value: '57g', percent: 0.20),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 // Plan Summary
//                 _ExpandableSection(
//                   title: 'Plan Summary',
//                   isExpanded: _summaryExpanded,
//                   onTap: () =>
//                       setState(() => _summaryExpanded = !_summaryExpanded),
//                   child: const Text(
//                     'Your personalized NaijaFit plan is tailored based on your goals, activity level, and dietary preferences. Stick to your daily calorie target for best results.',
//                     style: TextStyle(fontSize: 13, color: Colors.black54),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//         ),
//         // Get Started Button
//         Padding(
//           padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
//           child: SizedBox(
//             width: double.infinity,
//             height: 54,
//             child: ElevatedButton(
//               onPressed: widget.onGetStarted,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kGreen,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30)),
//                 elevation: 0,
//               ),
//               child: const Text('Get Started!',
//                   style: TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.w600)),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _ExpandableSection extends StatelessWidget {
//   final String title;
//   final bool isExpanded;
//   final VoidCallback onTap;
//   final Widget child;
//
//   const _ExpandableSection({
//     required this.title,
//     required this.isExpanded,
//     required this.onTap,
//     required this.child,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: kLightGreen,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           InkWell(
//             onTap: onTap,
//             borderRadius: BorderRadius.circular(12),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 16, vertical: 14),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(title,
//                       style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: kGreen)),
//                   Icon(
//                     isExpanded
//                         ? Icons.keyboard_arrow_up
//                         : Icons.keyboard_arrow_down,
//                     color: kGreen,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (isExpanded)
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
//               child: child,
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// class _MacroRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final double percent;
//
//   const _MacroRow(
//       {required this.label,
//         required this.value,
//         required this.percent});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(label,
//                 style: const TextStyle(
//                     fontSize: 13, fontWeight: FontWeight.w500)),
//             Text(value,
//                 style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: kGreen)),
//           ],
//         ),
//         const SizedBox(height: 4),
//         LinearProgressIndicator(
//           value: percent,
//           backgroundColor: Colors.white,
//           color: kGreen,
//           minHeight: 6,
//           borderRadius: BorderRadius.circular(4),
//         ),
//       ],
//     );
//   }
// }