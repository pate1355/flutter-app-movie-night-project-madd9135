import 'package:flutter/material.dart';

class EnterCodePage extends StatefulWidget {
  const EnterCodePage({super.key});

  @override
  EnterCodePageState createState() => EnterCodePageState();
}

class EnterCodePageState extends State<EnterCodePage> {
  final _formKey = GlobalKey<FormState>();
  String _code = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Session'),
        backgroundColor: Colors.redAccent[100],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  maxLength: 4,
                  autofocus: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.code),
                    hintText: 'Enter the code from your friend',
                    labelText: 'Code',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Code is required' : null,
                  onSaved: (value) => _code = value!,
                ),
                const SizedBox(height: 150),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (_code.length == 4) {
                        Navigator.pushNamed(context, '/movie_selection');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Code must be 4 digits long')),
                        );
                      }
                    }
                  },
                  icon: Container(
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(7),
                    child: const Icon(
                      Icons.start,
                      color: Colors.white,
                    ),
                  ),
                  label: const Text('Begin'),
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                      vertical: 7,
                      horizontal: 40,
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
