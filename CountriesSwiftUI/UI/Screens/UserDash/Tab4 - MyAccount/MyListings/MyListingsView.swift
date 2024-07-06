import LinkNavigator
import SwiftUI


struct UpperTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack {
            HStack {
                TabBarButton(title: "판매중", index: 0, selectedTab: $selectedTab)
                    .frame(maxWidth: .infinity)
                TabBarButton(title: "판매완료", index: 1, selectedTab: $selectedTab)
                    .frame(maxWidth: .infinity)
            }
            .padding()
            Rectangle() // Add a rectangle as the indicator bar
                .frame(width: UIScreen.main.bounds.width / 2, height: 2) // Set width to half the screen width
                .foregroundColor(Color.blue) // Color of the indicator bar
                .offset(x: UIScreen.main.bounds.width / 4 * CGFloat(selectedTab == 0 ? -1 : 1), y: 0) // Position the indicator based on selected tab
                .animation(.easeInOut, value: selectedTab) // Add animation
        }
    }
}

struct TabBarButton: View {
    let title: String
    let index: Int
    @Binding var selectedTab: Int
    
    var body: some View {
        Button(action: {
            self.selectedTab = self.index
        }) {
            Text(title)
                .foregroundColor(self.selectedTab == index ? .black : .gray)
                .padding()
        }
    }
}

struct MyListingsView: View {
    let navigator: LinkNavigatorType
    @State private var selectedTab = 0
    
    var body: some View {
        VStack{
            HStack(){
                Button(action: { navigator.back(isAnimated: true) }) {
                    Text("‹").font(.system(size: 35))
                }
                .padding()
                Spacer()
            }
            HStack(){
                Text("판매목록")
                    .font(.system(size: 25).weight(.bold))
                Spacer()
            }
            .padding(.horizontal, 20)
            UpperTabBar(selectedTab: $selectedTab)
            ZStack {
                ForSalesView(navigator: navigator)
                    .offset(x: selectedTab == 0 ? 0 : -UIScreen.main.bounds.width) // Slide to left if selected tab is 0
                
                SoldView(navigator: navigator)
                    .offset(x: selectedTab == 1 ? 0 : UIScreen.main.bounds.width) // Slide to right if selected tab is 1
            }
            .animation(.easeInOut, value: selectedTab)
        }
    }
}

