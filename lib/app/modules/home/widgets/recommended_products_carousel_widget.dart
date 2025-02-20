import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../../shop/routes/routes.dart';
import '../../../services/settings_service.dart';
import '../controllers/home_controller.dart';

class RecommendedProductsCarouselWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!Get.find<SettingsService>().isModuleActivated("Shop")) {
        return SizedBox();
      } else {
        return Column(
          children: [
            Container(
              color: Get.theme.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                children: [
                  Expanded(child: Text("Recommended Products".tr, style: Get.textTheme.headlineSmall)),
                  MaterialButton(
                    onPressed: () {
                      Get.toNamed(Routes.CATEGORIES);
                    },
                    shape: StadiumBorder(),
                    color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                    child: Text("View All".tr, style: Get.textTheme.titleMedium),
                    elevation: 0,
                  ),
                ],
              ),
            ),
            Container(
              height: 360,
              color: Get.theme.primaryColor,
              child: Obx(() {
                return ListView.builder(
                    padding: EdgeInsets.only(bottom: 10),
                    primary: false,
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.products.length,
                    itemBuilder: (_, index) {
                      var _product = controller.products.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.PRODUCT, arguments: {'product': _product, 'heroTag': 'products_list_item'});
                        },
                        child: Container(
                          width: 180,
                          margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
                          // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                            ],
                          ),
                          child: Column(
                            //alignment: AlignmentDirectional.topStart,
                            children: [
                              Hero(
                                tag: 'recommended_product_carousel' + _product.id,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                  child: CachedNetworkImage(
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    imageUrl: _product.firstImageUrl,
                                    placeholder: (context, url) => Image.asset(
                                      'assets/img/loading.gif',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 100,
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                height: 130,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Get.theme.primaryColor,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      _product.name,
                                      maxLines: 2,
                                      style: Get.textTheme.bodyMedium!.merge(TextStyle(color: Get.theme.hintColor)),
                                    ),
                                    SizedBox(height: 10),
                                    Wrap(
                                      spacing: 5,
                                      alignment: WrapAlignment.spaceBetween,
                                      direction: Axis.horizontal,
                                      crossAxisAlignment: WrapCrossAlignment.end,
                                      children: [
                                        Text(
                                          "Start from".tr,
                                          style: Get.textTheme.bodySmall,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            if (_product.getOldPrice > 0)
                                              Ui.getPrice(
                                                _product.getOldPrice,
                                                style: Get.textTheme.bodyLarge!.merge(TextStyle(color: Get.theme.focusColor, decoration: TextDecoration.lineThrough)),
                                                unit: _product.quantityUnit,
                                              ),
                                            Ui.getPrice(
                                              _product.getPrice,
                                              style: Get.textTheme.bodyMedium!.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                                              unit: _product.quantityUnit,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }),
            ),
          ],
        );
      }
    });
  }
}
