import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  final CollectionReference _tasks = FirebaseFirestore.instance.collection('taskCollection');

  Future<void> _addListItem() async {
    try {
      await _tasks.doc(_nameController.text).set({
        "subTasks": [],
      });
    } catch (e) {
      print("Error adding document: $e");
    }
    setState(() {
      listList.add(TaskList(
        _nameController.text,
        [],
      ));
    });
    _nameController.text = "";
  }
  
  void _deleteList(int index) async {
    try {
      await _tasks.doc(listList[index].listName).delete();
    } catch (e) {
      print("Error removing the task");
    }
    setState(() {
      listList.removeAt(index);
    });
  }

  void _addSubTask(int index) async {
    try {
      await _tasks.doc(listList[index].listName).update({
        "subTasks": FieldValue.arrayUnion([
          {
            "taskName": _nameController.text, 
            "markComplete": false,
          }
        ])
      });
    } catch (e) {
      print("Error with adding subtask");
    }
    setState(() {
      listList[index].subTasks.add(
        Task(
          _nameController.text,
          false,
      ));
    });
    _nameController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot> (
        stream: _tasks.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          listList.clear();
          for (var doc in streamSnapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final listName = doc.id;
            final List<dynamic> subTasksData = data['subTasks'] ?? [];
            List<Task> subTasks = subTasksData.map((subTask) {
              return Task(
                subTask['taskName'],
                subTask['markComplete'],
              );
            }).toList();
            listList.add(TaskList(listName, subTasks));
          }
          
          return Center(child: Column(
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
                              Text( listList[index].listName ),
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
                                          onChanged: (bool? value) async {
                                            final task = listList[index].subTasks[subIndex];
                                            final oldMap = {
                                              "taskName": task.taskName,
                                              "markComplete": task.markComplete,
                                            };
                                            final newMap = {
                                              "taskName": task.taskName,
                                              "markComplete": value!,
                                            };

                                            try {
                                              await _tasks.doc(listList[index].listName).update({
                                                "subTasks": FieldValue.arrayRemove([oldMap])
                                              });
                                              await _tasks.doc(listList[index].listName).update({
                                                "subTasks": FieldValue.arrayUnion([newMap])
                                              });

                                              setState(() {
                                                task.markComplete = value;
                                              });
                                            } catch (e) {
                                              print("Error updating subtask: $e");
                                            }
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
                                            onPressed: () async { 
                                              try {
                                                await _tasks.doc(listList[index].listName).update({
                                                  "subTasks": FieldValue.arrayRemove([
                                                    {
                                                      "taskName": listList[index].subTasks[subIndex].taskName, 
                                                      "markComplete": listList[index].subTasks[subIndex].markComplete,
                                                    }
                                                  ])
                                                });
                                              } catch (e) {
                                                print("Error deleting subtask");
                                              }
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
            ],//widget
          ),//column
        );
        }
      ),
    );//scaffold
  }
}
