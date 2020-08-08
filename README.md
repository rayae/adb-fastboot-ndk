# Fastboot and adb for Android devices
 Build with NDK(android-ndk-r17b-linux-x86_64).

# Requirements
 * Ubuntu 18.04 WSL (only tested)
 * [Android NDK](https://developer.android.google.cn/ndk/downloads/older_releases)
 * cmake
 * ninja-build
 * golang-go

# How to use
 * run `sh init_environment.sh` to initial build environment and get source codes
 * run `make` to build all (dont use parallel build)
 * run `make adb` to build adb binary
 * run `make fastboot` to build fastboot binary
 * see `build/out` for binaries

# Thanks
This project based on [fastboot-adb-android](https://github.com/shakalaca/fastboot-adb-android)

# License
```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
 