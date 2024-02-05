//
//  ShareSheetExtensionApp.swift
//  ShareSheetExtension
//
//  Created by Lam Hoang Tung on 1/29/24.
//

import SwiftUI

/*
 1. Đăng kí target share extension
 
 2. Chỉnh sửa file info.plist trong folder share theo link: https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionScenarios.html#//apple_ref/doc/uid/TP40014214-CH21-SW1:~:text=string%20like%20this%3A-,SUBQUERY%20(,).%40count%20%3D%3D%201,-Here%20is%20an
 
 SUBQUERY (
     extensionItems,
     $extensionItem,
     SUBQUERY (
         $extensionItem.attachments,
         $attachment,
         ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.image"
     ).@count == $extensionItem.attachments.@count
 ).@count == 1
 
 
 */

@main
struct ShareSheetExtensionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ImageItem.self)
    }
}
