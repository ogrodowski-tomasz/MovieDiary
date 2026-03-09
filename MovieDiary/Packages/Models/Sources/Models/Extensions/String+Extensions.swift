import Foundation

extension String {
    
    var getYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        guard let date = dateFormatter.date(from: self) else { return self }
        return Calendar.current.component(.year, from: date).description
    }
}


