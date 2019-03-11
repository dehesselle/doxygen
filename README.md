# Doxygen: DoxyWizard for macOS

The official DoxyWizard for macOS is built against Qt 4. It does not support retina displays nor Mojave's dark mode. This fork contains the scripts I use to compile it myself.

![alt-text](doc/doxywizard_macos.png)

## Building

```bash
cd addon/doxywizard
./build_qt5_app.sh
```

This will create `DoxyWizard.app` in `/Volumes/WORKSPACE/template_app`.

## Credits and License

See the [original repository](https://github.com/doxygen/doxygen). I only wrote the buildscript above.

