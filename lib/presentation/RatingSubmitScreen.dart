import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naijafit/widgets/ratingsubmitdiologe.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _selectedStars = 4;
  final TextEditingController _commentController = TextEditingController();
  final List<String?> _photos = [null, null, null];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Gallery se image pick karo
  Future<void> _pickImage(int index) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _photos[index] = image.path;
      });
    }
  }

  // Image remove karo
  void _removeImage(int index) {
    setState(() {
      _photos[index] = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final double w = mq.size.width;
    final double h = mq.size.height;
    final double ts = mq.textScaleFactor;

    double rf(double fs) {
      final scaled = fs * (w / 375);
      return scaled.clamp(fs * 0.85, fs * 1.20);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Top bar ──────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04,
                  vertical: h * 0.015,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: w * 0.1,
                        height: w * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(w * 0.03),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.chevron_left_rounded,
                          color: Colors.black87,
                          size: w * 0.06,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Review",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: rf(18) / ts,
                          fontFamily: "semibold",
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: w * 0.1),
                  ],
                ),
              ),

              SizedBox(height: h * 0.01),

              // ── Main card ────────────────────────────────────────
              Container(
                margin: EdgeInsets.symmetric(horizontal: w * 0.04),
                padding: EdgeInsets.all(w * 0.055),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(w * 0.06),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Food image + name
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: w * 0.22,
                            height: w * 0.22,
                            decoration: BoxDecoration(
                              color: const Color(0xFF026F1A),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF026F1A)
                                      .withOpacity(0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lunch_dining_rounded,
                                  color: Colors.white,
                                  size: w * 0.1,
                                ),
                                SizedBox(height: h * 0.004),
                                Text(
                                  "Food image",
                                  style: TextStyle(
                                    fontSize: rf(9) / ts,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: h * 0.014),
                          Text(
                            "Crispy Chicken",
                            style: TextStyle(
                              fontSize: rf(16) / ts,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                              fontFamily: "semibold",
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.028),
                    _divider(),
                    SizedBox(height: h * 0.024),

                    // ── Star rating ──────────────────────────────
                    Text(
                      "How was your food?",
                      style: TextStyle(
                        fontSize: rf(14) / ts,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        fontFamily: "regular",
                      ),
                    ),
                    SizedBox(height: h * 0.012),
                    Row(
                      children: List.generate(5, (index) {
                        final filled = index < _selectedStars;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedStars = index + 1),
                          child: Padding(
                            padding: EdgeInsets.only(right: w * 0.02),
                            child: Icon(
                              filled
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: filled
                                  ? const Color(0xFF026F1A)
                                  : Colors.grey.shade300,
                              size: w * 0.10,
                            ),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: h * 0.026),
                    _divider(),
                    SizedBox(height: h * 0.022),

                    // ── Add Photo ────────────────────────────────
                    Text(
                      "Add Photo",
                      style: TextStyle(
                        fontSize: rf(14) / ts,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        fontFamily: "regular",
                      ),
                    ),
                    SizedBox(height: h * 0.012),
                    Row(
                      children: List.generate(3, (index) {
                        final hasPhoto = _photos[index] != null;
                        return Padding(
                          padding: EdgeInsets.only(right: w * 0.03),
                          child: GestureDetector(
                            // Plus per click → gallery open
                            onTap: hasPhoto
                                ? null
                                : () => _pickImage(index),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: w * 0.17,
                                  height: w * 0.17,
                                  decoration: BoxDecoration(
                                    color: hasPhoto
                                        ? Colors.transparent
                                        : const Color(0xFFF5F5F5),
                                    borderRadius:
                                    BorderRadius.circular(w * 0.03),
                                    border: Border.all(
                                      color: hasPhoto
                                          ? const Color(0xFF026F1A)
                                          : Colors.grey.shade200,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: hasPhoto
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        w * 0.03),
                                    child: Image.file(
                                      File(_photos[index]!),
                                      fit: BoxFit.cover,
                                      width: w * 0.17,
                                      height: w * 0.17,
                                    ),
                                  )
                                      : Icon(
                                    Icons.add_rounded,
                                    color: Colors.black38,
                                    size: w * 0.07,
                                  ),
                                ),

                                // Cross button — sirf tab show ho jab image ho
                                if (hasPhoto)
                                  Positioned(
                                    top: -6,
                                    right: -6,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(index),
                                      child: Container(
                                        width: w * 0.055,
                                        height: w * 0.055,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF026F1A),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close_rounded,
                                          color: Colors.white,
                                          size: w * 0.035,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: h * 0.026),
                    _divider(),
                    SizedBox(height: h * 0.022),

                    // ── Comment ──────────────────────────────────
                    Text(
                      "Comment",
                      style: TextStyle(
                        fontSize: rf(14) / ts,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: h * 0.012),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(w * 0.04),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _commentController,
                        maxLines: 5,
                        style: TextStyle(
                          fontSize: rf(13.5) / ts,
                          fontFamily: "regular",
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: "Type text here",
                          hintStyle: TextStyle(
                            fontFamily: "regular",
                            fontSize: rf(13.5) / ts,
                            color: Colors.black26,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(w * 0.04),
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.032),

                    // ── Submit button ────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: h * 0.06,
                      child: ElevatedButton(
                        onPressed: () {
                          ReviewSuccessDialog.show(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF026F1A),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w * 0.1),
                          ),
                          padding:
                          EdgeInsets.symmetric(vertical: h * 0.002),
                        ),
                        child: Text(
                          "Submit review",
                          style: TextStyle(
                            fontSize: rf(15) / ts,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: "extrabold",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() => Container(
    height: 1,
    color: Colors.grey.shade100,
  );
}