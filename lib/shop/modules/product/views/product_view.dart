import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/shop/modules/product/widgets/add_to_cart_widget.dart';

import '../../../../app/models/media_model.dart';
import '../../../../app/modules/global_widgets/circular_loading_widget.dart';
import '../../../../app/modules/global_widgets/notifications_button_widget.dart';
import '../../../../common/ui.dart';
import '../../../models/product_model.dart';
import '../../../providers/shop_laravel_provider.dart';
import '../../../routes/routes.dart';
import '../../global_widgets/cart_button_widget.dart';
import '../controllers/product_controller.dart';
import '../widgets/option_group_item_widget.dart';
import '../widgets/product_til_widget.dart';
import '../widgets/product_title_bar_widget.dart';
import '../widgets/store_item_widget.dart';

class ProductView extends GetView<ProductController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var _product = controller.product.value;
      if (!_product.hasData) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return Scaffold(
          bottomNavigationBar: AddToCartWidget(),
          body: RefreshIndicator(
              onRefresh: () async {
                Get.find<ShopLaravelApiClient>().forceRefresh();
                controller.refreshProduct(showMessage: true);
                Get.find<ShopLaravelApiClient>().unForceRefresh();
              },
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 310,
                    elevation: 0,
                    floating: true,
                    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color: Get.theme.primaryColor.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ]),
                        child: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                      ),
                      onPressed: () => {Get.back()},
                    ),
                    actions: [CartButtonWidget(), NotificationsButtonWidget()],
                    bottom: buildProductTitleBarWidget(_product),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Obx(() {
                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            buildCarouselSlider(_product),
                            buildCarouselBullets(_product),
                          ],
                        );
                      }),
                    ).marginOnly(bottom: 50),
                  ),

                  // WelcomeWidget(),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        buildCategories(_product),
                        ProductTilWidget(
                          title: Text("Description".tr, style: Get.textTheme.titleSmall),
                          content: Obx(() {
                            if (controller.product.value.description == '') {
                              return SizedBox();
                            }
                            return Ui.applyHtml(_product.description, style: Get.textTheme.bodyLarge);
                          }),
                        ),
                        buildOptions(_product),
                        buildStore(_product),
                      ],
                    ),
                  ),
                ],
              )),
        );
      }
    });
  }

  Widget buildOptions(Product _product) {
    return Obx(() {
      if (controller.optionGroups.isEmpty) {
        return SizedBox();
      }
      return ProductTilWidget(
        horizontalPadding: 0,
        title: Text("Options".tr, style: Get.textTheme.titleSmall).paddingSymmetric(horizontal: 20),
        content: ListView.separated(
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index) {
            return OptionGroupItemWidget(optionGroup: controller.optionGroups.elementAt(index));
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 6);
          },
          itemCount: controller.optionGroups.length,
          primary: false,
          shrinkWrap: true,
        ),
      );
    });
  }

  CarouselSlider buildCarouselSlider(Product _product) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        height: 370,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          controller.currentSlide.value = index;
        },
      ),
      items: _product.images.map((Media media) {
        return Builder(
          builder: (BuildContext context) {
            return Hero(
              tag: controller.heroTag.value + _product.id,
              child: CachedNetworkImage(
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
                imageUrl: media.url,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Container buildCarouselBullets(Product _product) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _product.images.map((Media media) {
          return Container(
            width: 20.0,
            height: 5.0,
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: controller.currentSlide.value == _product.images.indexOf(media) ? Get.theme.hintColor : Get.theme.primaryColor.withOpacity(0.4)),
          );
        }).toList(),
      ),
    );
  }

  ProductTitleBarWidget buildProductTitleBarWidget(Product _product) {
    return ProductTitleBarWidget(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              _product.name,
              style: Get.textTheme.headlineSmall!.merge(TextStyle(height: 1.1)),
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!_product.store.hasData)
                Container(
                  child: Text("  .  .  .  ".tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyMedium!.merge(
                        TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 3),
                ),
              if (_product.store.available)
                Container(
                  child: Text("Available".tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyMedium!.merge(
                        TextStyle(color: Colors.green, height: 1.4, fontSize: 10),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 3),
                ),
              if (!_product.store.available)
                Container(
                  child: Text("Offline".tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyMedium!.merge(
                        TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 3),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_product.getOldPrice > 0)
                    Ui.getPrice(
                      _product.getOldPrice,
                      style: Get.textTheme.titleLarge?.merge(TextStyle(color: Get.theme.focusColor, decoration: TextDecoration.lineThrough)),
                      unit: _product.quantityUnit,
                    ),
                  Ui.getPrice(
                    _product.getPrice,
                    style: Get.textTheme.displaySmall!.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                    unit: _product.quantityUnit,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCategories(Product _product) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5,
        runSpacing: 8,
        children: List.generate(_product.categories.length, (index) {
              var _category = _product.categories.elementAt(index);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_category.name, style: Get.textTheme.bodyLarge!.merge(TextStyle(color: _category.color))),
                decoration: BoxDecoration(
                    color: _category.color.withOpacity(0.2),
                    border: Border.all(
                      color: _category.color.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            }) +
            List.generate(_product.subCategories.length, (index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_product.subCategories.elementAt(index).name, style: Get.textTheme.bodySmall),
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    border: Border.all(
                      color: Get.theme.focusColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            }),
      ),
    );
  }

  Widget buildStore(Product _product) {
    if (_product.store.hasData) {
      return GestureDetector(
        onTap: () {
          Get.toNamed(Routes.STORE, arguments: {'store': _product.store, 'heroTag': 'product_details'});
        },
        child: ProductTilWidget(
          title: Text("Store".tr, style: Get.textTheme.titleSmall),
          content: StoreItemWidget(store: _product.store),
          actions: [
            Text("View More".tr, style: Get.textTheme.titleMedium),
          ],
        ),
      );
    } else {
      return ProductTilWidget(
        title: Text("Store".tr, style: Get.textTheme.titleSmall),
        content: SizedBox(
          height: 60,
        ),
        actions: [],
      );
    }
  }
}
