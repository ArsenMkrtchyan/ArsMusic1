//
//  Library.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/28/20.
//  Copyright © 2020 smu117. All rights reserved.
//

import SwiftUI
import URLImage
struct Library: View {
    var tracks = UserDefaults.standard.savedTracks()
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { gemoetry in
                    
                    HStack(spacing:20) {
                        Button(action: {
                            print("aas")
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: gemoetry.size.width / 2 - 25, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.993742764, green: 0.2345221937, blue: 0.5096193552, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9380424619, green: 0.9332326651, blue: 0.9417529702, alpha: 1)))
                                .cornerRadius(10)
                        })
                        Button(action: {
                            print("aas")
                        }, label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: gemoetry.size.width / 2 - 25, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.8900585771, green: 0.2170285881, blue: 0.4671475887, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.937254902, green: 0.9333333333, blue: 0.9411764706, alpha: 1)))
                                .cornerRadius(10)
                        })
                    }
                }.padding().frame(height: 50)
                Divider().padding(.leading).padding(.trailing)
                
                List(tracks) { track in
                    LibraryCell(cell:track)
                }
            }
            .navigationBarTitle("Library")
        }
        
    }
}

struct LibraryCell: View {
    var cell: SearchViewModel.Cell
    var body: some View {
        HStack {
            URLImage(URL(string: cell.iconUrlString ?? "")!).frame(width: 60, height: 60).cornerRadius(2)
            //resizable()
            VStack(alignment: .leading) {
                Text("\(cell.artistName)")
                Text("\(cell.trackName)")
            }
        }
    }
}



struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}

