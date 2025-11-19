/// Design Tokens: "Paper & Ink" Design System
///
/// The immutable visual style guide for Bloom Scroll.
/// Use these exact hex codes, fonts, and spacing rules for all UI components.
library;

import 'package:flutter/material.dart';

/// Color Palette: The Canvas (Backgrounds)
class BloomColors {
  BloomColors._(); // Private constructor to prevent instantiation

  // The Canvas (Backgrounds)
  static const Color primaryBg = Color(0xFFFDFCF8); // Warm Off-White / "Old Paper"
  static const Color surfaceBg = Color(0xFFF4F1EA); // Slightly darker paper for cards/containers
  static const Color skeletonBg = Color(0xFFE6E2D6); // For loading states - warm gray

  // The Ink (Typography & Icons)
  static const Color inkPrimary = Color(0xFF1A1A1A); // Soft Black - rarely use pure #000
  static const Color inkSecondary = Color(0xFF595959); // Graphite - for metadata/subtitles
  static const Color inkTertiary = Color(0xFF8C8C8C); // Stone - for disabled states/borders

  // The Garden (Data & Accents)
  static const Color bloomRed = Color(0xFFD9534F); // Muted Coral - for "Action" or "Alerts"
  static const Color growthGreen = Color(0xFF2D6A4F); // Botanical Green - for positive trends/serendipity
  static const Color chartLine = Color(0xFF1A1A1A); // Charts should be drawn in Ink
  static const Color chartFill = Color(0x1A2D6A4F); // growth_green with 10% opacity
}

/// Typography: Font Families and Text Styles
class BloomTypography {
  BloomTypography._();

  // Font Families
  static const String headingFont = 'Libre Baskerville';
  static const String bodyFont = 'Inter';

  // Heading Styles (Libre Baskerville)
  static const TextStyle h1 = TextStyle(
    fontFamily: headingFont,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: BloomColors.inkPrimary,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: headingFont,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: BloomColors.inkPrimary,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: headingFont,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: BloomColors.inkPrimary,
    height: 1.3,
  );

  // Body Styles (Inter)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: BloomColors.inkPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: BloomColors.inkPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: BloomColors.inkSecondary,
    height: 1.5,
  );

  // UI Styles (Inter SemiBold)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: BloomColors.inkPrimary,
    height: 1.2,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: BloomColors.inkPrimary,
    height: 1.2,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: BloomColors.inkPrimary,
    height: 1.2,
  );

  // Metadata/Caption (Inter Regular, Secondary Ink)
  static const TextStyle caption = TextStyle(
    fontFamily: bodyFont,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: BloomColors.inkSecondary,
    height: 1.3,
    letterSpacing: 0.2,
  );

  // Data Numbers (Inter with Tabular Figures)
  static const TextStyle dataLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: BloomColors.inkPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle dataMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: BloomColors.inkPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle dataSmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: BloomColors.inkPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}

/// Layout & Spacing Constants
class BloomSpacing {
  BloomSpacing._();

  // Grid Unit: 8px
  static const double unit = 8.0;

  // Standard Padding: 20px (not 16px - give it breath)
  static const double screenPadding = 20.0;
  static const EdgeInsets screenPaddingAll = EdgeInsets.all(screenPadding);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: screenPadding);
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(vertical: screenPadding);

  // Component Spacing
  static const double xs = 4.0;  // 0.5 units
  static const double sm = 8.0;  // 1 unit
  static const double md = 16.0; // 2 units
  static const double lg = 24.0; // 3 units
  static const double xl = 32.0; // 4 units

  // Corner Radius
  static const double cardRadius = 4.0; // Subtle, near-sharp to mimic cut paper
  static const double buttonRadius = 4.0; // Can also be 0.0 for rectangular pill
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(cardRadius));
  static const BorderRadius buttonBorderRadius = BorderRadius.all(Radius.circular(buttonRadius));

  // Elevation: 0 (No shadows - use borders instead)
  static const double elevation = 0.0;

  // Border
  static const double borderWidth = 1.0;
  static const BorderSide defaultBorder = BorderSide(
    color: BloomColors.inkTertiary,
    width: borderWidth,
  );
}

/// Chart Configuration (fl_chart)
class BloomChartConfig {
  BloomChartConfig._();

  // Chart Colors
  static const Color lineColor = BloomColors.chartLine;
  static const Color fillColor = BloomColors.chartFill;
  static const Color touchColor = BloomColors.bloomRed;

  // Chart Settings
  static const bool showGrid = false; // Remove background grids completely
  static const bool showAxisTitles = false; // Remove X/Y labels unless critical
  static const bool showBorder = false; // No box around the chart

  // Touch Interaction
  static const double touchSpotRadius = 6.0;
  static const double lineWidth = 2.0;
}
