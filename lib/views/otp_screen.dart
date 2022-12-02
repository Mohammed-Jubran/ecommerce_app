import 'package:ecommerce_app/providers/auth_provider.dart';
import 'package:ecommerce_app/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late String _otpCode;

  _sendOtp() {
    final otp = Provider.of<AuthProvider>(context, listen: false).otpCode;
    if (_otpCode == otp) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/2.png',
              height: 200,
            ),
            const Text('Enter OTP Verification Code',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text(
                'Please enter your phone number to send you a verification code',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey)),
            const SizedBox(height: 5),
            OTPTextField(
                length: 6,
                width: MediaQuery.of(context).size.width,
                textFieldAlignment: MainAxisAlignment.spaceAround,
                outlineBorderRadius: 15,
                style: TextStyle(fontSize: 17),
                onCompleted: (pin) {
                  _otpCode = pin;
                }),
            const SizedBox(height: 50),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: _sendOtp,
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ))),
                    child: const Text('Send'))),
          ],
        ),
      ),
    );
  }
}
