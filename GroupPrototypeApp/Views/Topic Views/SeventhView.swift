//
//  SeventhView.swift
//  GroupPrototypeApp
//
//  Created by Haven F on 3/6/25.
//

import SwiftUI

struct SeventhView: View {
        
    @State private var text: String = "Once upon a time in a quiet village, there was a mysterious old library. Many said it held books that whispered secrets of the past and future to those who listened carefully. One day, a curious young scholar named Elara discovered a hidden passage behind a dusty shelf, leading to an unknown chamber..."
    @State private var isBold: Bool = false
    @State private var isItalic: Bool = false
    @State private var isUnderlined: Bool = false
    @State private var isProcessing: Bool = false
    @State private var selectedText: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { isBold.toggle() }) {
                    Image(systemName: "bold")
                        .font(.title)
                        .foregroundColor(isBold ? .blue : .primary)
                }
                
                Button(action: { isItalic.toggle() }) {
                    Image(systemName: "italic")
                        .font(.title)
                        .foregroundColor(isItalic ? .blue : .primary)
                }
                
                Button(action: { isUnderlined.toggle() }) {
                    Image(systemName: "underline")
                        .font(.title)
                        .foregroundColor(isUnderlined ? .blue : .primary)
                }
            }
            .padding()
            
            TextEditor(text: $text)
                .frame(height: 300)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .font(getFont())
                .contextMenu {
                    Button("Proofread", action: proofreadText)
                    Button("Rewrite", action: rewriteText)
                }
        }
        .padding()
    }
    
    func getFont() -> Font {
        var font: Font = .body
        if isBold && isItalic {
            font = .system(.body, design: .default).bold().italic()
        } else if isBold {
            font = .system(.body, design: .default).bold()
        } else if isItalic {
            font = .system(.body, design: .default).italic()
        }
        return font
    }
        
    func proofreadText() {
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            text = "[Proofread] " + text
            isProcessing = false
        }
    }
    
    func rewriteText() {
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            text = "[Rewritten] " + text
            isProcessing = false
        }
    }
}
