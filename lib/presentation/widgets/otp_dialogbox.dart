import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpDialogBox extends StatefulWidget {
  final Function(String) onOtpEntered;
  const OtpDialogBox({super.key, required this.onOtpEntered});

  @override
  State<OtpDialogBox> createState() => _OtpDialogBoxState();
}
String otpCode = "";
class _OtpDialogBoxState extends State<OtpDialogBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Enter OTP",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.86,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Column(
          children: [
            OtpTextField(
              fieldWidth: MediaQuery.of(context).size.width * 0.08,
              enabledBorderColor: Colors.green,
              showFieldAsBox: true,
              focusedBorderColor: Colors.green.shade800,
              numberOfFields: 6,
              borderRadius: BorderRadius.circular(8),
              onSubmit: (String verificationCode) {
                otpCode = verificationCode;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Verify", style: TextStyle(fontSize: 16)),
              onPressed: () {
                if (otpCode.isNotEmpty) {
                  widget.onOtpEntered(otpCode);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
