//
//  MissionBlock.swift
//  Astro Launches
//
//  Created by rocketjeff on 4/1/22.
//

import SwiftUI

// Displays info common to LaunchRow and LaunchDetail
// Row 1: Mission name
// Row 2: optional rocket name and status, as tags
// Row 3: Launch Date and Time as icon and text
struct MissionBlock: View {
    
    var launch:Launch
    var showRocket:Bool
    var showStatus:Bool
    
    var body: some View {
        
        VStack {
            HStack{
                Text(launch.missionName).font(.title2).bold().foregroundColor(Color(uiColor:.label))
                Spacer()
            }
            HStack
            {
                if (showRocket)
                {
                    Tag(text: launch.rocketName)
                }
                if let status = launch.status, showStatus == true // make sure the launch has a status
                {
                    StatusTag(text: status,status: launch.astroStatus)
                }
                Spacer()
            }.padding(.bottom, 4)
            
            HStack{
                LaunchDate(launch: launch).padding(.trailing, 6)
                LaunchTime(launch: launch)
                Spacer()
            }
        }
        
    }
}


