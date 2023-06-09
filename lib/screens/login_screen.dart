import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fire_crud/providers/providers.dart';
import 'package:fire_crud/screens/screens.dart';
import 'package:fire_crud/services/services.dart';
import 'package:fire_crud/themes/app_theme.dart';
import 'package:fire_crud/ui/input_decorations.dart';
import 'package:fire_crud/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const String routerName = "Login";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
                child: Column(
      children: [
        const SizedBox(height: 200),
        CardContainer(
            child: Column(children: [
          const SizedBox(height: 10),
          Text('Login', style: Theme.of(context).textTheme.headline4),
          const SizedBox(height: 30),
          ChangeNotifierProvider(
            create: (_) => LoginFormProvider(),
            child: const _LoginForm(),
          )
        ])),
        const SizedBox(height: 30),
        TextButton(
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                    AppTheme.primary.withOpacity(0.1)),
                shape: MaterialStateProperty.all(const StadiumBorder())),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, RegisterScreen.routerName);
            },
            child: const Text('Crear una nueva cuenta.',
                style: TextStyle(fontSize: 18, color: Colors.black87))),
        const SizedBox(height: 30),
      ],
    ))));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'john.doe@gmail.com',
                  labelText: 'Email',
                  prefixIcon: Icons.alternate_email_sharp),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El correo no tiene un formato valido';
              }),
          const SizedBox(height: 25),
          TextFormField(
              autocorrect: false,
              obscureText: true,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe tener mas de 6 caracteres';
              }),
          const SizedBox(height: 25),
          MaterialButton(
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      //Quitamos el teclado al pulsar el boton
                      FocusScope.of(context).unfocus();

                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      //Al pulsar el boton se comprueba si el form es valido a traves del provider
                      if (!loginForm.isValidForm()) return;
                      loginForm.isLoading = true;
                      final String? errorMsg = await authService.mailLogin(
                          loginForm.email, loginForm.password);

                      if (errorMsg == null)
                        Navigator.pushReplacementNamed(
                            context, HomeScreen.routerName);
                      else // Mostrar error en pantalla
                        NotificationsService.showSnackBar(errorMsg);

                      loginForm.isLoading = false;
                    },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
              color: AppTheme.primary,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? 'Espere' : 'Iniciar sesión',
                    style: TextStyle(color: Colors.white),
                  ))),
          const SizedBox(height: 25),
          MaterialButton(
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      //Quitamos el teclado al pulsar el boton
                      FocusScope.of(context).unfocus();

                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      loginForm.isLoading = true;

                      //Inicia session con cuenta de google
                      final String? errorMsg =
                          await authService.signInWithGoogle();

                      if (errorMsg == null)
                        Navigator.pushReplacementNamed(
                            context, HomeScreen.routerName);
                      else // Mostrar error en pantalla
                        NotificationsService.showSnackBar(errorMsg);

                      loginForm.isLoading = false;
                    },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
              color: const Color.fromARGB(255, 102, 152, 228),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Container(
                      child: Text(
                    loginForm.isLoading
                        ? 'Espere'
                        : 'Iniciar sesión con Google',
                    style: const TextStyle(color: Colors.white),
                  ))))
        ]));
  }
}
