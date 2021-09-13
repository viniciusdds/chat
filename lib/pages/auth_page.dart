import 'package:chat/components/auth_form.dart';
import 'package:chat/core/models/auth_form_data.dart';
import 'package:chat/core/services/auth/auth_mock_service.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool _isLoading = false;

  Future<void> _handleSubmit(AuthFormData formData) async {
    try{
      setState(() =>  _isLoading = true);

      if(formData.isLogin){
        // Login
        await AuthMockService().login(
            formData.email,
            formData.password
        );
      }else{
        // Signup
        await AuthMockService().signup(
            formData.name,
            formData.email,
            formData.password,
            formData.image
        );
      }

    }catch(error){
      // Tratar o erro
    }finally{
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: AuthForm(onSubmit: _handleSubmit),
            ),
          ),
          Visibility(
            visible: _isLoading,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.5)
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ),
    );
  }
}