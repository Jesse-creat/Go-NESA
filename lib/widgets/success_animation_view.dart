import 'package:flutter/material.dart';
import 'package:gojek/beranda/beranda_view.dart';
import 'package:lottie/lottie.dart';

class SuccessAnimationView extends StatefulWidget {
  final String successMessage;
  final Widget? destination;

  const SuccessAnimationView({
    Key? key,
    required this.successMessage,
    this.destination,
  }) : super(key: key);

  @override
  _SuccessAnimationViewState createState() => _SuccessAnimationViewState();
}

class _SuccessAnimationViewState extends State<SuccessAnimationView> {
  @override
  void initState() {
    super.initState();
    _navigateToDestination();
  }

  void _navigateToDestination() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.destination ?? BerandaView()),
          (Route<dynamic> route) => false,
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/icons/succes.json',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 20),
            Text(
              widget.successMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
