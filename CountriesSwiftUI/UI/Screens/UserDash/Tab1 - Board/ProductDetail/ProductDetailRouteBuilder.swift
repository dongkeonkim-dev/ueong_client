
import LinkNavigator
import SwiftUI


struct ProductDetailRouteBuilder: RouteBuilder {
    
  var matchPath: String { "productDetail" } // ✅
  
  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
        return WrappingController(matchPath: matchPath) {
            ProductDetailPage(navigator: navigator) // ✅
      }
    }
  }
}


