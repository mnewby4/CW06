import 'package:flutter/material.dart';
/*
  manage list of tasks with CRUD firebase

  UI: 
    text input for task names
    add buttons 
    single list view of tasks
      each should have checkmark to mark as complete, delete to remove task, and nested list for sublist w additional tasks [daily+hourly tasks combined] 
        ex. Monday list = 9-10AM details for that timeframe, Monday again with 12PM-2PM w another list of tasks(?)

  statefulwidget [tasklistscreen] = main screen
    inside: list of tasks [obj w name, completion status, firebase-related info] as instance vars
    methods to add/complete/remove tasks within tasklistscreen idget [incl firebase] 

  firebase--ensure tasks add/complete/remove IRT
    authentication to secure app and identify users

  login and logout for users(?)
 */

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Task Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Task {
  String taskName;
  bool markComplete;
  List<Task> subTasks; 

  Task(this.taskName, this.markComplete, this.subTasks);
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  List<Task> taskList = [];
  /*int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }*/

  void _addTask() {
    setState(() {
      taskList.add(Task(
        _nameController.text, 
        false, 
        [],
      ));
    });
    for (int i = 0; i < taskList.length; i++) {
      print(taskList[i].taskName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /*const Text('You have pushed the button this many times:'),
            Text(
              _nameController.text,
              style: Theme.of(context).textTheme.headlineMedium,
            ),*/
            SizedBox(
              height: 150,
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Add a new task here"),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Task Name'),
                  ),
                  ElevatedButton(
                    onPressed: () { _addTask(); },
                    child: Text("Add Task"),
                  ),
                ],
              ),
            ),
            Container(
              height: 500,
               child: ListView.builder(
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: taskList[index].markComplete,
                            onChanged: (bool? value) {
                              setState(() {
                                taskList[index].markComplete = value!;
                                print(taskList[index].markComplete);
                              });
                            },
                          ),
                            Text(
                              taskList[index].taskName,
                              style: TextStyle(
                                color: taskList[index].markComplete ? Colors.grey : Colors.black,
                              ),
                            ),
                          SizedBox(width: 30.0),
                          SizedBox(
                            child: ElevatedButton(
                              onPressed: () { /*_deleteTask(index);*/ print("HIII"); },
                              child: Text('X'),
                            ),
                          ), 
                        ],
                      ),
                    );
                  },
                ),
            ),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/
    );
  }
}
