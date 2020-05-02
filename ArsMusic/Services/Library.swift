//
//  Library.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/28/20.
//  Copyright © 2020 smu117. All rights reserved.
//

import SwiftUI
import URLImage


struct Library: View{
 
    @State var tracks = UserDefaults.standard.savedTracks()
    @State var showingAlert = false
    @State var number: Int?
    @State private var track: SearchViewModel.Cell!
    var tapBarDelegate: MainTabBarControllerDeledate?
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { gemoetry in
                    
                    HStack(spacing:20) {
                        Button(action: {
                            self.track = self.tracks.first
                            self.number = 1
                            self.tapBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: gemoetry.size.width / 2 - 25, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.993742764, green: 0.2345221937, blue: 0.5096193552, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9380424619, green: 0.9332326651, blue: 0.9417529702, alpha: 1)))
                                .cornerRadius(10)
                        })
                        Button(action: {
                            self.tracks = UserDefaults.standard.savedTracks()
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
                
                List {
                    ForEach(tracks) { track in
                        LibraryCell(cell:track).gesture(
                            LongPressGesture()
                                .onEnded{ _ in
                            self.showingAlert = true
                            self.track = track
                        }.simultaneously(with: TapGesture()
                            .onEnded{ _ in
                               // let kayWindow = UIApplication.shared.windows.last
                                let kayWindow = UIApplication.shared.connectedScenes.filter({
                                    $0.activationState == .foregroundActive
                                }).map({
                                    $0 as? UIWindowScene
                                }).compactMap({$0}).first?.windows.filter({
                                    $0.isKeyWindow
                                }).first
                                
                                let tapBarVC = kayWindow?.rootViewController as? MainTabBarController
                                tapBarVC?.trackDetailView.delagate = self
                            self.track = track
                                self.number = self.tracks.firstIndex(of: track)! + 1
                            self.tapBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                            
                        }))
                    }.onDelete(perform: deleteTrack)
                    
                }
            }.actionSheet(isPresented: $showingAlert, content: {
                ActionSheet(title:Text("Are you sure you want to delate track?"),
                            buttons: [.destructive(Text("Delete"), action: {
                                self.deleteTrack(track: self.track)
                            }),.cancel()
                ])
                })
                .navigationBarTitle("Library")
        }
        
    }
    
    func deleteTrack(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
    func deleteTrack(track: SearchViewModel.Cell) {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return }
        self.tracks.remove(at: myIndex)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
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

extension Library: TrackMoviesDelegate {
   
    
    func moveBackForPreviusTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        
        guard let myIndex = index else { return nil }
        
        var nextTrack: SearchViewModel.Cell
        if myIndex - 1 == -1  {
            nextTrack = tracks[tracks.count - 1]
            number = tracks.count
        }else {
            nextTrack = tracks[myIndex - 1]
            number! -= 1
        }
        self.track = nextTrack
        return nextTrack
    }
    
    func moveForwordForPreviusTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        
        var nextTrack: SearchViewModel.Cell
        if myIndex + 1 == tracks.count {
            number = 1
            nextTrack = tracks[0]
        }else {
            nextTrack = tracks[myIndex + 1]
            number! += 1
        }
        self.track = nextTrack
        return nextTrack
    }
    
    var numberOfTracks: Int? {
        return tracks.count
       }
       
       var numberOfTrack: Int? {
           return number
       }
       
    
}
