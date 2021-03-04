<br />
<p align="center"><a href="https://flutter.gskinner.com"><img src="https://flutter.gskinner.com/assets/images/gskinnerxflutter.png?" width="440px"></a></p>

<p align="center"><img src="https://flutter.gskinner.com/assets/images/git_promoimage.png?" width="800px"></p>

# Flutter Folio

A demo app showcasing how Flutter can deliver a great multi-platform experience, targeting iOS, Android, MacOS, Windows, Linux, and web. Built by [gskinner](https://gskinner.com) in partnership with Google, Flutter Folio purposefully considers user expectations, input devices and idioms for each platform, ensuring it feels at home on every device.

In addition to forking and reviewing the [MIT licensed](LICENSE.md) code available here, you can check out more information on the [Flutter Folio Showcase Website](https://flutter.gskinner.com).

### About gskinner
We exist to build innovative digital experiences for smart clients, and we love how easy Flutter makes that experience. Don't hesitate to [stop by our site](https://gskinner.com) to learn more about what we do. We'd love to hear from you!

<p align="center"><img src="https://flutter.gskinner.com/assets/images/git_dashes.png?" width="800px"></p>

### Demo Builds
To preview the app without needing to run a build process you can download any of the latest released builds.

| Target Platfom | Build |
| ------ | ------ |
| Web | [ www.flutterfolio.com](https://www.flutterfolio.com/) |
| Linux | [tar.gz](https://www.flutterfolio.com/builds/latest/linux-build/linux_build.tar.xz?84) |
| Windows | [.zip](https://www.flutterfolio.com/builds/latest/windows-build/windows_build.zip?84) |
| macOS | [dmg](https://www.flutterfolio.com/builds/latest/macos-build/FlutterFolio.dmg?84) |
| Android | Checkout the repo to install on your local device. |
| iOS | Checkout the repo to install on your local device. |

### Installation

If you're new to Flutter the first thing you'll need is to follow the [setup instructions](https://flutter.dev/docs/get-started/install). 

Once Flutter is setup, you can use the default `stable` channel, or switch to the latest `dev` version to get the most current fixes for desktop/web:
 * Run `flutter channel dev`
 * Run `flutter upgrade`

If you've never run a desktop build before, you will need to enable it with a one-time command for your current platform:
* `flutter config --enable-macos-desktop`
* `flutter config --enable-windows-desktop`
* `flutter config --enable-linux-desktop`

Once you're on `dev` and desktop is enabled, you're ready to run the app:
* `flutter run -d windows`
* `flutter run -d macos`
* `flutter run -d linux`
* `flutter run -d android`
* `flutter run -d ios`
* `flutter run -d web`

If you re-start your IDE, you should also see a new launch option for your current desktop platform.

### Client Keys
This repo includes a set of Keys for Cloudinary and Firebase that are on the free pricing plans. Depending on traffic, these may reach their limit. If that happens, you will need to provide your own keys in order to run the app locally, those can be found in `AppKeys.dart`. These limits should refresh each month, so your mileage will vary here.

### License

This application is released under the [MIT license](LICENSE.md). You can use the code for any purpose, including commercial projects.

[![license](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

