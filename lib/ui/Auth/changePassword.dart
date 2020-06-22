//for future use



// import 'package:flutter/material.dart';
// import 'package:flutter_form_bloc/flutter_form_bloc.dart';

// import '../../services/auth.dart';
// import '../../functions/validations.dart';
// import '../Costume_widgets/loading_dialog.dart';
// import '../Costume_widgets/costume_text_field.dart';
// import '../Costume_widgets/bloc_text_form_field.dart';

// class ChangePassword extends StatefulWidget {
//   @override
//   _ChangePasswordState createState() {
//     return _ChangePasswordState();
//   }
// }

// class _ChangePasswordState extends State<ChangePassword> {
//   final _formKey = GlobalKey<FormState>();
//   final _oldPasswordController = TextEditingController();
//   FieldValidationFormBloc _formBloc;
//   var _oldPasswordErrorText = '';

//   @override
//   void dispose() {
//     _oldPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => FieldValidationFormBloc(),
//       child: Builder(
//         builder: (context) {
//           _formBloc = BlocProvider.of<FieldValidationFormBloc>(context);
//           return Container(
//             decoration: const BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage(
//                       'images/backgroundImage.png',
//                     ),
//                     fit: BoxFit.fill)),
//             child: Scaffold(
//               backgroundColor: const Color.fromRGBO(250, 251, 253, 75),
//               body: FutureBuilder<bool>(
//                 future: Auth().isSigendInWithEmailAndPassword(),
//                 builder: (context, snapshot) {
//                   var isChangeable = snapshot.hasData ? snapshot.data : true;
//                   return snapshot == null
//                       ? const LoadingDialog()
//                       : ListView(
//                           children: <Widget>[
//                             Column(
//                               children: <Widget>[
//                                 Column(
//                                   children: <Widget>[
//                                     Align(
//                                       alignment: Alignment.topLeft,
//                                       child: Row(
//                                         children: <Widget>[
//                                           FlatButton(
//                                             onPressed: () {
//                                               Navigator.pop(context);
//                                             },
//                                             child: const Text(
//                                               'الغاء',
//                                               style: TextStyle(
//                                                   fontSize: 18,
//                                                   fontWeight: FontWeight.bold,
//                                                   fontFamily: 'ae_Sindibad'),
//                                             ),
//                                           ),
//                                           const Expanded(
//                                               child: SizedBox(width: 5)),
//                                           FlatButton(
//                                             onPressed: isChangeable
//                                                 ? () {
//                                                     _formBloc.submit();
//                                                     var data =
//                                                         _formBloc.onSubmitting(
//                                                       hasPassword: true,
//                                                       hasConfirmPassword: true,
//                                                     );

//                                                     return _onPressedDone(
//                                                         data['Password'] ?? '');
//                                                   }
//                                                 : null,
//                                             child: const Text(
//                                               'تم',
//                                               style: TextStyle(
//                                                   fontSize: 20,
//                                                   fontWeight: FontWeight.bold,
//                                                   fontFamily: 'ae_Sindibad'),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const SizedBox(height: 75),
//                                     const Padding(
//                                       padding: EdgeInsets.only(right: 30),
//                                       child: Align(
//                                         alignment: Alignment.bottomRight,
//                                         child: Text(
//                                           'تغيير كلمة السر',
//                                           style: TextStyle(
//                                               color: Color(0xFFCA39E3),
//                                               fontSize: 24,
//                                               fontFamily: 'ae_Sindibad'),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 20),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 15),
//                                 Container(
//                                   width:
//                                       MediaQuery.of(context).size.width / 1.1,
//                                   child: Column(
//                                     children: <Widget>[
//                                       const SizedBox(height: 60),
//                                       Form(
//                                         key: _formKey,
//                                         child: Directionality(
//                                           textDirection: TextDirection.rtl,
//                                           child: CustomTextField(
//                                             key: _formKey,
//                                             controller: _oldPasswordController,
//                                             validator: (value) {
//                                               _oldPasswordErrorText =
//                                                   validatePassword(value);
//                                               if (_oldPasswordErrorText !=
//                                                   null) {
//                                                 return _oldPasswordErrorText;
//                                               }
//                                               return null;
//                                             },
//                                             hint: 'كلمة السر القديمة',
//                                             readOnly: !isChangeable,
//                                           ),
//                                         ),
//                                       ),
//                                       BlocTextFormField(
//                                         hint: 'كلمة السر جديدة',
//                                         textFieldBloc: _formBloc.password,
//                                         obscure: true,
//                                       ),
//                                       BlocTextFormField(
//                                         hint: 'تاكيد كلمة السر الجديدة',
//                                         textFieldBloc:
//                                             _formBloc.passwordConfirm,
//                                         // obscure: true,
//                                       ),
//                                       const SizedBox(height: 20),
//                                       !isChangeable
//                                           ? const Text(
//                                               'لا يمكنتك تغيير كلمة المرور لانك سجلت باستخدام كوكل او فبس بوك',
//                                               textAlign: TextAlign.center,
//                                             )
//                                           : Container(),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         );
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   _onPressedDone(String newPassord) async {
//     if (_formKey.currentState.validate() && newPassord.isNotEmpty) {
//       var error =
//           await Auth().changePassword(_oldPasswordController.text, newPassord);
//       if (error == null) {
//         Navigator.of(context).pop();
//       } else {
//         showFlushSnackBar(context, error);
//       }
//     }
//   }
// }
