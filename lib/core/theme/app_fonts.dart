import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppFonts {
  static TextStyle get displayLarge => GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleLarge => GoogleFonts.outfit(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyLarge =>
      GoogleFonts.roboto(fontSize: 16, color: AppColors.textPrimary);

  static TextStyle get bodyMedium =>
      GoogleFonts.roboto(fontSize: 14, color: AppColors.textSecondary);

  static TextStyle get labelLarge => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.surface,
  );
}
