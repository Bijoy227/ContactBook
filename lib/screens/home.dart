import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../db/contactdb.dart';
import 'contact.dart';
import '../extensions.dart';

enum OrderOptions { orderFromAToZ, orderFromZToA, orderWithNumber }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = [];
  List<Contact> tempContacts = [];
  List<Contact> filteredContacts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAllContacts();

    searchController.addListener(() {
      getAllFilteredContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CONTACTS',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: '#BBE7FE'.toColor(),
        actions: <Widget>[
          // logout button
          TextButton.icon(
            label: Text(
              'Logout',
              style: TextStyle(
                color: Colors.brown,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
            icon: Icon(Icons.logout_sharp),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),

          // PopUp Menu (Sort Option)
          PopupMenuButton<OrderOptions>(
            color: '#EFF1DB'.toColor(),
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text(
                  'Sort (A-Z)',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: OrderOptions.orderFromAToZ,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text(
                  'Sort (Z-A)',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: OrderOptions.orderFromZToA,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text(
                  'Sort With Number',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: OrderOptions.orderWithNumber,
              ),
            ],
            onSelected: _sortContacts,
          ),
        ],
      ),
      backgroundColor: '#EFF1DB'.toColor(),

      // Floating Button (Add New)
      floatingActionButton: SizedBox(
        height: 40,
        width: 100,
        child: FloatingActionButton(
          onPressed: () {
            _displayContactPage();
          },
          child: Text(
            'Add New',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          backgroundColor: '#D3B5E5'.toColor(),
        ),
      ),

      // Body
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              style: TextStyle(),
              controller: searchController,
              decoration: const InputDecoration(
                  labelText: 'Search Contact',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: _singleContactCard,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget: Card for each contact
  Widget _singleContactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        color: "#EFE7D3".toColor(),
        child: Padding(
          padding: EdgeInsets.all(7.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: contacts[index].img != null
                        ? FileImage(File(contacts[index].img))
                        : AssetImage('assets/images/person1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contacts[index].name ?? '',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'kingsbridge',
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Text(contacts[index].phone ?? '',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'kingsbridge',
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _availableOptions(context, index);
      },
    );
  }

  /// Method: Getting filtered contacts according to search input
  void getAllFilteredContacts() {
    List<Contact> _filteredContacts = [];
    _filteredContacts.addAll(tempContacts);
    if (searchController.text.isNotEmpty) {
      _filteredContacts.retainWhere((contact) {
        String serachedContact = searchController.text.toLowerCase();
        String contactName = contact.name.toLowerCase() ?? "/";
        bool contactNameMatches = contactName.contains(serachedContact);
        return contactNameMatches;
      });
      setState(() {
        contacts = _filteredContacts;
        print(contacts);
      });
    } else {
      setState(() {
        contacts = tempContacts;
      });
    }
  }

  /// Method: Showing available options (make call, delete, update and see details)
  void _availableOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              color: '#BBE7FE'.toColor(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextButton.icon(
                      label: Text(
                        'Make Call',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      icon: Icon(Icons.call_outlined),
                      onPressed: () {
                        launch('tel: ${contacts[index].phone}');
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextButton.icon(
                      label: Text(
                        'Text Message',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      icon: Icon(Icons.sms_sharp),
                      onPressed: () {
                        launch('sms: ${contacts[index].phone}');
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextButton.icon(
                      label: Text(
                        'Details and Edit Contact',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      icon: Icon(Icons.contact_mail),
                      onPressed: () {
                        Navigator.pop(context);
                        _displayContactPage(contact: contacts[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextButton.icon(
                      label: Text(
                        'Delete Contact',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      icon: Icon(Icons.delete_outline),
                      onPressed: () {
                        helper.deleteContact(contacts[index].id);
                        setState(() {
                          contacts.removeAt(index);
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Method: Display Contact details and edit page
  void _displayContactPage({Contact contact}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  /// Method: Get all Contacts from database
  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
        tempContacts = contacts;
      });
    });
  }

  /// Method: Sorting contacts according to contact name
  void _sortContacts(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderFromAToZ:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderFromZToA:
        contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
      case OrderOptions.orderWithNumber:
        contacts.sort(
          (a, b) {
            return a.phone.compareTo(b.phone);
          },
        );
        break;
    }
    setState(() {});
  }
}
