import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

import '../../firebase/firebase.dart';
import '../../firebase/firestore.dart';


import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_radio/material_radio.dart';
import 'package:angular_components/material_radio/material_radio_group.dart';
import 'package:angular_components/material_spinner/material_spinner.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel_set.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel_auto_dismiss.dart';

import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/laminate/overlay/module.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';

@Component(
  selector: 'class-list',
  styleUrls: ['class_list_component.css'],
  templateUrl: 'class_list_component.html',
  providers:[overlayBindings],
  directives: [
    AutoFocusDirective,
    AutoDismissDirective,
    MaterialIconComponent,
    MaterialButtonComponent,
    MaterialRadioComponent,
    MaterialRadioGroupComponent,
    MaterialSpinnerComponent,
    MaterialExpansionPanel,
    MaterialExpansionPanelAutoDismiss,
    MaterialExpansionPanelSet,
    MaterialDialogComponent,
    ModalComponent,
    materialInputDirectives,
    NgFor,
    NgIf
  ],
)
class ClassListComponent implements OnInit {
  String errorMessage = null;
  bool loading = false;
  List<String> blocks = ['1.1','1.2','1.3','1.4','2.1','2.2','2.3','2.4'];
  Map<String, Block> blockList = {
    '1.1':new Block('1.1'),
    '1.2':new Block('1.2'),
    '1.3':new Block('1.3'),
    '1.4':new Block('1.4'),
    '2.1':new Block('2.1'),
    '2.2':new Block('2.2'),
    '2.3':new Block('2.3'),
    '2.4':new Block('2.4')
  };
  Map<String, Iterable> classLists = {
    '1.1':[],
    '1.2':[],
    '1.3':[],
    '1.4':[],
    '2.1':[],
    '2.2':[],
    '2.3':[],
    '2.4':[]
  };
  Map<String, String> selectedClass = {
    '1.1':null,
    '1.2':null,
    '1.3':null,
    '1.4':null,
    '2.1':null,
    '2.2':null,
    '2.3':null,
    '2.4':null
  };
  ngOnInit() {
    loadClassLists();
  }
  loadClassLists() async {
    classLists = {
      '1.1':await blockList['1.1'].classList(),
      '1.2':await blockList['1.2'].classList(),
      '1.3':await blockList['1.3'].classList(),
      '1.4':await blockList['1.4'].classList(),
      '2.1':await blockList['2.1'].classList(),
      '2.2':await blockList['2.2'].classList(),
      '2.3':await blockList['2.3'].classList(),
      '2.4':await blockList['2.4'].classList()
    };
  }
  bool dialogOpen = null;
  bool dialogLoading = false;
  String dialogBlock = null;
  String newClassName = '';
  createClassDialog(block) {
    dialogLoading = false;
    dialogBlock = block;
    newClassName = '';
    dialogOpen = true;
  }
  createClass() async {
    dialogLoading = true;
    try {
      await blockList[dialogBlock].createClass(newClassName);
      await blockList[dialogBlock].reloadData();
      classLists[dialogBlock] = await blockList[dialogBlock].classList();
      dialogLoading = false;
      dialogOpen = false;
    } catch (error) {
      errorMessage = error;
      dialogLoading = false;
      dialogOpen = false; 
    }
  }
  classesDone() async {
    print(selectedClass);
    if (!selectedClass.containsValue(null)) {
      loading = true;
      await users.doc(user.email).set({
        'classes':selectedClass
      });
      loading = false;
      newUser = false;
      window.history.replaceState({'state':null,'component':null}, 'Main App', '/');
    } else {
      errorMessage = 'Please Select all Your Classes.';
    }
  }
}
