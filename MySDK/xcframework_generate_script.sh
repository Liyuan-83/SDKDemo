#!/bin/bash

echo "### start execute script"

# 尋找當前目錄底下副檔名為 xcodeproj 的檔案，找不到則結束程式。
# 如果順利找到的話，應該會是像 "kkbox.xcodeproj" 這樣子的字串。
proj_name=( *.xcodeproj )
[[ -e $proj_name ]] || { echo "Not found *.xcodeproj"; exit 1; }

# 字串處理，取前段半為專案 scheme name。
# 以上面提的範例的話，會得到 "kkbox" 這樣的字串。
scheme_name="${proj_name%.*}"
echo "Successful get scheme name: $scheme_name"

# 打印出目前 xcode 使用的版本
xcodebuild -version

# archive 出實體機版本的 framework
xcodebuild clean archive \
-project $proj_name \
-scheme $scheme_name \
-destination "generic/platform=iOS" \
-archivePath "archives/iOS" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# archive 出模擬器版本的 framework
xcodebuild clean archive \
-project $proj_name \
-scheme $scheme_name \
-destination "generic/platform=iOS Simulator" \
-archivePath "archives/Simulator" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# 合併以上兩個版本成為一個 xcframework
xcodebuild -create-xcframework \
-framework ./archives/iOS.xcarchive/Products/Library/Frameworks/$scheme_name.framework \
-framework ./archives/Simulator.xcarchive/Products/Library/Frameworks/$scheme_name.framework \
-output ./archives/$scheme_name.xcframework

exit 0
