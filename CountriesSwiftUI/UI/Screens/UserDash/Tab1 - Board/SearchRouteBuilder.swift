import LinkNavigator
import SwiftUI


struct SearchRouteBuilder: RouteBuilder {
    
  var matchPath: String { "search" } // ✅

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
        return WrappingController(matchPath: matchPath) {
            SearchPage(navigator: navigator) // ✅
      }
    }
  }
}

