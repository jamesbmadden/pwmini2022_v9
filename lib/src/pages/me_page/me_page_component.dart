import 'package:angular/angular.dart';

import '../material_card_component.dart';
import '../page_component.dart';

import 'dart:html';
import 'dart:convert';

import '../../../firebase/firebase.dart';

import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_ripple/material_ripple.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/material_spinner/material_spinner.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/laminate/overlay/module.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

@Component(
  selector:'me-page',
  templateUrl:'me_page_component.html',
  styleUrls:['../page_component.css'],
  providers:[
    overlayBindings
  ],
  directives:[
    MaterialRippleComponent,
    MaterialCardComponent,
    MaterialButtonComponent,
    MaterialDialogComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    MaterialSpinnerComponent,
    MaterialToggleComponent,
    ModalComponent,
    NgFor,
    NgIf,
    NgModel,
    NgStyle
  ]
)

// PLEASE, PLEASE WORK

class MePageComponent extends PageComponent implements OnInit {
  bool dialogOpen = false;
  List<String> tabs = [
    'My Account',
    'Options'
  ];

  String email = user.email;
  bool verifiedEmail = user.emailVerified;

  List myClass = ['loading...'];

  Map options = {};

  ngOnInit() {
    if (localStorage['options'] != null) {
      options = json.decode(localStorage['options']);
    } else {
      localStorage['options'] = json.encode(options);
    }
    if (myClasses != null) {
      myClass = myClasses.values.toList();
    } else {
      myClass = ['loading...'];
    }
  }

  signOutButton() async {
    await logout();
    window.location.reload();
  }

  changeClasses() {
    window.history.pushState({'state':'select_class','component':'class-list'}, 'Select Classes', '/select_class');
  }

  setOption(option, event) {
    options[option] = event;
    localStorage['options'] = json.encode(options);
  }

}