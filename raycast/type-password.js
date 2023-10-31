#!/usr/bin/env osascript

// @raycast.schemaVersion 1
// @raycast.title Type Password
// @raycast.mode compact
// @raycast.icon 🔑

let app = Application.currentApplication();
app.includeStandardAdditions = true;
let pw = app.doShellScript("");
let se = Application("System Events");
se.keyCode(53); // escape
delay(0.5);
se.keystroke(pw);
se.keyCode(36); // enter
