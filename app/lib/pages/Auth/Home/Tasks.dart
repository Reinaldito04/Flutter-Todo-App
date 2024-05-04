import 'dart:async';

import 'package:app/api/DeleteTask.dart' as eliminarTarea;
import 'package:app/api/EditTask.dart';
import 'package:app/api/TaskGet.dart';
import 'package:app/api/TaskPost.dart';
import 'package:flutter/material.dart';

import 'package:app/api/CompletedTask.dart' as completarTarea;

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Task> tasks = [];

  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      TaskGet taskGet = TaskGet();
      List<Task> fetchedTasks = await taskGet.fetchTasks();
      setState(() {
        tasks = fetchedTasks;
        isLoading = false;
        print("Se ha actualizado");
      });
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
        tasks =
            []; // Asigna una lista vacía en caso de error al cargar las tareas
      });
      print('Error al obtener las tareas: $e');
    }
  }

  bool showCompletedTasks = false;
  TextEditingController _dateController = TextEditingController();

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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${pendingTasks.length}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: pendingTasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            _showTaskDetails(context, pendingTasks[index]);
                          },
                          child: ListTile(
                            title: Text(pendingTasks[index].title),
                            leading: Checkbox(
                              value: pendingTasks[index].completed,
                              onChanged: (bool? value) {
                                setState(() {
                                  pendingTasks[index].completed = value!;
                                });
                                if (value == true) {
                                  var id = pendingTasks[index].id;
                                  completarTarea.CompletedTask()
                                      .completarTarea(id);
                                }
                              },
                            ),
                          ),
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
                      shrinkWrap: false,
                      itemCount: completedTasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            _showTaskDetails(context, completedTasks[index]);
                          },
                          child: ListTile(
                            title: Text(completedTasks[index].title),
                            leading: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                var id = completedTasks[index].id;
                                eliminarTarea.DeleteTask().delete(id);
                                _fetchTasks();
                              },
                            ),
                          ),
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

  void _showTaskDetails(BuildContext context, Task task) {
    // Formatear la fecha en el formato deseado

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(task.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Descripción: ${task.description}'),
              Text(
                  'Fecha límite: ${task.fecha}'), // Mostrar la fecha formateada
              // Agrega más información sobre la tarea según sea necesario
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para eliminar la tarea

                eliminarTarea.DeleteTask().delete(task.id);
                _fetchTasks();

                Navigator.pop(context);
              },
              child: Text('Eliminar'),
            ),
            TextButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para editar la tarea
                Navigator.pop(context);
                _showAddTaskModal(context, task: task);
              },
              child: Text('Editar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cerrar'),
            ),
            // Agrega más acciones según sea necesario, como editar, eliminar, etc.
          ],
        );
      },
    );
  }

  Future<void> _selectedDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2200));

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  void _showAddTaskModal(BuildContext context, {Task? task}) {
    String title = task?.title ?? '';
    String description = task?.description ?? '';

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
                  task == null ? 'Añadir Tarea' : 'Editar Tarea',
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
                  task == null ? 'Añadir Descripción' : 'Editar Descripción',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Ingrese la descripción de la tarea',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => description = value,
                  textInputAction: TextInputAction.next,
                ),
                Text(
                  task == null ? 'Añadir Fecha limite' : 'Editar Fecha Limite',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: "Fecha",
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_today),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                  onTap: () {
                    _selectedDate();
                  },
                  readOnly: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (title.isNotEmpty &&
                        description.isNotEmpty &&
                        _dateController.text.isNotEmpty) {
                      // Instancia TaskPost para enviar la nueva tarea al servidor
                      if (task ==null){
                        _addTask(title, description);   
                      }
                      else{
                        _editTarea(title, description, task.id);
                      }
                      
                    } else {
                      // Si falta algún campo, muestra un diálogo de error
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
                  child: Text(
                    task==null ?'Agregar':"Editar",
                    
                   ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addTask(String title, String description) {
    TaskPost taskport = TaskPost();
    Task newTask = Task(
      id: 0, // Ajusta el ID según tu lógica de generación de IDs en el servidor
      title: title,
      description: description,
      completed: false,
      fecha: _dateController.text,
    );
    taskport.addTask(newTask).then((_) {
      // Cuando la tarea se haya agregado exitosamente, actualiza la lista de tareas
      _fetchTasks(); // <-- Aquí se llama a _fetchTasks() para obtener las tareas actualizadas
      _dateController.text = '';
      Navigator.pop(context);
    }).catchError((error) {
      print(error);
      // Si ocurre un error al agregar la tarea, muestra un diálogo de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Ocurrió un error al agregar la tarea.'),
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
    });
  }


 void _editTarea(String title, String description,int id) {
    
    Task newTask = Task(
      id:id,
      title: title,
      description: description,
      completed: false,
      fecha: _dateController.text,
    );
     EditTask().Edit(newTask, id).then((_) {
      // Cuando la tarea se haya agregado exitosamente, actualiza la lista de tareas
      _fetchTasks(); // <-- Aquí se llama a _fetchTasks() para obtener las tareas actualizadas
      _dateController.text = '';
      Navigator.pop(context);
    }).catchError((error) {
      print(error);
      // Si ocurre un error al agregar la tarea, muestra un diálogo de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Ocurrió un error al agregar la tarea.'),
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
    });
  }

}
