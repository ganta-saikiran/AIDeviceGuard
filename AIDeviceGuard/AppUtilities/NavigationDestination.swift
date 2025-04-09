//
//  NavigationDestination.swift
//  AIDeviceGuard
//
//  Created by Ganta Saikiran on 06/04/25.
//


import SwiftUI
/// navigateToDestination
/// ///  we can use a navigationView to perform navigation based
/// on a presented data value. To support this, use the
/// ``NavigationDestination(isPresented:destination:)`` view modifier
/// inside a navigation View to associate a view with a kind of data, and
/// then present a value of that data type from a navigation View. The
/// following example reimplements the previous example as a series of
/// presentation:
///
///     NavigationView {
///         List {
///             SomeView()
///             .onTapGesture {
///             navigate = true
///         }
///         .navigateToDestination(for: $navigate) {
///             DestinationView()
///         }
///
///     }
///
/// Separating the view from the data facilitates programmatic navigation
/// because you can manage navigation state by recording the presented data.
///
/// When ever the value of isPresented is `True` it will push to the `destinationView` view
extension View {
    func navigateToDestination<Destination: View>(_ isPresented: Binding<Bool>, hideChevron: Bool = false, @ViewBuilder destinationView: @escaping () -> Destination) -> some View {
        modifier(NavigationDestination(isPresented: isPresented, hideChevron: hideChevron, destination: destinationView))
    }
}

struct NavigationDestination<Destination: View>: ViewModifier {
    @Binding var isPresented: Bool
    var hideChevron: Bool
    var destination: () -> (Destination)
    func body(content: Content) -> some View {
        ZStack {
            content
            NavigationLink(
                isActive: $isPresented,
                destination: {
                    NavigationLazyView(destination())
                },
                label: { EmptyView() }
            )
            .hidden()
            .if(hideChevron) { view in
                view.opacity(0.0)
            }
        }
    }
}

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content

    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}
