import CoreEnvironment
import SwiftUI

public struct CastListView: View {
    
    let cast: [CastCrewModel]
    
    public init(cast: [CastCrewModel]) {
        self.cast = cast
    }
    
    public var body: some View {
        List(cast) { person in
            Text(person.name)
        }
        .navigationTitle("Cast")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    CastListView()
//}
