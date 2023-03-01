open System
open System.IO

module Keybind =
    type Action =
        | Back
        | Forward
        | Actions
        | CodeActions
        | GoToBuffer
        | GoToFile
        | GoToJump
        | GoToSymbol
        | GoToSymbolGlobal
        | Navigate
        | ParameterInfo
        | Reformat
        | SearchGlobal
        | Terminal
        | Zen

    type ModKey = | Cmd

    type Key =
        | Enter
        | Letter of string

    type ModKeybind =
        { mo: ModKey
          key: Key
          shift: bool
          act: Action }

    type KeybindFile = { name: string; content: string list }

open Keybind

let (+) a b = List.append b a

module JetBrains =
    let keybind act bind =
        match bind with
        | Some b -> $"  <action id=\"{act}\">\n    <keyboard-shortcut first-keystroke=\"{b}\"/>\n  </action>"
        | _ -> $"  <action id=\"{act}\"/>"

    let mapMod (modKey: ModKeybind) =
        let act =
            match modKey.act with
            | Actions -> "GotoAction"
            | CodeActions -> "ShowIntentionActions"
            | GoToBuffer -> "RecentFiles"
            | GoToFile -> "GotoFile"
            | GoToJump -> "ShowBookmarks"
            | GoToSymbol -> "FileStructurePopup"
            | GoToSymbolGlobal -> "GotoSymbol"
            | Navigate -> "ShowNavBar"
            | ParameterInfo -> "ParameterInfo"
            | SearchGlobal -> "FindInPath"
            | Terminal -> "ActivateTerminalToolWindow"
            | Zen -> "HideAllWindows"
            | _ -> failwith ""

        let char =
            match modKey.key with
            | Enter -> "enter"
            | Letter l -> l

        let bind =
            match modKey.mo with
            | Cmd ->
                match modKey.shift with
                | true -> "shift meta"
                | _ -> "meta"
            |> fun s -> $"{s} {char}"

        keybind act (Some bind)

    let configMods mods =
        let mapped = List.map mapMod mods

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
            |> List.map (fun a -> keybind a None)

        let content =
            [ "<keymap version=\"1\" name=\"bruno-roque\" parent=\"macOS System Shortcuts\">" ]
            |> (+) mapped
            |> (+) disabled
            |> (+) [ "</keymap>" ]

        List.map
            (fun (p: string) -> p.Split "/")
            [ "DataGrip2022.3/keymaps"
              "GoLand2022.3/keymaps"
              "IntelliJIdea2022.3/keymaps"
              "PyCharm2022.3/jba_config/mac.keymaps"
              "Rider2022.3/keymaps"
              "WebStorm2022.3/jba_config/mac.keymaps" ]
        |> List.map Path.Combine
        |> List.map (fun p -> Path.Combine("Library", "Application Support", "JetBrains", p, "bruno-roque.xml"))
        |> List.map (fun p -> { name = p; content = content })

module VsCode =
    let keybind act bind cond =
        let cond =
            match cond with
            | Some c -> $"    \"when\": \"{c}\"\n"
            | _ -> ""

        $"  {{\n    \"key\": \"{bind}\",\n    \"command\": \"{act}\",\n{cond}  }},"

    let mapMeta (modKey: ModKeybind) =
        let act =
            match modKey.act with
            | Actions -> "workbench.action.showCommands"
            | CodeActions -> "editor.action.quickFix"
            | Back -> "workbench.action.navigateBack"
            | Forward -> "workbench.action.navigateForward"
            | GoToBuffer -> "workbench.action.quickOpen"
            | GoToFile -> "workbench.action.quickOpen"
            | GoToJump -> "bookmarks.listFromAllFiles"
            | GoToSymbol -> "workbench.action.gotoSymbol"
            | GoToSymbolGlobal -> "workbench.action.showAllSymbols"
            | Navigate -> "breadcrumbs.focusAndSelect"
            | ParameterInfo -> "editor.action.triggerParameterHints"
            | SearchGlobal -> "workbench.action.findInFiles"
            | Terminal -> "workbench.action.terminal.toggleTerminal"
            | Zen -> "workbench.action.toggleSidebarVisibility"
            | _ -> failwith ""

        let char =
            match modKey.key with
            | Enter -> "enter"
            | Letter l -> l

        let bind =
            match modKey.mo with
            | Cmd ->
                match modKey.shift with
                | true -> "cmd+shift"
                | _ -> "cmd"
            |> fun s -> $"{s}+{char}"

        keybind act bind None

    let configMods mods =
        let extras =
            [ (Cmd, Letter("["), false, Back); (Cmd, Letter("]"), false, Forward) ]
            |> List.map (fun (m, k, s, a) -> { mo = m; key = k; shift = s; act = a })

        let mapped =
            mods
            |> (+) extras
            |> List.map mapMeta
            |> (+) [ (keybind "editor.action.commentLine" "ctrl-c" (Some "editorFocus")) ]
            |> (+) [ (keybind "bookmarks.toggle" "ctrl-s" (Some "editorFocus")) ]
            |> (+) [ (keybind "workbench.action.focusActiveEditorGroup" "escape" (Some "!editorFocus")) ]

        let content = [ "[" ] |> (+) mapped |> (+) [ "]" ]

        [ { name = Path.Combine("Library", "Application Support", "Code", "User", "keybindings.json")
            content = content } ]


let mods =
    [ (Cmd, Enter, false, CodeActions)
      (Cmd, Letter("b"), false, GoToBuffer)
      (Cmd, Letter("f"), false, SearchGlobal)
      (Cmd, Letter("h"), true, Zen)
      (Cmd, Letter("i"), false, ParameterInfo)
      (Cmd, Letter("j"), false, GoToJump)
      (Cmd, Letter("l"), false, Navigate)
      (Cmd, Letter("o"), false, GoToFile)
      (Cmd, Letter("p"), false, Actions)
      (Cmd, Letter("t"), false, Terminal)
      (Cmd, Letter("y"), false, GoToSymbol)
      (Cmd, Letter("y"), true, GoToSymbolGlobal) ]
    |> List.map (fun (m, k, s, a) -> { mo = m; key = k; shift = s; act = a })

let writeFile f =
    let path =
        Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), f.name)

    printfn $"Writing: {path}"
    File.WriteAllLines(path, f.content)
    true

JetBrains.configMods mods
|> (+) (VsCode.configMods mods)
|> List.forall writeFile
