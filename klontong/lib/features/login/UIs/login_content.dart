import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/features/login/UIs/login_error_type.enum.dart';
import 'package:klontong/features/login/login_page.state.dart';
import 'package:klontong/features/login/login_page.uiapicubit.dart';
import 'package:klontong/shared/UIs/shared.ui.dart';

class LoginContent extends StatelessWidget {
  const LoginContent({super.key, this.isForRegister = false});

  final bool isForRegister;

  @override
  Widget build(context) => Card(
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              TextField(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                cursorColor: Theme.of(context).colorScheme.onPrimaryContainer,
                decoration: SharedUI.inputDecoration(
                  context: context,
                  hintText: 'Enter your Email',
                  labelText: 'Email',
                ),
                onChanged: context.read<LoginPageUiCubit>().updateEmail,
              ),
              const SizedBox(height: 10),
              TextFormField(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                cursorColor: Theme.of(context).colorScheme.onPrimaryContainer,
                obscureText: true,
                decoration: SharedUI.inputDecoration(
                  context: context,
                  hintText: 'Enter your password',
                  labelText: 'Password',
                ),
                onChanged: context.read<LoginPageUiCubit>().updatePassword,
              ),
              if (isForRegister) const SizedBox(height: 10),
              if (isForRegister)
                TextFormField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  cursorColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  obscureText: true,
                  decoration: SharedUI.inputDecoration(
                    context: context,
                    hintText: 'Reenter your password',
                    labelText: 'Confirm Password',
                  ),
                  onChanged:
                      context.read<LoginPageUiCubit>().updateReTypePassword,
                ),
              const SizedBox(height: 10),
              BlocSelector<LoginPageUiCubit, LoginPageState,
                  Set<LoginErrorType>>(
                selector: (state) => state.errorList,
                builder: (_, list) {
                  if (list.isEmpty) return const SizedBox.shrink();
                  return Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        for (int i = 0; i < list.length; i++)
                          Text(
                            list.elementAt(i).name,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                onPressed: isForRegister
                    ? context.read<LoginPageUiCubit>().onRegister
                    : context.read<LoginPageUiCubit>().onLogin,
                child: Text(
                  isForRegister ? 'Register' : 'Login',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
              ),
              if (!isForRegister) const SizedBox(height: 10),
              if (!isForRegister)
                Text(
                  'or',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16,
                  ),
                ),
              if (!isForRegister)
                TextButton(
                  onPressed: () => context.read<LoginPageUiCubit>().to(1),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (isForRegister) const SizedBox(height: 10),
              if (isForRegister)
                TextButton(
                  onPressed: () => context.read<LoginPageUiCubit>().to(0),
                  child: Text(
                    'Already have account, Login',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}
