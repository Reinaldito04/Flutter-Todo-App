import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class Task {
  String title;
  String description;
  bool completed;

  Task(
      {required this.title,
      required this.completed,
      required this.description});
}

class _TasksPageState extends State<TasksPage> {
  List<Task> tasks = [
    Task(title: "Tarea 1", description: "hola", completed: false),
    Task(title: "Tarea 1", description: "hola", completed: false),
    Task(title: "Tarea 1", description: "si", completed: false),
  ];

  bool showCompletedTasks = false;

  @override
  Widget build(BuildContext context) {
    List<Task> pendingTasks = tasks.where((task) => !task.completed).toList();
    List<Task> completedTasks = tasks.where((task) => task.completed).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Tareas Pendientes",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${pendingTasks.length}",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent),
                    ),
                  ],
                )),
            Expanded(
              child: ListView.builder(
                itemCount: pendingTasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    title: Text(pendingTasks[index].title),
                    value: pendingTasks[index].completed,
                    onChanged: (bool? value) {
                      setState(() {
                        pendingTasks[index].completed = value!;
                      });
                    },
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  showCompletedTasks = !showCompletedTasks;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Tareas Completadas (${completedTasks.length})",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              alignment: showCompletedTasks
                  ? Alignment.bottomCenter
                  : Alignment.topCenter,
              height: showCompletedTasks ? 150 : 0,
              child: showCompletedTasks
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: completedTasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(completedTasks[index].title),
                          // Puedes añadir más detalles aquí si es necesario
                        );
                      },
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskModal(context);
        },
        backgroundColor: Colors.blue, // Color de fondo del botón
        foregroundColor: Colors.white, // Color del icono del botón
        elevation: 4.0, // Elevación del botón
        tooltip: "Añadir",

        shape: RoundedRectangleBorder(
          // Forma del botón
          borderRadius: BorderRadius.circular(25.0), // Bordes redondeados
        ),
        child: Icon(Icons.add), // Icono del botón
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
    String title = '';
    String description = '';

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Añadir Tarea',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Ingrese el título de la tarea',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    title = value;
                  },
                ),
                Text(
                  "Añadir Descripción",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Ingrese la descripción de la tarea',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => description = value,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (title.isNotEmpty && description.isNotEmpty) {
                      setState(() {
                        tasks.add(Task(
                          title: title,
                          description: description,
                          completed: false,
                        ));
                      });
                      Navigator.pop(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content:
                                Text('Por favor, completa todos los campos.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Agregar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
