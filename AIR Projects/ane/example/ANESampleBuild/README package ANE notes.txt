How to package ANE

Example:
[AIR SDK]/bin/adt -package -target ane ./ane/ANESample.ane extension.xml -swc ANESampleMain.swc -platform Android-ARM -C android . -platform default -C default .

or

Use included Ant build.xml / ANESampleBulid - ANE Build.launch (External Tools Configuration for automated tasks)

Packaging notes:
http://help.adobe.com/en_US/air/extensions/WSf268776665d7970d-2e74ffb4130044f3619-7fff.html
http://help.adobe.com/en_US/air/build/WS901d38e593cd1bac1e63e3d128cdca935b-8000.html

-- Android
1. Create source Android project with AIR ane stuff
	(see Code_Samples/AIR Projects/ane/example/ANESampleAndroid)
2. Right click project/Export/Java/JAR file, select "src" and "gen" folders, and export .jar file
3. Copy this exported .jar file to "android" folder
4. Open build.xml and enter this .jar file name into value attribute of
	<property name="ANDROID_JAR" value="???.jar" />
5. If source Android project has any 3rd party library .jar (usually under "libs"), copy them also then
	list them in platformoptions_android.xml
6. If source Android project has "lib/armeabi" "lib/armeabi-v7a" etc., copy the contents
	to respective "android/libs" folder
7. If source Android project has any items under "assets," copy contents to NOT this ane build project
	but to actual Flash/ActionScript/Flex project's source folder (in Flex, src)
8. If .ane requires special Android permissions/activity info/etc from manifest, copy them
	into AIR application descriptor

-- iOS TODO: *********
1. Create source iOS project with AIR ane stuff
	(see Code_Samples/AIR Projects/ane/example/ANESampleiOS)
2. Copy .a
2. platformoptions_ios.xml

-- Common for both Android and iOS
1. Create main ActionScript library project to handle ane communication to Android/iOS
	(example ANESampleMain)
2. Create default ActionScript library project to handle ane communication in case
	app runs on platform ane does not support
3. Set these projects as respective resource paths in build.xml
4. Run build.xml to compile .ane
5. Add .ane to Flash/ActionScript/Flex project
6. Done
