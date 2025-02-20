import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopBarIconLoaderWidget extends StatelessWidget {
  const TopBarIconLoaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
        BoxShadow(
          color: Get.theme.primaryColor.withOpacity(0.5),
          blurRadius: 10,
        ),
      ]),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Get.theme.hintColor),
          ),
        ),
      ),
    );
  }
}