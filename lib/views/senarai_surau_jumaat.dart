import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class SenaraiSurauJumaatPage extends StatefulWidget {
  @override
  _SenaraiSurauJumaatPageState createState() => _SenaraiSurauJumaatPageState();
}

class _SenaraiSurauJumaatPageState extends State<SenaraiSurauJumaatPage> {
  List<List<dynamic>> _surauList = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCSVData();
  }

  Future<void> _loadCSVData() async {
    try {
      // Try to load CSV file from assets
      // You'll need to add the CSV file to assets folder and update pubspec.yaml
      final String csvData = await rootBundle.loadString('assets/data/surau_jumaat.csv');
      final List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvData);
      
      setState(() {
        _surauList = csvTable;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading CSV: $e');
      // If CSV file doesn't exist, use placeholder data
      setState(() {
        _surauList = [
          ['Nama Surau', 'Alamat', 'Bandar', 'Negeri'],
          ['Surau Al-Ikhlas', 'Jalan ABC', 'Kuala Lumpur', 'Wilayah Persekutuan'],
          ['Surau Al-Falah', 'Jalan XYZ', 'Shah Alam', 'Selangor'],
          // Add more placeholder data or load from actual CSV
        ];
        _isLoading = false;
      });
    }
  }

  List<List<dynamic>> get _filteredList {
    if (_searchQuery.isEmpty) {
      return _surauList.length > 1 ? _surauList.sublist(1) : [];
    }
    
    return _surauList.where((row) {
      if (row.isEmpty) return false;
      final searchLower = _searchQuery.toLowerCase();
      return row.any((cell) => cell.toString().toLowerCase().contains(searchLower));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Senarai Surau Jumaat',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 52, 21, 104),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari surau...',
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  // Surau List
                  Expanded(
                    child: _filteredList.isEmpty
                        ? Center(
                            child: Text(
                              'Tiada surau dijumpai',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredList.length,
                            itemBuilder: (context, index) {
                              final surau = _filteredList[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: 10),
                                color: Colors.white.withOpacity(0.9),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.mosque,
                                    color: const Color.fromARGB(255, 52, 21, 104),
                                  ),
                                  title: Text(
                                    surau.isNotEmpty ? surau[0].toString() : 'N/A',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (surau.length > 1)
                                        Text(surau[1].toString()),
                                      if (surau.length > 2)
                                        Text(
                                          '${surau.length > 3 ? surau[2].toString() : ''} ${surau.length > 3 ? surau[3].toString() : ''}',
                                        ),
                                    ],
                                  ),
                                  isThreeLine: surau.length > 2,
                                ),
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

