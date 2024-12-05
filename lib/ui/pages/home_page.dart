import 'dart:io';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/notification_services.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/ui/pages/add_task_page.dart';
import 'package:todo_app/ui/size_config.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/widgets/button.dart';
import 'package:todo_app/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    if (Platform.isAndroid) notifyHelper.requestAndroidPermissions();
    if (Platform.isIOS) notifyHelper.requestIOSPermissions();

    _taskController.getTasks();
    notifyHelper.initializeNotification();
  }

  final TaskController _taskController = Get.put(TaskController());
  final ThemeServices _themeServices = Get.find<ThemeServices>();

  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(height: 6),
          _showTasks(),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          _themeServices.switchTheme();
        },
        icon: Obx(() => Icon(
              _themeServices.isDarkMode.value
                  ? Icons.sunny
                  : Icons.nightlight_round,
              size: 24,
            )),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _taskController.deleteAllTasks();
            notifyHelper.cancelAllNotifications();
          },
          icon: Icon(
            Icons.delete_outline,
            color: pinkClr,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: CircleAvatar(
            backgroundImage: AssetImage("images/person.jpeg"),
            radius: 16.0,
          ),
        )
      ],
    );
  }

  Container _addTaskBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                return Text(
                  DateFormat.yMMMMd().format(DateTime.now()).toString(),
                  style: headingStyle,
                );
              }),
              Obx(() {
                return Text(
                  "Today",
                  style: subHeadingStyle,
                );
              }),
            ],
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  Container _addDateBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: _selectedDate,
        width: 80,
        height: 100,
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }

  _showTasks() {
    return Expanded(
      child: Obx(() => _taskController.taskList.isEmpty
          ? _noTaskMsg()
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                scrollDirection: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  Task task = _taskController.taskList[index];

                  // * filter tasks based on their selected date
                  // Daily Condition
                  if (task.repeat == "Daily" ||
                      task.date == DateFormat.yMd().format(_selectedDate) ||
                      // Weekly Condition
                      (task.repeat == "Weekly" &&
                          _selectedDate
                                      .difference(
                                          DateFormat.yMd().parse(task.date!))
                                      .inDays %
                                  7 ==
                              0) ||
                      // Monthly Condition
                      (task.repeat == "Monthly" &&
                          DateFormat.yMd().parse(task.date!).day ==
                              _selectedDate.day)) {
                    // here we notify that the start time has began

                    if (task.startTime != null &&
                        RegExp(r'^\d{1,2}:\d{2}\s(?:AM|PM)$')
                            .hasMatch(task.startTime!)) {
                      var date = DateFormat("hh:mm a").parse(task.startTime!);
                      var myTime = DateFormat("HH:mm").format(date);

                      try {
                        notifyHelper.scheduledNotification(
                          int.parse(myTime.split(":")[0]),
                          int.parse(myTime.split(":")[1]),
                          task,
                        );
                      } catch (e) {
                        print("Failed to schedule notification: $e");
                      }
                    } else {
                      print(
                          "Invalid or missing time format: ${task.startTime}");
                    }

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(seconds: 1),
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () => showBottomSheet(context, task),
                            child: TaskTile(task),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return _noTaskMsg();
                  }
                },
                itemCount: _taskController.taskList.length,
              ),
            )),
    );
  }

  Stack _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 1500),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 6)
                      : const SizedBox(height: 220),
                  SvgPicture.asset(
                    "images/task.svg",
                    colorFilter: ColorFilter.mode(primaryClr, BlendMode.srcIn),
                    height: 90,
                    semanticsLabel: "Task",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: Text(
                      "You do not have any tasks for today!\nAdd new tasks to make your day productive.",
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  GestureDetector _buildBottomSheet({
    required String label,
    required Function() onTap,
    required Color color,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 50,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? _themeServices.isDarkMode.value
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : color,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : color,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.30
                : SizeConfig.screenHeight * 0.39),
        color: _themeServices.isDarkMode.value ? darkGreyClr : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _themeServices.isDarkMode.value
                      ? Colors.grey[600]!
                      : Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(height: 20),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: "Complete Task",
                    onTap: () {
                      notifyHelper.cancelNotification(task);
                      _taskController.markTaskAsCompleted(task.id!);
                      Get.back();
                    },
                    color: primaryClr),
            _buildBottomSheet(
                label: "Delete Task",
                onTap: () {
                  notifyHelper.cancelNotification(task);
                  _taskController.deleteTask(task);
                  Get.back();
                },
                color: pinkClr),
            const SizedBox(height: 40),
            _buildBottomSheet(
              label: "Cancel",
              onTap: () {
                Get.back();
              },
              color: primaryClr,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }
}
