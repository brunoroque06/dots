open System
open System.IO

module Keybind =
    type Action =
        | Back
        | Forward
        | GoToAction
        | GoToBookmark
        | GoToFile
        | GoToFileRecent
        | GoToSymbol
        | GoToSymbolInFile
        | Navigate
        | Reformat
        | Search
        | ShowActions
        | SplitHorizontally
        | SplitVertically
        | Terminal
        | Zen

    type Key =
        | Enter
        | LeftSquareBracket
        | Letter of string
        | RightSquareBracket

    type MetaKeybind =
        { action: Action
          key: Key
          shift: bool }

    type VimKeybind = { action: Action; key: Key }

    type KeybindFile = { name: string; content: string list }

open Keybind

let (+) a b = List.append b a

module JetBrains =
    let keybind action bind =
        match bind with
        | Some b -> $"  <action id=\"{action}\">\n    <keyboard-shortcut first-keystroke=\"{b}\"/>\n  </action>"
        | _ -> $"  <action id=\"{action}\"/>"

    let mapMeta (meta: MetaKeybind) =
        let action =
            match meta.action with
            | GoToAction -> "GotoAction"
            | GoToBookmark -> "ShowBookmarks"
            | GoToFile -> "GotoFile"
            | GoToFileRecent -> "RecentFiles"
            | GoToSymbol -> "GotoSymbol"
            | GoToSymbolInFile -> "FileStructurePopup"
            | Navigate -> "ShowNavBar"
            | Search -> "FindInPath"
            | ShowActions -> "ShowIntentionActions"
            | SplitHorizontally -> "SplitHorizontally"
            | SplitVertically -> "SplitVertically"
            | Terminal -> "ActivateTerminalToolWindow"
            | Zen -> "HideAllWindows"
            | _ -> failwith ""

        let char =
            match meta.key with
            | Enter -> "enter"
            | Letter l -> l
            | _ -> failwith ""

        let bind =
            match meta.shift with
            | false -> "meta"
            | _ -> "shift meta"
            |> fun s -> $"{s} {char}"

        keybind action (Some bind)

    let configMetas metas =
        let mapped = List.map mapMeta metas

        let disabled =
            [ "CompareTwoFiles"
              "EditorDuplicate"
              "FindNext"
              "GotoClass"
              "QuickImplementations"
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
            [ "DataGrip2021.3/keymaps"
              "PyCharm2021.3/jba_config/mac.keymaps"
              "Rider2021.3/jba_config/mac.keymaps"
              "WebStorm2021.3/jba_config/mac.keymaps" ]
        |> List.map Path.Combine
        |> List.map (fun p -> Path.Combine("Library", "Application Support", "JetBrains", p, "bruno-roque.xml"))
        |> List.map (fun p -> { name = p; content = content })

module NeoVim =
    let mapMeta (meta: MetaKeybind) =
        let action =
            match meta.action with
            | GoToAction -> ":Telescope commands<cr>"
            | GoToBookmark -> ":Telescope marks<cr>"
            | GoToFile -> ":lua require('telescope.builtin').find_files({hidden = true})<cr>"
            | GoToFileRecent -> ":Telescope buffers<cr>"
            | GoToSymbol -> ":Telescope lsp_references<cr>"
            | GoToSymbolInFile -> ":Telescope lsp_references<cr>"
            | Navigate -> ":Explore<cr>"
            | Search -> ":Telescope live_grep<cr>"
            | ShowActions -> ":Telescope lsp_code_actions<cr>"
            | SplitHorizontally -> ":vsplit<cr>"
            | SplitVertically -> ":split<cr>"
            | Terminal -> ":terminal<cr>"
            | Zen -> ":only"
            | _ -> failwith ""

        let bind =
            match meta.key with
            | Enter -> "<enter>"
            | Letter l ->
                match meta.shift with
                | false -> l
                | _ -> $"<S-{l}>"
            | _ -> failwith ""
            |> fun c -> $"<leader>{c}"

        $"vim.keymap.set(\"n\", \"{bind}\", \"{action}\")"

    let configMetas metas =
        let mapped = List.map mapMeta metas

        [ { name = Path.Combine(".config", "nvim", "keybinds.lua")
            content = mapped } ]

module VsCode =
    let keybind action bind condition =
        let cond =
            match condition with
            | Some c -> $"    \"when\": \"{c}\"\n"
            | _ -> ""

        $"  {{\n    \"key\": \"{bind}\",\n    \"command\": \"{action}\"\n{cond}  }},"

    let mapMeta (meta: MetaKeybind) =
        let action =
            match meta.action with
            | Back -> "workbench.action.navigateBack"
            | Forward -> "workbench.action.navigateForward"
            | GoToAction -> "workbench.action.showCommands"
            | GoToBookmark -> "bookmarks.listFromAllFiles"
            | GoToFile -> "workbench.action.quickOpen"
            | GoToFileRecent -> "workbench.action.quickOpen"
            | GoToSymbol -> "workbench.action.showAllSymbols"
            | GoToSymbolInFile -> "workbench.action.gotoSymbol"
            | Navigate -> "breadcrumbs.focusAndSelect"
            | Search -> "workbench.action.findInFiles"
            | ShowActions -> "editor.action.quickFix"
            | SplitHorizontally -> "workbench.action.splitEditorOrthogonal"
            | SplitVertically -> "workbench.action.splitEditor"
            | Terminal -> "workbench.action.terminal.toggleTerminal"
            | Zen -> "workbench.action.toggleSidebarVisibility"
            | _ -> failwith ""

        let char =
            match meta.key with
            | Enter -> "enter"
            | LeftSquareBracket -> "["
            | Letter l -> l
            | RightSquareBracket -> "]"

        let bind =
            match meta.shift with
            | false -> "cmd"
            | _ -> "cmd+shift"
            |> fun s -> $"{s}+{char}"

        keybind action bind None

    let configMetas metas =
        let extras =
            [ (Back, LeftSquareBracket, false)
              (Forward, RightSquareBracket, false) ]
            |> List.map (fun (a, k, s) -> { action = a; key = k; shift = s })

        let mapped =
            metas
            |> (+) extras
            |> List.map mapMeta
            |> (+) [ (keybind "workbench.action.focusActiveEditorGroup" "escape" (Some "!editorFocus")) ]

        let content = [ "[" ] |> (+) mapped |> (+) [ "]" ]

        [ { name = Path.Combine("Library", "Application Support", "Code", "User", "keybindings.json")
            content = content } ]


let metas =
    [ (GoToAction, Letter("p"), false)
      (GoToBookmark, Letter("b"), false)
      (GoToFile, Letter("o"), false)
      (GoToFileRecent, Letter("e"), false)
      (GoToSymbol, Letter("y"), true)
      (GoToSymbolInFile, Letter("y"), false)
      (Navigate, Letter("l"), false)
      (Search, Letter("g"), false)
      (ShowActions, Enter, false)
      (SplitHorizontally, Letter("d"), true)
      (SplitVertically, Letter("d"), false)
      (Terminal, Letter("t"), false)
      (Zen, Letter("h"), true) ]
    |> List.map (fun (a, k, s) -> { action = a; key = k; shift = s })

let writeFile f =
    let path =
        Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), f.name)

    printfn $"Writing: {path}"
    File.WriteAllLines(path, f.content)
    true

JetBrains.configMetas metas
|> (+) (NeoVim.configMetas metas)
|> (+) (VsCode.configMetas metas)
|> List.forall writeFile
