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

    type Key =
        | Enter
        | LeftSquareBracket
        | Letter of string
        | RightSquareBracket

    type MetaKeybind =
        { action: Action
          key: Key
          shift: bool }

    type ModalKeybind = { action: Action; key: Key }

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
              "PyCharm2022.3/jba_config/mac.keymaps"
              "Rider2022.3/jba_config/mac.keymaps"
              "WebStorm2022.3/jba_config/mac.keymaps" ]
        |> List.map Path.Combine
        |> List.map (fun p -> Path.Combine("Library", "Application Support", "JetBrains", p, "bruno-roque.xml"))
        |> List.map (fun p -> { name = p; content = content })

module NeoVim =
    let mapMeta (meta: MetaKeybind) =
        let action =
            match meta.action with
            | Actions -> ":Telescope commands<cr>"
            | CodeActions -> ":Telescope lsp_code_actions<cr>"
            | GoToBuffer -> ":Telescope buffers<cr>"
            | GoToFile -> ":lua require('telescope.builtin').find_files({hidden = true})<cr>"
            | GoToJump -> ":Telescope marks<cr>"
            | GoToSymbol -> ":Telescope treesitter<cr>"
            | GoToSymbolGlobal -> ":Telescope treesitter<cr>"
            | Navigate -> ":Explore<cr>"
            | ParameterInfo -> ":lua vim.lsp.buf.signature_help()<cr>"
            | SearchGlobal -> ":Telescope live_grep<cr>"
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

        $"  {{\n    \"key\": \"{bind}\",\n    \"command\": \"{action}\",\n{cond}  }},"

    let mapMeta (meta: MetaKeybind) =
        let action =
            match meta.action with
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
            |> (+) [ (keybind "bookmarks.toggle" "ctrl-s" (Some "editorFocus")) ]

        let content =
            [ "[" ] |> (+) mapped |> (+) [ "]" ]

        [ { name = Path.Combine("Library", "Application Support", "Code", "User", "keybindings.json")
            content = content } ]


let metas =
    [ (Actions, Letter("p"), false)
      (CodeActions, Enter, false)
      (GoToBuffer, Letter("b"), false)
      (GoToFile, Letter("o"), false)
      (GoToJump, Letter("j"), false)
      (GoToSymbol, Letter("y"), false)
      (GoToSymbolGlobal, Letter("y"), true)
      (Navigate, Letter("l"), false)
      (ParameterInfo, Letter("i"), false)
      (SearchGlobal, Letter("f"), true)
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
