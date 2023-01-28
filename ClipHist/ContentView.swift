//
//  ContentView.swift
//  ClipHist
//
//  Created by Jhamir Francisco Piminchumo on 21/12/21.
// 

import SwiftUI
import OnPasteboardChange

struct currentId {
    static var id : Int = -1
}

struct CopiedItem : Identifiable {
    let id : Int
    let value : String
    var selected : Bool = false
    let image : NSImage?
}

var itemClicked = false

struct ContentView: View {
    @State var copiedItems : [CopiedItem] = []
    @State var modTimes = 0
    
    var window = NSWindow (
            contentRect: NSRect(x: 0, y: 0, width: 250, height: 400), // just default
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false
        )
    
    var body: some View {
        VStack{
            List{
                Text("Clipboard History").font(.largeTitle)
                
                ForEach(copiedItems.reversed()) { ci in
                    Divider()
                    CopiedItemRow(copiedItem: ci)
                }
                .onPasteboardChange {
                    if(!itemClicked) {
                        print("The clipboard was changed!")
                        
                        let image = pasteboardImage();
                        
                        let latestItem = NSPasteboard.general.pasteboardItems?.first?.string(forType: .string)
                        
                        if(latestItem != nil) {
                            let newci : CopiedItem = .init(id: copiedItems.count, value: latestItem!, image: image)
                            copiedItems.append(newci)
                            currentId.id = newci.id
                        }
                    }
                    else {
                        modTimes += 1
                        if(modTimes >= 2) {
                            modTimes = 0
                            itemClicked = false
                        }
                    }
                }
            }
        }
        .frame(minWidth: 250, idealWidth: 250, minHeight: 400, idealHeight: 400)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CopiedItemRow : View {
    @State var copiedItem: CopiedItem
    @State private var selectedItem = false
    @State private var sameId : Bool = false
    
    var body: some View{
        Text(copiedItem.value)
            .frame(maxWidth: .infinity, maxHeight: 16*3, alignment: .leading)
            .padding()
            .contentShape(Rectangle())
            .onTapGesture{
                itemClicked = true
                selectedItem = true
                currentId.id = copiedItem.id
                //Copy Item value to NSPasteboard
                let pasteboard = NSPasteboard.general
                pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                pasteboard.setString(copiedItem.value, forType: NSPasteboard.PasteboardType.string)
            }
            .onPasteboardChange {
                sameId = copiedItem.id == currentId.id
            }
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(sameId ? Color.accentColor : Color.clear)
                
            )
        
        if(copiedItem.image != nil) {
            Image(nsImage: copiedItem.image!).padding()
        }
    }
}



//Pasteboard image
//Write to clipboard
func writeImageToPasteboard(img: NSImage)
{
    let pb = NSPasteboard.general
    pb.clearContents()
    pb.writeObjects([img])
}

//Read from clipboard
func pasteboardImage() -> NSImage?
{
    let pb = NSPasteboard.general
    var imgData = pb.data(forType: NSPasteboard.PasteboardType.tiff)
    
    if(imgData != nil) { return NSImage(data: imgData!) }
    
    imgData = pb.data(forType: NSPasteboard.PasteboardType.png);
    NSImage(pasteboard: NSPasteboard.general)
    
    if(imgData != nil) { return NSImage(data: imgData!) }
   
    return nil;
}
