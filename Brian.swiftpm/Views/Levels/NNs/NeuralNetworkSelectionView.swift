//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 22/02/25.
//

import SwiftUI

struct NeuralNetworkSelectionView: View {
    @State private var selectedNetwork: NeuralNetworkType = .singleLayerPerceptron

    var body: some View {
        VStack {
            VStack {
                Text(selectedNetwork.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top)

                networkView(for: selectedNetwork)
                    .frame(height: 250)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .transition(.opacity)
                    .animation(.easeInOut, value: selectedNetwork)

                Text(selectedNetwork.description)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.8))
            .cornerRadius(20)
            .padding()

            Spacer()

            VStack(spacing: -10) {
                HStack(spacing: -15) {
                    networkButton(network: .singleLayerPerceptron)
                    networkButton(network: .radialBasisNetwork)
                }
                HStack(spacing: -15) {
                    networkButton(network: .multiLayerPerceptron)
                    networkButton(network: .recurrentNeuralNetwork)
                }
            }
            .padding(.bottom, 40)
        }
        .background(Color.black.ignoresSafeArea())
    }

    private func networkButton(network: NeuralNetworkType) -> some View {
        Button(action: {
            withAnimation {
                selectedNetwork = network
            }
        }) {
            Text(network.buttonText)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 150, height: 50)
                .background(selectedNetwork == network ? Color.green : Color.indigo)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
        .padding()
    }

    @ViewBuilder
    private func networkView(for type: NeuralNetworkType) -> some View {
        switch type {
        case .singleLayerPerceptron:
            SingleLayerPerceptronView()
        case .radialBasisNetwork:
            RadialBasisNetworkView()
        case .multiLayerPerceptron:
            MultiLayerPerceptronView()
        case .recurrentNeuralNetwork:
            RecurrentNeuralNetworkView()
        }
    }
}

enum NeuralNetworkType: CaseIterable {
    case singleLayerPerceptron, radialBasisNetwork, multiLayerPerceptron, recurrentNeuralNetwork

    var title: String {
        switch self {
        case .singleLayerPerceptron: return "Single Layer Perceptron"
        case .radialBasisNetwork: return "Radial Basis Network"
        case .multiLayerPerceptron: return "Multi Layer Perceptron"
        case .recurrentNeuralNetwork: return "Recurrent Network"
        }
    }
    
    var buttonText: String {
        switch self {
        case .singleLayerPerceptron: return "Single Layer"
        case .radialBasisNetwork: return "Radial Basis"
        case .multiLayerPerceptron: return "Multi Layer"
        case .recurrentNeuralNetwork: return "Recurrent Network"
        }
    }

    var description: String {
        switch self {
        case .singleLayerPerceptron:
            return "A simple perceptron with one layer that classifies linearly separable data."
        case .radialBasisNetwork:
            return "Uses radial basis functions as activation functions to perform classification."
        case .multiLayerPerceptron:
            return "A fully connected neural network with multiple hidden layers for deep learning."
        case .recurrentNeuralNetwork:
            return "Processes sequences of data and maintains memory through loops in connections."
        }
    }
}

struct SingleLayerPerceptronView: View {
    var body: some View {
        NeuralNetworkView(
            inputLayerCount: 2,
            hiddenLayers: [1],
            outputLayerCount: 0,
            neuronWidth: 30,
            neuronHeight: 30,
            neuronSpacing: 40
        )
        .padding(.trailing, 40)
    }
}

struct RadialBasisNetworkView: View {
    var body: some View {
        NeuralNetworkView(
            inputLayerCount: 2,
            hiddenLayers: [2],
            outputLayerCount: 1,
            neuronWidth: 30,
            neuronHeight: 30,
            neuronSpacing: 50
        )
        .padding(.trailing, 100)
    }
}

struct MultiLayerPerceptronView: View {
    var body: some View {
        NeuralNetworkView(
            inputLayerCount: 3,
            hiddenLayers: [4, 4],
            outputLayerCount: 2,
            neuronWidth: 25,
            neuronHeight: 25,
            neuronSpacing: 35
        )
        .padding(.trailing, 90)
    }
}

struct RecurrentNeuralNetworkView: View {
    var body: some View {
        NeuralNetworkView(
            inputLayerCount: 3,
            hiddenLayers: [3, 3],
            outputLayerCount: 3,
            neuronWidth: 25,
            neuronHeight: 25,
            neuronSpacing: 35
        )
        .padding(.trailing, 90)
    }
}

struct NeuralNetworkSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NeuralNetworkSelectionView()
    }
}
