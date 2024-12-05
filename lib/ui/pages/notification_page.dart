import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/ui/theme.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, required this.payload});

  final String payload;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String _payload = "";

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
          color: Get.isDarkMode ? primaryClr : Colors.white,
        ),
        elevation: 0,
        backgroundColor: context.theme.primaryColor,
        title: Text(
          _payload.toString().split("|")[0],
          style: headingStyle.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Hello Yahya",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Get.isDarkMode ? Colors.white : darkGreyClr,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "You have a new reminder",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Get.isDarkMode ? Colors.grey[500] : darkGreyClr,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: primaryClr,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title
                    Row(
                      children: [
                        Icon(
                          Icons.text_format,
                          size: 35,
                          color: context.theme.iconTheme.color,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Title",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _payload.toString().split("|")[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    //description
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(
                          Icons.description,
                          size: 35,
                          color: context.theme.iconTheme.color,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Description",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // date
                    Text(
                      _payload.toString().split("|")[1],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 35,
                          color: context.theme.iconTheme.color,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Date",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _payload.toString().split("|")[2],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      )),
    );
  }
}
