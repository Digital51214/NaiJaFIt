import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        height: size.height * 0.058,
        width: size.height * 0.058,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xff3A8DD9).withOpacity(0.10),
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}