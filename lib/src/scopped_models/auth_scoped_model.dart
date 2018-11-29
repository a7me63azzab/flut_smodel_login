import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
// import 'dart:io';

final baseUrl = 'http://192.168.1.3:5000/user';

mixin AuthModel on Model {
  // Map<String, dynamic> _user;
  User _user;
  bool loading = false;
  notifyListeners();

  User get user {
    return _user;
  }

  //USER REGISTER
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    loading = true;
    notifyListeners();
    print('from scoped model => $userData');
    var url = Uri.parse('$baseUrl/register');
    final mimeTypeData = lookupMimeType(userData['image'].path).split('/');

    var request = http.MultipartRequest("POST", url);
    request.fields['userName'] = userData['userName'];
    request.fields['name'] = userData['fullName'];
    request.fields['email'] = userData['email'];
    request.fields['password'] = userData['password'];
    request.fields['phoneNum'] = userData['phoneNum'];

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        userData['image'].path,
        contentType: MediaType(
          mimeTypeData[0],
          mimeTypeData[1],
        ),
      ),
    );

    try {
      print('inside try block');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        loading = false;
        notifyListeners();
        print('Something went wrong.');
        print(json.decode(response.body));
        return null;
      }

      final responseData = json.decode(response.body);
      _user = User(
          responseData['userName'],
          responseData['fullName'],
          responseData['phoneNum'],
          responseData['email'],
          responseData['imageUrl'],
          responseData['token']);
      print('response ====> $responseData');
      loading = false;
      notifyListeners();
      return responseData;
    } catch (error) {
      loading = false;
      notifyListeners();
      print('---------------error------------');
      print(error);
      return null;
    }
  }

  //USER LOGIN

  //UPDATE PROFILE

  //LOGOUT

  //FORGET PASSWORD

  //RESETPASSWORD
}
