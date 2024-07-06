import LinkNavigator
import SwiftUI


struct AddProductRouteBuilder: RouteBuilder {
    
  var matchPath: String { "addProduct" } // ✅

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
        return WrappingController(matchPath: matchPath) {
            AddProductPage(navigator: navigator)
      }
    }
  }
}


