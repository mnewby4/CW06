import 'package:flutter/material.dart';
/*
  manage list of tasks with CRUD firebase

  UI: 
    Xtext input for task names
    Xadd buttons 
    single list view of tasks
      each should have checkmark to mark as complete, delete to remove task, and nested list for sublist w additional tasks [daily+hourly tasks combined] 
        ex. Monday list = 9-10AM details for that timeframe, Monday again with 12PM-2PM w another list of tasks(?)

  Xstatefulwidget [tasklistscreen] = main screen
    inside: list of tasks [obj w name, completion status, firebase-related info] as instance vars
    methods to add/complete/remove tasks within tasklistscreen idget [incl firebase] 

  firebase--ensure tasks add/complete/remove IRT
    authentication to secure app and identify users

  login and logout for users(?)

  Monday list
    9AM-10PM: 
        HW1
        Essay2
    12PM-2PM: 
        HW2
        Essay4
  Tuesday list
    9AM-10PM: 
      ex2
      blah
    12PM-2PM:
      ex1
      ex3

  Overall task Name
    Subtitle: 
      task 
      task
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

class TaskList {
  String listName; 
  List<Task> subTasks; 
  TaskList(this.listName, this.subTasks);
}

class Task {
  String taskName;
  bool markComplete;

  Task(this.taskName, this.markComplete);
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  List<TaskList> listList = [];

  void _addListItem() {
    setState(() {
      listList.add(TaskList(
        _nameController.text, 
        [],
      ));
    });
  }
  
  void _deleteList(int index) {
    setState(() {
      listList.removeAt(index);
    });
  }

  void _addSubTask(int index) {
    setState(() {
      listList[index].subTasks.add(
        Task(
          _nameController.text,
          false,
      ));
    });
    for (int i = 0; i <= listList[index].subTasks.length; i++) {
      print(listList[index].subTasks[i].taskName);
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
            SizedBox(
              height: 150,
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Add the list or subtask name here"),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  ElevatedButton(
                    onPressed: () { _addListItem(); },
                    child: Text("Add List"),
                  ),
                ],
              ),
            ),
            Container(
              height: 600,
              child: ListView.builder(
                itemCount: listList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            listList[index].listName,
                          ),
                          SizedBox(width: 30.0),
                          SizedBox(
                              child: ElevatedButton(
                                onPressed: () { _deleteList(index); },
                                child: Text('X'),
                              ),
                            ), 
                          SizedBox(
                            child: ElevatedButton(
                              onPressed: () { _addSubTask(index); },
                              child: Text('+ task'),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 100, 
                        child: ListView.builder(
                          shrinkWrap: true, 
                          physics: ClampingScrollPhysics(),
                          itemCount: listList[index].subTasks.length, 
                          itemBuilder: (context, subIndex) {
                            return SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Checkbox(
                                      value: listList[index].subTasks[subIndex].markComplete,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          listList[index].subTasks[subIndex].markComplete = value!;
                                        });
                                      },
                                    ),
                                  Text(
                                    listList[index].subTasks[subIndex].taskName,
                                    style: TextStyle(
                                      color: listList[index].subTasks[subIndex].markComplete 
                                      ? Colors.grey : Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 30.0),
                                  SizedBox(
                                      child: ElevatedButton(
                                        onPressed: () { 
                                          setState(() {
                                            listList[index].subTasks.removeAt(subIndex);
                                          });
                                        },
                                        child: Text('X'),
                                      ),
                                    ), 
                                ],
                              ),
                            );
                          }
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
