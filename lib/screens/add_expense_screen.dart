import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dot_expense/database_helper.dart';
import 'package:intl/intl.dart';

import '../models/category.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  static const routeName = 'add_expense_screen';

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final dbHelper = DatabaseHelper.instance;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _expenseNameController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _nominalController = TextEditingController();
  String _imageCategorySelected;

  String _expenseName;
  String _expenseCategory;
  String _expenseDate;
  int _expenseNominal;

  DateTime selectedDate = DateTime.now();

  List<Category> _availableCategory = [
    Category('Makanan', 'assets/images/makanan.png'),
    Category('Internet', 'assets/images/internet.png'),
    Category('Edukasi', 'assets/images/edukasi.png'),
    Category('Hadiah', 'assets/images/hadiah.png'),
    Category('Transport', 'assets/images/transport.png'),
    Category('Belanja', 'assets/images/belanja.png'),
    Category('Alat Rumah', 'assets/images/alat_rumah.png'),
    Category('Olahraga', 'assets/images/olahraga.png'),
    Category('Hiburan', 'assets/images/hiburan.png'),
  ];

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime.now());
    if (picked != null)
      setState(() {
        selectedDate = picked;
        print(picked.toIso8601String());
        _dateController.text = DateFormat.yMMMd().format(selectedDate);
      });
  }

  Future<void> _insert() async {
    var expenseItem = Expense(
        name: _expenseNameController.text,
        category: _categoryController.text,
        date: selectedDate.toIso8601String(),
        nominal: int.parse(_nominalController.text));

    final id = await dbHelper.insert(expenseItem);
    print('inserted row id: $id');
  }

  @override
  void initState() {
    // TODO: implement initState
    _expenseName = '';
    _expenseCategory = '';
    _expenseDate = '';
    _expenseNominal = 0;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _expenseNameController.dispose();
    _categoryController.dispose();
    _dateController.dispose();
    _nominalController.dispose();
    super.dispose();
  }

  void displayModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: GridView.builder(
                itemCount: _availableCategory.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      print(_availableCategory[index].name);
                      setState(() {
                        _categoryController.text =
                            _availableCategory[index].name;
                        _imageCategorySelected =
                            _availableCategory[index].image;
                      });

                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(242, 242, 242, 1)),
                              child: Image(
                                  image: AssetImage(
                                      _availableCategory[index].image))),
                          Text(_availableCategory[index].name),
                        ],
                      ),
                    ),
                  );
                }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 25,
                    )),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "Tambah Pengeluaran Baru",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Nama Pengeluaran'),
                    TextFormField(
                      controller: _expenseNameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Kategori'),
                    TextFormField(
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        displayModalBottomSheet(context);
                      },
                      controller: _categoryController,
                      decoration: InputDecoration(
                          prefixIcon: _imageCategorySelected != null
                              ? Image(image: AssetImage(_imageCategorySelected))
                              : Icon(Icons.category),
                          suffixIcon: Icon(Icons.arrow_right),
                          border: InputBorder.none,
                          hintText: 'Masukkan Kategori'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Tanggal'),
                    TextFormField(
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _selectDate(context);
                      },
                      controller: _dateController,
                      decoration: InputDecoration(
                          // border: InputBorder.none,
                          suffixIcon: InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Icon(
                              Icons.date_range,
                              color: Colors.grey,
                            ),
                          ),
                          hintStyle: TextStyle(fontSize: 11.0)),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Nominal'),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixText: 'Rp ',
                      ),
                      keyboardType: TextInputType.number,
                      controller: _nominalController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false
                          // otherwise.
                          if (_formKey.currentState.validate()) {
                            // // If the form is valid, display a Snackbar.
                            // Scaffold.of(context).showSnackBar(
                            //     SnackBar(content: Text('Processing Data')));
                            _insert().then((value) => showDialog(
                                context: context,
                                builder: (_) => new AlertDialog(
                                      title: new Text("Sukses"),
                                      content: new Text(
                                          "Data pengeluaranmu berhasil ditambahkan"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Close me!'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    )));
                          }
                        },
                        child: Text('Simpan'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
