import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    let name: String
    let startTime: Date
    let endTime: Date
    let color: Color
}


struct TimeAxisView: View {
    let screenWidth = UIScreen.main.bounds.width
    let hourHeight: CGFloat = 75
    
    var body: some View {
        VStack(spacing: 0) {
            
            ForEach(0..<25) { hour in
                HStack(alignment: .center) {
                    Text("\(hour):00")
                        .frame(width: 46, height: hourHeight, alignment: .trailing) // 固定寬度，右對齊
                    VStack {
                        Divider()
                    }
                }
            }
            
            Spacer()
            
        }
        .frame(height: 25 * hourHeight, alignment: .top)
    }
}


struct TimeTableView: View {
    let totalMinutesInDay: CGFloat = 24 * 60
    let day: Int
    let DayTableWidth: CGFloat
    let hourHeight: CGFloat = 75
    @EnvironmentObject private var viewModel: ScheduleViewModel
    @StateObject var classItemsWrapper: ClassItemsWrapper = ClassItemsWrapper()
    @Binding private var scrollViewContentSize: CGSize
    
    private var TimeTable24HoursHeight: CGFloat {
            scrollViewContentSize.height - CGFloat(75) // CGFloat(75)為頂部+底部空白
    }
    
    init(day: Int, DayTableWidth: CGFloat, scrollViewContentSize: Binding<CGSize>) {
        self.day = day
        self.DayTableWidth = DayTableWidth
        self._scrollViewContentSize = scrollViewContentSize
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(Array(classItemsWrapper.classItems), id: \.key) { id, item in
                let startMinutes = minutesSinceMidnight(for: item.begin)
                let endMinutes = minutesSinceMidnight(for: item.end)
                let classDuration = endMinutes - startMinutes
                
                NavigationLink(
                    destination: ClassItemView(classId: id, day: day, item: item)
                ) {
                    VStack {
                        Text("\(item.className)")
                            .foregroundStyle(.black)
                    }
                    .frame(height: (classDuration / totalMinutesInDay) * TimeTable24HoursHeight)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(item.classColor.opacity(0.55))
                    )
                }
                .offset(y: ( ((startMinutes / totalMinutesInDay) * TimeTable24HoursHeight) + CGFloat(75 / 2) ) ) // +(75/2)是因爲原本初始頂部距離0點線(75/2)，因此+(75/2)把初始頂部移到0點線
                .onAppear {
                    //TimeTable24HoursHeight = $scrollViewContentSize.wrappedValue.height - CGFloat(50)
                    print("amomsoasmamsoamsomasoamsomaosmas")
                    print(TimeTable24HoursHeight)
                    print("offset:\( ( (startMinutes / totalMinutesInDay) * TimeTable24HoursHeight ) + CGFloat(75 / 2) )")
                }
            }
        }
        .frame(height: 25 * hourHeight, alignment: .top)
        .onAppear {
            classItemsWrapper.classItems = viewModel.weekSchedule!.dailySchedules[day-1].classItemsWrapper.classItems
        }
    }
    


    func minutesSinceMidnight(for date: Date) -> CGFloat {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        print("hour:\(hour)")
        print("minute:\(minute)")
        return CGFloat(hour * 60 + minute)
    }
}




struct ClassTimetableView: View {
    let screenWidth = UIScreen.main.bounds.width
    //let screenHeight = U
    let TimetableContentsMargin: CGFloat = 12
    let ClassHstackLeaddingPadding: CGFloat = 60
    let DayTableWidth: CGFloat
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    @State private var pageSize: CGSize = .zero
    @State private var scrollViewContentSize: CGSize = .zero
    @State private var scrollOffset: CGPoint = .zero
    
    init() {
        DayTableWidth = (screenWidth - TimetableContentsMargin - ClassHstackLeaddingPadding) / 5
    }
    
    var body: some View {
        NavigationStack {
            
            GeometryReader { Geometry in
                ZStack(alignment: .topLeading) {
                    // TimeAxisView 跟隨ScrollView垂直滾動
                    TimeAxisView()
                        .clipped()
                        .readIntrinsicContentSize(to: $scrollViewContentSize)
                        .offset(y: scrollOffset.y)
                    
                    
                    VStack {
                        ScrollView([.horizontal, .vertical], showsIndicators: false) {
                            VStack(spacing: 0) {
                                //使用 GeometryReader 來追蹤滾動偏移量
                                GeometryReader { scrollViewGeometry in
                                    Color.black
                                        .onChange(of: scrollViewGeometry.frame(in: .named("scroll")).origin) { newValue in
                                            self.scrollOffset = newValue
                                        }
                                }
                                .frame(maxHeight: 0)
                                
                                HStack(alignment: .top, spacing: 0) {
                                    ForEach(1..<8) { day in
                                        TimeTableView(day: day, DayTableWidth: DayTableWidth, scrollViewContentSize: $scrollViewContentSize)
                                            .frame(width: DayTableWidth)
                                    }
                                }
                            }
                        }
                        .frame(width: DayTableWidth * 5, height: pageSize.height)
                        .coordinateSpace(name: "scroll")
                        .clipped()
                        .onAppear {
                            self.pageSize = Geometry.size
                            print("page:\(pageSize.height)")
                        }
                    }
                    .padding(.leading, ClassHstackLeaddingPadding)
                    
                    
                    VStack {
                        // 頂端星期幾顯示
                        HStack(spacing: 0) {
                            ForEach(1..<8) { day in
                                VStack {
                                    Text("星期\(day.chinese)")
                                }
                                .frame(width: DayTableWidth )
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color(red: 235/255, green: 235/255, blue: 235/255))
                        )
                        .offset(x: scrollOffset.x)
                        .clipped()
                    }
                    .padding(.leading, ClassHstackLeaddingPadding)
                    .clipped()
                    
                }
                .padding(.leading, TimetableContentsMargin)
            }
                
            
            
               /* ZStack(alignment: .topLeading) {
                    ZStack(alignment: .topLeading) {
                        // 用 GeometryReader 監聽滾動偏移量
                        /*GeometryReader { geometry in
                            TimeAxisView()
                                .offset(x: 0, y: scrollOffset.y)
                                .onAppear {
                                    scrollOffset = CGPoint(x: geometry.frame(in: .named("scrollView")).minX, y: geometry.frame(in: .named("scrollView")).minY)
                                    
                                }
                        }*/
                        //TimeAxisView()
                        
                        ScrollView([.horizontal, .vertical], showsIndicators: false) {
                            HStack(alignment: .top, spacing: 0) {
                                ForEach(1..<6) { day in
                                    let _ = print("\(day)")
                                    TimeTableView(day: day, scrollViewContentSize: $scrollViewContentSize)
                                        .frame(width: DayTableWidth)
                                }
                            }
                            .padding(.leading, ClassHstackLeaddingPadding)
                        }
                        //.hideScrollIndicators()
                    }
                    
                    
                    // 頂端星期幾顯示
                    HStack(spacing: 0) {
                        ForEach(1..<10) { day in
                            VStack {
                                Text("星期\(day.chinese)")
                            }
                            .frame(width: (screenWidth - TimetableContentsMargin - ClassHstackLeaddingPadding)/5 )
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(red: 235/255, green: 235/255, blue: 235/255))
                    )
                    .offset(x: ClassHstackLeaddingPadding)
                    .clipped()
                    .edgesIgnoringSafeArea(.horizontal)
                }
                .padding(.leading, TimetableContentsMargin)
                .readIntrinsicContentSize(to: $scrollViewContentSize)
            */
        }
    }
}

#Preview {
    ClassTimetableView()
        .modelContainer(for: Item.self, inMemory: true)
}
