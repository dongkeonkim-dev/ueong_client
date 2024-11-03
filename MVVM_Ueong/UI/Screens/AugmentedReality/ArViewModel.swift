

import Foundation

extension ArView {
    class ViewModel: ObservableObject {
        @Published var url: String
        
        init(url: String) {
            self.url = url
        }
        
        
    }
}
