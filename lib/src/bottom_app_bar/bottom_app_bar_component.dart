import 'package:angular/angular.dart';

import 'dart:html';
import 'dart:async';

import 'package:angular_components/material_ripple/material_ripple.dart';
import 'package:angular_components/material_icon/material_icon.dart';

@Component(
  selector:'bottom-app-bar',
  templateUrl:'bottom_app_bar_component.html',
  styleUrls:['bottom_app_bar_component.css'],
  directives:[
    MaterialIconComponent,
    MaterialRippleComponent,
  ]
)

class BottomAppBarComponent implements OnInit {
  String url = window.location.pathname;
  ngOnInit() {
    Timer.periodic(new Duration(milliseconds: 33), (event) {
      url = window.location.pathname;
    });
  }

  setUrl(url) {
    window.history.pushState({'state':null,'component':null}, 'Mini \'22', url);
  }
}

// Hello!