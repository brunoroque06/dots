open System
open System.IO

let (+) a b = List.append b a

type Action =
    | Actions
    | Back
    | Close
    | CodeActions
    | Find
    | FindGlobal
    | Forward
    | GoToBuffer
    | GoToFile
    | GoToJump
    | GoToSymbol
    | GoToSymbolGlobal
    | Navigate
    | ParameterInfo
    | Replace
    | ReplaceGlobal
    | Settings
    | Terminal
    | Zen

type Key =
    | Enter
    | OpenBracket
    | CloseBracket
    | Char of string

type Bind = { key: Key; shift: bool; act: Action }

type File = { name: string; content: string list }

module JetBrains =
    let toText act bind =
        match bind with
        | Some b -> $"  <action id=\"{act}\">\n    <keyboard-shortcut first-keystroke=\"{b}\"/>\n  </action>"
        | _ -> $"  <action id=\"{act}\"/>"

    let map (bind: Bind) =
        let act =
            match bind.act with
            | Actions -> "GotoAction"
            | Back -> "Back"
            | Close -> "CloseContent"
            | CodeActions -> "ShowIntentionActions"
            | Find -> "Find"
            | FindGlobal -> "FindInPath"
            | Forward -> "Forward"
            | GoToBuffer -> "RecentFiles"
            | GoToFile -> "GotoFile"
            | GoToJump -> "ShowBookmarks"
            | GoToSymbol -> "FileStructurePopup"
            | GoToSymbolGlobal -> "GotoSymbol"
            | Navigate -> "ShowNavBar"
            | ParameterInfo -> "ParameterInfo"
            | Replace -> "Replace"
            | ReplaceGlobal -> "ReplaceInPath"
            | Settings -> "ShowSettings"
            | Terminal -> "ActivateTerminalToolWindow"
            | Zen -> "HideAllWindows"

        let char =
            match bind.key with
            | Enter -> "enter"
            | OpenBracket -> "open_bracket"
            | CloseBracket -> "close_bracket"
            | Char l -> l

        let bind =
            match bind.shift with
            | true -> "shift meta"
            | _ -> "meta"
            |> fun s -> $"{s} {char}"

        toText act (Some bind)

    let config binds =
        let mapped = List.map map binds

        let disabled =
            [ "CompareTwoFiles"
              "EditorDuplicate"
              "FindNext"
              "GotoClass"
              "GotoLine"
              "QuickImplementations"
              "QuickJavaDoc"
              "org.intellij.plugins.markdown.ui.actions.styling.ToggleBoldAction"
              "Vcs.UpdateProject" ]
            |> List.map (fun a -> toText a None)

        let content =
            [ "<keymap version=\"1\" name=\"bruno-roque\" parent=\"macOS System Shortcuts\">" ]
            |> (+) mapped
            |> (+) disabled
            |> (+) [ "</keymap>" ]

        List.map
            (fun (p: string) -> p.Split "/")
            [ "DataGrip2022.3/keymaps"
              "GoLand2022.3/keymaps"
              "PyCharm2022.3/jba_config/mac.keymaps"
              "Rider2022.3/keymaps"
              "WebStorm2022.3/jba_config/mac.keymaps" ]
        |> List.map Path.Combine
        |> List.map (fun p -> Path.Combine("Library", "Application Support", "JetBrains", p, "bruno-roque.xml"))
        |> List.map (fun p -> { name = p; content = content })

module VsCode =
    let toText act bind cond =
        let cond =
            match cond with
            | Some c -> $"    \"when\": \"{c}\"\n"
            | _ -> ""

        $"  {{\n    \"key\": \"{bind}\",\n    \"command\": \"{act}\",\n{cond}  }},"

    let map (bind: Bind) =
        let act =
            match bind.act with
            | Actions -> "workbench.action.showCommands"
            | CodeActions -> "editor.action.quickFix"
            | Close -> "workbench.action.closeActiveEditor"
            | Back -> "workbench.action.navigateBack"
            | Find -> "actions.find"
            | FindGlobal -> "workbench.action.findInFiles"
            | Forward -> "workbench.action.navigateForward"
            | GoToBuffer -> "workbench.action.quickOpen"
            | GoToFile -> "workbench.action.quickOpen"
            | GoToJump -> "bookmarks.listFromAllFiles"
            | GoToSymbol -> "workbench.action.gotoSymbol"
            | GoToSymbolGlobal -> "workbench.action.showAllSymbols"
            | Navigate -> "breadcrumbs.focusAndSelect"
            | ParameterInfo -> "editor.action.triggerParameterHints"
            | Replace -> "editor.action.startFindReplaceAction"
            | ReplaceGlobal -> "workbench.action.replaceInFiles"
            | Settings -> "workbench.action.openSettings"
            | Terminal -> "workbench.action.terminal.toggleTerminal"
            | Zen -> "workbench.action.toggleSidebarVisibility"

        let char =
            match bind.key with
            | Enter -> "enter"
            | OpenBracket -> "["
            | CloseBracket -> "]"
            | Char l -> l

        let bind =
            match bind.shift with
            | true -> "cmd+shift"
            | _ -> "cmd"
            |> fun s -> $"{s}+{char}"

        toText act bind None

    let config binds =
        let mapped =
            binds
            |> List.map map
            |> (+) [ (toText "editor.action.commentLine" "ctrl-c" (Some "editorFocus")) ]
            |> (+) [ (toText "bookmarks.toggle" "ctrl-s" (Some "editorFocus")) ]
            |> (+) [ (toText "workbench.action.focusActiveEditorGroup" "escape" (Some "!editorFocus")) ]

        let content = [ "[" ] |> (+) mapped |> (+) [ "]" ]

        [ { name = Path.Combine("Library", "Application Support", "Code", "User", "keybindings.json")
            content = content } ]


let binds =
    [ (Enter, false, CodeActions)
      (OpenBracket, false, Back)
      (CloseBracket, false, Forward)
      (Char(","), false, Settings)
      (Char("b"), false, GoToBuffer)
      (Char("f"), false, Find)
      (Char("f"), true, FindGlobal)
      (Char("h"), true, Zen)
      (Char("i"), false, ParameterInfo)
      (Char("j"), false, GoToJump)
      (Char("l"), false, Navigate)
      (Char("o"), false, GoToFile)
      (Char("p"), false, Actions)
      (Char("r"), false, Replace)
      (Char("r"), true, ReplaceGlobal)
      (Char("t"), false, Terminal)
      (Char("w"), false, Close)
      (Char("y"), false, GoToSymbol)
      (Char("y"), true, GoToSymbolGlobal) ]
    |> List.map (fun (k, s, a) -> { key = k; shift = s; act = a })


let writeFile f =
    let path =
        Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), f.name)

    printfn $"Writing: {path}"
    File.WriteAllLines(path, f.content)
    true

JetBrains.config binds
|> (+) (VsCode.config binds)
|> List.forall writeFile
