import 'package:angular/angular.dart';

import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'firebase/firebase.dart';
import 'src/login/login_prompt_component.dart';
import 'src/class_list/class_list_component.dart';

import 'src/pages/classes_page/classes_page_component.dart';
import 'src/pages/me_page/me_page_component.dart';
import 'src/pages/mini_page/mini_page_component.dart';
import 'src/bottom_app_bar/bottom_app_bar_component.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [
    LoginPromptComponent, 
    ClassListComponent,
    ClassesPageComponent,
    MePageComponent, 
    MiniPageComponent,
    BottomAppBarComponent,
    NgIf
  ],
)
class AppComponent implements OnInit {
  String icon;
  String url = window.location.pathname;
  String username = 'loading...';
  bool loggedIn = false;
  final Storage localStorage = window.localStorage;
  void ngOnInit() async { // When the component is created, register a listener for the logged in status
    print(localStorage['options']);
    if (localStorage['options'] == null) {
      Map options = {
        'useImages':true,
      };
      localStorage['options'] == json.encode(options);
    }
    await loadFirebase();
    auth.onAuthStateChanged.listen((_user) {
      user = _user;
      if (_user != null) {
        icon = user.photoURL;
        username = _user.email;
        loggedIn = true;
      } else {
        icon = null;
        username = "Not Logged In";
        loggedIn = false;
      }
    });
    Timer.periodic(new Duration(milliseconds: 33), (event) {
      url = window.location.pathname;
    });
    
  }
  
  void logoutButton() {
    logout();
  }
  
}
