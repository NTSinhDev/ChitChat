
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restart_app/restart_app.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  const ErrorScreen({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),
                const Spacer(),
                Text(
                  "OOPS! Some thing when Wrong!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontSize: 20),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 32),
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 16),
                Lottie.asset('assets/animations/404.json'),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Restart.restartApp();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 14,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 24,
                      bottom: MediaQuery.of(context).size.height / 20,
                      right: MediaQuery.of(context).size.width / 24,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.blue,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Restart App",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
