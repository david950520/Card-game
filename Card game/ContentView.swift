import SwiftUI

// 1. 定義卡片的資料結構
struct Card: Identifiable, Equatable {
    let id = UUID()
    let content: String     // 卡片上的圖示 (Emoji)
    var isFaceUp = false    // 是否翻開
    var isMatched = false   // 是否已配對成功
}

struct ContentView: View {
    // 2. 宣告遊戲狀態與卡片資料
    @State private var cards: [Card] = [
        Card(content: "🐶"), Card(content: "🐶"),
        Card(content: "🐱"), Card(content: "🐱"),
        Card(content: "🦊"), Card(content: "🦊"),
        Card(content: "🐼"), Card(content: "🐼")
    ].shuffled()
    
    @State private var selectedIndex: Int? = nil // 記錄第一張被翻開的卡片索引
    @State private var isChecking = false        // 防止玩家在比對動畫期間亂點

    // 設定網格為 4 列
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            // 1. 放在最底層的背景圖片 (請把 "bgImage" 換成你在 Assets 裡實際的圖片名稱)
            Image("creative-hand-drawn-spring-landscape_23-2148845096")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea() // 讓圖片填滿整個螢幕
            
            // 2. 疊在上面的遊戲主要內容
            VStack(spacing: 25) {
                Text("🙈 翻牌對對碰 🙈")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.black) // 背景有圖時，文字改白色的比較清楚
                
                // 3. 網格佈局呈現卡片
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(cards.indices, id: \.self) { index in
                        CardView(card: cards[index])
                            .onTapGesture {
                                handleCardTap(at: index)
                            }
                    }
                }
                .padding()
                
                // 4. 重新開始按鈕
                Button(action: {
                    restartGame()
                }) {
                    Text("重新開始")
                        .font(.title3)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }

    // 點擊卡片的邏輯控制
    func handleCardTap(at index: Int) {
        guard !isChecking, !cards[index].isFaceUp, !cards[index].isMatched else { return }
        
        if let firstIndex = selectedIndex {
            cards[index].isFaceUp = true
            isChecking = true
            
            if cards[firstIndex].content == cards[index].content {
                cards[firstIndex].isMatched = true
                cards[index].isMatched = true
                selectedIndex = nil
                isChecking = false
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    cards[firstIndex].isFaceUp = false
                    cards[index].isFaceUp = false
                    selectedIndex = nil
                    isChecking = false
                }
            }
        } else {
            selectedIndex = index
            cards[index].isFaceUp = true
        }
    }

    // 重新洗牌重置遊戲
    func restartGame() {
        cards = [
            Card(content: "🐶"), Card(content: "🐶"),
            Card(content: "🐱"), Card(content: "🐱"),
            Card(content: "🦊"), Card(content: "🦊"),
            Card(content: "🐼"), Card(content: "🐼")
        ].shuffled()
        selectedIndex = nil
        isChecking = false
    }
}

// 單張卡片的長相外觀
struct CardView: View {
    let card: Card
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(card.isFaceUp || card.isMatched ? 0.8 : 0.3))
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.6), lineWidth: 2)
            
            if card.isFaceUp || card.isMatched {
                Text(card.content)
                    .font(.system(size: 45))
            } else {
                Text("❓")
                    .font(.system(size: 35))
            }
        }
        .frame(height: 100)
    }
}
#Preview {
    ContentView()
}
