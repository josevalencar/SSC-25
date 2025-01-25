//
//  File.metal
//  Brian
//
//  Created by José Vitor Alencar on 25/01/25.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

[[ stitchable ]]
half4 colorfulNetwork(float2 pos,
                   half4 baseColor,
                   float2 resolution,
                   float time)
{
    // Constants
    constexpr float DETAIL = 15.0;
    constexpr float ANIMATION_SPEED = 1.5;
    constexpr float BRIGHTNESS = 0.2;
    constexpr float STRUCTURE_SMOOTHNESS = 1.2;
    constexpr float SATURATION = 0.31;
    constexpr float PI = 3.14159;

    // Convert pos to normalized coordinates
    float2 p = (pos - 0.5 * resolution) / resolution.y;
    float dist_squared = dot(p, p);
    float S = 15.0;
    float a = 0.0;
    float2 n = float2(0.0);
    float2 q;

    // Main loop for neuron structure
    for (float j = 1.0; j < DETAIL; j++) {
        // Rodrigues' rotation formula
        float3 rotatedP;
        {
            float3 ax = float3(0.0, 0.0, 1.0);
            float c = cos(5.0 + sin(time) * 0.01);
            float s = sin(5.0 + sin(time) * 0.01);
            rotatedP = mix(dot(float3(p, 0.0), ax) * ax, float3(p, 0.0), c) + s * cross(ax, float3(p, 0.0));
        }
        p = rotatedP.xy;

        // Update n using Rodrigues' rotation formula
        {
            float3 ax = float3(0.0, 0.0, 1.0);
            float c = cos(5.0 + sin(time) * 0.01);
            float s = sin(5.0 + sin(time) * 0.01);
            float3 rotatedN = mix(dot(float3(n, 0.0), ax) * ax, float3(n, 0.0), c) + s * cross(ax, float3(n, 0.0));
            n = rotatedN.xy;
        }

        // Compute q
        q = p * S + time * ANIMATION_SPEED + sin(time * ANIMATION_SPEED - dist_squared * 0.0) * 2.0 + j + n;

        // Accumulate contributions
        a += dot(cos(q) / S, float2(SATURATION));
        n -= sin(q);
        S *= STRUCTURE_SMOOTHNESS;
    }

    // Compute final result
    float result = 0.17 * ((a + BRIGHTNESS) + a + a);

    // Voronoi calculation
    float3 voronoi;
    {
        float3 x = float3(time, pos / resolution);
        float3 p = floor(x);
        float3 f = fract(x);
        float id = 0.0;
        float2 res = float2(2.0);
        for (int k = -1; k <= 1; k++) {
            for (int j = -1; j <= 1; j++) {
                for (int i = -1; i <= 1; i++) {
                    float3 b = float3(float(i), float(j), float(k));
                    float3 r = b - f;
                    float d = dot(r, r);

                    float cond = max(sign(res.x - d), 0.0);
                    float nCond = 1.0 - cond;

                    float cond2 = nCond * max(sign(res.y - d), 0.0);
                    float nCond2 = 1.0 - cond2;

                    id = (dot(p + b, float3(1.0, 3.0, 1.0)) * cond) + (id * nCond);
                    res = float2(d, res.x) * cond + res * nCond;

                    res.y = cond2 * d + nCond2 * res.y;
                }
            }
        }
        voronoi = float3(sqrt(res), abs(id));
    }

    float final = pow(voronoi.r * 0.1, result * 30.0) * 1.5;
    float2 uv = pos / resolution;
    float wave = cos(5.0 * time + (uv.y * uv.x * PI));
    float3 neuronColor = float3(
        1.3 + 0.5 * sin(2.0 * time + wave),
        1.3 + 0.5 * sin(2.0 * time + 2.0 * PI / 3.0 + 2.0 * wave),
        1.3 + 0.5 * sin(2.0 * time + 4.0 * PI / 3.0 + 2.0 * wave)
    );

    float3 color = final * neuronColor + float3(0.5, 0.1, 0.8) * final * 0.1;

    // Fix for Metal's `half4` construction
    return half4(half3(color), half(1.0));
}
