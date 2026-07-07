import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_size.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';
import 'package:tasky/core/features/navigation/main_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF181818),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                children: [
                  SizedBox(
                    height: AppSize.ph8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSvgPicture.withoutColor(
                        path: 'assets/images/Logo.svg',
                        hight: AppSize.h42,
                        width: AppSize.w42,
                      ),
                      SizedBox(
                        width: AppSize.pw16,
                      ),
                      Text(
                        "Tasky",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppSize.ph108,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome To Tasky",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      CustomSvgPicture.withoutColor(
                        path: 'assets/images/waving-hand.svg',
                      )
                    ],
                  ),
                  SizedBox(
                    height: AppSize.ph8,
                  ),
                  Text(
                    "Your productivity journey starts here.",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontSize: AppSize.sp16),
                  ),
                  SizedBox(
                    height: AppSize.ph24,
                  ),
                  CustomSvgPicture.withoutColor(
                    path: 'assets/images/welcom.svg',
                    hight: AppSize.h200,
                    width: AppSize.w200,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.pw16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: AppSize.ph24,
                        ),
                        CustomTextFormField(
                          controller: controller,
                          hintText: 'e.g. Ebraam Ehab',
                          title: 'Full Name',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please Enter Your Name";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: AppSize.ph24,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_key.currentState?.validate() ?? false) {
                              await PreferencesManager().setString(
                                  StorageKey.username, controller.value.text);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return MainScreen();
                                  },
                                ),
                              );
                            } else {
                              // Todo : snakbar
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //     elevation: 10,
                              //     content: Text('Please Enter Your Name'),
                              //   ),
                              // );
                            }
                          },
                          child: Text(
                            "Let's Get Started",
                          ),
                        ),
                        SizedBox(
                          height: AppSize.ph24,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
