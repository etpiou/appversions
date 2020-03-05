#!/bin/bash
echo "Checking application version"
outfile="$HOME/Documents/appversions.txt"
machinename=$(/usr/sbin/scutil --get ComputerName)
echo "Machine name: $machinename" > $outfile
username=$(/usr/bin/whoami)
echo "User: $username" >> $outfile
echo "Applications: " >> $outfile
for appname in /System/Applications/*.app /System/Applications/Utilities/*.app /Applications/*.app /Applications/Utilities/*.app $HOME/Applications/*.app; do
  if test -d "$appname"; then
    echo "$appname" >> $outfile
    filename="$appname/Contents/Info.plist"
    if grep --quiet CFBundleName "$filename"; then
      /usr/libexec/PlistBuddy -c "Print CFBundleName" "$filename" >> $outfile
    fi
    for propertyname in CFBundleShortVersionString CFBundleVersion; do
      if grep --quiet $propertyname "$filename"; then
        /usr/libexec/PlistBuddy -c "Print $propertyname" "$filename" >> $outfile
        break
      fi
    done
  fi
done
echo "Application version info has been saved to $outfile. You can double-click the file in the Finder to open it."
