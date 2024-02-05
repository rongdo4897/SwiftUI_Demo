//
//  ShareViewController.swift
//  Share
//
//  Created by Lam Hoang Tung on 2/5/24.
//

import UIKit
import Social
import SwiftUI
import SwiftData

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Vô hiệu hóa loại bỏ tương tác
        isModalInPresentation = true
        
        /*
         Trong Swift, extensionContext thường được sử dụng trong ngữ cảnh của các ứng dụng iOS để tương tác với các extension. Đây là một phần của framework NSExtensionContext.

         Nếu làm việc với các ứng dụng có extension (ví dụ: Share Extension, Today Extension), extensionContext thường được sử dụng để chia sẻ dữ liệu giữa ứng dụng chính và extension.
         */
        
        if let itemProviders = (extensionContext?.inputItems.first as? NSExtensionItem)?.attachments {
            let hostingView = UIHostingController(rootView: ShareView(extensionContext: extensionContext, itemProviders: itemProviders))
            hostingView.view.frame = view.frame
            view.addSubview(hostingView.view)
        }
    }
}

fileprivate struct ShareView: View {
    var extensionContext: NSExtensionContext?
    var itemProviders: [NSItemProvider]
    
    @State private var items: [Item] = []
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 15) {
                Text("Add to Favourites")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .tint(.red)
                    }
                    .padding(.bottom, 10)
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(items) { item in
                            Image(uiImage: item.previewImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: size.width - 30)
                        }
                    }
                    .padding(.horizontal, 15)
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .frame(height: 300)
                .scrollIndicators(.hidden)
                
                // Save button
                Button(action: saveItems, label: {
                    Text("Save")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(.blue, in: .rect(cornerRadius: 10))
                        .contentShape(.rect)
                })
                
                Spacer(minLength: 0)
            }
            .padding(15)
            .onAppear {
                extractItems(size: size)
            }
        }
    }
    
    // Dismiss View
    func dismiss() {
        extensionContext?.completeRequest(returningItems: [])
    }
    
    // Trích xuất dữ liệu hình ảnh và tạo hình ảnh xem trước hình thu nhỏ
    func extractItems(size: CGSize) {
        guard items.isEmpty else {return}
        DispatchQueue.global(qos: .userInteractive).async {
            for provider in itemProviders {
                let _ = provider.loadDataRepresentation(for: .image) { data, error in
                    if let data, let image = UIImage(data: data), let thumbnail = image.preparingThumbnail(of: .init(width: size.width, height: 300)) {
                        // UI must br update on main thread
                        DispatchQueue.main.async {
                            items.append(.init(imageData: data, previewImage: thumbnail))
                        }
                    }
                }
            }
        }
    }
    
    // Lưu dữ liệu vào SwiftData
    func saveItems() {
        do {
            let context = try ModelContext(.init(for: ImageItem.self))
            for item in items {
                context.insert(ImageItem(data: item.imageData))
            }
            
            try context.save()
            
            dismiss()
        } catch {
            print(error.localizedDescription)
            dismiss()
        }
    }
}

extension ShareView {
    private struct Item: Identifiable {
        let id: UUID = .init()
        var imageData: Data
        var previewImage: UIImage
    }
}
