import 'package:flutter/material.dart';

class Emptyscreen extends StatefulWidget {
  const Emptyscreen({super.key});

  @override
  State<Emptyscreen> createState() => _EmptyscreenState();
}

class _EmptyscreenState extends State<Emptyscreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double screenHeight = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Top Navigation Bar ───
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.015,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: screenWidth * 0.135,
                      height: screenWidth * 0.135,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF3DE),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.chevron_left,
                          color: const Color(0xFF2E7D32),
                          size: screenWidth * 0.1,
                        ),
                      ),
                    ),
                  ),

                  // Logo Image
                  Image.asset(
                    'assets/images/LOGO.png',
                    width: screenWidth * 0.16,
                    height: screenWidth * 0.16,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.04),

            // ─── Center Lock Icon ───
            Center(
              child: Container(
                width: screenWidth * 0.4,
                height: screenWidth * 0.4,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF3DE),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.lock_open_outlined,
                    color: const Color(0xFF2E7D32),
                    size: screenWidth * 0.22,
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.055),

            // ─── Title ───
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Text(
                'No Meals Logged Yet',
                style: TextStyle(
                  fontSize: screenWidth * 0.058,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.015),

            // ─── Subtitle ───
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Text(
                'Start by adding your first meal to track your calories and vitality.',
                style: TextStyle(
                  fontSize: screenWidth * 0.039,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.04),

            // ─── Info Card ───
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.025,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3DE),
                  borderRadius: BorderRadius.circular(screenWidth * 0.08),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Icon Circle
                    Container(
                      width: screenWidth * 0.08,
                      height: screenWidth * 0.08,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E7D32),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: screenWidth * 0.045,
                        ),
                      ),
                    ),

                    SizedBox(width: screenWidth * 0.04),

                    // Info Text
                    Expanded(
                      child: Text(
                        'Did you know? Logging breakfast before 9 AM improves metabolism by 12%',
                        style: TextStyle(
                          fontSize: screenWidth * 0.039,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}