import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../db/contactdb.dart';
import '../extensions.dart';
import '../toastHelper/toastHelper.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  Contact _editedContact;
  var contact;

  @override
  void initState() {
    super.initState();
    contact = ContactHelper();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
    }

    _nameController.text = _editedContact.name;
    _emailController.text = _editedContact.email;
    _phoneController.text = _editedContact.phone;
    _addressController.text = _editedContact.address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_editedContact.name ?? 'ADD NEW CONTACT'),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: 'RiseofKingdom',
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: '#BBE7FE'.toColor(),
          centerTitle: true),
      backgroundColor: '#EFF1DB'.toColor(),
      floatingActionButton: SizedBox(
        height: 40,
        width: 110,
        child: FloatingActionButton(
          // Checking validity
          onPressed: () {
            if (_editedContact.name != null &&
                _editedContact.phone != null &&
                _editedContact.name.isNotEmpty &&
                _editedContact.phone.isNotEmpty) {
              ToastMassage("Successfully Added!", context);
              Navigator.pop(context, _editedContact);
            } else if (_editedContact.name == null) {
              FocusScope.of(context).requestFocus(_nameFocus);
              AlertMassage("Contact Name Can't be Empty!", context);
            } else {
              FocusScope.of(context).requestFocus(_phoneFocus);
              AlertMassage("Phone Number Can't be Empty!", context);
            }
          },
          child: Text(
            'Save Contact',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'RiseofKingdom',
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          backgroundColor: '#D3B5E5'.toColor(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: _editedContact.img != null
                        ? FileImage(File(_editedContact.img))
                        : AssetImage('assets/images/person1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () async {
                await ImagePicker.pickImage(source: ImageSource.gallery)
                    .then((file) {
                  if (file == null) return;
                  setState(() {
                    _editedContact.img = file.path;
                  });
                });
              },
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                style: TextStyle(
                  fontFamily: 'kingsbridge',
                ),
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Person Name',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'RiseofKingdom',
                    )),
                onChanged: (text) {
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(
                  fontFamily: 'kingsbridge',
                ),
                controller: _emailController,
                decoration: InputDecoration(
                    icon: Icon(Icons.mail),
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'RiseofKingdom',
                    )),
                onChanged: (text) {
                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(
                  fontFamily: 'kingsbridge',
                ),
                focusNode: _phoneFocus,
                controller: _phoneController,
                decoration: InputDecoration(
                    icon: Icon(Icons.dialpad),
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'RiseofKingdom',
                    )),
                onChanged: (text) {
                  _editedContact.phone = "+88" + text;
                },
                keyboardType: TextInputType.phone,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(
                  fontFamily: 'kingsbridge',
                ),
                controller: _addressController,
                decoration: InputDecoration(
                    icon: Icon(Icons.location_pin),
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'RiseofKingdom',
                    )),
                onChanged: (text) {
                  _editedContact.address = text;
                },
                keyboardType: TextInputType.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
