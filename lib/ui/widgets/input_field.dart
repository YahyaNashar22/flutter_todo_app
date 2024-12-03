import 'package:flutter/material.dart';
import "package:get/get.dart";
import 'package:todo_app/ui/size_config.dart';
import 'package:todo_app/ui/theme.dart';

class MyInputField extends StatelessWidget {
  const MyInputField({
    super.key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  });

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleStyle,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          width: SizeConfig.screenWidth,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  autofocus: false,
                  readOnly: widget != null ? true : false,
                  style: subTitleStyle,
                  cursorColor:
                      Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: subTitleStyle,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.theme.scaffoldBackgroundColor,
                        width: 0,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.theme.scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ),
              widget ?? Container(),
            ],
          ),
        ),
      ],
    );
  }
}
