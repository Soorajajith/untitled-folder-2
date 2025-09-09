import SwiftUI
import CoreLocation

struct Person {
    let name: String
    let location: CLLocation
    let musicPreference: String
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    // Hardcoded user location (San Francisco, CA)
    private let hardcodedUserLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // Updated longitude to match San Francisco
    
    @Published var userLocation: CLLocation?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        // Assign the hardcoded location directly to userLocation
        self.userLocation = hardcodedUserLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Use this method if you need to handle real location updates
        if let location = locations.last {
            self.userLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            LocalArtistsView()
                .navigationBarTitle("DJ Fixer")
        }
    }
}

struct LocalArtistsView: View {
    @State private var showOptions = false
    
    var body: some View {
        NavigationView {
            VStack {
                if !showOptions {
                    Button(action: {
                        self.showOptions = true
                    }) {
                        Text("Find Local Artists")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding()
                    
                    NavigationLink(destination: FeedView()) {
                        Text("Feed")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding()
                } else {
                    NavigationLink(destination: SearchView(title: "Nearby DJs", people: nearbyDJs)) {
                        Text("Nearby DJs")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding()
                    
                    NavigationLink(destination: SearchView(title: "Nearby Mixing Masters", people: mixingMasters)) {
                        Text("Nearby Mixing Masters")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding()
                }
            }
            .navigationBarItems(trailing:
                Button(action: {
                    self.showOptions = false
                }) {
                    Text("Back")
                }
            )
        }
    }
}

struct SearchView: View {
    let title: String
    let people: [Person]
    
    @ObservedObject private var locationManager = LocationManager()
    
    var body: some View {
        ResultsView(people: people, title: title)
    }
}

struct ResultsView: View {
    let people: [Person]
    let title: String
    
    @ObservedObject private var locationManager = LocationManager()
    
    var body: some View {
        List(people, id: \.name) { person in
            NavigationLink(destination: DJDetailsView(person: person)) {
                VStack(alignment: .leading) {
                    Text("Name: \(person.name)")
                    Text("Music Preference: \(person.musicPreference)")
                    if let userLocation = locationManager.userLocation {
                        let distance = userLocation.distance(from: person.location)
                        Text(String(format: "Distance: %.2f meters", distance))
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle(title)
    }
}

struct DJDetailsView: View {
    let person: Person
    
    var body: some View {
        VStack {
            Text("Details for \(person.name)")
                .font(.title)
                .padding()
            
            NavigationLink(destination: PersonalPage()) {
                Text("Upcoming Events")
                    .font(.title)
                    .padding()
            }
            
            NavigationLink(destination: ContactPage()) {
                Text("Contact")
                    .font(.title)
                    .padding()
            }
            
            Spacer()
        }
        .navigationBarTitle("DJ Details", displayMode: .inline)
    }
}

struct PersonalPage: View {
    var body: some View {
        Text("Upcoming Events")
            .font(.title)
            .padding()
    }
}

struct ContactPage: View {
    var body: some View {
        Text("Contact")
            .font(.title)
            .padding()
    }
}

struct FeedView: View {
    var body: some View {
        Text("Feed")
            .font(.title)
            .padding()
    }
}

let nearbyDJs = [
    Person(name: "John", location: CLLocation(latitude: 37.7749, longitude: -122.4194), musicPreference: "Techno House"),
    Person(name: "Emma", location: CLLocation(latitude: 40.7128, longitude: -74.0060), musicPreference: "Dubstep"),
    Person(name: "Alex", location: CLLocation(latitude: 34.0522, longitude: -118.2437), musicPreference: "Indie"),
    Person(name: "DJ Luvz", location: CLLocation(latitude: 34.0522, longitude: -118.2437), musicPreference: "Electronic")
    // Add more DJs with their respective locations and music preferences here
]

let mixingMasters = [
    Person(name: "Max", location: CLLocation(latitude: 37.7749, longitude: -122.4194), musicPreference: "House"),
    Person(name: "Sophia", location: CLLocation(latitude: 40.7128, longitude: -74.0060), musicPreference: "Techno"),
    Person(name: "Leo", location: CLLocation(latitude: 34.0522, longitude: -118.2437), musicPreference: "Deep House"),
    Person(name: "Mia", location: CLLocation(latitude: 34.0522, longitude: -118.2437), musicPreference: "Trance")
    // Add more mixing masters with their respective locations and music preferences here
]

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
