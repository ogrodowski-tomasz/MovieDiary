import SwiftUI
import Models

public struct DetailsView: View {
    let id: Int
    let listType: ListType
    public init(id: Int, listType: ListType) {
        self.id = id
        self.listType = listType
    }
    public var body: some View {
        Text("TUTAJ DETALE\n \(id)\n\(listType)")
    }
}

#Preview {
    DetailsView(id: 123141324123123, listType: .movies)
}
