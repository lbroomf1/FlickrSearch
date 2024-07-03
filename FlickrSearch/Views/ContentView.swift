//
//  ContentView.swift
//  FlickrSearch
//
//  Created by LB on 7/3/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FlickrViewModel()
    @State private var searchText = ""
    @State private var selectedPhoto: FlickrPhoto? = nil
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, onTextChanged: {
                    viewModel.fetchPhotos(tags: searchText)
                })
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.photos) { photo in
                            if let url = URL(string: photo.media.m) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)
                                .clipped()
                                .onTapGesture {
                                    selectedPhoto = photo
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Flickr Search")
            .sheet(item: $selectedPhoto) { photo in
                PhotoDetailView(photo: photo)
            }
        }
    }
}

struct PhotoDetailView: View {
    let photo: FlickrPhoto
    
    var body: some View {
        VStack {
            if let url = URL(string: photo.media.m) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: 300)
            }
            Text(photo.title)
                .font(.headline)
                .padding()
            Text(photo.description)
                .padding()
            Text("Author: \(photo.author)")
                .padding()
            Text("Published: \(formattedDate(from: photo.published))")
                .padding()
            Spacer()
        }
        .padding()
    }
    
    func formattedDate(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return dateString
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var onTextChanged: () -> Void
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        var onTextChanged: () -> Void
        
        init(text: Binding<String>, onTextChanged: @escaping () -> Void) {
            _text = text
            self.onTextChanged = onTextChanged
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            onTextChanged()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, onTextChanged: onTextChanged)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
