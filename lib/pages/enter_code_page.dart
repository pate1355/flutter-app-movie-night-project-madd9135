import 'package:flutter/material.dart';
import 'package:movie_night/helpers/http_helper.dart';
import 'package:movie_night/shared/shared_preferences_helper.dart';

class EnterCodePage extends StatefulWidget {
  const EnterCodePage({super.key});

  @override
  EnterCodePageState createState() => EnterCodePageState();
}

class EnterCodePageState extends State<EnterCodePage> {
  final _formKey = GlobalKey<FormState>();
  String? _code;
  String? deviceID;

  final codeController = TextEditingController();
  final HttpHelper httpHelper = HttpHelper();
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  Future<void> getSharedPref() async {
    String? sharePref = await SharedPreferencesHelper.getDeviceId();

    if (sharePref != null) {
      setState(() {
        deviceID = sharePref;
      });
    }
  }

  Future<void> joinSession() async {
    try {
      final response = await httpHelper.joinSession(deviceID, _code!);
      if (response.isNotEmpty) {
        await SharedPreferencesHelper.saveCode(_code!);
        await SharedPreferencesHelper.saveSessionId(response['session_id']);
        Navigator.pushNamed(context, '/enter_movie_selection');
      } else if (response.isEmpty) {
        setState(() {
          errorMsg = 'Error joining session, please try again!';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unexpected error, please try again!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid code, please try again!')),
      );
    }
  }

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
                  controller: codeController,
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
                if (errorMsg != null)
                  AlertDialog(content: Text(errorMsg!), actions: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          errorMsg = null;
                        });
                      },
                      child: const Text('Close'),
                    )
                  ]),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (_code!.length == 4) {
                        joinSession();
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
