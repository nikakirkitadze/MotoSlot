import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/widgets/widgets.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/booking_cubit.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String paymentId;

  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.paymentId,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) {
          setState(() => _isLoading = true);
        },
        onPageFinished: (_) {
          setState(() => _isLoading = false);
        },
        onNavigationRequest: (request) {
          final uri = Uri.tryParse(request.url);
          if (uri != null && uri.scheme == 'motoslot') {
            _handleCallback(uri);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handleCallback(Uri uri) {
    final transactionId = uri.queryParameters['transactionId'] ?? '';
    final status = uri.queryParameters['status'] ?? '';
    final isSuccess = status == 'success';

    context.read<BookingCubit>().handlePaymentResult(
          transactionId: transactionId,
          isSuccess: isSuccess,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.securePayment),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            context.read<BookingCubit>().handlePaymentResult(
                  transactionId: '',
                  isSuccess: false,
                );
            context.pop();
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(
              child: AppLoading(message: context.l10n.loadingPaymentPage),
            ),
        ],
      ),
    );
  }
}
