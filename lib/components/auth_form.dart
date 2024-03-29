import 'dart:io';

import 'package:chat/components/user_image_picker.dart';
import 'package:chat/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {

  final void Function(AuthFormData) onSubmit;

  const AuthForm({
      Key key,
      @required this.onSubmit
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();

  void _handleImagePick(File image){
    _formData.image = image;
  }
  
  void _showError(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
      )
    );
  }

  void _submit(){
    final isValid = _formKey.currentState.validate() ?? false;
    if(!isValid){
      return;
    }

    if(_formData.image == null && _formData.isSignup){
      //return _showError('Image não selecionada!');
      _formData.image = File('assets/images/avatar.png');
    }

    widget.onSubmit(_formData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Visibility(
                 visible: _formData.isSignup,
                  child: UserImagePicker(onImagePick: _handleImagePick)
              ),
              Visibility(
                visible: _formData.isSignup,
                child: TextFormField(
                  key: ValueKey('name'),
                  initialValue: _formData.name,
                  onChanged: (name) => _formData.name = name,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                  ),
                  validator: (_name){
                    final name = _name ?? '';
                    if(name.trim().length < 5){
                      return 'Nome deve ter no mínimo 5 caracteres.';
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              TextFormField(
                key: ValueKey('email'),
                initialValue: _formData.email,
                onChanged: (email) => _formData.email = email,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                ),
                validator: (_email){
                  final email = _email ?? '';
                  if(!email.contains('@')){
                    return 'E-mail informado não é válido.';
                  }else{
                    return null;
                  }
                },
              ),
              TextFormField(
                key: ValueKey('password'),
                initialValue: _formData.password,
                onChanged: (password) => _formData.password = password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
                validator: (_password){
                  final password = _password ?? '';
                  if(password.length < 6){
                    return 'Senha deve ter no mínimo 6 caracteres.';
                  }else{
                    return null;
                  }
                },
              ),
              SizedBox(height: 12),
              ElevatedButton(
                  onPressed: _submit,
                  child: Text(_formData.isLogin ? 'Entrar' : 'Cadastrar')
              ),
              TextButton(
                  onPressed: (){
                    setState(() {
                      _formData.toogleAuthMode();
                    });
                  },
                  child: Text(
                        _formData.isLogin
                          ? 'Criar uma nova conta?'
                          : 'Já possui conta?'
                      )
              )
            ],
          ),
        ),
      ),
    );
  }
}

