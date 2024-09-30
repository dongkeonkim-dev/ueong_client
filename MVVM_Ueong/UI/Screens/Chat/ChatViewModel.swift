//
//  ChatViewModel.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//
import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    let username: String
    let chatterUsername: String
    let chatterNickname: String
    var postId: Int
    var relatedPost: Post
    let messageRepository = MessageRepository()
    let postRepository = PostRepository()
    let photoRepository = PhotoRepository()
    
    init(chatterUsername: String, chatterNickname: String, postId: Int) {
        self.username = "username1"
        self.chatterUsername = chatterUsername
        self.chatterNickname = chatterNickname
        self.relatedPost = Post()
        self.postId = postId
        fetchPage() // 메시지 로드
    }
    
    // 비동기 작업을 순차적으로 처리하도록 개선한 메서드
    func fetchPage(){
        Task{
            await fetchMessages()
            await fetchPost()
        }
    }

    private func fetchMessages() async {
        do {
            let messages = try await messageRepository.getMessagesByChatter(username: username, chatter: chatterUsername)
            DispatchQueue.main.async {
                self.messages = messages
            }
        } catch {
            print("Error fetching messages: \(error)")
        }
    }
    
    private func fetchPost() async {
        do {
            let post = try await postRepository.getPostById(username: username, postId: postId)
            DispatchQueue.main.async {
                self.relatedPost = post
            }
            await fetchPhotosForPost(postId: postId) // 게시물 데이터를 가져온 후에 사진 데이터를 가져옵니다.
        } catch {
            print("Error fetching post: \(error)")
        }
    }

    private func fetchPhotosForPost(postId: Int) async {
        do {
            let photos = try await photoRepository.getPhotosForPost(postId: postId)
            DispatchQueue.main.async {
                self.relatedPost.photos = photos // 게시물 사진 업데이트
            }
        } catch {
            print("Error fetching photos: \(error)")
        }
    }
}
