//
//  SmokeFrameworkCodeGen.swift
//  SmokeFrameworkApplicationGenerate
//

import SmokeFrameworkCodeGeneration
import ServiceModelEntities
import ServiceModelCodeGeneration

struct SmokeFrameworkAsyncAwaitGeneration: Codable {
    let client: AsyncAwaitGeneration
    let server: AsyncAwaitGeneration
    
    static var `default`: SmokeFrameworkAsyncAwaitGeneration {
        return SmokeFrameworkAsyncAwaitGeneration(client: .none, server: .none)
    }
}

struct SmokeFrameworkCodeGen: Codable {
    let modelFilePath: String
    let baseName: String
    let applicationSuffix: String?
    let generationType: GenerationType
    let applicationDescription: String?
    let modelOverride: ModelOverride?
    let httpClientConfiguration: HttpClientConfiguration?
    let asyncAwaitGeneration: SmokeFrameworkAsyncAwaitGeneration?
    let initializationType: InitializationType?
    let operationStubGenerationRule: OperationStubGenerationRule
}
