// ignore_for_file: empty_constructor_bodies

import 'dart:convert';
// import 'dart:html';


import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:localstore/localstore.dart';

import 'province_view.dart';
import 'district_view.dart';
import 'ward_view.dart';
import 'user_info.dart';
import 'address_info.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final step1FormKey = GlobalKey<FormState>();
  final step2FormKey = GlobalKey<FormState>();

  int currentStep = 0;
  UserInfo userInfo = UserInfo();
  bool isLoaded = false;

  Future<UserInfo> init() async{
    if(isLoaded) return UserInfo();
    var value = await loadUserInfo();
    if(value !=null){
      try{
        isLoaded = true;
        return UserInfo.fromMap(value);
      }catch(e){
        debugPrint(e.toString());
        return UserInfo();
      }
    }
    return UserInfo();
  }

  @override
  Widget build(BuildContext context) {
    void updateStep(int value){
      if(currentStep == 0){
        if(step1FormKey.currentState!.validate()){
          step1FormKey.currentState!.save();
          setState(() {
            currentStep = value;
          });
        }
      }else if(currentStep == 1){
        if(value > currentStep){
          if(step2FormKey.currentState!.validate()){
            step2FormKey.currentState!.save();
            setState(() {
              currentStep= value;
            });
          }
        }else{
          setState(() {
            currentStep= value;
          });
        }
      } else if(currentStep == 2){
        setState(() {
          if(value < currentStep){
            currentStep = value;
          }else{
            saveUserInfo(userInfo).then((value){
              showDialog<void>(
                context: context, 
                barrierDismissible: false,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: const Text('Thông báo'),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Text('Hồ sơ Người dùng đã được lưu thành công!'),
                          Text('Bạn có thể quay lại các bước để cập nhật '),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('đóng'),
                        onPressed:(){
                          Navigator.of(context).pop();
                        }, 
                      ),
                    ],
                  );
                },
              );
            });
          }
        });
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cap Nhat Ho So'),
        actions: [
          IconButton(
            onPressed: (){
              showDialog<bool>(
                context: context, 
                barrierDismissible: false,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: const Text('Xác Nhận'),
                    content: const Text('Bạn có muốn xóa thông tin đã lưu?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Hủy'),
                        onPressed: (){
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: const Text('đồng ý'),
                        onPressed: (){
                        Navigator.of(context).pop(true);
                      }, 
                      )
                    ],
                  );
                },
              ).then((value) {
                if (value != null && value == true) {
                  setState(() {
                    userInfo = UserInfo();
                  });
                  saveUserInfo(userInfo);
                }
              });
            },
           icon: const Icon(Icons.delete_outlined),
          )
        ],
      ),
      body: FutureBuilder<UserInfo>(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userInfo = snapshot.data!;
            return Stepper(
              type: StepperType.horizontal,
              currentStep: currentStep,
              controlsBuilder: (context, details){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      children: [
                        if(currentStep == 2)
                          FilledButton(
                            onPressed: details.onStepContinue,
                            child: const Text('Lưu'),
                         )
                        else
                          FilledButton.tonal(
                            onPressed: details.onStepContinue, 
                            child: const Text('Tiếp'),
                          ),
                        if(currentStep> 0)
                          TextButton(onPressed: details.onStepCancel,
                           child: const Text('quay lại'),
                          ),
                      ],
                    ),
                    if(currentStep == 2)
                      OutlinedButton(
                        onPressed: (){}, 
                        child: const Text('Đóng')
                    ),
                  ],
                );
              },
              onStepTapped: (value){
                updateStep(value);
              },
              onStepContinue: (){
                updateStep(currentStep + 1);
              },
              onStepCancel: (){
                if (currentStep > 0){
                  setState(() {
                    currentStep--;
                  });
                }
              },
              steps: [
                Step(
                  title: const Text('Cơ bản'), 
                  content: Step1Form(formKey: step1FormKey, userInfo: userInfo),
                  isActive: currentStep == 0
                ),
                Step(
                  title: const Text('Địa chỉ'), 
                  content: Step2Form(formKey: step2FormKey, userInfo: userInfo),
                  isActive: currentStep == 1
                ),
                Step(
                  title: const Text('Xác nhận'), 
                  content: ConfirmInfo(userInfo: userInfo),
                  isActive: currentStep == 2
                ),
              ],
            );
          }else if (snapshot.hasError){
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }else{
            return const Center(child: LinearProgressIndicator());
          }
        },
      ),
    );
  }
}

class Step1Form extends StatefulWidget{
  final GlobalKey<FormState> formKey;
  final UserInfo userInfo;

  const Step1Form({
    super.key,
    required this.formKey,
    required this.userInfo,
  });

  @override
  State<Step1Form> createState() => _Step1FormState();
}

class _Step1FormState extends State<Step1Form>{
  final nameCtl = TextEditingController();
  final dateCtl = TextEditingController();
  final emailCtl = TextEditingController();
  final phoneCtl = TextEditingController();

  bool isEmailValid(String email){
    String pattern = 
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$";
    final emailRegex = RegExp(pattern);
    return emailRegex.hasMatch(email);
}

  bool isMobileValid(String value){
    String pattern = r"(^(?:[+0]9)?[0-9]{10,12}$)";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
  
  @override
  Widget build(BuildContext context){
    nameCtl.text = widget.userInfo.name ?? '';
    dateCtl.text = widget.userInfo.birthDate != null
      ? DateFormat('dd/MM/yyyy').format(widget.userInfo.birthDate!)
      : '';
    emailCtl.text = widget.userInfo.email ?? '';
    phoneCtl.text = widget.userInfo.phoneNumber ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtl,
                decoration: const InputDecoration(labelText: 'Họ và tên'),
                keyboardType: TextInputType.name,
                textCapitalization:  TextCapitalization.words,
                validator: (value){
                  if (value == null || value.isEmpty){
                    return'Vui long nhập họ tên';
                  }
                  return null;
                },
                onChanged: (value) => widget.userInfo.name = value,
              ),
              TextFormField(
                controller: dateCtl,
                decoration: const InputDecoration(
                  labelText:  "Ngày sinh",
                  hintText: "Nhập ngày sinh",
                ),
                onTap: () async {
                  DateTime? date = DateTime(1900);
                  FocusScope.of(context).requestFocus(FocusNode());
                  date = await showDatePicker(
                    context: context, 
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    initialDate: widget.userInfo.birthDate ?? DateTime.now(),
                    firstDate: DateTime(1900), 
                    lastDate: DateTime(2100));
                  if(date != null){
                    widget.userInfo.birthDate = date;
                    dateCtl.text = DateFormat('dd/MM/yyyy').format(date);
                  }
                },
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Vui lòng nhập ngày sinh';
                  }
                  try{
                    DateFormat('dd/MM/yyyy').parse(value);
                    return null;
                  } catch(e){
                    return 'Ngày sinh không hợp lệ';
                  }
                },
              ),
              TextFormField(
                controller: emailCtl,
                decoration:  const  InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }else if(!isEmailValid(value)){
                    return 'Định dạng email không hợp lệ ';
                  }
                  return null;
                }, 
                onChanged: (value) => widget.userInfo.email = value,
              ),
              TextFormField(
                controller: phoneCtl,
                decoration: const InputDecoration(labelText: 'số điện thoại'),
                keyboardType: TextInputType.phone,
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }else if(!isMobileValid(value)){
                    return 'Định dạng số điện thoại không hợp lệ ';
                  }
                  return null;
                }, 
                onChanged: (value) => widget.userInfo.phoneNumber = value,
              ),
            ],
          ),
        ),
      );
    }
  }

class Step2Form extends StatefulWidget{
  final GlobalKey<FormState> formKey;
  final UserInfo userInfo;
  const Step2Form({
    super.key,
    required this.formKey,
    required this.userInfo,
  });

  @override
  State<Step2Form> createState() => _Step2FormState();
}

class _Step2FormState extends State<Step2Form>{
  final streetCtl = TextEditingController();

  List<Province> provinceList = [];
  List<District> districtList = [];
  List<Ward> wardList = [];
  @override
  void initState(){
    loadLocationData().then((value) => setState((){}));
    super.initState();
  }
  Future<void> loadLocationData() async {
    try {
      String data = await rootBundle.loadString('assets/don_vi_hanh_chinh.json'); // Đảm bảo rằng tên tệp JSON đúng và đã được đặt trong thư mục assets
      Map<String, dynamic> jsonData = json.decode(data);

      List provinceData = jsonData['province'];
      provinceList =
          provinceData.map((json) => Province.fromMap(json)).toList();

      List districtData = jsonData['district'];
      districtList =
          districtData.map((json) => District.fromMap(json)).toList();

      List wardData = jsonData['ward'];
      wardList = wardData.map((json) => Ward.fromMap(json)).toList();
    } catch (e) {
      debugPrint('Error loading location data: $e');
    }
  }

  @override

  Widget build (BuildContext context){
    streetCtl.text= widget.userInfo.address?.street ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            Autocomplete<Province>(
              fieldViewBuilder: (
                context,
                textEditingController,
                focusNode,
                onFieldSubmitted,
              ) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  textEditingController.text = 
                    widget.userInfo.address?.province?.name ?? '';
                 });
                 return TextFormField(
                  decoration: const InputDecoration(
                    labelText:'Tỉnh / Thành phố', 
                  ),
                  controller: textEditingController,
                  focusNode: focusNode,
                  validator: (value){
                    if(widget.userInfo.address?.province == null || value!.isEmpty){
                      return 'vui lòng chọn 1 tỉnh/ thành phố';
                    }
                    return null;
                  },
                 );
              },
              displayStringForOption: (option) => option.name!,
              optionsBuilder: (textEditingValue){
                if (textEditingValue.text.isEmpty) {
                  return provinceList;
                }
                return provinceList.where((element) {
                  final title = removeDiacritics(element.name ?? '');
                  final keyword = removeDiacritics(textEditingValue.text);
                  final pattern = r'\b(' + keyword + r')\b';
                  final regExp = RegExp(pattern, caseSensitive: false);
                  return title.isEmpty && regExp.hasMatch(title);
                });
              },
              onSelected: (option){
                if(widget.userInfo.address?.province !=option){
                  setState(() {
                    widget.userInfo.address = AddressInfo(province: option);
                  });
                }
              },
            ),

            Autocomplete<District>(
              fieldViewBuilder: (
                context,
                textEditingController,
                focusNode,
                onFieldSubmitted,
              ){
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  textEditingController.text = 
                    widget.userInfo.address?.district?.name ?? '';
                 });
                 return TextFormField(
                  decoration: const InputDecoration(
                    labelText:'Huyện / Quận', 
                  ),
                  controller: textEditingController,
                  focusNode: focusNode,
                  validator: (value){
                    if(widget.userInfo.address?.district == null || value!.isEmpty){
                      return 'vui lòng chọn 1 huyện/ quận';
                    }
                    return null;
                  },
                 );
              },
              displayStringForOption: (option) => option.name!,
              optionsBuilder: (textEditingValue){
                if (textEditingValue.text.isEmpty) {
                  return districtList.where((element) => 
                    widget.userInfo.address?.province?.id !=null &&
                    element.provinceId == 
                      widget.userInfo.address?.province?.id);
                  
                }
                return districtList.where((element) {
                  var condl = element.provinceId ==
                      widget.userInfo.address?.province?.id;
                  final title = removeDiacritics(element.name ?? '');
                  final keyword = removeDiacritics(textEditingValue.text);
                  final pattern = r'\b(' + keyword + r')\b';
                  final regExp = RegExp(pattern, caseSensitive: false);
                  return condl && title.isEmpty && regExp.hasMatch(title);
                });
              },
              onSelected: (option){
                if(widget.userInfo.address?.province !=option){
                  setState(() {
                    widget.userInfo.address?.district =  option;
                    widget.userInfo.address?.ward = null;
                  });
                }
              },
            ),

            Autocomplete<Ward>(
              fieldViewBuilder: (
                context,
                textEditingController,
                focusNode,
                onFieldSubmitted,
              ){
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  textEditingController.text = 
                    widget.userInfo.address?.ward?.name ?? '';
                 });
                 return TextFormField(
                  decoration: const InputDecoration(
                    labelText:'Xã / phường / thị trấn', 
                  ),
                  controller: textEditingController,
                  focusNode: focusNode,
                  validator: (value){
                    if(widget.userInfo.address?.ward == null || value!.isEmpty){
                      return 'vui lòng chọn 1 Xã / phường / thị trấn';
                    }
                    return null;
                  },
                 );
              },
              displayStringForOption: (option) => option.name!,
              optionsBuilder: (textEditingValue){
                if (textEditingValue.text.isEmpty) {
                  return wardList.where((element) => 
                    element.districtId == 
                      widget.userInfo.address?.district?.id);
                  
                }
                return wardList.where((element) {
                  var condl = element.districtId ==
                      widget.userInfo.address?.district?.id;
                  final title = removeDiacritics(element.name ?? '');
                  final keyword = removeDiacritics(textEditingValue.text);
                  final pattern = r'\b(' + keyword + r')\b';
                  final regExp = RegExp(pattern, caseSensitive: false);
                  return condl && title.isEmpty && regExp.hasMatch(title);
                });
              },
              onSelected: (option){
                widget.userInfo.address?.ward =  option;
              },
            ),

            TextFormField(
              controller: streetCtl,
              decoration: const InputDecoration(labelText: 'Địa chỉ'),
              keyboardType: TextInputType.streetAddress,
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'vui lòng nhập địa chỉ';
                }
                return null;
              },
              onSaved: (value){
                widget.userInfo.address?.street = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmInfo extends StatelessWidget{
  final UserInfo userInfo;

  const ConfirmInfo({
    super.key,
    required this.userInfo,
  });


  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoItem('Họ và tên:', userInfo.name),
          _buildInfoItem(
            'Ngày sinh:',
            userInfo.birthDate != null
              ? DateFormat('dd/MM/yyyy').format(userInfo.birthDate!)
              : '',
          ),
          _buildInfoItem('Email:', userInfo.email),
          _buildInfoItem('Số điện thoại:', userInfo.phoneNumber),
          _buildInfoItem('Tỉnh/ thành phố:', userInfo.address?.province?.name),
          _buildInfoItem('Huyện /quận:', userInfo.address?.district?.name),
          _buildInfoItem('Xã/ phường/ thị trấn:', userInfo.address?.ward?.name),
          _buildInfoItem('địa chỉ:', userInfo.address?.street),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String? value){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:  8.0),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText:  label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(8.0),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

Future<void> saveUserInfo(UserInfo info) async{
  return await Localstore.instance
      .collection('users')
      .doc('info')
      .set(info.toMap());
}

Future<Map<String, dynamic>?> loadUserInfo() async{
  return await Localstore.instance.collection('users').doc('info').get();
}