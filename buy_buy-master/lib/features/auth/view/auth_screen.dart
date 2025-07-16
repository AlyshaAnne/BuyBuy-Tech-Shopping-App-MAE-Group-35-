import 'package:auto_route/auto_route.dart';
import 'package:buy_buy/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isSignUp = false;

  void _toggleForm(bool isSignUp) {
    setState(() {
      _isSignUp = isSignUp;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Authentication'), centerTitle: true),
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthState,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _toggleForm(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !_isSignUp ? theme.primaryColor : theme.indicatorColor,
                        foregroundColor: !_isSignUp ? theme.hintColor : theme.primaryColor,
                      ),
                      child: const Text('Sign In'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _toggleForm(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSignUp ? theme.primaryColor : theme.indicatorColor,
                        foregroundColor: _isSignUp ? theme.hintColor : theme.primaryColor,
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => val != null && val.contains('@') ? null : 'Enter a valid email',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (val) => val != null && val.length >= 6 ? null : 'Min 6 characters',
                    ),
                    if (_isSignUp) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                        validator: (val) => val != null && val.length >= 6 ? null : 'Enter a valid phone number',
                      ),
                    ],
                    const SizedBox(height: 24),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const CircularProgressIndicator();
                        }
                        return ElevatedButton(onPressed: _submit, child: Text(_isSignUp ? 'Sign Up' : 'Sign In'));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleAuthState(context, state) {
    if (state is Unauthorized && state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error.toString())));
    } else if (state is Authorized && !state.initial) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login successful!')));
      AutoRouter.of(context).maybePop();
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final phone = _phoneController.text.trim();

      final authBloc = context.read<AuthBloc>();

      if (_isSignUp) {
        authBloc.add(AuthSignUpEvent(email: email, password: password, phone: phone));
      } else {
        authBloc.add(AuthSignInEvent(email: email, password: password));
      }
    }
  }
}
