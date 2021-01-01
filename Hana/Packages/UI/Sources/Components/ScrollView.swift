//
//  ScrollView.swift
//  
//
//  Created by Ivan Lisovyi on 01.01.21.
//

import SwiftUI

public struct ScrollView<Content: View, ActivityIndicator: View>: View {
  public typealias OnScrollOffsetChange = (CGFloat) -> Void

  @State private var previousScrollOffset: CGFloat = 0
  @State private var scrollOffset: CGFloat = 0
  @State private var frozen: Bool = false

  @Binding var isRefreshing: Bool

  var onScrollOffsetChange: OnScrollOffsetChange?

  let threshold: CGFloat

  let activity: ActivityIndicator
  let content: Content

  public init(
    isRefreshing: Binding<Bool>,
    threshold: CGFloat = 60,
    onScrollOffsetChange: OnScrollOffsetChange? = nil,
    @ViewBuilder activity: () -> ActivityIndicator,
    @ViewBuilder content: () -> Content
  ) {
    self._isRefreshing = isRefreshing
    self.threshold = threshold
    self.onScrollOffsetChange = onScrollOffsetChange
    self.activity = activity()
    self.content = content()
  }

  public var body: some View {
    VStack {
      SwiftUI.ScrollView {
        ZStack(alignment: .top) {
          MovingView()

          VStack {
            content
          }
          .alignmentGuide(
            .top,
            computeValue: { d in (isRefreshing && frozen) ? -threshold : 0.0 }
          )

          activityView
        }
      }
      .background(FixedView())
      .onPreferenceChange(RefreshableKeyTypes.PrefKey.self, perform: preferencesChanged(with:))
    }
  }

  @ViewBuilder private var activityView: some View {
    if isRefreshing {
      VStack {
        Spacer()
        activity
        Spacer()
      }
      .frame(height: threshold)
      .fixedSize()
      .offset(y: -threshold + (isRefreshing && frozen ? threshold : 0.0))
    }
  }

  private func preferencesChanged(with values: [RefreshableKeyTypes.PrefData]) {
    DispatchQueue.main.async {
      // Calculate scroll offset
      let movingBounds = values.first { $0.type == .movingView }?.bounds ?? .zero
      let fixedBounds = values.first { $0.type == .fixedView }?.bounds ?? .zero

      scrollOffset = movingBounds.minY - fixedBounds.minY
      onScrollOffsetChange?(scrollOffset)

      // Crossing the threshold on the way down, we start the refresh process
      if !isRefreshing && (scrollOffset > threshold && previousScrollOffset <= threshold) {
        isRefreshing = true
      }

      if isRefreshing {
        // Crossing the threshold on the way up, we add a space at the top of the scrollview
        if previousScrollOffset > threshold && scrollOffset <= threshold {
          frozen = true
        }
      } else {
        // remove the space at the top of the scroll view
        frozen = false
      }

      // Update last scroll offset
      previousScrollOffset = scrollOffset
    }
  }

  private struct MovingView: View {
    var body: some View {
      GeometryReader { proxy in
        Color.clear.preference(
          key: RefreshableKeyTypes.PrefKey.self,
          value: [
            RefreshableKeyTypes.PrefData(
              type: .movingView,
              bounds: proxy.frame(in: .global)
            )
          ]
        )
      }
      .frame(height: 0)
    }
  }

  private struct FixedView: View {
    var body: some View {
      GeometryReader { proxy in
        Color.clear.preference(
          key: RefreshableKeyTypes.PrefKey.self,
          value: [
            RefreshableKeyTypes.PrefData(
              type: .fixedView,
              bounds: proxy.frame(in: .global)
            )
          ]
        )
      }
    }
  }
}

extension ScrollView where ActivityIndicator == AnyView {
  public init(
    isRefreshing: Binding<Bool>,
    threshold: CGFloat = 60,
    onScrollOffsetChange: OnScrollOffsetChange? = nil,
    @ViewBuilder activity: () -> ActivityIndicator = {
      AnyView(
        ProgressView().scaleEffect(1.5)
      )
    },
    @ViewBuilder content: () -> Content
  ) {
    self._isRefreshing = isRefreshing
    self.threshold = threshold
    self.onScrollOffsetChange = onScrollOffsetChange
    self.activity = activity()
    self.content = content()
  }
}

extension ScrollView {
  public func onScrollOffsetChange(_ perform: @escaping OnScrollOffsetChange) -> Self {
    var scrollView = self
    scrollView.onScrollOffsetChange = perform
    return scrollView
  }
}

private struct RefreshableKeyTypes {
  enum ViewType: Int {
    case movingView
    case fixedView
  }

  struct PrefData: Equatable {
    let type: ViewType
    let bounds: CGRect
  }

  struct PrefKey: PreferenceKey {
    static var defaultValue: [PrefData] = []

    static func reduce(value: inout [PrefData], nextValue: () -> [PrefData]) {
      value.append(contentsOf: nextValue())
    }

    typealias Value = [PrefData]
  }
}

#if DEBUG
struct ScrollView_Previews: PreviewProvider {
  static var previews: some View {
    ScrollView(isRefreshing: .constant(true)) {
      Group {
        Color.red
        Color.blue
        Color.yellow
      }
      .frame(width: 300, height: 100)
    }
  }
}
#endif
