#!/bin/bash
# vendor/extra: drop 25 fonts/imported/ copies that duplicate prebuilt_font modules (Kati "overriding
# commands" errors). Done as a script so the patches don't carry the font files. Runs in vendor/extra.
set -e
git rm -q --ignore-unmatch \
    fonts/imported/GoogleSans-Italic.ttf \
    fonts/imported/GoogleSans-Regular.ttf \
    fonts/imported/GoogleSansClock-Regular.ttf \
    fonts/imported/GoogleSansFlex-Regular.ttf \
    fonts/imported/GoogleSansFlexClock-Regular.ttf \
    fonts/imported/HarmonyOS-Sans-Italic.ttf \
    fonts/imported/HarmonyOS-Sans.ttf \
    fonts/imported/OnePlusSans-Black.ttf \
    fonts/imported/OnePlusSans-BlackItalic.ttf \
    fonts/imported/OnePlusSans-Bold.ttf \
    fonts/imported/OnePlusSans-BoldItalic.ttf \
    fonts/imported/OnePlusSans-Italic.ttf \
    fonts/imported/OnePlusSans-Light.ttf \
    fonts/imported/OnePlusSans-LightItalic.ttf \
    fonts/imported/OnePlusSans-Medium.ttf \
    fonts/imported/OnePlusSans-MediumItalic.ttf \
    fonts/imported/OnePlusSans-Regular.ttf \
    fonts/imported/OnePlusSans-Thin.ttf \
    fonts/imported/OnePlusSans-ThinItalic.ttf \
    fonts/imported/Recursive-VF.ttf \
    fonts/imported/Rookery-Bold.otf \
    fonts/imported/Rookery-Italic.otf \
    fonts/imported/Rookery-Medium.otf \
    fonts/imported/Rookery-Regular.otf \
    fonts/imported/SanFranciscoDisplayPro.ttf
if ! git diff --cached --quiet; then
    git -c user.name="${GIT_AUTHOR_NAME:-chiranz}" -c user.email="${GIT_AUTHOR_EMAIL:-chiranz@localhost}" \
        commit -q -m "fonts: drop 25 imported/ copies that duplicate prebuilt_font modules"
fi
