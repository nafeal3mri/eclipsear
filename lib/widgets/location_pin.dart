import 'package:flutter/material.dart';

/// A circular map pin with a short stem, used to mark a selected location.
///
/// Shared by the location picker ([ChangeLocationPage]) and the eclipse
/// details map so the user's saved location renders identically in both.
class LocationPin extends StatelessWidget {
  final Color color;
  const LocationPin({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.50),
                blurRadius: 14,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.my_location_rounded,
              color: Colors.white, size: 18),
        ),
        // Stem
        Container(
          width: 2,
          height: 10,
          color: color,
        ),
      ],
    );
  }
}
