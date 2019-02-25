import 'package:angular/angular.dart';

import '../../firebase/firebase.dart';

import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_spinner/material_spinner.dart';

import 'dart:html';

@Component(
  selector: 'login-prompt',
  styleUrls: ['login_prompt_component.css'],
  templateUrl: 'login_prompt_component.html',
  directives: [
    MaterialButtonComponent,
    MaterialSpinnerComponent,
    materialInputDirectives,
    NgFor,
    NgIf,
  ],
)
class LoginPromptComponent implements OnInit {
  
  String username = null;
  String loginEmail = '';
  String loginPassword = '';

  String signupEmail = '';
  String signupPassword = '';
  String signupRePassword = '';

  bool isSafari = false;
  String gButton = 'initial';

  String errorMessage = '';
  String page = "login";
  bool loggedIn;
  bool loading = true;
  void ngOnInit() {
    auth.onAuthStateChanged.listen((_user) {
      loading = false;
      if (_user != null) {
        loggedIn = true;
        username = _user.email;
      } else {
        username = null;
        loggedIn = false;
      }
    });
    if (loggedIn == false) {
      loading = false;
    }
    RegExp uagent = new RegExp(r'/^((?!chrome|android).)*safari',caseSensitive:false);
    isSafari = uagent.hasMatch(window.navigator.userAgent);
    gButton = isSafari ? 'none' : 'initial';
  }
  void loginButton() {
    errorMessage = '';
    login(loginEmail, loginPassword).then((response) {
      loginEmail = '';
      loginPassword = '';
    }).catchError((error) {
      print(error.message);
      errorMessage = error.message;
      loading = false;
      loggedIn = false;
      loginEmail = '';
      loginPassword = '';
    });
    loading = true;
  }
  void signupButton() {
    if (signupPassword == signupRePassword) {
      errorMessage = '';
      auth.createUserWithEmailAndPassword(signupEmail, signupPassword).then((user) {
        auth.currentUser.sendEmailVerification().then((response) {
          print('Verification Email Sent');
        });
        signupEmail = '';
        signupPassword = '';
        signupRePassword = '';
      }).catchError((error) {
        print(error.message);
        errorMessage = error.message;
        loading = false;
        loggedIn = false;
        signupEmail = '';
        signupPassword = '';
        signupRePassword = '';
      });
      loading = true;
    }
  }
  void loginGoogle() {
    print('Logging in with Google');
    auth.signInWithRedirect(google).then((result) {
      print(result);
      loading = false;
    }).catchError((error) {
      errorMessage = error.message;
      print(error.message);
      loading = false;
    });
    loading = true;
  }
}

// Hello?