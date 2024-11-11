import SwiftUI

struct StartTabView: View {
    @EnvironmentObject var myEvents: EventStore
    var body: some View {
        TabView{
            EventsListView()
                .tabItem {
                    Label("List", systemImage: "list.triangle")
                }
            EventsCalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                    
                }
        }
    }
}

struct StartTabView_Previews: PreviewProvider {
    static var previews: some View {
        StartTabView()
            .environmentObject(EventStore(preview: true))
    }
}

