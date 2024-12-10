import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizedBoxExtension on int {
  Widget get sizedBoxW => SizedBox(width: w);
  Widget get sizedBoxH => SizedBox(height: h);
}
