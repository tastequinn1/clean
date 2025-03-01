import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../global_widgets/block_button_widget.dart';
import '../controllers/book_e_service_controller.dart';
import '../widgets/payment_details_widget.dart';

class BookingSummaryView extends GetView<BookEServiceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Booking Summary".tr,
            style: context.textTheme.titleLarge,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Get.back(),
          ),
          elevation: 0,
        ),
        bottomNavigationBar: buildBottomWidget(controller.booking.value),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Booking At".tr, style: Get.textTheme.bodyLarge),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 15),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${DateFormat.yMMMMEEEEd(Get.locale.toString()).format(controller.booking.value.bookingAt!)}', style: Get.textTheme.bodyMedium),
                          Text('${DateFormat('HH:mm', Get.locale.toString()).format(controller.booking.value.bookingAt!)}', style: Get.textTheme.bodyMedium),
                        ],
                      )),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Address".tr, style: Get.textTheme.bodyLarge),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.place_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 15),
                      Expanded(
                        child: Obx(() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (controller.currentAddress.hasDescription()) Text(controller.currentAddress.description, style: Get.textTheme.titleSmall),
                              if (controller.currentAddress.hasDescription()) SizedBox(height: 10),
                              Text(controller.currentAddress.address, style: Get.textTheme.bodyMedium),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("A Hint for the Provider".tr, style: Get.textTheme.bodyLarge),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.description_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 15),
                      Expanded(
                        child: Obx(() {
                          return Text(controller.booking.value.hint, style: Get.textTheme.bodyMedium);
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget buildBottomWidget(Booking _booking) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PaymentDetailsWidget(booking: _booking),
          Obx(() {
            return BlockButtonWidget(
                text: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Confirm & Booking Now".tr,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.titleLarge?.merge(
                          TextStyle(color: Get.theme.primaryColor),
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Get.theme.primaryColor, size: 20)
                  ],
                ),
                color: Get.theme.colorScheme.secondary,
                onPressed: Get.find<LaravelApiClient>().isLoading(task: "addBooking")
                    ? null
                    : () {
                        controller.createBooking();
                      });
          }).paddingSymmetric(vertical: 10, horizontal: 20),
        ],
      ),
    );
  }
}
