import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dot_expense/database_helper.dart';
import 'package:flutter_dot_expense/models/category.dart';
import 'package:flutter_dot_expense/models/expense.dart';
import 'package:flutter_dot_expense/screens/add_expense_screen.dart';
import 'package:intl/intl.dart';

class ExpenseListScreen extends StatefulWidget {
  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final dbHelper = DatabaseHelper.instance;

  List<Expense> _allExpenses;
  int _total;

  List<int> _totalCategory = List<int>();

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

  String getStringImage(String category) {
    if (category == 'Makanan') {
      return 'assets/images/makanan.png';
    } else if (category == 'Internet') {
      return 'assets/images/internet.png';
    } else if (category == 'Edukasi') {
      return 'assets/images/edukasi.png';
    } else if (category == 'Hadiah') {
      return 'assets/images/hadiah.png';
    } else if (category == 'Transport') {
      return 'assets/images/transport.png';
    } else if (category == 'Belanja') {
      return 'assets/images/belanja.png';
    } else if (category == 'Alat Rumah') {
      return 'assets/images/alat_rumah.png';
    } else if (category == 'Olahraga') {
      return 'assets/images/olahraga.png';
    } else if (category == 'Hiburan') {
      return 'assets/images/hiburan.png';
    }
  }

  final formatCurrency =
      NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);

  void _getAllExpenses() async {
    final allRows = await dbHelper.queryAllRows();
    setState(() {
      _allExpenses = allRows;
    });

    print('query all rows:');
    allRows.forEach((row) => _allExpenses = allRows);
  }

  void _calculateTotalExpenses() async {
    var total = (await dbHelper.getTotalExpense())[0]['Total'];
    print(total);
    setState(() {
      _total = total;
    });
  }

  Future<int> calculatePerCategory(String category) async {
    var total = (await dbHelper.getTotalCategory('$category'))[0]['Total'];
    return total;
  }

  void _getTotalPerCategory(){
    for (var cat in _availableCategory) {
      calculatePerCategory(cat.name).then((value) {
        setState(() {
          _totalCategory.add(value);
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getTotalPerCategory();
    _calculateTotalExpenses();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    _getAllExpenses();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Color.fromRGBO(70, 181, 167, 1),
              height: MediaQuery.of(context).size.height / 3,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.teal[600]),
                    child: Icon(
                      Icons.person_outline_sharp,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Pengeluaran Anda Hari Ini',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    _total != null ? formatCurrency.format(_total) : "0",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'Pengeluaran Berdasarkan Kategori',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              height: 150.0,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                scrollDirection: Axis.horizontal,
                itemCount: _availableCategory.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      width: 150,
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                              image:
                                  AssetImage(_availableCategory[index].image)),
                          Text(_availableCategory[index].name),
                          _totalCategory.isNotEmpty ?
                              _totalCategory[index] != null ?
                          Text(formatCurrency.format(_totalCategory[index]), style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),) : Text('Rp 0') : SizedBox()
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(width: 10),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'Semua Pengeluaran',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            _allExpenses != null
                ? Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                          child: Text(
                            _allExpenses.isNotEmpty
                                ? 'Hari Ini'
                                : 'Tidak ada pengeluaran',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(20),
                          shrinkWrap: true,
                          itemCount: _allExpenses.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor:
                                        Color.fromRGBO(242, 242, 242, 1),
                                    child: Image(
                                        image: AssetImage(getStringImage(
                                            _allExpenses[index].category))),
                                  ),
                                  SizedBox(width: 10),
                                  Text(this._allExpenses[index].name),
                                  Spacer(),
                                  // Text(_allExpenses[index].date),
                                  Text(
                                    formatCurrency
                                        .format(_allExpenses[index].nominal),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                : Text('No Data')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {
          Navigator.of(context)
              .pushNamed(AddExpenseScreen.routeName)
              .then((value) {
            _getAllExpenses();
            _calculateTotalExpenses();
            _getTotalPerCategory();
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), //
    );
  }
}
