//
//  Sinebow.swift
//  Brian
//
//  Created by José Vitor Alencar on 20/01/25.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>

using namespace metal;

[[ stitchable ]] half4 sinebow(float2 pos, half4 color, float2 s, float t){
    float2 uv = (pos / s.x) * 2 - 1;
    float wave = sin(uv.x + t);
    wave *= wave * 50;
    float luma = 1 / (100 * uv.y + wave);
    return half4(luma, luma, luma, 1);
}
