import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvgPicture extends StatelessWidget {
  const CustomSvgPicture(
      {super.key, required this.path, this.withColorFilter = true, this.hight, this.width});

  const CustomSvgPicture.withoutColor({
    // named Constructor
    super.key,
    required this.path,
    this.hight,
    this.width
  }) : withColorFilter = false;

  final String path;
  final bool withColorFilter;
  final double? width;
  final double? hight;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      height: hight,
      width: width,
      colorFilter: withColorFilter
          ? ColorFilter.mode(
              Theme.of(context).colorScheme.secondary,
              BlendMode.srcIn,
            )
          : null,
    );
  }
}
