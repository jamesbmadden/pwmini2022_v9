import 'package:angular/angular.dart';

import 'dart:html';
import 'dart:convert';

import '../../../firebase/firebase.dart';
import '../../../firebase/firestore.dart';

import '../material_card_component.dart';

import '../selected_directive.dart';
import '../page_component.dart';

import 'package:intl/intl.dart';

import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_ripple/material_ripple.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/material_spinner/material_spinner.dart';

import 'package:angular_components/model/date/date.dart';

@Component(
  selector:'mini-page',
  templateUrl:'mini_page_component.html',
  styleUrls:['../page_component.css'],
  directives:[
    SelectedDirective,
    MaterialRippleComponent,
    MaterialCardComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    MaterialSpinnerComponent,
    NgFor,
    NgIf,
    NgModel,
    NgStyle
  ]
)

class MiniPageComponent extends PageComponent implements OnInit {
  List<String> tabs = ['main page'];
  List miniEvents = [];

  Map dateStuff = {
    'week': [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ],
    'months': [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ]
  };
  
  Storage localStorage = window.localStorage;

  ngOnInit() {
    if (window.navigator.onLine) {
      loadMini();
    } else {
      loadMiniOffline();
    }
  }

  void loadMini() async {
    loading = true;
    await loadFirestore();
    mini.doc('school').get().then((docSnap) {
      miniEvents = docSnap.data()["events"];
      loading = false;
      localStorage["miniEvents"] = json.encode(miniEvents);
    });
  }

  void loadMiniOffline() {
    loading = true;
    miniEvents = json.decode(localStorage["miniEvents"]);
    loading = false;
  }
   
  String getDate(input) {
    Date date = Date.parse(input, DateFormat('yyyy-MM-dd'));
    String dateString = '${dateStuff['week'][date.asUtcTime().weekday]}, ${dateStuff['months'][date.asUtcTime().month-1]} ${date.asUtcTime().day}'; 
    return dateString;
  }
}