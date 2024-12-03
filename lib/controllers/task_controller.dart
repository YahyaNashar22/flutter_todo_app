import 'package:get/get.dart';
import 'package:todo_app/db/db_helper.dart';
import 'package:todo_app/models/task_model.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  Future<int> addTask(Task? task) {
    return DbHelper.insert(task);
  }

  Future<void> getTasks() async {
    final List<Map<String, dynamic>> tasks = await DbHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void deleteTask(task) async {
    await DbHelper.delete(task);
    getTasks();
  }

  void markTaskAsCompleted(int id) async {
    await DbHelper.update(id);
    getTasks();
  }

  void deleteAllTasks() async {
    await DbHelper.deleteAll();
    getTasks();
  }
}
