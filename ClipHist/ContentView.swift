//
//  ContentView.swift
//  ClipHist
//
//  Created by Jhamir Francisco Piminchumo on 21/12/21.
// 

import SwiftUI

struct ContentView: View {
    @StateObject var model = ClipHistModel()
    
    var body: some View {
        VStack{
            Text("Clipboard History")
                .textSelection(.enabled)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class ClipHistModel : ObservableObject {
    init() {
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) {(event) in
            guard let characters =  event.characters else {return}
            print(characters)
        }
    }
}
