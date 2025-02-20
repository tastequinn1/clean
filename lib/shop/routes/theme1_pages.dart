import 'package:get/get.dart' show GetPage;

import '../../app/middlewares/auth_middleware.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/categories_view.dart';
import '../modules/category/views/category_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/cash_view.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/checkout/views/confirmation_view.dart';
import '../modules/checkout/views/paypal_view.dart';
import '../modules/checkout/views/stripe_view.dart';
import '../modules/checkout/views/wallet_view.dart';
import '../modules/order_confirmation/bindings/order_confirmation_binding.dart';
import '../modules/order_confirmation/views/order_confirmation_view.dart';
import '../modules/orders/bindings/order_binding.dart';
import '../modules/orders/views/order_view.dart';
import '../modules/orders/views/orders_view.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/product_view.dart';
import '../modules/store/bindings/store_binding.dart';
import '../modules/store/views/store_products_view.dart';
import '../modules/store/views/store_view.dart';
import 'routes.dart';

class Theme1ShopPages {
  static final routes = [
    GetPage(name: Routes.CATEGORIES, page: () => CategoriesView(), bindings: [CategoryBinding(), CartBinding()]),
    GetPage(name: Routes.CATEGORY, page: () => CategoryView(), bindings: [CategoryBinding(), CartBinding()]),
    GetPage(name: Routes.PRODUCT, page: () => ProductView(), bindings: [ProductBinding(), CartBinding()]),
    GetPage(name: Routes.STORE, page: () => StoreView(), binding: StoreBinding()),
    GetPage(name: Routes.STORE_PRODUCTS, page: () => StoreProductsView(), binding: StoreBinding()),
    GetPage(name: Routes.ORDERS, page: () => OrdersView(), bindings: [OrderBinding(), CartBinding()], middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.ORDER, page: () => OrderView(), binding: OrderBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CART, page: () => CartView(), binding: CartBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.ORDER_CONFIRMATION, page: () => OrderConfirmationView(), binding: OrderConfirmationBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PAYMENT_CONFIRMATION, page: () => ConfirmationView(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CHECKOUT, page: () => CheckoutView(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CASH, page: () => CashViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.WALLET, page: () => WalletViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PAYPAL, page: () => PayPalViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.STRIPE, page: () => StripeViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    /*GetPage(name: Routes.E_SERVICE, page: () => ProductView(), binding: ProductBinding(), transition: Transition.downToUp),
    GetPage(name: Routes.BOOK_E_SERVICE, page: () => BookProductView(), binding: BookProductBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.BOOKING_SUMMARY, page: () => OrderSummaryView(), binding: BookProductBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.SEARCH, page: () => SearchView(), binding: RootBinding(), transition: Transition.downToUp),
    GetPage(name: Routes.RAZORPAY, page: () => RazorPayViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.STRIPE_FPX, page: () => StripeFPXViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PAYSTACK, page: () => PayStackViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PAYMONGO, page: () => PayMongoViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.FLUTTERWAVE, page: () => FlutterWaveViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    */
  ];
}
