
import 'package:flutter/material.dart';

enum screenType {
  Small,
  Medium,
  Large,
}

class DetectedScreen {
  BuildContext context;
  double height;
  double width;
  screenType sizeName;

  DetectedScreen(this.context) {
    height = MediaQuery.of(this.context).size.height;
    width = MediaQuery.of(this.context).size.width;
    _setNameScreen();
  }

  void _setNameScreen() {
    //todo: edit screen width conditions
    if (this.width >= 320 && this.width < 360 ) {
      sizeName = screenType.Small;
    } else if (this.width >= 360 && this.width < 400) {
      sizeName = screenType.Medium;
    } else if (this.width >= 400 && this.height >= 765) {
      sizeName = screenType.Large;
    }
  }
}

class LoginScreenProperties {
  DetectedScreen detectedScreen;
  double editTextSize;
  double forgetTextSize;
  double loginTextSize;
  double faceAndGoogleTextSize;
  double signUpText;

  LoginScreenProperties(DetectedScreen ourScreen) {
    this.detectedScreen = ourScreen;

    _initLogin();
  }

  void _initLogin() {
    switch (this.detectedScreen.sizeName) {
      case screenType.Small:
        this.editTextSize = 12;
        this.forgetTextSize = 14;
        this.loginTextSize = 17;
        this.faceAndGoogleTextSize = 16;
        this.signUpText = 14;

        break;
      case screenType.Medium:
        this.editTextSize = 16;
        this.forgetTextSize = 16;
        this.loginTextSize = 22;
        this.faceAndGoogleTextSize = 20;
        this.signUpText = 18;

        break;
      case screenType.Large:
        this.editTextSize = 20;
        this.forgetTextSize = 20;
        this.loginTextSize = 24;
        this.faceAndGoogleTextSize = 22;
        this.signUpText = 20;

        break;
      default:
        this.editTextSize = 22;
        this.forgetTextSize = 22;
        this.loginTextSize = 26;
        this.faceAndGoogleTextSize = 24;
        this.signUpText = 22;
    }
  }
}

class SignUpScreenProperties {
  DetectedScreen detectedScreen;
  double headerTextSize;

  double descriptionTextSize;

  double editTextSize;
  double signUPTextSize;

  double faceAndGoogleTextSize;

  double signUpText;

  //todo:add all properties of SignUpScreen
  SignUpScreenProperties(DetectedScreen ourScreen) {
    this.detectedScreen = ourScreen;
    _initSignUp();
  }

  void _initSignUp() {
    switch (this.detectedScreen.sizeName) {
      case screenType.Small:
        this.headerTextSize = 18;
        this.descriptionTextSize = 10;
        this.editTextSize = 12;
        this.signUPTextSize = 17;
        this.faceAndGoogleTextSize = 16;
        this.signUpText = 14;

        break;
      case screenType.Medium:
        this.headerTextSize = 24;
        this.descriptionTextSize = 13;
        this.editTextSize = 16;
        this.signUPTextSize = 22;
        this.faceAndGoogleTextSize = 20;
        this.signUpText = 18;

        break;
      case screenType.Large:
        this.headerTextSize = 30;
        this.descriptionTextSize = 16;
        this.editTextSize = 20;
        this.signUPTextSize = 24;
        this.faceAndGoogleTextSize = 22;
        this.signUpText = 20;

        break;
      default:
        this.headerTextSize = 32;
        this.descriptionTextSize = 18;
        this.editTextSize = 22;
        this.signUPTextSize = 26;
        this.faceAndGoogleTextSize = 24;
        this.signUpText = 22;
    }
  }
}

class CreateEditTask {
  DetectedScreen detectedScreen;
  double headerTextSize;
  double defaultSizeText;
  double iconSize;
  double sizeBoxHeight;

  //todo:add all properties of Edit Create TaskScreen
  CreateEditTask(DetectedScreen ourScreen) {
    this.detectedScreen = ourScreen;
    _initSignUp();
  }

  void _initSignUp() {
    switch (this.detectedScreen.sizeName) {
      case screenType.Small:
        this.headerTextSize = 16;
        this.defaultSizeText = 14;
        this.iconSize=16;
        this.sizeBoxHeight=30;

        break;
      case screenType.Medium:
        this.headerTextSize = 18;
        this.defaultSizeText = 16;
        this.iconSize=18;
        this.sizeBoxHeight=45;


        break;
      case screenType.Large:
        this.headerTextSize = 22;
        this.defaultSizeText = 18;
        this.iconSize=20;
        this.sizeBoxHeight=50;

        break;
      default:
        this.headerTextSize = 24;
        this.defaultSizeText = 20;
        this.iconSize=22;
        this.sizeBoxHeight=55;
    }
  }
}

class DateScreen {
  DetectedScreen detectedScreen;
  double widthDate;
  double widthTime;
  double defaultTextSize;
  double iconSize;

  //todo:add all properties of Edit Create TaskScreen
  DateScreen(DetectedScreen ourScreen) {
    this.detectedScreen = ourScreen;
    _initSignUp();
  }

  void _initSignUp() {
    switch (this.detectedScreen.sizeName) {
      case screenType.Small:
        this.widthDate = 130;
        this.widthTime = 100;
        this.defaultTextSize=12;
        this.iconSize =16;

        break;
      case screenType.Medium:
        this.widthDate = 145;
        this.widthTime = 105;
        this.defaultTextSize=14;
        this.iconSize =18;

        break;
      case screenType.Large:
        this.widthDate = 155;
        this.widthTime = 110;
        this.defaultTextSize=16;
        this.iconSize =20;

        break;
      default:
        this.widthDate = 165;
        this.widthTime = 115;
        this.defaultTextSize=18;
        this.iconSize =22;


    }
  }
}

//todo:this class to add all properties of DisplayProjectScreen AND StoriesAndTasksScreen
class PersonalStoryTaskProperties {
  DetectedScreen detectedScreen;

  double storyNameSize;
  double allTaskUnfinish;
  double lastUpdateEnded;
  double processingRatio;
  double taskName;
  double taskDescription;
  double storyCardHeight;
  double taskCardHeight;

  //todo:add all properties of Personal_Story_Task Screen
  PersonalStoryTaskProperties(DetectedScreen ourScreen) {
    this.detectedScreen = ourScreen;
    _initSignUp();
  }

  void _initSignUp() {
    switch (this.detectedScreen.sizeName) {
      case screenType.Small:
        this.storyNameSize = 14;
        this.allTaskUnfinish = 10;
        this.lastUpdateEnded = 8;
        this.processingRatio = 10;
        this.taskName = 12;
        this.taskDescription = 8;
        this.storyCardHeight = 180;
        this.taskCardHeight = 130;

        break;
      case screenType.Medium:
        this.storyNameSize = 16;
        this.allTaskUnfinish = 12;
        this.lastUpdateEnded = 10;
        this.processingRatio = 12;
        this.taskName = 14;
        this.taskDescription = 10;
        this.storyCardHeight = 190;
        this.taskCardHeight = 140;

        break;
      case screenType.Large:
        this.storyNameSize = 18;
        this.allTaskUnfinish = 14;
        this.lastUpdateEnded = 12;
        this.processingRatio = 14;
        this.taskName = 16;
        this.taskDescription = 12;
        this.storyCardHeight = 200;
        this.taskCardHeight = 155;

        break;
      default:
        this.storyNameSize = 20;
        this.allTaskUnfinish = 16;
        this.lastUpdateEnded = 14;
        this.processingRatio = 16;
        this.taskName = 18;
        this.taskDescription = 14;
        this.storyCardHeight = 210;
        this.taskCardHeight = 170;


    }
  }
}

class AllDetailsScreen {
  DetectedScreen detectedScreen;
  double headerTextSize;
  double defaultTextSize;
  double defaultTextSize2;
  double bigCirclesHeight;
  double smallCirclesHeight;
  double userImageHeight;

  //todo:add all properties of Edit Create TaskScreen
  AllDetailsScreen(DetectedScreen ourScreen) {
    this.detectedScreen = ourScreen;
    _initSignUp();
  }

  void _initSignUp() {
    switch (this.detectedScreen.sizeName) {
      case screenType.Small:
        this.headerTextSize = 16;
        this.defaultTextSize = 12;
        this.defaultTextSize2 = 10;
        this.bigCirclesHeight = 50;
        this.smallCirclesHeight = 40;
        this.userImageHeight = 40;

        break;
      case screenType.Medium:
        this.headerTextSize = 18;
        this.defaultTextSize = 14;
        this.defaultTextSize2 = 12;
        this.bigCirclesHeight = 60;
        this.smallCirclesHeight = 50;
        this.userImageHeight = 45;

        break;
      case screenType.Large:
        this.headerTextSize = 20;
        this.defaultTextSize = 16;
        this.defaultTextSize2 = 14;
        this.bigCirclesHeight = 70;
        this.smallCirclesHeight = 60;
        this.userImageHeight = 50;

        break;
      default:
        this.headerTextSize = 22;
        this.defaultTextSize = 18;
        this.defaultTextSize2 = 16;
        this.bigCirclesHeight = 80;
        this.smallCirclesHeight = 70;
        this.userImageHeight = 54;


    }
  }
}
