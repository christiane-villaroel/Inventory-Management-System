import Foundation

struct Event: Identifiable {
    enum EventType: String, Identifiable, CaseIterable {
        case pants, shirts, shoes, dresses, suits, unspecified
        var id: String {
            self.rawValue
        }
        
        var icon: String {
            switch self {
            case .pants:
                return "👖"
            case .shirts:
                return "👕"
            case .shoes:
                return "👟"
            case .dresses:
                return "👗"
            case .suits:
                return "👔"
            case .unspecified:
                return "*"
            }
        }
    }
    
    var eventType: EventType
    var date: Date
    var note: String
    var id: String
    
    var dateComponents: DateComponents {
        var dateComponents = Calendar.current.dateComponents(
            [.month,
             .day,
             .year,
             .hour,
             .minute],
            from: date)
        dateComponents.timeZone = TimeZone.current
        dateComponents.calendar = Calendar(identifier: .gregorian)
        return dateComponents
    }
    
    init(id: String = UUID().uuidString, eventType: EventType = .unspecified, date: Date, note: String) {
        self.eventType = eventType
        self.date = date
        self.note = note
        self.id = id
    }
    
    static var sampleEvents: [Event] {
         return [
             Event(eventType: .pants, date: Date().diff(numDays: 0), note: "Restock Jean Pants"),
             Event(date: Date().diff(numDays: -1), note: "Inventory Check"),
             Event(eventType: .shirts, date: Date().diff(numDays: 6), note: "Restock T-Shirts"),
             Event(eventType: .suits, date: Date().diff(numDays: 2), note: "Restock Suits"),
             Event(eventType: .dresses, date: Date().diff(numDays: -1), note: "Restock Dresses"),
             Event(eventType: .shoes, date: Date().diff(numDays: -3), note: "Restock Shoes"),
             Event(date: Date().diff(numDays: -4), note: "Inventory Check")
         ]
     }
}
