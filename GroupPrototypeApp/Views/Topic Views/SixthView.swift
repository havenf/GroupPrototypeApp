//
//  SixthView.swift
//  GroupPrototypeApp
//
//  Created by Haven F on 3/6/25.
//import SwiftUI


import SwiftUI
import AVFoundation

// MARK: - Speech Synthesis View
struct SixthView: View {
    // AVSpeechSynthesizer instance (responsible for converting text to speech)
    let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        VStack(spacing: 30) { // Arranges UI elements vertically with spacing
            Text("Speech Synthesis Demo")
                .font(.largeTitle) // Makes text large
                .bold()
                .padding()

            // Speak Button
            Button(action: {
                speakText() // Calls function to convert text to speech
            }) {
                Text("Speak") // Button label
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer() // Pushes content to top, keeping UI well-spaced
        }
        .padding()
        .background(Color(UIColor.systemGray6)) // Light gray background for visibility
        .edgesIgnoringSafeArea(.all)
    }

    // MARK: - Speech Synthesis Function
    func speakText() {
        // SSML (Speech Synthesis Markup Language) for speech customization
        let ssml = """
        <speak>
            Hello!
            <break time="1s"/> <!-- 1-second pause -->
            <prosody rate="200%">Nice to meet you!</prosody> <!-- Doubles speech speed -->
        </speak>
        """

        //  Fetches available system voices
        let availableVoices = AVSpeechSynthesisVoice.speechVoices()

        // Selects the first available English (US) voice OR falls back to system default
        let selectedVoice = availableVoices.first { $0.language == "en-US" } ?? AVSpeechSynthesisVoice(language: "en-US")

        // Attempts to create an AVSpeechUtterance using SSML representation
        if let utterance = AVSpeechUtterance(ssmlRepresentation: ssml) {
            utterance.voice = selectedVoice // Sets the selected voice
            synthesizer.speak(utterance) // Triggers speech synthesis
        } else {
            // If SSML fails, falls back to simple text-to-speech
            let fallbackUtterance = AVSpeechUtterance(string: "Hello! Nice to meet you.")
            fallbackUtterance.voice = selectedVoice
            synthesizer.speak(fallbackUtterance)
        }
    }
}
