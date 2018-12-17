import 'package:scoped_model/scoped_model.dart';

import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'dart:io';

final baseUrl = 'http://192.168.1.4:5000';

mixin AuthModel on Model {
  // Map<String, dynamic> _user;
  User _user;
  bool loading = false;

  bool isValid = false;
  bool isSuccess = false;
  bool resetPasswordSuccess = false;

  notifyListeners();

  User get user {
    return _user;
  }

  //USER REGISTER
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    loading = true;
    notifyListeners();
    print('from scoped model => $userData');
    var url = Uri.parse('$baseUrl/user/register');
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

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['token']);
      prefs.setString('userEmail', responseData['email']);
      prefs.setString('userId', responseData['userId']);
      prefs.setString('imageUrl', responseData['imageUrl']);

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

  Future<Map<String, dynamic>> getCurrentUserData() async {
    loading = true;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.get('userId');
    String token = prefs.get('token');

    try {
      http.Response response =
          await http.get('$baseUrl/user/$userId', headers: {'x-auth': token});
      if (response.statusCode != 200 && response.statusCode != 201) {
        loading = false;
        notifyListeners();
        print('Something went wrong.');
        print(json.decode(response.body));
        return null;
      }

      final responseData = jsonDecode(response.body);
      _user = User(
          responseData['userName'],
          responseData['fullName'],
          responseData['phoneNum'],
          responseData['email'],
          responseData['imageUrl'],
          responseData['token']);
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

  // get new image url
  Future<Map<String, dynamic>> updateImage(File image) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // first get current user image url
    // final imageUrl = prefs.get('imageUrl');
    final token = prefs.get('token');
    print('token => $token');
    // delete image from server
    try {
      http.Response deleteResponse = await http
          .delete('$baseUrl/image/delete', headers: {'x-auth': token});
      if (deleteResponse.statusCode != 200 &&
          deleteResponse.statusCode != 201) {
        return null;
      }

      // upload new image
      var url = Uri.parse('$baseUrl/image/upload');
      final mimeTypeData = lookupMimeType(image.path).split('/');

      var request = http.MultipartRequest("POST", url);

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          image.path,
          contentType: MediaType(
            mimeTypeData[0],
            mimeTypeData[1],
          ),
        ),
      );

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
      print(' ............ ${responseData['url']}');

      // update image url in db
      await this.updateUserData({'imageUrl': responseData['url']});

      return responseData;
    } catch (error) {
      loading = false;
      notifyListeners();
      print('---------------error------------');
      print(error);
      return null;
    }
  }

  Future<Map<String, dynamic>> updateUserData(
      Map<String, dynamic> newData) async {
    print('from update image => $newData');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.get('userId');
    final token = prefs.get('token');
    try {
      var url = Uri.parse('$baseUrl/user/update/$userId');
      http.Response response = await http.patch(
        url,
        headers: {"Content-Type": "application/json", 'x-auth': token},
        body: json.encode(newData),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('error====>');
        return null;
      }
      final responseData = jsonDecode(response.body);
      print('from update user data $responseData');
      _user = User(
        responseData['userName'],
        responseData['fullName'],
        responseData['phoneNum'],
        responseData['email'],
        responseData['imageUrl'],
      );
      notifyListeners();
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  // User Login
  Future<Map<String, dynamic>> userLogin(Map<String, dynamic> userData) async {
    print('from scoped model $userData');
    loading = true;
    notifyListeners();
    try {
      var url = Uri.parse('$baseUrl/user/login');
      http.Response response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {'email': userData['email'], 'password': userData['password']}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('x error x');
        loading = false;
        notifyListeners();
        return null;
      }

      final responseData = jsonDecode(response.body);
      print('User Login => $responseData');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['token']);
      prefs.setString('userEmail', responseData['email']);
      prefs.setString('userId', responseData['userId']);
      prefs.setString('imageUrl', responseData['imageUrl']);

      _user = User(
          responseData['userName'],
          responseData['fullName'],
          responseData['phoneNum'],
          responseData['email'],
          responseData['imageUrl'],
          responseData['token']);

      loading = false;
      notifyListeners();
      return responseData;
    } catch (error) {
      loading = false;
      notifyListeners();
      return null;
    }
  }

  // Check Old Password
  Future<Map<String, dynamic>> checkOldPassword(String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');
    Map<String, String> oldPassword = {'oldPassword': password};
    try {
      var url = Uri.parse('$baseUrl/user/password/check');
      http.Response response = await http.post(
        url,
        headers: {"Content-Type": "application/json", 'x-auth': token},
        body: jsonEncode(oldPassword),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('x error x');
        isValid = false;
        notifyListeners();
        return null;
      }

      final responseData = jsonDecode(response.body);
      print('check password => $responseData');
      if (!responseData['isValid']) {
        isValid = false;
        notifyListeners();
      }
      isValid = true;
      notifyListeners();
      return responseData;
    } catch (error) {
      isValid = false;
      notifyListeners();
      return null;
    }
  }

  // Check Old Password
  Future<Map<String, dynamic>> updatePassword(String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');
    Map<String, String> newPassword = {'newPassword': password};
    try {
      var url = Uri.parse('$baseUrl/user/password/update');
      http.Response response = await http.patch(
        url,
        headers: {"Content-Type": "application/json", 'x-auth': token},
        body: jsonEncode(newPassword),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('x error x');
        isSuccess = false;

        notifyListeners();
        return null;
      }

      final responseData = jsonDecode(response.body);
      print('check password => $responseData');
      if (!responseData['success']) {
        isSuccess = false;

        notifyListeners();
      }
      isSuccess = true;

      notifyListeners();
      return responseData;
    } catch (error) {
      isSuccess = false;

      notifyListeners();
      return null;
    }
  }

  ///user/forget
  Future<Map<String, dynamic>> forgetPassword(String email) async {
    print('from scoped model $email');
   
    try {
      var url = Uri.parse('$baseUrl/user/forget');
      http.Response response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('x error x');
        
        return null;
      }

      final responseData = jsonDecode(response.body);
      print('forget password => $responseData');

      
      return responseData;
    } catch (error) {
      
      return null;
    }
  }

  Future<Map<String, dynamic>> resetPassword(
      String newPassword, String resetToken) async {
    print('from scoped model $newPassword , $resetToken');
    loading = true;
    notifyListeners();
    try {
      var url = Uri.parse('$baseUrl/user/reset/$resetToken');
      http.Response response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'password': newPassword}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('x error x');
        resetPasswordSuccess = false;
        notifyListeners();
        return null;
      }

      final responseData = jsonDecode(response.body);
      print('forget password => $responseData');

      resetPasswordSuccess = true;
      notifyListeners();
      return responseData;
    } catch (error) {
      resetPasswordSuccess = false;
      notifyListeners();
      return null;
    }
  }
}
