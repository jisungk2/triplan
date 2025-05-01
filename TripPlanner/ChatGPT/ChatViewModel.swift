//
//  ChatViewModel.swift
//  chatgpttest
//
//  Created by Jisung Kang on 4/28/25.
//

import Foundation

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var messages: [Message] = []
        @Published var currentInput: String = ""
        private let openAIService = OpenAIService()

        /// Sends the currentInput + prompt to OpenAI, appends both user & AI messages,
        /// and invokes `completion` with the AI Message once it arrives.
        func sendMessage(completion: @escaping (Message) -> Void) {
            // 1) build & append the user message
            let input = currentInput
                + " This is the current trip plan. Please give me suggestions for other activities I could do in the gaps in the itinerary. Please format your response in mm/dd/yy hh:mm activityName Location, hh:mm activityName Location e.g., 07/28/23 14:00 Museum of Modern Art New York, 07/29/23, ..."
            let userMsg = Message(
                id: UUID(),
                role: .user,
                content: input,
                createAt: Date()
            )
            messages.append(userMsg)
            currentInput = ""

            // 2) call the API
            Task {
                let response = await openAIService.sendMessage(messages: messages)
                guard let choice = response?.choices.first?.message else {
                    print("Had no received message")
                    return
                }
                let aiMsg = Message(
                    id: UUID(),
                    role: choice.role,
                    content: choice.content,
                    createAt: Date()
                )

                // 3) back on main thread, append & fire completion
                await MainActor.run {
                    self.messages.append(aiMsg)
                    completion(aiMsg)
                }
            }
        }
    }

    
}

struct Message: Decodable, Identifiable, Equatable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}
