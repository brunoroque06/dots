// Change
map("cu", "sU");

// Go (same tab)
map("gh", "gU");
map("gg", "go");
map("gt", "T");
map("gu", "O");

// Open (new tab)
map("ob", "b");
map("of", "af");
mapkey("og", "#8Open a URL in new tab", function() {
  Front.openOmnibar({ type: "URLs", extra: "getAllSites", tabbed: true });
});
map("oh", "oh");
map("om", "cf");
mapkey("oi", "#8Open incognito window", function() {
  RUNTIME("openIncognito", {
    url: "https://www.startpage.com"
  });
});
map("oy", "oy");

// Paste
unmap("p");
map("pg", "sg");
map("ps", "ss");
map("ph", "sh");
map("py", "sy");
unmap("sb");
unmap("sd");
unmap("sg");
unmap("ss");
unmap("sh");
unmap("sy");
unmap("sw");

// Scroll
map("sf", ";fs");
map("ss", "w");
map("st", ";w");

// Tabs
map("[", "E");
map("]", "R");
map("{", "S");
map("}", "D");

// Settings
Hints.characters = "qwertyiopasfgzxcvbnm";
Hints.scrollKeys = "0udjkhlG$";
settings.enableAutoFocus = false;
settings.hintAlign = "left";
settings.startToShowEmoji = 9;
settings.tabsThreshold = 1;
settings.theme = `
.sk_theme {
  font-family: IBM Plex Sans, sans;
  font-size: 14pt;
  background: #24272e;
  color: #abb2bf;
}
.sk_theme tbody {
  color: #fff;
}
.sk_theme input {
  color: #d0d0d0;
}
.sk_theme .url {
  color: #61afef;
}
.sk_theme .annotation {
  color: #56b6c2;
}
.sk_theme .omnibar_highlight {
  color: #528bff;
}
.sk_theme .omnibar_timestamp {
  color: #e5c07b;
}
.sk_theme .omnibar_visitcount {
  color: #98c379;
}
.sk_theme #sk_omnibarSearchResult>ul>li:nth-child(odd) {
  background: #303030;
}
.sk_theme #sk_omnibarSearchResult>ul>li.focused {
  background: #3e4452;
}
#sk_status, #sk_find {
  font-size: 14pt;
}`;
