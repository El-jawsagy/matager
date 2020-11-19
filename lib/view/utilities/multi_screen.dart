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
    if (this.width >= 320 && this.width < 360) {
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

class DrawerPageSize {
  DetectedScreen detectedScreen;
  double userNameSize;
  double emailSize;
  double titleSize;
  double iconSize;
  double imageWidthSize;
  double imageHeightSize;

  double sizeBoxHeight;

  //todo:add all properties of Edit Create TaskScreen
  DrawerPageSize(DetectedScreen ourScreen) {
    this.detectedScreen = ourScreen;
    print(detectedScreen.sizeName);
    _initSignUp();
  }

  void _initSignUp() {
    switch (this.detectedScreen.sizeName) {
      case screenType.Small:
        this.userNameSize = 14;
        this.emailSize = 12;
        this.imageHeightSize = 60;
        this.imageWidthSize = 60;
        this.iconSize = 16;
        this.titleSize = 14;
        this.sizeBoxHeight = 30;

        break;
      case screenType.Medium:
        this.userNameSize = 20;
        this.emailSize = 14;

        this.iconSize = 20;
        this.imageHeightSize = 80;
        this.imageWidthSize = 80;
        this.sizeBoxHeight = 45;

        break;
      case screenType.Large:
        this.userNameSize = 20;
        this.emailSize = 10;
        this.imageHeightSize = 80;
        this.imageWidthSize = 80;
        this.iconSize = 14;
        this.iconSize = 24;
        this.sizeBoxHeight = 50;

        break;
      default:
        this.userNameSize = 20;
        this.emailSize = 10;
        this.imageHeightSize = 80;
        this.imageWidthSize = 80;
        this.iconSize = 14;

        this.sizeBoxHeight = 55;
    }
  }
}

class HomePageSize {
  DetectedScreen detectedScreen;
  double headerTextSize;
  double nameSize;
  double priceSize;
  double iconSize;
  double iconHeaderSize;
  double sizeBoxHeight;

  //todo:add all properties of Edit Create TaskScreen
  HomePageSize(DetectedScreen ourScreen) {
    this.detectedScreen = ourScreen;
    print(detectedScreen.sizeName);
    _initSignUp();
  }

  void _initSignUp() {
    switch (this.detectedScreen.sizeName) {
      case screenType.Small:
        this.headerTextSize = 20;
        this.nameSize = 10;

        this.iconSize = 14;
        this.iconHeaderSize = 18;
        this.sizeBoxHeight = 30;

        break;
      case screenType.Medium:
        this.headerTextSize = 24;
        this.nameSize = 12;
        this.iconSize = 22;
        this.iconHeaderSize = 22;

        this.sizeBoxHeight = 45;

        break;
      case screenType.Large:
        this.headerTextSize = 26;
        this.nameSize = 12;
        this.iconSize = 24;
        this.iconHeaderSize = 24;

        this.sizeBoxHeight = 50;

        break;
      default:
        this.headerTextSize = 22;
        this.nameSize = 12;
        this.iconSize = 20;
        this.iconHeaderSize = 18;

        this.sizeBoxHeight = 55;
    }
  }
}

class CategorySize {
  DetectedScreen detectedScreen;
  double headerTextSize;
  double nameSize;
  double smallNameSize;
  double priceSize;
  double iconSize;
  double smallIconSize;
  double iconHeaderSize;
  double sizeBoxHeight;

  //todo:add all properties of Edit Create TaskScreen
  CategorySize(DetectedScreen ourScreen) {
    this.detectedScreen = ourScreen;
    print(detectedScreen.sizeName);
    _initSignUp();
  }

  void _initSignUp() {
    switch (this.detectedScreen.sizeName) {
      case screenType.Small:
        this.headerTextSize = 18;
        this.nameSize = 14;
        this.smallNameSize = 10;

        this.iconSize = 16;
        this.smallIconSize = 12;

        this.iconHeaderSize = 20;
        this.sizeBoxHeight = 30;

        break;
      case screenType.Medium:
        this.headerTextSize = 24;
        this.nameSize = 20;
        this.iconSize = 22;
        this.iconHeaderSize = 22;

        this.sizeBoxHeight = 45;

        break;
      case screenType.Large:
        this.headerTextSize = 26;
        this.nameSize = 20;
        this.iconSize = 24;
        this.iconHeaderSize = 24;

        this.sizeBoxHeight = 50;

        break;
      default:
        this.headerTextSize = 22;
        this.nameSize = 20;
        this.iconSize = 20;
        this.iconHeaderSize = 18;

        this.sizeBoxHeight = 55;
    }
  }
}

class MarketSize {
  DetectedScreen detectedScreen;
  double headerTextSize;
  double nameSize;
  double priceSize;
  double iconSize;
  double iconHeaderSize;
  double sizeBoxHeight;

  //todo:add all properties of Edit Create TaskScreen
  MarketSize(DetectedScreen ourScreen) {
    this.detectedScreen = ourScreen;
    print(detectedScreen.sizeName);
    _initSignUp();
  }

  void _initSignUp() {
    switch (this.detectedScreen.sizeName) {
      case screenType.Small:
        this.headerTextSize = 16;
        this.nameSize = 14;

        this.iconSize = 16;

        this.iconHeaderSize = 20;
        this.sizeBoxHeight = 30;

        break;
      case screenType.Medium:
        this.headerTextSize = 20;
        this.nameSize = 16;
        this.iconSize = 22;
        this.iconHeaderSize = 22;

        this.sizeBoxHeight = 45;

        break;
      case screenType.Large:
        this.headerTextSize = 26;
        this.nameSize = 16;
        this.iconSize = 24;
        this.iconHeaderSize = 24;

        this.sizeBoxHeight = 50;

        break;
      default:
        this.headerTextSize = 22;
        this.nameSize = 12;
        this.iconSize = 20;
        this.iconHeaderSize = 18;

        this.sizeBoxHeight = 55;
    }
  }
}

class ProductSize {
  DetectedScreen detectedScreen;
  double headerTextSize;
  double nameSize;
  double priceSize;
  double dotsSize;
  double iconSize;
  double sizeBoxHeight;

  //todo:add all properties of Edit Create TaskScreen
  ProductSize(DetectedScreen ourScreen) {
    this.detectedScreen = ourScreen;
    print(detectedScreen.sizeName);
    _initSignUp();
  }

  void _initSignUp() {
    switch (this.detectedScreen.sizeName) {
      case screenType.Small:
        this.headerTextSize = 14;
        this.nameSize = 12;
        this.iconSize = 18;
        this.dotsSize = 6;
        this.sizeBoxHeight = 30;

        break;
      case screenType.Medium:
        this.headerTextSize = 18;
        this.nameSize = 20;
        this.iconSize = 20;
        this.dotsSize = 10;

        this.sizeBoxHeight = 45;

        break;
      case screenType.Large:
        this.headerTextSize = 22;
        this.nameSize = 18;
        this.iconSize = 20;
        this.dotsSize = 10;

        this.sizeBoxHeight = 50;

        break;
      default:
        this.headerTextSize = 24;
        this.nameSize = 20;
        this.iconSize = 20;
        this.dotsSize = 10;

        this.sizeBoxHeight = 55;
    }
  }
}

class CartSize {
  DetectedScreen detectedScreen;
  double headerTextSize;
  double nameSize;
  double priceSize;
  double iconSize;
  double sizeBoxHeight;

  //todo:add all properties of Edit Create TaskScreen
  CartSize(DetectedScreen ourScreen) {
    this.detectedScreen = ourScreen;
    print(detectedScreen.sizeName);
    _initSignUp();
  }

  void _initSignUp() {
    switch (this.detectedScreen.sizeName) {
      case screenType.Small:
        this.headerTextSize = 14;
        this.nameSize = 12;
        this.iconSize = 14;
        this.sizeBoxHeight = 30;

        break;
      case screenType.Medium:
        this.headerTextSize = 18;
        this.nameSize = 16;
        this.iconSize = 16;
        this.sizeBoxHeight = 45;

        break;
      case screenType.Large:
        this.headerTextSize = 22;
        this.nameSize = 18;
        this.iconSize = 20;
        this.sizeBoxHeight = 50;

        break;
      default:
        this.headerTextSize = 24;
        this.nameSize = 20;
        this.iconSize = 20;
        this.sizeBoxHeight = 55;
    }
  }
}

class CartCheckOutSize {
  DetectedScreen detectedScreen;
  double headerTextSize;
  double nameSize;
  double stringSize;
  double priceSize;
  double iconSize;
  double iconHeaderSize;
  double sizeBoxHeight;

  //todo:add all properties of Edit Create TaskScreen
  CartCheckOutSize(DetectedScreen ourScreen) {
    this.detectedScreen = ourScreen;
    print(detectedScreen.sizeName);
    _initSignUp();
  }

  void _initSignUp() {
    switch (this.detectedScreen.sizeName) {
      case screenType.Small:
        this.headerTextSize = 20;
        this.nameSize = 12;
        this.stringSize = 8;
        this.iconSize = 12;
        this.iconHeaderSize = 18;
        this.sizeBoxHeight = 30;

        break;
      case screenType.Medium:
        this.headerTextSize = 24;
        this.nameSize = 16;
        this.stringSize = 10;

        this.iconSize = 18;
        this.iconHeaderSize = 22;

        this.sizeBoxHeight = 45;

        break;
      case screenType.Large:
        this.headerTextSize = 26;
        this.nameSize = 18;
        this.stringSize = 10;

        this.iconSize = 20;
        this.iconHeaderSize = 24;

        this.sizeBoxHeight = 50;

        break;
      default:
        this.headerTextSize = 22;
        this.nameSize = 12;
        this.stringSize = 10;

        this.iconSize = 20;
        this.iconHeaderSize = 18;

        this.sizeBoxHeight = 55;
    }
  }
}

class OrderSize {
  DetectedScreen detectedScreen;
  double headerTextSize;
  double nameSize;
  double stringSize;
  double priceSize;
  double iconSize;
  double iconHeaderSize;
  double sizeBoxHeight;

  //todo:add all properties of Edit Create TaskScreen
  OrderSize(DetectedScreen ourScreen) {
    this.detectedScreen = ourScreen;
    print(detectedScreen.sizeName);
    _initSignUp();
  }

  void _initSignUp() {
    switch (this.detectedScreen.sizeName) {
      case screenType.Small:
        this.headerTextSize = 20;
        this.nameSize = 12;
        this.stringSize = 8;
        this.iconSize = 12;
        this.iconHeaderSize = 18;
        this.sizeBoxHeight = 30;

        break;
      case screenType.Medium:
        this.headerTextSize = 24;
        this.nameSize = 16;
        this.stringSize = 10;

        this.iconSize = 18;
        this.iconHeaderSize = 22;

        this.sizeBoxHeight = 45;

        break;
      case screenType.Large:
        this.headerTextSize = 26;
        this.nameSize = 18;
        this.stringSize = 10;

        this.iconSize = 20;
        this.iconHeaderSize = 24;

        this.sizeBoxHeight = 50;

        break;
      default:
        this.headerTextSize = 22;
        this.nameSize = 12;
        this.stringSize = 10;

        this.iconSize = 20;
        this.iconHeaderSize = 18;

        this.sizeBoxHeight = 55;
    }
  }
}

class OrderDetailsSize {
  DetectedScreen detectedScreen;
  double headerTextSize;
  double nameSize;
  double ratingSize;
  double stringSize;
  double priceSize;
  double iconSize;
  double iconHeaderSize;
  double sizeBoxHeight;

  //todo:add all properties of Edit Create TaskScreen
  OrderDetailsSize(DetectedScreen ourScreen) {
    this.detectedScreen = ourScreen;
    print(detectedScreen.sizeName);
    _initSignUp();
  }

  void _initSignUp() {
    switch (this.detectedScreen.sizeName) {
      case screenType.Small:
        this.headerTextSize = 20;

        this.nameSize = 10;
        this.stringSize = 8;
        this.iconSize = 12;
        this.iconHeaderSize = 18;
        this.sizeBoxHeight = 30;

        break;
      case screenType.Medium:
        this.headerTextSize = 24;
        this.nameSize = 14;
        this.stringSize = 10;

        this.iconSize = 18;
        this.iconHeaderSize = 22;

        this.sizeBoxHeight = 45;

        break;
      case screenType.Large:
        this.headerTextSize = 26;
        this.nameSize = 14;
        this.stringSize = 10;

        this.iconSize = 18;
        this.iconHeaderSize = 24;

        this.sizeBoxHeight = 50;

        break;
      default:
        this.headerTextSize = 22;
        this.nameSize = 12;
        this.stringSize = 10;

        this.iconSize = 20;
        this.iconHeaderSize = 18;

        this.sizeBoxHeight = 55;
    }
  }
}
class AddressSize {
  DetectedScreen detectedScreen;
  double headerTextSize;
  double nameSize;
  double stringSize;
  double priceSize;
  double iconSize;
  double iconHeaderSize;
  double sizeBoxHeight;

  //todo:add all properties of Edit Create TaskScreen
  AddressSize(DetectedScreen ourScreen) {
    this.detectedScreen = ourScreen;
    print(detectedScreen.sizeName);
    _initSignUp();
  }

  void _initSignUp() {
    switch (this.detectedScreen.sizeName) {
      case screenType.Small:
        this.headerTextSize = 20;
        this.nameSize = 12;
        this.stringSize = 8;
        this.iconSize = 12;
        this.iconHeaderSize = 18;
        this.sizeBoxHeight = 30;

        break;
      case screenType.Medium:
        this.headerTextSize = 24;
        this.nameSize = 16;
        this.stringSize = 10;

        this.iconSize = 18;
        this.iconHeaderSize = 22;

        this.sizeBoxHeight = 45;

        break;
      case screenType.Large:
        this.headerTextSize = 26;
        this.nameSize = 18;
        this.stringSize = 10;

        this.iconSize = 20;
        this.iconHeaderSize = 24;

        this.sizeBoxHeight = 50;

        break;
      default:
        this.headerTextSize = 22;
        this.nameSize = 12;
        this.stringSize = 10;

        this.iconSize = 20;
        this.iconHeaderSize = 18;

        this.sizeBoxHeight = 55;
    }
  }
}

