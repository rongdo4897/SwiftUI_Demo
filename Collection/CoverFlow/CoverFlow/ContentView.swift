//
//  ContentView.swift
//  CoverFlow
//
//  Created by Lam Hoang Tung on 1/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var items: [CoverFlowItem] = [.red, .blue, .green, .yellow, .primary].compactMap{ .init(color: $0) }
    
    // MARK: View Properties
    @State private var spacing: CGFloat = 0
    @State private var rotation: Double = .zero
    @State private var enableReflection: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer(minLength: 0)
                
                CoverFlowView(
                    itemWidth: 280,
                    spacing: spacing,
                    rotation: rotation,
                    enableReflection: enableReflection,
                    items: items
                ) { item in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(item.color.gradient)
                        .frame(height: 180)
                }
                
                Spacer(minLength: 0)
                
                // Custom View
                VStack(alignment: .leading, spacing: 10) {
                    Toggle("Toggle Reflection", isOn: $enableReflection)
                    
                    Text("Card Spacing")
                        .font(.caption2)
                        .foregroundStyle(.white)
                    
                    Slider(value: $spacing, in: -120...20)
                    
                    Text("Card Rotation")
                        .font(.caption2)
                        .foregroundStyle(.white)
                    
                    Slider(value: $rotation, in: 0...180)
                }
                .padding(15)
                .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                .padding(15)
            }
            .navigationTitle("CoverFlow")
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
