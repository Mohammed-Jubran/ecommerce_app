import 'package:ecommerce_app/providers/auth_provider.dart';
import 'package:ecommerce_app/views/forget_password.dart';
import 'package:ecommerce_app/views/home_page.dart';
import 'package:ecommerce_app/views/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  String initialCountry = 'JO';
  PhoneNumber number = PhoneNumber(isoCode: 'JO');
  bool _isInvisible = true;
  String _phone = '';

  _login() async {
    final isLoggedIn = await Provider.of<AuthProvider>(context, listen: false)
        .login(_phone, _passwordController.text);
    if (isLoggedIn) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(Provider.of<AuthProvider>(context).errorMsg),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Sign In',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 50),
                  Material(
                    elevation: 6.0,
                    shadowColor: Colors.grey,
                    borderRadius: BorderRadius.circular(50),
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        _phone = number.phoneNumber!;
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DROPDOWN,
                      ),
                      ignoreBlank: false,
                      initialValue: number,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      formatInput: false,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Material(
                    elevation: 6.0,
                    shadowColor: Colors.grey,
                    borderRadius: BorderRadius.circular(50),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _isInvisible,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.purple),
                          suffixIcon: IconButton(
                              onPressed: () {
                                _isInvisible = !_isInvisible;
                                setState(() {});
                              },
                              icon: _isInvisible
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility)),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(50),
                          )),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgetPassword()));
                          },
                          child: const Text('Forget Password?'))),
                  const SizedBox(height: 20),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: _login,
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ))),
                          child: const Text('LOGIN'))),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                          child: const Text('Create'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
