import 'package:kiddie_care_app/locator.dart';
import 'package:kiddie_care_app/model/authentication.dart';
import 'package:kiddie_care_app/services/ml_service.dart';
import 'package:flutter/material.dart';
import '../pages/SignUp/sign_up_babysitter.dart';
import '../pages/SignUp/sign_up_childcare.dart';
import '../pages/SignUp/sign_up_parent.dart';

class AuthActionButton extends StatefulWidget {
  final String? role;

  AuthActionButton(
      {Key? key,
      this.role,
      required this.onPressed,
      required this.isLogin,
      required this.reload});
  final Function onPressed;
  final bool isLogin;
  final Function reload;

  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  final MLService _mlService = locator<MLService>();
  Authentication? predictedUser;

  Future<Authentication?> _predictUser() async {
    Authentication? userAndPass = await _mlService.predict();
    return userAndPass;
  }

  Future onTap() async {
    try {
      bool faceDetected = await widget.onPressed();
      if (faceDetected) {
        debugPrint('Face hereeeeeeeee');
        // Check the role and navigate accordingly
        if (widget.role == 'parents') {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignUpParent(role: 'parents'),
            ),
          );
        } else if (widget.role == 'babysitter') {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignUpBabysitter(role: 'babysitter'),
            ),
          );
        } else if (widget.role == 'childcarecentres') {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignUpChildcare(role: 'childcarecentres'),
            ),
          );
        } 
      } else {
        debugPrint('Face Not hereeee');
      }
    } catch (e) {
      debugPrint('Error:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.orange,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.orange.withOpacity(0.1),
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CAPTURE',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.camera_alt, color: Colors.white)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
