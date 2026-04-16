import 'package:commitlock/components/custombottombar.dart';
import 'package:commitlock/core/constants/app_theme.dart';
import 'package:commitlock/core/utils/validators.dart';
import 'package:commitlock/providers/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:commitlock/models/user_model.dart';
import 'package:commitlock/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final String _storedEmail = "test123@gmail.com";  // Predefined email
  final String _storedPassword = "password123";  // Predefined password
  final String _storedName = "Devan";  // Predefined username
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: Validators.emailValidator,
                controller: emailController,
                style: Textfont.body,
                decoration: InputDecoration(labelText: 'Email',labelStyle: Textfont.subText,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.accentColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.secondaryColor),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.dangerColor),),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.dangerColor),)
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                validator: Validators.passwordValidator,
                style: Textfont.body,
             
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password',
                labelStyle: Textfont.subText,
        
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.accentColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.secondaryColor),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.dangerColor),),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.dangerColor),)
                )
                
              ),
              SizedBox(height: 30),
              _isLoading? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ): ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  if (_formKey.currentState!.validate()) {

                    if (emailController.text == _storedEmail &&
                        passwordController.text == _storedPassword) {
                      // Login successful, store the user and navigate
                      
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                          final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
                    final user = UserModel(
                      id: '1',
                      name: _storedName,
                      email: _storedEmail,
                      password: _storedPassword,
                    );
                    sessionProvider.loadSessions(user.id);
                    await authProvider.login(user);
                    print("User logged in: ${authProvider.currentUser?.name}");

                    setState(() {
                      _isLoading = false;
                    });
        
                    // Navigate to home screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => Custombottombar()),
                    );
                  } else {
                      setState(() {
                        _isLoading = false;
                      });
                    // Show error if credentials are incorrect
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid credentials')),
                    );
                  }
                }},
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}