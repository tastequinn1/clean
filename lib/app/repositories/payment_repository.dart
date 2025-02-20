import 'package:get/get.dart';

import '../models/booking_model.dart';
import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import '../providers/laravel_provider.dart';

class PaymentRepository {
  late LaravelApiClient _laravelApiClient;

  PaymentRepository() {
    _laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<PaymentMethod>> getMethods() {
    return _laravelApiClient.getPaymentMethods();
  }

  Future<List<Wallet>> getWallets() {
    return _laravelApiClient.getWallets();
  }

  Future<List<WalletTransaction>> getWalletTransactions(Wallet wallet) {
    return _laravelApiClient.getWalletTransactions(wallet);
  }

  Future<Wallet> createWallet(Wallet wallet) {
    return _laravelApiClient.createWallet(wallet);
  }

  Future<Wallet> updateWallet(Wallet wallet) {
    return _laravelApiClient.updateWallet(wallet);
  }

  Future<bool> deleteWallet(Wallet wallet) {
    return _laravelApiClient.deleteWallet(wallet);
  }

  Future<Payment> create(Booking booking) {
    return _laravelApiClient.createPayment(booking);
  }

  Future<Payment> createWalletPayment(Booking booking, Wallet wallet) {
    return _laravelApiClient.createWalletPayment(booking, wallet);
  }

  Uri getPayPalUrl(Booking booking) {
    return _laravelApiClient.getPayPalUrl(booking);
  }

  Uri getRazorPayUrl(Booking booking) {
    return _laravelApiClient.getRazorPayUrl(booking);
  }

  Uri getStripeUrl(Booking booking) {
    return _laravelApiClient.getStripeUrl(booking);
  }

  Uri getPayStackUrl(Booking booking) {
    return _laravelApiClient.getPayStackUrl(booking);
  }

  Uri getPayMongoUrl(Booking booking) {
    return _laravelApiClient.getPayMongoUrl(booking);
  }

  Uri getFlutterWaveUrl(Booking booking) {
    return _laravelApiClient.getFlutterWaveUrl(booking);
  }

  Uri getStripeFPXUrl(Booking booking) {
    return _laravelApiClient.getStripeFPXUrl(booking);
  }
}
