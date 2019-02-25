import 'package:angular/angular.dart';

import 'dart:html';
import 'dart:async';
import 'dart:convert';

import '../../../firebase/firebase.dart';
import '../../../firebase/firestore.dart';

import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;

import '../material_card_component.dart';

import '../selected_directive.dart';
import '../page_component.dart';

import 'package:intl/intl.dart';

import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_ripple/material_ripple.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/material_datepicker/material_datepicker.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/material_radio/material_radio.dart';
import 'package:angular_components/material_radio/material_radio_group.dart';
import 'package:angular_components/material_spinner/material_spinner.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/material_datepicker/module.dart';

import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/laminate/overlay/module.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/model/date/date.dart';

@Component(
  selector:'classes-page',
  templateUrl:'classes_page_component.html',
  styleUrls:['../page_component.css'],
  providers:[
    datepickerBindings,
    overlayBindings
  ],
  directives:[ // Build again
    AutoFocusDirective,
    AutoDismissDirective,
    SelectedDirective,
    materialInputDirectives,
    MaterialInputComponent,
    MaterialRippleComponent,
    MaterialCardComponent,
    MaterialDialogComponent,
    MaterialDatepickerComponent,
    MaterialButtonComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    MaterialRadioComponent,
    MaterialRadioGroupComponent,
    MaterialSpinnerComponent,
    MaterialCheckboxComponent,
    ModalComponent,
    NgFor,
    NgIf,
    NgModel,
    NgStyle
  ]
)

// PLEASE, PLEASE WORK

class ClassesPageComponent extends PageComponent implements OnInit {
  Map myClassesMap = {};
  List<String> tabs = [
    'Homework',
    'Events'
  ];

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

  Map<String, Map> myClassesRef = {};
  List yourClassesList = [];
  List myClassesTitleList = [];
  List blockNames = [];
  final Storage localStorage = window.localStorage;

  List completedWork = [];

  Map images = {};

  Map options = {
    'useImages':true,
  };

  bool loading = true;

  var storage = fb.storage();

  ngOnInit() {
    if (localStorage['options'] != null) {
      options = json.decode(localStorage['options']);
    } else {
      localStorage['options'] = json.encode(options);
    }
    if (localStorage['completed'] != null) {
      completedWork = json.decode(localStorage['completed']);
    }
    if (window.navigator.onLine) {
      loadClasses();
    } else {
      loadClassesOffline();
    }
  }

  setDone(String name) {
    if (!completedWork.contains(name)) {
      completedWork.add(name);
      localStorage['completed'] = json.encode(completedWork);
    } else {
      completedWork.remove(name);
      localStorage['completed'] = json.encode(completedWork);
    }
  }

  void loadClasses() async {
    loading = true;
    await loadFirestore();
    me.get().then((docSnap) async {
      if (docSnap.exists && docSnap.data()["classes"] != null) {
        myClassesMap = docSnap.data()["classes"];
        myClassesRef = {
          '1.1': await new Block('1.1').getClass(myClassesMap['1.1']),
          '1.2': await new Block('1.2').getClass(myClassesMap['1.2']),
          '1.3': await new Block('1.3').getClass(myClassesMap['1.3']),
          '1.4': await new Block('1.4').getClass(myClassesMap['1.4']),
          '2.1': await new Block('2.1').getClass(myClassesMap['2.1']),
          '2.2': await new Block('2.2').getClass(myClassesMap['2.2']),
          '2.3': await new Block('2.3').getClass(myClassesMap['2.3']),
          '2.4': await new Block('2.4').getClass(myClassesMap['2.4'])
        };
        blockNames = myClassesRef.keys.toList();
        myClassesTitleList = myClassesMap.values.toList();
        yourClassesList = myClassesRef.values.toList();
        localStorage['myClassesMap'] = jsonEncode(myClassesMap);
        localStorage['yourClassesList'] = jsonEncode(yourClassesList);
        localStorage['blockNames'] = jsonEncode(blockNames);
        images = await getImages();
        loading = false;
        deleteOldDone();
      } else {
        myClassesRef = {};
        loading = false;
        deleteOldDone();
      }
    });
  }

  void loadClassesOffline() {
    loading = true;
    myClassesMap = jsonDecode(localStorage['myClassesMap']);
    yourClassesList = jsonDecode(localStorage['yourClassesList']);
    blockNames = jsonDecode(localStorage['blockNames']);
    loading = false;
  }

  void deleteOldDone() async {
    List currentWork = [];
    yourClassesList.forEach((theClass) {
      theClass['homework'].forEach((work) {
        currentWork.add(work['title']);
      });
    });
    if (localStorage['completed'] != null) {
      List completedWork = json.decode(localStorage["completed"]);
      localStorage['completed'] = json.encode(completedWork.where((work) {
        return currentWork.contains(work);
      }).toList());
    }
  }

  String dialogError;
  bool dialogOpen = false;
  bool dialogLoading = false;
  String isHomework = 'homework';
  String newHomeworkTitle = '';
  File newHomeworkImage;
  String postClass;
  Date date;
  DateRange dateRange = DateRange(Date.today().add(days:1), Date.today().add(years:1));

  void openDialog() {
    isHomework = 'homework';
    newHomeworkTitle = '';
    date = null;
    newHomeworkImage = null;
    postClass = null;
    dialogOpen = true;
  }

  void fileChange(Event event) {
    InputElement target = event.target;
    newHomeworkImage = target.files[0];
  }

  void postHomework() async {
    if (postClass != null) {
      if (newHomeworkTitle != '') {
        if (date != null) {
          dialogLoading = true;
          fs.DocumentReference block = classes.doc(blockNames[myClassesTitleList.indexOf(postClass)]);
          fs.DocumentSnapshot blockData = await block.get();
          if (blockData.exists) {
            Map theClass = blockData.data()[postClass];
            if (newHomeworkImage != null && isHomework == 'homework') {
              print('posting with image...');
              String fileName = '${postClass}/${newHomeworkImage.name}';
              print(fileName);
              fb.storage().ref('').child(fileName).put(
                newHomeworkImage,
                fb.UploadMetadata(
                  contentType:newHomeworkImage.type,
                  customMetadata:{
                    "owner":user.email
                  }
                )
              );
              print('Image has been put');
              theClass[isHomework].add({'title':newHomeworkTitle,'date':date.toString(),'image':fileName});
            } else {
              theClass[isHomework].add({'title':newHomeworkTitle,'date':date.toString()});
            }
            await block.update(data:{
              postClass:theClass
            });
            dialogLoading = false;
            dialogOpen = false;
            loadClasses();
          }
        } else {
          dialogError = 'Please Select a Date.';
        }
      } else {
        dialogError = 'Please Enter a Title.';
      }
    } else {
      dialogError = 'Please Select a Class.';
    }
  } 
  String getDate(input) {
    Date date = Date.parse(input, DateFormat('yyyy-MM-dd'));
    String dateString = '${dateStuff['week'][date.asUtcTime().weekday]}, ${dateStuff['months'][date.asUtcTime().month-1]} ${date.asUtcTime().day}'; 
    return dateString;
  }
  Future getImages() async {
    return Future(() async {
      await yourClassesList.forEach((theClass) async {
        String location = myClassesMap[blockNames[yourClassesList.indexOf(theClass)]]; 
        images[location] = {};
        await theClass['homework'].forEach((work) async {
          if (work['image'] != null) {
            images[location][work['title']] = await fb.storage().ref('').child(work['image']).getDownloadURL();
            print(images);
          }
        });
      });
      return images;
    });
  }
  String getImage(String theClass, String title) {
    if (options['useImages']) {
      return images[theClass][title].toString();
    } else {
      return 'hide';
    }
  }
}