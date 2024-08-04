//
//  Examples.swift
//  HotProspects
//
//  Created by Marcus Benoit on 04.08.24.
//

import SwiftUI
import UserNotifications

struct Notifications: View {
    let users = ["Tohru", "Yuki", "Kyo", "Momiji"]
    
    @State private var selection = Set<String>()
    
    @State private var selectedTab = "One"
    
    @State private var output = ""
    
    @State private var backgroundColor = Color.red
    
    var body: some View {
        NavigationStack{
            VStack {
                Text("Hello world!")
                    .padding()
                    .background(backgroundColor)
                
                Text("Change color")
                    .padding()
                    .contextMenu {
                        Button("Red", systemImage: "checkmark.circle.fill", role: .destructive) {
                            backgroundColor = .red
                        }
                        
                        Button("Green") {
                            backgroundColor = .green
                        }
                        
                        Button("Blue") {
                            backgroundColor = .blue
                        }
                    }
            }
            
            
            Image("example")
                .interpolation(.none) // shows pixel without any "optimization"
                .resizable()
                .scaledToFit()
                .background(.black)
            
            Text(output)
                .task {
                    await fetchReadings()
                }
            
            List(users, id: \.self, selection: $selection) { user in
                Text(user)
            }
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
            }
            
            if selection.isEmpty == false {
                Text("You've selected \(selection.formatted())")
            }
        }
        
        List {
            Text("Taylor Swift")
                .swipeActions {
                    Button("Delete", systemImage: "minus.circle", role: .destructive) {
                        print("Deleting")
                    }
                }
            
                .swipeActions(edge: .leading) {
                    Button("Pin", systemImage: "pin") {
                        print("Pinning")
                    }
                    .tint(.orange)
                }
        }
        
        VStack {
            Button("Request permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
            
            Button("Schedule notifications") {
                let content = UNMutableNotificationContent()
                content.title = "feed the dog"
                content.subtitle = "he looks very hungry!"
                content.sound = UNNotificationSound.default
                
                // show this notification 5 seconds from now
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                // add our notification request
                UNUserNotificationCenter.current().add(request)
            }
        }
        
        TabView(selection: $selectedTab) {
            Button("Show Tab 2") {
                selectedTab = "Two"
            }
            .tabItem {
                Label("One", systemImage: "star")
            }
            .tag("One")
            
            Text("Tab 2")
                .tabItem {
                    Label("Two", systemImage: "circle")
                }
                .tag("Two")
        }
    }
    
    func fetchReadings() async {
        let fetchTask = Task {
            let url = URL(string: "https://www.hws.dev/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            output = "Found \(readings.count) readings."
        }
        
        // CODE doesn't work!
        
        //    let result = await fetchTask.result
        //
        //            switch result {
        //                case .success(let str):
        //                    output = str
        //                case .failure(let error):
        //                    output = "Error: \(error.localizedDescription)"
        //            case:
        //                output = "we fucked up"
        //            }
    }
}


#Preview {
    Notifications()
}
