import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../services/surau_database_service.dart';

class SenaraiSurauJumaatPage extends StatefulWidget {
  @override
  _SenaraiSurauJumaatPageState createState() => _SenaraiSurauJumaatPageState();
}

class _SenaraiSurauJumaatPageState extends State<SenaraiSurauJumaatPage> {
  List<Map<String, dynamic>> _surauList = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedNegeri;
  String? _selectedDaerah;
  List<String> _negeriList = [];
  List<String> _daerahList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Clean text to remove invalid encoding characters
  String _cleanText(String? text) {
    if (text == null || text.isEmpty) return 'N/A';
    
    // Handle common encoding issues
    String cleaned = text
        .replaceAll('â', '-') // Replace corrupted "â" with dash (common in "AL-ISLAH" cases)
        .replaceAll(RegExp(r'[^\x20-\x7E\u00A0-\u024F\u1E00-\u1EFF\u0590-\u05FF]+'), ' ') // Keep printable ASCII, Latin, and Hebrew chars
        .replaceAll(RegExp(r'\s+'), ' ') // Replace multiple spaces with single space
        .trim();
    
    // If result is empty after cleaning, return original or N/A
    return cleaned.isEmpty ? (text.trim().isEmpty ? 'N/A' : text.trim()) : cleaned;
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Load negeri list
      final negeriList = await SurauDatabaseService.getNegeriList();
      
      setState(() {
        _negeriList = negeriList;
        _isLoading = false;
      });

      // Load initial surau list
      await _searchSurau();
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchSurau() async {
    try {
      List<Map<String, dynamic>> results;

      if (_searchQuery.isNotEmpty) {
        results = await SurauDatabaseService.searchSurau(_searchQuery);
      } else if (_selectedDaerah != null && _selectedDaerah!.isNotEmpty) {
        results = await SurauDatabaseService.getSurauByDaerah(_selectedDaerah!);
      } else if (_selectedNegeri != null && _selectedNegeri!.isNotEmpty) {
        results = await SurauDatabaseService.getSurauByNegeri(_selectedNegeri!);
      } else {
        results = await SurauDatabaseService.getAllSurau();
      }

      setState(() {
        _surauList = results;
      });
    } catch (e) {
      print('Error searching surau: $e');
    }
  }

  Future<void> _onNegeriChanged(String? negeri) async {
    setState(() {
      _selectedNegeri = negeri;
      _selectedDaerah = null;
      _daerahList = [];
    });

    if (negeri != null && negeri.isNotEmpty) {
      final daerahList = await SurauDatabaseService.getDaerahList(negeri);
      setState(() {
        _daerahList = daerahList;
      });
    }

    await _searchSurau();
  }

  Future<void> _onDaerahChanged(String? daerah) async {
    setState(() {
      _selectedDaerah = daerah;
    });
    await _searchSurau();
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
        backgroundColor: AppConstants.appBarColor,
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
                        hintText: 'Cari surau, negeri, daerah, atau alamat...',
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
                        _searchSurau();
                      },
                    ),
                  ),
                  // Filter Dropdowns
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            value: _selectedNegeri,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Negeri',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: [
                              DropdownMenuItem<String>(
                                value: null,
                                child: Text('Semua Negeri', overflow: TextOverflow.ellipsis),
                              ),
                              ..._negeriList.map((negeri) => DropdownMenuItem<String>(
                                value: negeri,
                                child: Text(negeri, overflow: TextOverflow.ellipsis),
                              )),
                            ],
                            onChanged: _onNegeriChanged,
                          ),
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          flex: 1,
                          child: Opacity(
                            opacity: (_selectedNegeri != null && _selectedNegeri!.isNotEmpty) ? 1.0 : 0.5,
                            child: DropdownButtonFormField<String>(
                              value: _selectedDaerah,
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Daerah',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              items: [
                                DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('Semua Daerah', overflow: TextOverflow.ellipsis),
                                ),
                                ..._daerahList.map((daerah) => DropdownMenuItem<String>(
                                  value: daerah,
                                  child: Text(daerah, overflow: TextOverflow.ellipsis),
                                )),
                              ],
                              onChanged: (_selectedNegeri != null && _selectedNegeri!.isNotEmpty)
                                  ? _onDaerahChanged
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Surau List
                  Expanded(
                    child: _surauList.isEmpty
                        ? Center(
                            child: Text(
                              'Tiada surau dijumpai',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _surauList.length,
                            itemBuilder: (context, index) {
                              final surau = _surauList[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: 10),
                                color: Colors.white.withOpacity(0.9),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.mosque,
                                    color: AppConstants.appBarColor,
                                  ),
                                  title: Text(
                                    _cleanText(surau['surau']?.toString() ?? 'N/A'),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (surau['alamat'] != null && surau['alamat'].toString().isNotEmpty)
                                        Text(_cleanText(surau['alamat'].toString())),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          if (surau['daerah'] != null && surau['daerah'].toString().isNotEmpty)
                                            Text(
                                              _cleanText(surau['daerah'].toString()),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          if (surau['poskod'] != null && surau['poskod'].toString().isNotEmpty)
                                            Text(
                                              ' ${_cleanText(surau['poskod'].toString())}',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                        ],
                                      ),
                                      if (surau['negeri'] != null && surau['negeri'].toString().isNotEmpty)
                                        Text(
                                          _cleanText(surau['negeri'].toString()),
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                        ),
                                      if (surau['telefon'] != null && surau['telefon'].toString().isNotEmpty)
                                        Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text(
                                            'Tel: ${_cleanText(surau['telefon'].toString())}',
                                            style: TextStyle(fontSize: 12, color: Colors.blue),
                                          ),
                                        ),
                                    ],
                                  ),
                                  isThreeLine: true,
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

