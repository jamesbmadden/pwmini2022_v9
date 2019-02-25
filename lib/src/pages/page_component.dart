import 'package:angular/angular.dart';

import 'dart:html';
import 'dart:math';

class PageComponent implements AfterContentInit {
  @HostListener('scroll')
  onScroll(event) {
    if (event.target.scrollTop > 0) {
      event.target.classes.add('scroll');
    } else {
      event.target.classes.remove('scroll');
    }
  }

  bool loading = false;
  num selectedTab = 0;
  List<String> tabs = [];
  Map<String, String> tabIndicatorStyles;
  Map<String, String> tabContainerStyles;

  ngAfterContentInit() {
    tabIndicatorStyles = {
    'width':'${100/tabs.length}%'
    };

    tabContainerStyles = {
      'width':'${100*tabs.length}%'
    };
  }

  setTab(tab, [swipe]) {
    if (swipe != true) {
      tabIndicatorStyles['transition'] = tabContainerStyles['transition'] = 'transform 0.4s cubic-bezier(1,0,0,1)';
    }
    selectedTab = tab;
    tabIndicatorStyles['transform'] = 'translate(${100*tab}%)';
    tabContainerStyles['transform'] = 'translate(-${(100/tabs.length)*tab}%)';
  }

  Map<String, dynamic> touch = {
    'start': <String, int>{
      'x':null,
      'y':null
    },
    'previous': <String, int>{
      'x':null,
      'y':null
    },
    'current': <String, int>{
      'x':null,
      'y':null
    },
    'horizontal':null,
    'oldTab':null
  };

  void touchStart([TouchEvent event]) {
    touch['horizontal'] = true;
    touch['start']['x'] = event.touches[0].client.x;
    touch['start']['y'] = event.touches[0].client.y;
    touch['previous'] = touch['start'];
    touch['current'] = touch['start'];
    touch['oldTab'] = selectedTab;
  }
  void touchMove([TouchEvent event]) {
    if (touch['horizontal']) {
      touch['previous'] = touch['current'];
      touch['current'] = {
        'x':event.touches[0].client.x,
        'y':event.touches[0].client.y
      };
      num touchDistance = touch['start']['y'] - touch['current']['y'];
      if (touchDistance.abs() > 50) {
        touch['horizontal'] = false;
        tabIndicatorStyles['transform'] = 'translate(${100*selectedTab}%)';
        tabContainerStyles['transform'] = 'translate(-${(100/tabs.length)*selectedTab}%)';
      } else {
        tabContainerStyles['transition'] = tabIndicatorStyles['transition'] ='initial';
        tabContainerStyles['transform'] = 'translate(calc(-${(100/tabs.length)*selectedTab}% - ${touch['start']['x'] - touch['current']['x']}px))';
        tabIndicatorStyles['transform'] = 'translate(calc(${100*selectedTab}% + ${(touch['start']['x'] - touch['current']['x'])/tabs.length}px))';
      }
    }
  }
  void touchEnd([TouchEvent event]) {
    tabContainerStyles['transition'] = tabIndicatorStyles['transition'] = 'transform 0.4s cubic-bezier(0,0,0,1)';
    if ((touch['start']['x'] - touch['current']['x']) > min(window.innerWidth/3, 144) && selectedTab < tabs.length-1) {
      setTab(selectedTab+1, true);
    } else if ((touch['current']['x'] - touch['start']['x']) > min(window.innerWidth/3, 144) && selectedTab > 0) {
      setTab(selectedTab-1, true);
    } else {
      setTab(selectedTab, true);
    }
  }
}

/* 
    this.style.transition = 'transform 0.4s cubic-bezier(0,0,0,1)';
    document.querySelector('.tabIndicator').style.transition = 'transform 0.4s cubic-bezier(0,0,0,1)';
    if ((scroll.startPos - scroll.currentPos) > (Math.min(window.innerWidth / 3, 144)) && selectedTab < 2) {
        var i = selectedTab + 1;
        document.querySelector('tab-view').style.transform = "translate(-" + i * 100 + "%)";
        document.querySelector('.tabIndicator').style.transform = "translate(" + i * 133 + "%)";
        selectedTab = i;
        document.querySelector('header nav p[selected]').removeAttribute('selected');
        document.querySelectorAll('header nav p')[i].setAttribute('selected', 'true');
    }
    else if ((scroll.currentPos - scroll.startPos) > (Math.min(window.innerWidth / 3, 144)) && selectedTab > 0) {
        var i = selectedTab - 1;
        document.querySelector('tab-view').style.transform = "translate(-" + i * 100 + "%)";
        document.querySelector('.tabIndicator').style.transform = "translate(" + i * 133 + "%)";
        selectedTab = i;
        document.querySelector('header nav p[selected]').removeAttribute('selected');
        document.querySelectorAll('header nav p')[i].setAttribute('selected', 'true');
    }
    else {
        var i = selectedTab;
        document.querySelector('tab-view').style.transform = "translate(-" + i * 100 + "%)";
        document.querySelector('.tabIndicator').style.transform = "translate(" + i * 133 + "%)";
    };
*/