import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tender Square',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'NunitoSans',
      ),
      home: const MyHomePage(title: 'Tender Square 🌴'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _isLoading = false;

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  Future<void> _loadPage() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _loadPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, left: 20.0),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 40.0,
              color: Colors.white,
              fontFamily: 'Pacifico-Regular',
            ),
          ),
        ),
        elevation: 4.0,
        shadowColor: Colors.green.withOpacity(0.4),
        toolbarHeight: 100.0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          : IndexedStack(
              index: _selectedIndex,
              children: <Widget>[
                _buildHomeContent(),
                const EarningsPage(),
                const SchedulePage(),
                const ContactsPage(),
              ],
            ),
      bottomNavigationBar: Material(
        elevation: 20.0,
        child: Container(
          height: 90.0,
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 30.0),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.wallet_rounded, size: 30.0),
                label: 'Earnings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.watch_rounded, size: 30.0),
                label: 'Schedule',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded, size: 30.0),
                label: 'Contacts',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'NunitoSans',
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'NunitoSans',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30.0),
              const Text(
                'Welcome to Tender Square!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                  fontFamily: 'NunitoSans',
                ),
              ),
              const SizedBox(height: 20.0),
              _buildContainer(
                child: Column(
                  children: [
                    _buildGradientButton('Buy 🤝', textColor: Colors.white),
                    const SizedBox(height: 20.0),
                    _buildGradientButton('Sell 💰', textColor: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
              _buildContainer(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Today's Earnings",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Color(0xFF4CAF50),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NunitoSans',
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total Earnings:',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0xFF4CAF50),
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'NunitoSans',
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    const Text(
                                      'Rs. 28000/-',
                                      style: TextStyle(
                                        fontSize: 32.0,
                                        color: Color(0xFF4CAF50),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oswald-Bold',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50.0,
                                child: VerticalDivider(
                                  color: Color(0xFF4CAF50),
                                  thickness: 2.0,
                                  width: 20.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Net Profit:',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0xFF4CAF50),
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'NunitoSans',
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    const Text(
                                      'Rs. 7000/-',
                                      style: TextStyle(
                                        fontSize: 32.0,
                                        color: Color(0xFF4CAF50),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oswald-Bold',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
              _buildContainer(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Today Total Count",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NunitoSans',
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Month: 9000',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Color(0xFF4CAF50),
                                      fontFamily: 'NunitoSans',
                                    ),
                                  ),
                                  const Text(
                                    '1000',
                                    style: TextStyle(
                                      fontSize: 80.0,
                                      color: Color(0xFF4CAF50),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Oswald-Bold',
                                    ),
                                  ),
                                  const Text(
                                    'Juice: 750',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Color(0xFF4CAF50),
                                      fontFamily: 'NunitoSans',
                                    ),
                                  ),
                                  const Text(
                                    'Water: 250',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Color(0xFF4CAF50),
                                      fontFamily: 'NunitoSans',
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset(
                                'assets/Rectangle.png',
                                width: 200.0,
                                height: 200.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 70.0,
              ),
              const Text(
                'Made with ❤️ by Hadil',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xFF4CAF50),
                  fontFamily: 'NunitoSans',
                ),
              ),
              const SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(26.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildGradientButton(String text, {Color textColor = Colors.white}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          backgroundColor: Colors.green,
          shadowColor: Colors.greenAccent.withOpacity(0.3),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'NunitoSans',
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class EarningsPage extends StatelessWidget {
  const EarningsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              _buildContainer(
                context: context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .stretch, // Make sure the column takes full width
                  children: [
                    Text(
                      "Today Total Earnings:",
                      style: TextStyle(
                        fontSize: 18.0, // Size of the text
                        fontWeight: FontWeight.bold, // Font weight (e.g., bold)
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Earning :',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                  height:
                                      8.0), // Spacing between text and amount
                              Text(
                                '₹1500000/-',
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Oswald-Bold',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 2, // Adjust width of the divider
                          color:
                              Color(0xFF4CAF50), // Green color for the divider
                          height:
                              80, // Adjust height of the divider based on your content
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Net profit :',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                  height:
                                      8.0), // Spacing between text and amount
                              Text(
                                '₹150000/-',
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Oswald-Bold',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                        height: 16.0), // Spacing between the row and button
                    Container(
                      width: double.infinity, // Full width
                      child: ElevatedButton(
                        onPressed: () {
                          // Your button action here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color(0xFF4CAF50), // Green background
                          foregroundColor: Colors.white, // White text
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Rounded corners
                          ),
                        ),
                        child: const Text(
                          'More Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildContainer(
                context: context,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Today Total Count",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NunitoSans',
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Total Month: 9000',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Color(0xFF4CAF50),
                                      fontFamily: 'NunitoSans',
                                    ),
                                  ),
                                  Text(
                                    '1000',
                                    style: TextStyle(
                                      fontSize: 80.0,
                                      color: Color(0xFF4CAF50),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Oswald-Bold',
                                    ),
                                  ),
                                  Text(
                                    'Juice: 750',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Color(0xFF4CAF50),
                                      fontFamily: 'NunitoSans',
                                    ),
                                  ),
                                  Text(
                                    'Water: 250',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Color(0xFF4CAF50),
                                      fontFamily: 'NunitoSans',
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset(
                                'assets/Rectangle.png',
                                width: 200.0,
                                height: 200.0,
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity, // Full width
                            child: ElevatedButton(
                              onPressed: () {
                                // Your button action here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color(0xFF4CAF50), // Green background
                                foregroundColor: Colors.white, // White text
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Rounded corners
                                ),
                              ),
                              child: const Text(
                                'More Details',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildContainer(
                context: context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .stretch, // Make sure the column takes full width
                  children: [
                    Text(
                      "Today Expance:",
                      style: TextStyle(
                        fontSize: 18.0, // Size of the text
                        fontWeight: FontWeight.bold, // Font weight (e.g., bold)
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '₹1500000/-',
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Oswald-Bold',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                        height: 16.0), // Spacing between the row and button
                    Container(
                      width: double.infinity, // Full width
                      child: ElevatedButton(
                        onPressed: () {
                          // Your button action here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Green background
                          foregroundColor: Colors.white, // White text
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Rounded corners
                          ),
                        ),
                        child: const Text(
                          'Add Expance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: double.infinity, // Full width
                      child: ElevatedButton(
                        onPressed: () {
                          // Your button action here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color(0xFF4CAF50), // Green background
                          foregroundColor: Colors.white, // White text
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Rounded corners
                          ),
                        ),
                        child: const Text(
                          'More Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer(
      {required BuildContext context, required Widget child}) {
    return Container(
      width: MediaQuery.of(context).size.width *
          0.85, // Adjust the width based on screen size
      padding: const EdgeInsets.all(26.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late Future<List<Contact>> _contactsFuture;
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _contactsFuture = _loadContacts();
  }

  Future<List<Contact>> _loadContacts() async {
    try {
      final jsonString = await rootBundle.loadString('assets/contact.json');
      final List<dynamic> jsonResponse = json.decode(jsonString);
      return jsonResponse.map((data) => Contact.fromJson(data)).toList();
    } catch (e) {
      print('Error loading contacts: $e');
      return [];
    }
  }

  void _filterContacts(String query) {
    setState(() {
      _searchQuery = query;
      _filteredContacts = _contacts.where((contact) {
        final lowerCaseQuery = query.toLowerCase();
        final lowerCaseName = contact.name.toLowerCase();
        final lowerCasePhone = contact.phone.toLowerCase();
        return lowerCaseName.contains(lowerCaseQuery) ||
            lowerCasePhone.contains(lowerCaseQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<Contact>>(
                future: _contactsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    _contacts = snapshot.data!;
                    _filteredContacts =
                        _searchQuery.isEmpty ? _contacts : _filteredContacts;

                    if (_filteredContacts.isEmpty) {
                      return const Center(
                          child: Text('No contacts available.'));
                    }

                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _filteredContacts
                            .map((contact) => Column(
                                  children: [
                                    _buildContact(contact.name, contact.phone),
                                    const Divider(
                                        thickness: 1, color: Colors.grey),
                                  ],
                                ))
                            .toList(),
                      ),
                    );
                  } else {
                    return const Center(child: Text('No contacts available.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Search contacts...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onChanged: _filterContacts,
    );
  }

  Widget _buildContact(String name, String phone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHighlightedText(name, _searchQuery),
                const SizedBox(height: 8.0),
                _buildHighlightedText(phone, _searchQuery),
              ],
            ),
          ),
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.phone,
                color: Colors.white,
              ),
            ),
            onPressed: () => _launchPhone(phone),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            iconSize: 24.0,
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedText(String text, String query) {
    if (query.isEmpty) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'NunitoSans',
        ),
      );
    }

    final lowerCaseText = text.toLowerCase();
    final lowerCaseQuery = query.toLowerCase();
    final startIndex = lowerCaseText.indexOf(lowerCaseQuery);

    if (startIndex == -1) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'NunitoSans',
        ),
      );
    }

    final endIndex = startIndex + query.length;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, startIndex),
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontFamily: 'NunitoSans',
            ),
          ),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.green, // Highlight color
              fontWeight: FontWeight.bold,
              fontFamily: 'NunitoSans',
            ),
          ),
          TextSpan(
            text: text.substring(endIndex),
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontFamily: 'NunitoSans',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final sanitizedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    final Uri phoneUri = Uri(scheme: 'tel', path: sanitizedPhoneNumber);

    if (await Permission.phone.request().isGranted) {
      try {
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri);
        } else {
          print('Could not launch $phoneUri');
        }
      } catch (e) {
        print('Error launching phone dialer: $e');
      }
    } else {
      print('Phone permission not granted');
    }
  }
}

class Contact {
  final String name;
  final String phone;

  Contact({required this.name, required this.phone});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      phone: json['phone'],
    );
  }
}

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Create Schedules',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: screenWidth * 0.85,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NunitoSans',
                          ),
                        ),
                        child: Text('Add +'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.85, // 85% of screen width
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Schedules :',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add your button action here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          'View all',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // You can change the button label
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: screenWidth * 0.85,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '15-09-2024',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'John Doe\n'
                                  '1234 Elm Street\n'
                                  'Springfield\n'
                                  '(555) 123-4567',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 63, 145, 66),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Monday',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Icon(
                                  Icons.call_rounded,
                                  color: Colors.white,
                                  size: 60.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              minimumSize: Size(190, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NunitoSans',
                              ),
                            ),
                            child: Text('Remove ⚠️'),
                          ),
                          SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              minimumSize: Size(190, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NunitoSans',
                              ),
                            ),
                            child: Text('Done ✅'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: screenWidth *
                      0.85, // Set the width to 85% of the screen width
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        12.0), // Border radius for rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Shadow color
                        offset: Offset(0, 2), // Shadow offset
                        blurRadius: 4, // Shadow blur radius
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch, // Make buttons full width
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Space between the two sections
                        children: [
                          // Left side: Date and address details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Align content to the start
                              children: [
                                Text(
                                  '15-09-2024',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'John Doe\n'
                                  '1234 Elm Street\n'
                                  'Springfield\n'
                                  '(555) 123-4567',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 63, 145, 66),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Monday',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Icon(
                                  Icons.call_rounded,
                                  color: Colors.white,
                                  size: 60.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              minimumSize: Size(190, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NunitoSans',
                              ),
                            ),
                            child: Text('Remove ⚠️'),
                          ),
                          SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              minimumSize: Size(190, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NunitoSans',
                              ),
                            ),
                            child: Text('Done ✅'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reminder :',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          'View all',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: screenWidth * 0.85,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '15-09-2024',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'John Doe\n'
                                  '1234 Elm Street\n'
                                  'Springfield\n'
                                  '(555) 123-4567',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 63, 145, 66),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Monday',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Icon(
                                  Icons.call_rounded,
                                  color: Colors.white,
                                  size: 60.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: screenWidth * 0.85,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '15-09-2024',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'John Doe\n'
                                  '1234 Elm Street\n'
                                  'Springfield\n'
                                  '(555) 123-4567',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 63, 145, 66),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Monday',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Icon(
                                  Icons.call_rounded,
                                  color: Colors.white,
                                  size: 60.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
