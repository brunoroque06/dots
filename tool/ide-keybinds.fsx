open System
open System.IO

module Keybind =
    type Action =
        | GoToAction
        | GoToBookmark
        | GoToFile
        | GoToFileRecent
        | GoToSymbol
        | GoToSymbolInFile
        | Navigate
        | Reformat
        | ShowActions
        | SplitHorizontally
        | SplitVertically
        | Terminal
        | Zen

    type Key =
        | Backslash
        | Enter
        | Letter of string

    let getLetter (Letter v) = v

    type MetaKeybind =
        { action: Action
          key: Key
          shift: bool }

    type VimKeybind = { action: Action; key: Key }

    type KeybindFile = { name: string; content: string list }

open Keybind

module Jetbrains =
    let convertMeta (meta: MetaKeybind) =
        let action =
            match meta.action with
            | GoToAction -> "GotoAction"
            | GoToBookmark -> "ShowBookmarks"
            | GoToFile -> "GotoFile"
            | GoToFileRecent -> "RecentFiles"
            | GoToSymbol -> "GotoSymbol"
            | GoToSymbolInFile -> "FileStructurePopup"
            | Navigate -> "ShowNavBar"
            | ShowActions -> "ShowIntentionActions"
            | SplitHorizontally -> "SplitHorizontally"
            | SplitVertically -> "SplitVertically"
            | Terminal -> "ActivateTerminalToolWindow"
            | Zen -> "HideAllWindows"
            | _ -> failwith "unsupported"

        let char =
            match meta.key with
            | Backslash -> "back_slash"
            | Enter -> "enter"
            | k -> getLetter k

        let bind =
            match meta.shift with
            | true -> "shift meta"
            | false -> "meta"
            |> fun s -> $"{s} {char}"

        $"  <action id=\"{action}\">\n    <keyboard-shortcut first-keystroke=\"{bind}\"/>\n  </action>"

    let configMetas metas =
        let converted = List.map convertMeta metas

        let content =
            [ "</keymap>" ]
            |> List.append (
                List.map
                    (fun a -> $"  <action id=\"{a}\"/>")
                    [ "GotoClass"
                      "QuickImplementations"
                      "org.intellij.plugins.markdown.ui.actions.styling.ToggleBoldAction"
                      "Vcs.UpdateProject" ]
            )
            |> List.append converted
            |> List.append [ "<keymap version=\"1\" name=\"bruno-roque\" parent=\"macOS System Shortcuts\">" ]

        List.map
            (fun p -> { name = p; content = content })
            (List.map
                (fun p -> Path.Combine("Library", "Application Support", "JetBrains", p, "bruno-roque.xml"))
                [ Path.Combine("DataGrip2021.3", "keymaps")
                  Path.Combine("PyCharm2021.3", "jba_config", "mac.keymaps")
                  Path.Combine("Rider2021.3", "jba_config", "mac.keymaps")
                  Path.Combine("WebStorm2021.3", "jba_config", "mac.keymaps") ])

let metas =
    [ (GoToAction, Letter("p"), false)
      (GoToBookmark, Letter("b"), false)
      (GoToFile, Letter("o"), false)
      (GoToFileRecent, Letter("e"), false)
      (GoToSymbol, Letter("y"), true)
      (GoToSymbolInFile, Letter("y"), false)
      (Navigate, Letter("l"), false)
      (ShowActions, Enter, false)
      (SplitHorizontally, Backslash, true)
      (SplitVertically, Backslash, false)
      (Terminal, Letter("t"), false)
      (Zen, Letter("h"), true) ]
    |> List.map (fun (a, k, s) -> { action = a; key = k; shift = s })

let writeFile f =
    let path =
        Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), f.name)

    printfn $"Writing: {path}"
    File.WriteAllLines(path, f.content)
    true

Jetbrains.configMetas metas
|> List.forall writeFile
