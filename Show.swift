//
//  Show.swift
//  Media Center
//
//  Created by Timothy Barnard on 06/12/2015.
//  Copyright © 2015 Timothy Barnard. All rights reserved.
//

import Foundation

class Show {
    
    var id:String?
    var name:String?
    var episode:String?
    var season:String?
    var avail:Int?
    
//    init(id:String,name: String, episode:String,season:String ,avail:Bool) {
//        self.id = id
//        self.name = name
//        self.season = season
//        self.episode = episode
//        self.avail = avail
//    }

    init() {
        
    }
    
    func getAvail()->Int {
        return self.avail!
    }
    func setAvail(avail: Int) {
        self.avail = avail
    }
    
    func getID()->String {
        return self.id!
    }
    
    func getName() ->String{
        return self.name!
    }
    
    func getSeason()->String {
        return self.season!
    }
    
    func getEpisde()->String {
        return self.episode!
    }
    
    func setID(id:String) {
        self.id = id
    }
    
    func setName(name:String) {
        self.name = name
    }
    
    func setSeason(season:String) {
        self.season = season
    }
    
    func setEpisode(episode:String) {
        self.episode = episode
    }
    
    
}