//
//  MultiSelector.swift
//  AppLogoResizer
//
//  Created by Lukas Krinke on 30.09.21.
//

import SwiftUI

struct MultiSelectionView<Selectable: Identifiable & Hashable>: View {
    @Binding var options: [Selectable]
    let optionToString: (Selectable) -> String
    
    @Binding var selected: Set<Selectable>
    var body: some View {
        VStack{
        Form{
            Section{
                Button(selected.count != options.count ? "Select all" : "Remove all"){
                    if selected.count != options.count{
                        selected = Set(options)
                    }else{
                        selected = []
                    }
                }
            }
            Section(header: Text("Sizes")){
                ForEach(options) { selectable in
                    Button(action: { toggleSelection(selectable: selectable) }) {
                        HStack {
                            Text(optionToString(selectable))
                                .foregroundColor(Color(UIColor.label))
                            Spacer()
                            if selected.contains { $0.id == selectable.id } {
                                Image(systemName: "checkmark").foregroundColor(.accentColor)
                            }
                        }
                    }.tag(selectable.id)
                }
            }
        }
        }
    }

    private func toggleSelection(selectable: Selectable) {
        if let existingIndex = selected.firstIndex(where: { $0.id == selectable.id }) {
            selected.remove(at: existingIndex)
        } else {
            selected.insert(selectable)
        }
    }
}
