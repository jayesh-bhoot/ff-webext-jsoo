open Js_of_ocaml
open Js

type font_source = 
    | Document
    | Browser

module Domains = Set.Make(String)

type app_state = {
    default_fonts: font_source;
    browser_fonts: Domains.t;
    document_fonts: Domains.t;
    current_tab_url: string;
}

let app = {
    default_fonts = Document;
    browser_fonts = Domains.empty;
    document_fonts = Domains.empty;
    current_tab_url = "";
}

let browser = Unsafe.global##.browser

let curr_val_query =
    object%js
    end

let use_document_fonts =
    object%js
        val value = Js._true
    end

let dont_use_document_fonts =
    object%js
        val value = Js._false
    end

let current_tab_query =
    object%js
        val currentWindow = Js._true
        val active = Js._true
    end

let handler () =
    let open Promise.Syntax in
    let* query_result = browser##.tabs##query current_tab_query in
    let current_tab = Js.Optdef.to_option (Js.array_get query_result 0) in
    let url = match current_tab with
        | None -> "empty"
        | Some tab -> tab##.url in
    let () = Firebug.console##log url in
    let useDocumentFonts = browser##.browserSettings##.useDocumentFonts in
    let* current_value = useDocumentFonts##get curr_val_query in
    let new_value = if current_value##.value = Js._true then dont_use_document_fonts else use_document_fonts in
    let* result = useDocumentFonts##set new_value in
    Promise.resolve result

let () =
    let onClicked = browser##.browserAction##.onClicked in
        onClicked##addListener handler