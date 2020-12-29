import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:restaurant_manage/backend/bloc/Data/Data_bloc.dart';
import 'package:restaurant_manage/backend/constants.dart';
import 'package:restaurant_manage/backend/repos/data_classes.dart';

class AddReservationScreen extends StatefulWidget {
  final Reservation _reservation;
  final GlobalKey<FormState> _formKey;
  final EdgeInsets buttonPadding;

  static const routeName = '/add';
  AddReservationScreen({
    Key key,
    Reservation reservation,
  })  : _reservation = reservation,
        _formKey = GlobalKey<FormState>(),
        buttonPadding = const EdgeInsets.symmetric(
          horizontal: 35,
          vertical: 18,
        ),
        super(key: key);

  @override
  _AddReservationScreenState createState() => _AddReservationScreenState();
}

class _AddReservationScreenState extends State<AddReservationScreen> {
  final Map<String, TextEditingController> _controlmap = {
    'name': TextEditingController(),
    'phone': TextEditingController(),
    'email': TextEditingController(),
    'date': TextEditingController(),
  };
  bool _validatedForm, _isEditMode;

  void _update() {
    setState(() => _validatedForm = widget._formKey.currentState.validate());
  }

  @override
  void initState() {
    _validatedForm = false;
    _isEditMode = widget._reservation != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppConstants _appConstants = context.watch<AppConstants>();
    DataBloc dataBloc = context.watch<DataBloc>();
    String formType = (_isEditMode) ? 'Update Employee' : 'Add Employee';

    // Build Button Styles
    final Color _buttonForegroundColor =
        (_validatedForm) ? _appConstants.getForeGroundColor : Colors.grey;
    final ButtonStyle _buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(_buttonForegroundColor),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        widget.buttonPadding,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          formType,
          style: TextStyle(color: _appConstants.getBackGroundColor),
        ),
        backgroundColor: _appConstants.getForeGroundColor,
        centerTitle: true,
        elevation: 1,
        shadowColor: _appConstants.getLighterForeGroundColor,
      ),
      backgroundColor: _appConstants.getBackGroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: _appConstants.getForeGroundColor),
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            color: _appConstants.getLighterForeGroundColor[50].withAlpha(255),
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            shadowColor: _appConstants.getLighterForeGroundColor,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Form(
                key: widget._formKey,
                autovalidateMode: AutovalidateMode.always,
                onChanged: _update,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      validators: [FormBuilderValidators.required()],
                      decoration: InputDecoration(labelText: 'Reserver Name'),
                      controller: _controlmap['name'],
                      attribute: 'name',
                    ),
                    FormBuilderTextField(
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.minLength(10),
                        FormBuilderValidators.maxLength(12),
                      ],
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      controller: _controlmap['phone'],
                      attribute: 'phone',
                    ),
                    FormBuilderTextField(
                      validators: [FormBuilderValidators.email()],
                      decoration: InputDecoration(labelText: 'Email'),
                      controller: _controlmap['email'],
                      attribute: 'email',
                    ),
                    FormBuilderDateTimePicker(
                      fieldLabelText: 'Reservation Date',
                      validators: [
                        FormBuilderValidators.required(),
                      ],
                      decoration:
                          InputDecoration(labelText: 'Reservation Date'),
                      initialDate: DateTime.now(),
                      controller: _controlmap['date'],
                      attribute: 'date',
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: (!_validatedForm)
                            ? null
                            : () {
                                // Date String Formatting
                                String _dateString = dataBloc.reformatDate(
                                  _controlmap['date'].text,
                                );

                                Reservation out = Reservation(
                                  name: _controlmap['name'].text,
                                  phoneNum:
                                      int.parse(_controlmap['phone'].text),
                                  email: _controlmap['email'].text,
                                  dateTime: DateTime.parse(_dateString),
                                );
                                if (_isEditMode)
                                  dataBloc.editReservation(out).then(
                                        (value) => Navigator.of(context).pop(),
                                      );
                                else
                                  dataBloc.addReservation(out).then(
                                        (value) => Navigator.of(context).pop(),
                                      );
                              },
                        style: _buttonStyle,
                        child: Text(
                          formType,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controlmap.forEach((_, TextEditingController c) => c.dispose());
    super.dispose();
  }
}
