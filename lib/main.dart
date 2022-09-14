import 'package:flutter/material.dart';
import 'package:sqlite_flutter/database/DatabaseHelper.dart';
import 'package:sqlite_flutter/model/DataModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper db = DatabaseHelper.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  List<DataModel> personList = [];
  bool isFetching = true;
  int? currentIndex;

  //insert data
  insertData(DataModel dataModel) {
    db.insertData(dataModel);
  }

  //fetch data
  fetchData() async {
    personList = await db.getData();
    setState(() {
      isFetching = false;
    });
  }

  //edit data
  edit(index) {
    currentIndex = index;
    nameController.text = personList[index].columnName;
    ageController.text = personList[index].columnAge;
    updateDialog();
  }

  //delete data
  delete(index) {
    db.deleteData(personList[index].columnId!);
    setState(() {
      personList.removeAt(index);
    });
  }

//add data dialog
  addDataDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext buildContext) => AlertDialog(
        content: SizedBox(
          height: 150,
          child: Center(
            child: Column(
              children: [
                //name
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //age
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    controller: ageController,
                    decoration: const InputDecoration(
                      hintText: 'Age',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                DataModel dataModel = DataModel(
                    columnName: nameController.text,
                    columnAge: ageController.text);
                insertData(dataModel);
                dataModel.columnId =
                    personList[personList.length - 1].columnId! + 1;
                setState(() {
                  personList.add(dataModel);
                  nameController.clear();
                  ageController.clear();
                  Navigator.pop(context);
                });
              },
              child: const Text('Save')),
        ],
      ),
    );
  }

//update data dialog
  updateDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext buildContext) => AlertDialog(
        content: SizedBox(
          height: 150,
          child: Center(
            child: Column(
              children: [
                //name
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //age
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    controller: ageController,
                    decoration: const InputDecoration(
                      hintText: 'Age',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                DataModel updatedDataModel = personList[currentIndex!];
                updatedDataModel.columnName = nameController.text;
                updatedDataModel.columnAge = ageController.text;
                db.updateData(updatedDataModel, currentIndex!);
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('Update')),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBAF8E4),
      //appbar
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'SQLite',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFBAF8E4),
      ),
      body: SafeArea(
        child: Center(
          child: isFetching == true
              ? const CircularProgressIndicator()
              //data list
              : ListView.builder(
                  itemCount: personList == null ? 0 : personList.length,
                  itemBuilder: (_, index) => ListTile(
                    onTap: () {
                      edit(index);
                    },
                    title: Text(personList[index].columnName),
                    subtitle: Text(personList[index].columnAge),
                    trailing: GestureDetector(
                      onTap: () {
                        delete(index);
                      },
                      child: const Icon(Icons.delete),
                    ),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        color: Color(0xFFE3F2FD),
                      ),
                    ),
                  ),
                ),
        ),
      ),
      //fav for add data
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF1CBDB6),
        onPressed: addDataDialog,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
