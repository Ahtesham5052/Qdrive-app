import 'package:flutter/material.dart';

class ElementSettings {
  const ElementSettings._();

  static List<String> classList(dynamic classes) {
    if (classes is List) {
      return classes.map((e) => e.toString()).toList();
    }
    return const [];
  }

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Resolves spacing utility classes using the QDrive spacing scale.
  ///
  /// Scale:
  /// 2, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52
  static double spacingFromClasses(List<String> classes) {
    if (classes.contains('space-none')) return 0;
    if (classes.contains('space-2xs')) return 2;
    if (classes.contains('space-xs')) return 4;
    if (classes.contains('space-sm')) return 8;
    if (classes.contains('space-md')) return 12;
    if (classes.contains('space-lg')) return 16;
    if (classes.contains('space-xl')) return 20;
    if (classes.contains('space-2xl')) return 24;
    if (classes.contains('space-3xl')) return 28;
    if (classes.contains('space-4xl')) return 32;
    if (classes.contains('space-5xl')) return 36;
    if (classes.contains('space-6xl')) return 40;
    if (classes.contains('space-7xl')) return 44;
    if (classes.contains('space-8xl')) return 48;
    if (classes.contains('space-9xl')) return 52;
    return 0;
  }

  /// Resolves padding utility classes using the QDrive spacing scale.
  static EdgeInsets padding(List<String> classes) {
    if (classes.contains('p-none')) return EdgeInsets.zero;
    if (classes.contains('p-2xs')) return const EdgeInsets.all(2);
    if (classes.contains('p-xs')) return const EdgeInsets.all(4);
    if (classes.contains('p-sm')) return const EdgeInsets.all(8);
    if (classes.contains('p-md')) return const EdgeInsets.all(12);
    if (classes.contains('p-lg')) return const EdgeInsets.all(16);
    if (classes.contains('p-xl')) return const EdgeInsets.all(20);
    if (classes.contains('p-2xl')) return const EdgeInsets.all(24);
    if (classes.contains('p-3xl')) return const EdgeInsets.all(28);
    if (classes.contains('p-4xl')) return const EdgeInsets.all(32);
    if (classes.contains('p-5xl')) return const EdgeInsets.all(36);
    if (classes.contains('p-6xl')) return const EdgeInsets.all(40);
    if (classes.contains('p-7xl')) return const EdgeInsets.all(44);
    if (classes.contains('p-8xl')) return const EdgeInsets.all(48);
    if (classes.contains('p-9xl')) return const EdgeInsets.all(52);

    EdgeInsets result = EdgeInsets.zero;

    result += _sidePadding(classes, 'pt', 'top');
    result += _sidePadding(classes, 'pb', 'bottom');
    result += _sidePadding(classes, 'pl', 'left');
    result += _sidePadding(classes, 'pr', 'right');

    result += _axisPadding(classes, 'px', Axis.horizontal);
    result += _axisPadding(classes, 'py', Axis.vertical);

    return result;
  }

  static EdgeInsets _sidePadding(
    List<String> classes,
    String prefix,
    String side,
  ) {
    final value = _spacingValue(classes, prefix);
    if (value == null) return EdgeInsets.zero;

    switch (side) {
      case 'top':
        return EdgeInsets.only(top: value);
      case 'bottom':
        return EdgeInsets.only(bottom: value);
      case 'left':
        return EdgeInsets.only(left: value);
      case 'right':
        return EdgeInsets.only(right: value);
      default:
        return EdgeInsets.zero;
    }
  }

  /// Resolves margin utility classes using the QDrive spacing scale.
  static EdgeInsets margin(List<String> classes) {
    if (classes.contains('m-none')) return EdgeInsets.zero;
    if (classes.contains('m-2xs')) return const EdgeInsets.all(2);
    if (classes.contains('m-xs')) return const EdgeInsets.all(4);
    if (classes.contains('m-sm')) return const EdgeInsets.all(8);
    if (classes.contains('m-md')) return const EdgeInsets.all(12);
    if (classes.contains('m-lg')) return const EdgeInsets.all(16);
    if (classes.contains('m-xl')) return const EdgeInsets.all(20);
    if (classes.contains('m-2xl')) return const EdgeInsets.all(24);
    if (classes.contains('m-3xl')) return const EdgeInsets.all(28);
    if (classes.contains('m-4xl')) return const EdgeInsets.all(32);
    if (classes.contains('m-5xl')) return const EdgeInsets.all(36);
    if (classes.contains('m-6xl')) return const EdgeInsets.all(40);
    if (classes.contains('m-7xl')) return const EdgeInsets.all(44);
    if (classes.contains('m-8xl')) return const EdgeInsets.all(48);
    if (classes.contains('m-9xl')) return const EdgeInsets.all(52);

    EdgeInsets result = EdgeInsets.zero;

    result += _sideMargin(classes, 'mt', 'top');
    result += _sideMargin(classes, 'mb', 'bottom');
    result += _sideMargin(classes, 'ml', 'left');
    result += _sideMargin(classes, 'mr', 'right');
    result += _axisMargin(classes, 'mx', Axis.horizontal);
    result += _axisMargin(classes, 'my', Axis.vertical);

    return result;
  }

  /// Internal helper for axis padding classes like `px-md` and `py-lg`.
  static EdgeInsets _axisPadding(
    List<String> classes,
    String prefix,
    Axis axis,
  ) {
    final value = _spacingValue(classes, prefix);
    if (value == null) return EdgeInsets.zero;

    if (axis == Axis.horizontal) {
      return EdgeInsets.symmetric(horizontal: value);
    }

    return EdgeInsets.symmetric(vertical: value);
  }

  /// Internal helper for axis margin classes like `mx-md` and `my-lg`.
  static EdgeInsets _axisMargin(
    List<String> classes,
    String prefix,
    Axis axis,
  ) {
    final value = _spacingValue(classes, prefix);
    if (value == null) return EdgeInsets.zero;

    if (axis == Axis.horizontal) {
      return EdgeInsets.symmetric(horizontal: value);
    }

    return EdgeInsets.symmetric(vertical: value);
  }

  /// Internal helper for side margin classes like `mt-md`, `ml-sm`, `mr-xl`.
  static EdgeInsets _sideMargin(
    List<String> classes,
    String prefix,
    String side,
  ) {
    final value = _spacingValue(classes, prefix);
    if (value == null) return EdgeInsets.zero;

    switch (side) {
      case 'top':
        return EdgeInsets.only(top: value);
      case 'bottom':
        return EdgeInsets.only(bottom: value);
      case 'left':
        return EdgeInsets.only(left: value);
      case 'right':
        return EdgeInsets.only(right: value);
      default:
        return EdgeInsets.zero;
    }
  }

  /// Reads spacing class value from a prefix.
  ///
  /// Example:
  /// - `mt-md` returns 12
  /// - `px-lg` returns 16
  /// - `space-2xl` returns 24
  static double? _spacingValue(List<String> classes, String prefix) {
    for (final className in classes) {
      if (!className.startsWith('$prefix-')) continue;

      final token = className.replaceFirst('$prefix-', '');

      switch (token) {
        case 'none':
          return 0;
        case '2xs':
          return 2;
        case 'xs':
          return 4;
        case 'sm':
          return 8;
        case 'md':
          return 12;
        case 'lg':
          return 16;
        case 'xl':
          return 20;
        case '2xl':
          return 24;
        case '3xl':
          return 28;
        case '4xl':
          return 32;
        case '5xl':
          return 36;
        case '6xl':
          return 40;
        case '7xl':
          return 44;
        case '8xl':
          return 48;
        case '9xl':
          return 52;
      }
    }

    return null;
  }

  static Color color(String? hex, {Color fallback = Colors.transparent}) {
    if (hex == null || hex.isEmpty) return fallback;

    final cleanHex = hex.replaceAll('#', '');

    if (cleanHex.length == 6) {
      return Color(int.parse('FF$cleanHex', radix: 16));
    }

    if (cleanHex.length == 8) {
      return Color(int.parse(cleanHex, radix: 16));
    }

    return fallback;
  }

  static double size(String? value) {
    switch (value) {
      case 'size-sm':
        return 34;
      case 'size-md':
        return 42;
      case 'size-lg':
        return 44;
      case 'size-xl':
        return 52;
      default:
        return 42;
    }
  }

  static double iconSize(String? value) {
    switch (value) {
      case 'icon-sm':
        return 16;
      case 'icon-md':
        return 20;
      case 'icon-lg':
        return 24;
      case 'icon-xl':
        return 28;
      case 'icon-2xl':
        return 32;
      case 'icon-4xl':
        return 40;
      default:
        return 20;
    }
  }

  static double dotWidth(String? value) {
    switch (value) {
      case 'dot-xs':
        return 4;
      case 'dot-sm':
        return 8;
      case 'dot-md':
        return 16;
      case 'dot-lg':
        return 20;
      default:
        return 4;
    }
  }

  static double dotHeight(String? value) {
    switch (value) {
      case 'dot-xs':
        return 4;
      case 'dot-sm':
        return 8;
      case 'dot-md':
        return 16;
      case 'dot-lg':
        return 20;
      default:
        return 4;
    }
  }

  static double positionOffset(String? value) {
    switch (value) {
      case 'bottom-xs':
        return 8;
      case 'bottom-sm':
        return 12;
      case 'bottom-md':
        return 16;
      case 'bottom-lg':
        return 24;
      default:
        return 12;
    }
  }

  static Color background(BuildContext context, List<String> classes) {
    final theme = Theme.of(context);
    final dark = isDark(context);

    if (classes.contains('bg-app')) {
      return theme.scaffoldBackgroundColor;
    }
    if (classes.contains('bg-glass')) {
      return dark
          ? const Color(0xFF161616).withOpacity(0.85)
          : Colors.white.withOpacity(0.90);
    }

    if (classes.contains('bg-surface')) {
      return theme.colorScheme.surface;
    }
    if (classes.contains('bg-white-opacity-soft')) {
      return Colors.white.withOpacity(0.18);
    }
    if (classes.contains('bg-purple')) {
      return const Color(0xFF5B21B6);
    }

    if (classes.contains('bg-navy')) {
      return const Color(0xFF172234);
    }

    if (classes.contains('bg-purple-dark')) {
      return const Color(0xFF4C1D95);
    }
    if (classes.contains('bg-primary')) {
      return theme.colorScheme.primary;
    }

    if (classes.contains('bg-secondary')) {
      return theme.colorScheme.secondary;
    }

    if (classes.contains('bg-card')) {
      return dark
          ? const Color(0xFF151515)
          : const Color.fromARGB(255, 224, 224, 224);
    }

    if (classes.contains('bg-card-soft')) {
      return dark ? const Color(0xFF1D1D1D) : const Color(0xFFF7F7F7);
    }

    if (classes.contains('bg-card-dark')) {
      return const Color(0xFF1D1D1D);
    }

    if (classes.contains('bg-muted')) {
      return dark ? const Color(0xFF242424) : const Color(0xFFEFEFEF);
    }

    if (classes.contains('bg-muted-fill')) {
      return dark
          ? const Color(0xFF242424)
          : const Color.fromARGB(255, 175, 174, 174);
    }

    if (classes.contains('bg-success-soft')) {
      return const Color(0xFF33B769);
    }

    if (classes.contains('bg-info-soft')) {
      return dark ? const Color(0xFF071A3D) : const Color(0xFFEFF6FF);
    }

    if (classes.contains('bg-info-dark')) {
      return const Color(0xff13224C);
    }

    if (classes.contains('bg-warning-soft')) {
      return dark ? const Color(0xFF3A2403) : const Color(0xFFFFFBEB);
    }

    if (classes.contains('bg-danger-soft')) {
      return dark ? const Color(0xFF3A0A0A) : const Color(0xFFFEF2F2);
    }

    if (classes.contains('bg-success')) {
      return const Color(0xFF00C776);
    }

    if (classes.contains('bg-inverse-card')) {
      return dark ? Colors.white : Colors.black;
    }

    if (classes.contains('bg-success-dark')) {
      return dark
          ? const Color.fromARGB(255, 20, 66, 31)
          : const Color.fromARGB(255, 194, 235, 204);
    }

    if (classes.contains('bg-info')) {
      return const Color(0xFF3B82F6);
    }

    if (classes.contains('bg-grey')) {
      return const Color(0xFFD1D1D1);
    }

    if (classes.contains('bg-warning')) {
      return const Color(0xFFF59E0B);
    }

    if (classes.contains('bg-danger')) {
      return const Color(0xFFEF4444);
    }

    if (classes.contains('bg-white-opacity')) {
      return Colors.white.withOpacity(0.55);
    }

    if (classes.contains('bg-black-opacity')) {
      return Colors.black.withOpacity(0.25);
    }

    if (classes.contains('bg-white')) {
      return Colors.white;
    }

    if (classes.contains('bg-black')) {
      return Colors.black;
    }

    if (classes.contains('bg-transparent')) {
      return Colors.transparent;
    }

    return Colors.transparent;
  }

  static Color textColor(BuildContext context, List<String> classes) {
    final theme = Theme.of(context);
    final dark = isDark(context);

    if (classes.contains('text-primary')) {
      return theme.colorScheme.primary;
    }

    if (classes.contains('text-secondary')) {
      return theme.colorScheme.secondary;
    }

    if (classes.contains('text-body')) {
      return dark ? Colors.white : const Color(0xFF111111);
    }

    if (classes.contains('text-surface')) {
      return dark ? const Color(0xFF111111) : const Color(0xFFFFFFFF);
    }

    if (classes.contains('text-muted')) {
      return dark ? const Color(0xFFA1A1AA) : const Color(0xFF6B7280);
    }

    if (classes.contains('text-muted-dark')) {
      return dark
          ? const Color.fromARGB(255, 108, 108, 110)
          : const Color(0xFF6B7280);
    }

    if (classes.contains('text-info')) {
      return const Color(0xFF8EC5FF);
    }
    if (classes.contains('text-inverse-body')) {
      return dark ? Colors.black : Colors.white;
    }

    if (classes.contains('text-inverse-muted')) {
      return dark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB);
    }

    if (classes.contains('text-info-soft')) {
      return const Color.fromARGB(255, 109, 165, 255);
    }
    if (classes.contains('text-info-dark')) {
      return const Color(0xFF957AC5);
    }

    if (classes.contains('text-success')) {
      return const Color(0xFF00C776);
    }
    if (classes.contains('text-success-soft')) {
      return dark
          ? const Color.fromARGB(255, 83, 255, 154)
          : const Color.fromARGB(255, 0, 135, 59);
    }
    if (classes.contains('text-success-dark')) {
      return dark
          ? const Color.fromARGB(255, 20, 66, 31)
          : const Color.fromARGB(255, 194, 235, 204);
    }

    if (classes.contains('text-warning')) {
      return const Color(0xFFF59E0B);
    }

    if (classes.contains('text-danger')) {
      return const Color(0xFFEF4444);
    }

    if (classes.contains('text-white')) {
      return Colors.white;
    }

    if (classes.contains('text-black')) {
      return Colors.black;
    }

    return dark ? Colors.white : const Color(0xFF111111);
  }

  static Color borderColor(BuildContext context, List<String> classes) {
    final dark = isDark(context);

    if (classes.contains('border-muted')) {
      return dark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E7EB);
    }

    if (classes.contains('border-muted-light')) {
      return  const Color.fromARGB(255, 171, 171, 171) ;
    }

    if (classes.contains('border-primary')) {
      return dark
          ? const Color(0xFFFFFFFF)
          : const Color.fromARGB(255, 69, 69, 69);
    }

    if (classes.contains('border-muted-dark')) {
      return dark
          ? const Color.fromARGB(255, 67, 67, 70)
          : const Color(0xFF6B7280);
    }

    if (classes.contains('border-strong')) {
      return dark ? const Color(0xFF555555) : const Color(0xFFBDBDBD);
    }

    if (classes.contains('border-success')) {
      return const Color(0xFF00C776);
    }

    if (classes.contains('border-info')) {
      return const Color(0xFF2563EB);
    }

    if (classes.contains('border-info-soft')) {
      return dark ? const Color(0xFF071A3D) : const Color(0xFFEFF6FF);
    }

    if (classes.contains('border-info-dark')) {
      return const Color(0xff1E1B47);
    }

    if (classes.contains('border-warning')) {
      return const Color(0xFFF59E0B);
    }

    if (classes.contains('border-purple')) {
      return const Color(0xFF5B21B6);
    }

    if (classes.contains('border-danger')) {
      return const Color(0xFFEF4444);
    }

    if (classes.contains('border-white')) {
      return Colors.white;
    }

    if (classes.contains('border-black')) {
      return Colors.black;
    }

    if (classes.contains('border-transparent')) {
      return Colors.transparent;
    }

    return dark ? const Color(0xFF262626) : const Color(0xFFE5E7EB);
  }

  static BorderRadius radius(List<String> classes) {
    if (classes.contains('rounded-none')) return BorderRadius.zero;
    if (classes.contains('rounded-sm')) return BorderRadius.circular(8);
    if (classes.contains('rounded-md')) return BorderRadius.circular(12);
    if (classes.contains('rounded-lg')) return BorderRadius.circular(16);
    if (classes.contains('rounded-xl')) return BorderRadius.circular(20);
    if (classes.contains('rounded-2xl')) return BorderRadius.circular(24);
    if (classes.contains('rounded-full')) return BorderRadius.circular(999);
    if (classes.contains('rounded-3xl')) {
      return BorderRadius.circular(32);
    }
    return BorderRadius.zero;
  }

  static bool hasDashedBorder(List<String> classes) {
    return classes.contains('border-dashed');
  }

  static double borderWidth(List<String> classes) {
    if (classes.contains('border-0')) return 0;
    if (classes.contains('border-2')) return 2;
    return 1;
  }

  static BoxBorder? border(BuildContext context, List<String> classes) {
    if (!classes.any((c) => c.startsWith('border'))) return null;

    if (classes.contains('border-dashed')) {
      return null;
    }

    final width = borderWidth(classes);

    if (classes.contains('border-bottom-muted')) {
      return Border(
        bottom: BorderSide(
          color: borderColor(context, ['border-muted']),
          width: width,
        ),
      );
    }

    return Border.all(color: borderColor(context, classes), width: width);
  }

  static Gradient? gradient(BuildContext context, List<String> classes) {
    final theme = Theme.of(context);
    final dark = isDark(context);

    if (classes.contains('bg-success-gradient')) {
      return const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF00A53F), Color(0xFF019A62)],
      );
    }

    if (classes.contains('bg-primary-gradient')) {
      return LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
      );
    }

    if (classes.contains('bg-info-gradient')) {
      return const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF2563EB), Color(0xFF6366F1)],
      );
    }

    if (classes.contains('bg-warning-gradient')) {
      return const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
      );
    }

    if (classes.contains('bg-danger-gradient') ||
        classes.contains('bg-error-gradient')) {
      return const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
      );
    }

    if (classes.contains('bg-purple-gradient')) {
      return const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
      );
    }

    if (classes.contains('bg-dark-gradient')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF111827), Color(0xFF030712)],
      );
    }

    if (classes.contains('bg-card-gradient')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: dark
            ? const [Color(0xFF1F1F1F), Color(0xFF111111)]
            : const [Color(0xFFFFFFFF), Color(0xFFF3F4F6)],
      );
    }

    if (classes.contains('bg-muted-gradient')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: dark
            ? const [Color(0xFF2A2A2A), Color(0xFF171717)]
            : const [Color(0xFFF9FAFB), Color(0xFFE5E7EB)],
      );
    }

    return null;
  }

  static List<BoxShadow> shadow(BuildContext context, List<String> classes) {
    final dark = isDark(context);

    if (classes.contains('shadow-none')) return [];

    if (classes.contains('shadow-sm')) {
      return [
        BoxShadow(
          color: dark ? Colors.black26 : Colors.black12,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    }

    if (classes.contains('shadow-xl')) {
      return [
        BoxShadow(
          color: dark ? Colors.black54 : Colors.black26,
          blurRadius: 32,
          offset: const Offset(0, 14),
        ),
      ];
    }

    if (classes.contains('shadow-md')) {
      return [
        BoxShadow(
          color: dark ? Colors.black38 : Colors.black12,
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ];
    }

    if (classes.contains('shadow-lg')) {
      return [
        BoxShadow(
          color: dark ? Colors.black45 : Colors.black26,
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ];
    }

    return [];
  }

  static FontWeight fontWeight(List<String> classes) {
    if (classes.contains('font-light')) return FontWeight.w300;
    if (classes.contains('font-normal')) return FontWeight.w400;
    if (classes.contains('font-bold')) return FontWeight.w500;
    if (classes.contains('font-extrabold')) return FontWeight.w800;
    return FontWeight.w400;
  }

  static double fontSize(List<String> classes) {
    if (classes.contains('text-2xs')) return 10;
    if (classes.contains('text-xs')) return 12;
    if (classes.contains('text-sm')) return 14;
    if (classes.contains('text-md')) return 16;
    if (classes.contains('text-base')) return 18;
    if (classes.contains('text-lg')) return 20;
    if (classes.contains('text-xl')) return 22;
    if (classes.contains('text-2xl')) return 24;
    if (classes.contains('text-3xl')) return 32;
    if (classes.contains('text-4xl')) return 40;
    return 16;
  }

  static TextAlign textAlign(List<String> classes) {
    if (classes.contains('text-center')) return TextAlign.center;
    if (classes.contains('text-right')) return TextAlign.right;
    if (classes.contains('text-left')) return TextAlign.left;
    return TextAlign.start;
  }

  static double lineHeight(List<String> classes) {
    if (classes.contains('leading-none')) return 1.0;
    if (classes.contains('leading-tight')) return 1.15;
    if (classes.contains('leading-snug')) return 1.25;
    if (classes.contains('leading-normal')) return 1.35;
    if (classes.contains('leading-relaxed')) return 1.5;
    if (classes.contains('leading-loose')) return 1.7;
    return 1.2;
  }

  static CrossAxisAlignment crossAxisAlignment(List<String> classes) {
    if (classes.contains('items-start')) return CrossAxisAlignment.start;
    if (classes.contains('items-center')) return CrossAxisAlignment.center;
    if (classes.contains('items-end')) return CrossAxisAlignment.end;
    if (classes.contains('items-stretch')) return CrossAxisAlignment.stretch;
    return CrossAxisAlignment.start;
  }

  static MainAxisAlignment mainAxisAlignment(List<String> classes) {
    if (classes.contains('justify-start')) return MainAxisAlignment.start;
    if (classes.contains('justify-center')) return MainAxisAlignment.center;
    if (classes.contains('justify-end')) return MainAxisAlignment.end;
    if (classes.contains('justify-between')) {
      return MainAxisAlignment.spaceBetween;
    }
    if (classes.contains('justify-around')) {
      return MainAxisAlignment.spaceAround;
    }
    if (classes.contains('justify-evenly')) {
      return MainAxisAlignment.spaceEvenly;
    }
    return MainAxisAlignment.start;
  }

  static BoxFit boxFit(List<String> classes) {
    if (classes.contains('object-cover')) return BoxFit.cover;
    if (classes.contains('object-contain')) return BoxFit.contain;
    if (classes.contains('object-fill')) return BoxFit.fill;
    if (classes.contains('object-fit-width')) return BoxFit.fitWidth;
    return BoxFit.cover;
  }

  static double? width(BuildContext context, List<String> classes) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (classes.contains('w-full')) return double.infinity;
    if (classes.contains('w-half')) return screenWidth * 0.5;
    if (classes.contains('w-third')) return screenWidth * 0.333;
    if (classes.contains('w-quarter')) return screenWidth * 0.25;
    if (classes.contains('w-action-half')) {
      return (screenWidth - 40) / 2;
    }
    if (classes.contains('w-screen')) return screenWidth;
    // Blog thumbnail width
    if (classes.contains('w-blog-thumb')) return 112;
    if (classes.contains('w-blog-thumb-md')) return 96;

    if (classes.contains('w-auto')) return null;

    return null;
  }

  static double? height(BuildContext context, List<String> classes) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (classes.contains('h-full')) return screenHeight;
    if (classes.contains('h-card-image')) return screenHeight * 0.265;
    if (classes.contains('h-vehicle-card')) return screenHeight * 0.36;
    if (classes.contains('h-sm')) return 36;
    if (classes.contains('h-md')) return 48;
    if (classes.contains('h-lg')) return 60;
    if (classes.contains('h-xl')) return 72;
    if (classes.contains('h-screen')) return screenHeight;
    if (classes.contains('h-chat-area')) return screenHeight * 0.62;

    if (classes.contains('h-blog-thumb')) return 96;
    if (classes.contains('h-blog-thumb-md')) return 72;

    if (classes.contains('h-auto')) return null;

    return null;
  }

  static TextStyle textStyle(
    BuildContext context,
    List<String> classes, {
    double? size,
    Color? color,
    FontWeight? weight,
  }) {
    final hasLineThrough = classes.contains('line-through');

    return TextStyle(
      fontSize: size ?? fontSize(classes),
      color: color ?? textColor(context, classes),
      fontWeight: weight ?? fontWeight(classes),
      height: lineHeight(classes),
      decoration: hasLineThrough ? TextDecoration.lineThrough : null,
      decorationThickness: hasLineThrough ? 1.4 : null,
    );
  }

  static BoxDecoration decoration(
    BuildContext context,
    List<String> classes, {
    Color? backgroundColor,
    List<String>? borderSides,
  }) {
    final isDashed = hasDashedBorder(classes);
    final baseBorder = isDashed ? null : border(context, classes);
    final resolvedGradient = gradient(context, classes);

    return BoxDecoration(
      color: resolvedGradient == null
          ? backgroundColor ?? background(context, classes)
          : null,
      gradient: resolvedGradient,
      borderRadius: radius(classes),
      border: isDashed
          ? null
          : _resolveBorder(context, baseBorder, borderSides),
      boxShadow: shadow(context, classes),
    );
  }

  /// Converts JSON list values safely into List<String>.
  ///
  /// Example:
  /// "borderSides": ["left", "bottom"]
  static List<String>? stringList(dynamic value) {
    if (value == null) return null;

    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }

    if (value is String && value.trim().isNotEmpty) {
      return [value.trim()];
    }

    return null;
  }

  /// Keeps the normal border when borderSides is not supplied.
  /// If borderSides exists, it creates border only on selected sides.
  ///
  /// Example:
  /// borderSides: ["left", "bottom"]
  static BoxBorder? _resolveBorder(
    BuildContext context,
    BoxBorder? baseBorder,
    List<String>? borderSides,
  ) {
    if (borderSides == null || borderSides.isEmpty) {
      return baseBorder;
    }

    if (baseBorder == null) {
      return null;
    }

    final normalizedSides = borderSides
        .map((side) => side.toLowerCase().trim())
        .where((side) => side.isNotEmpty)
        .toSet();

    final side = _borderSideFromBaseBorder(context, baseBorder);

    return Border(
      left: normalizedSides.contains('left') ? side : BorderSide.none,
      top: normalizedSides.contains('top') ? side : BorderSide.none,
      right: normalizedSides.contains('right') ? side : BorderSide.none,
      bottom: normalizedSides.contains('bottom') ? side : BorderSide.none,
    );
  }

  /// Reuses the colour and width from your existing class-based border.
  ///
  /// So this JSON:
  /// "classes": ["border-muted"]
  /// "borderSides": ["left", "bottom"]
  ///
  /// will use the same muted border colour, but only on left and bottom.
  static BorderSide _borderSideFromBaseBorder(
    BuildContext context,
    BoxBorder? baseBorder,
  ) {
    if (baseBorder is Border) {
      final candidates = [
        baseBorder.left,
        baseBorder.top,
        baseBorder.right,
        baseBorder.bottom,
      ];

      for (final side in candidates) {
        if (_isUsableBorderSide(side)) {
          return side;
        }
      }
    }

    if (baseBorder is BorderDirectional) {
      final candidates = [
        baseBorder.start,
        baseBorder.top,
        baseBorder.end,
        baseBorder.bottom,
      ];

      for (final side in candidates) {
        if (_isUsableBorderSide(side)) {
          return side;
        }
      }
    }

    return BorderSide(color: Theme.of(context).dividerColor, width: 1);
  }

  static bool _isUsableBorderSide(BorderSide side) {
    return side.style != BorderStyle.none && side.width > 0;
  }
}
