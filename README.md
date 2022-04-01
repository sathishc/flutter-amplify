# Flutter Todo App with Amplify

A Flutter project that demonstrates Amplify integration with Flutter.

## Pre-requisites

1. An AWS account with local configuration (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION) pointing to that account and region. You can export the above variables in your shell for access. 

2. Amplify CLI

3. Fluuter CLI and Android Studio with Emulator setup 

To install the Amplify cli, type the following in your command shell

```bash
npm install -g @aws-amplify/cli
```

## Getting Started

1. Create a new Flutter App from the command line or Android Studio IDE (to create projects via android studio, you need to have installed Flutter plugins within studio).

To create the app from command line, type the following in your command line

```bash
flutter create todo
```

The above command will create a basic flutter app. We will replace the contents of this app to implement a basic Todo list with no backend. Open the above 'todo' folder in an IDE (peferably Android Studio)

## Create a basic Todo list scaffold

To create a basic Todolist without any backend functionality, create a folder called todo inside your 'lib' folder, create the files todo.dart, todo_list.dart and todo_service.dart and copy the contents of the files from this repository into the files you created.

Change the code within the main.dart file with the contents of main.dart in this repository.

Now you are ready to run this app. First install dependencies by running the following command from the root folder.

```bash
flutter pub get
```

Next launch the emulator from Android Studio and click on the 'Run' or 'Debug' icon to build and deploy the app in an emulator.

You should now be able to see the app in the emulator and interact with it

## Integrate to a backend using Amplify

We will now integrated to an AWS backend which consists of the API Gateway, a Lambda function and a DynamoDB database. We will also introduce Authentication for the system using AWS Cognito.

1. We need to first initiatize Amplify in your project. From the root folder in your command line type the following

```bash
amplify init # provide the necessary details - amplify will show intelligent defaults
```

The above command initializes amplify within your project. We can now use the command line to provision necessary backends in AWS.

2. Once the backend are provisioned, we need libraries that allow us to communcte with these backends from our app. We can update dependencies in pubspec.yaml to include the necessary amplify libraries. Copy the following code into the yaml file. Note that we are adding libraries for amplify, cognito and authentication

```yaml
name: todo
description: A new Flutter project.

# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
version: 1.0.0+1

environment:
  sdk: ">=2.16.1 <3.0.0"

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter


  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.2
  amplify_flutter: ^0.4.0
  amplify_auth_cognito: ^0.4.0
  amplify_authenticator: ^0.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^1.0.0

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/assets-and-images/#resolution-aware.

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/assets-and-images/#from-packages

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/custom-fonts/#from-packages
```

Execute the following in the command line to install the libraries

```bash
flutter pub get
```

## Add Authentication

We will now add authentication to our app by provisioning a cognito backend and integrate the necessary components into the frontend.

1. Initialize amplify within the project and add authentication
```bash
amplify add auth # add basic username based authentication by following the instructions
amplify push # this will create the necessary cognito backend in AWs and update amplifyconfiguration.dart
```

2. Update the the UI to include authentication. Replace the main.dart with the code below.

```dart
mport 'package:flutter/material.dart';

// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_api/amplify_api.dart';

// Generated in previous step
import 'amplifyconfiguration.dart';
import 'todo/todo_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {



  @override
  initState() {
    super.initState();
    _configureAmplify();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Authenticator(
      initialStep: AuthenticatorStep.signIn,
      child: MaterialApp(
        builder: Authenticator.builder(),
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: const Text('Flutter Todo List'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () {
                  _todoSignOut();
                },
              )],
          ),
          body: const TodoList(title: 'Flutter Todo list'),
        ),
      ),
    );
  }

  void _todoSignOut() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  void _configureAmplify() async {

    // Add Pinpoint and Cognito Plugins, or any other plugins you want to use
    // AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyAPI apiPlugin = AmplifyAPI();
    // await Amplify.addPlugins([authPlugin, analyticsPlugin]);
    await Amplify.addPlugins([authPlugin, apiPlugin]);

    // Once Plugins are added, configure Amplify
    // Note: Amplify can only be configured once.
    try {
      await Amplify.configure(amplifyconfig);
      print('Successfully configured');
    } on AmplifyAlreadyConfiguredException {
      print("Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }
}

```

Now build the project and redeploy the app into the emulator. You should now see components that allow you to sign-up, sign-in, reset password etc within the app.

