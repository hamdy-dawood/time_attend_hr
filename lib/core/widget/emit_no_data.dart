import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/image_manager.dart';

class EmitNoData extends StatelessWidget {
  const EmitNoData({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 0.1.sh),
          Center(
            child: Image.asset(
              ImageManager.noDataImage,
              height: 0.5.sh,
            ),
          ),
        ],
      ),
    );
  }
}
