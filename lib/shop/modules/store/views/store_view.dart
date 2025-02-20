import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../app/models/media_model.dart';
import '../../../../app/modules/global_widgets/circular_loading_widget.dart';
import '../../../../common/map.dart';
import '../../../../common/ui.dart';
import '../../../models/store_model.dart';
import '../../../providers/shop_laravel_provider.dart';
import '../../../routes/routes.dart';
import '../controllers/store_controller.dart';
import '../widgets/featured_carousel_widget.dart';
import '../widgets/store_til_widget.dart';
import '../widgets/store_title_bar_widget.dart';

class StoreView extends GetView<StoreController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var _store = controller.store.value;
      if (!_store.hasData) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return Scaffold(
          body: RefreshIndicator(
              onRefresh: () async {
                Get.find<ShopLaravelApiClient>().forceRefresh();
                controller.refreshStore(showMessage: true);
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
                      icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                      onPressed: () => {Get.back()},
                    ),
                    bottom: buildStoreTitleBarWidget(_store),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Obx(() {
                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            buildCarouselSlider(_store),
                            buildCarouselBullets(_store),
                          ],
                        );
                      }),
                    ).marginOnly(bottom: 50),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        buildContactUs(),
                        StoreTilWidget(
                          title: Text("Description".tr, style: Get.textTheme.titleSmall),
                          content: Ui.applyHtml(_store.description, style: Get.textTheme.bodyLarge),
                        ),
                        buildAddresses(context),
                        StoreTilWidget(
                          horizontalPadding: 0,
                          title: Text("Featured Products".tr, style: Get.textTheme.titleSmall).paddingSymmetric(horizontal: 20),
                          content: FeaturedCarouselWidget(),
                          actions: [
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.STORE_PRODUCTS, arguments: _store);
                              },
                              child: Text("View All".tr, style: Get.textTheme.titleMedium),
                            ).paddingSymmetric(horizontal: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      }
    });
  }

  Container buildContactUs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Contact us".tr, style: Get.textTheme.titleSmall),
                Text("If your have any question!".tr, style: Get.textTheme.bodySmall),
              ],
            ),
          ),
          Wrap(
            spacing: 5,
            children: [
              MaterialButton(
                onPressed: () {
                  launchUrlString("tel:${controller.store.value.mobileNumber}");
                },
                height: 44,
                minWidth: 44,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                child: Icon(
                  Icons.phone_android_outlined,
                  color: Get.theme.colorScheme.secondary,
                ),
                elevation: 0,
              ),
              MaterialButton(
                onPressed: () {
                  launchUrlString("tel:${controller.store.value.phoneNumber}");
                },
                height: 44,
                minWidth: 44,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                child: Icon(
                  Icons.call_outlined,
                  color: Get.theme.colorScheme.secondary,
                ),
                elevation: 0,
              ),
            ],
          )
        ],
      ),
    );
  }

  Container buildAddresses(context) {
    var _addresses = controller.store.value.addresses;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: Ui.getBoxDecoration(),
      child: (_addresses.isEmpty)
          ? Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.15),
              highlightColor: Colors.grey[200]!.withOpacity(0.1),
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            )
          : Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: MapsUtil.getStaticMaps(_addresses.map((e) => e.getLatLng()).toList()),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                  ),
                  child: Column(
                    children: List.generate(_addresses.length, (index) {
                      var _address = _addresses.elementAt(index);
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_address.description, style: Get.textTheme.titleSmall),
                                SizedBox(height: 5),
                                Text(_address.address, style: Get.textTheme.bodySmall),
                              ],
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              MapsUtil.openMapsSheet(context, _address.getLatLng(), controller.store.value.name);
                            },
                            height: 44,
                            minWidth: 44,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                            child: Icon(
                              Icons.directions_outlined,
                              color: Get.theme.colorScheme.secondary,
                            ),
                            elevation: 0,
                          ),
                        ],
                      ).marginOnly(bottom: 10);
                    }),
                  ),
                ),
              ],
            ),
    );
  }

  CarouselSlider buildCarouselSlider(Store _store) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        height: 360,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          controller.currentSlide.value = index;
        },
      ),
      items: _store.images.map((Media media) {
        return Builder(
          builder: (BuildContext context) {
            return Hero(
              tag: controller.heroTag + _store.id,
              child: CachedNetworkImage(
                width: double.infinity,
                height: 360,
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

  Container buildCarouselBullets(Store _store) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _store.images.map((Media media) {
          return Container(
            width: 20.0,
            height: 5.0,
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: controller.currentSlide.value == _store.images.indexOf(media) ? Get.theme.hintColor : Get.theme.primaryColor.withOpacity(0.4)),
          );
        }).toList(),
      ),
    );
  }

  StoreTitleBarWidget buildStoreTitleBarWidget(Store _store) {
    return StoreTitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _store.name,
                  style: Get.textTheme.headlineSmall!.merge(TextStyle(height: 1.1)),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
              Container(
                child: Text(_store.type.name.tr,
                    maxLines: 1,
                    style: Get.textTheme.bodyMedium!.merge(
                      TextStyle(color: Get.theme.colorScheme.secondary, height: 1.4, fontSize: 10),
                    ),
                    softWrap: false,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
