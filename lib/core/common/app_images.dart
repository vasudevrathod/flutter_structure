import 'package:flutter/material.dart';

enum AppImages { png, jpg, webp }

extension ImageWidget on String {
  // Shortcut to get an Image.asset widget
  Image img({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AppImages imageType = AppImages.png,
  }) {
    return Image.asset(
      'assets/images/$this.${imageType.name}', // Assuming you use PNGs mostly
      width: width,
      height: height,
      fit: fit,
    );
  }
}

// Use
// 'logo'.img(width: 50) // Looks for assets/images/logo.png

// if not PNG
// 'background'.img(
//   imageType: AppImages.jpg, 
//   fit: BoxFit.cover,
// ) 
