TARGET=${TARGET:-"aarch64-linux-android"}
OPENCV=${OPENCV}

if [ "$TARGET" = "aarch64-linux-android" ]; then
  OPENCV_ABI_DIR="arm64-v8a"
else
  OPENCV_ABI_DIR="armeabi-v7a"
fi

export OPENCV_INCLUDE_PATHS="$OPENCV/include"
export OPENCV_LINK_PATHS="$OPENCV/libs/$OPENCV_ABI_DIR"
export OPENCV_LINK_LIBS="opencv_core,opencv_imgproc,opencv_imgcodecs"

# Detect host OS for NDK prebuilt tag
UNAME=$(uname | tr 'A-Z' 'a-z')
if [ "$UNAME" = "darwin" ]; then
  HOST_TAG="darwin-x86_64"
else
  HOST_TAG="linux-x86_64"
fi

if [ "$TARGET" = "aarch64-linux-android" ]; then
    ARCH="aarch64-linux-android"
elif [ "$TARGET" = "armv7-linux-androideabi" ]; then
    ARCH="armv7a-linux-androideabi"
fi

export TOOLCHAIN="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/$HOST_TAG"
export API="${API:-24}"
export AR="$TOOLCHAIN/bin/llvm-ar"
export CC="$TOOLCHAIN/bin/$ARCH$API-clang"
export CXX="$TOOLCHAIN/bin/$ARCH$API-clang++"

# Ensure Rust uses NDK clang as the linker for the Android target
if [ "$TARGET" = "aarch64-linux-android" ]; then
  export CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER="$CC"
elif [ "$TARGET" = "armv7-linux-androideabi" ]; then
  export CARGO_TARGET_ARMV7_LINUX_ANDROIDEABI_LINKER="$CC"
fi

export RUSTFLAGS="-C linker=$CC"

RUST_BACKTRACE="full" cargo build -vv --target $TARGET