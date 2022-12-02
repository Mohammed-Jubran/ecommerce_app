import 'package:ecommerce_app/providers/auth_provider.dart';
import 'package:ecommerce_app/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  String phone = '';

  bool _isInvisible = true;
  String initialCountry = 'JO';
  PhoneNumber number = PhoneNumber(isoCode: 'JO');

  _signUp() async {
    final isLoggedIn = await Provider.of<AuthProvider>(context, listen: false)
        .signUp(
            email: _emailController.text,
            username: _usernameController.text,
            phone: phone,
            password: _passwordController.text);
    if (isLoggedIn) {
      await Provider.of<AuthProvider>(context, listen: false).sendOtp(phone);
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Sign Up',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 50),
              Material(
                elevation: 6.0,
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(50),
                child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.purple),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(50)))),
              ),
              const SizedBox(height: 20),
              Material(
                elevation: 6.0,
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(50),
                child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    phone = number.phoneNumber!;
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.DROPDOWN,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: const TextStyle(color: Colors.black),
                  initialValue: number,
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
                      prefixIcon: const Icon(Icons.lock, color: Colors.purple),
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
              const SizedBox(height: 30),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _signUp,
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ))),
                      child: const Text('Sign Up'))),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('LOGIN'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
