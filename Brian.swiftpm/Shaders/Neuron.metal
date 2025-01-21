//
//  SimpleEffects.metal
//  Brian
//
//  Created by José Vitor Alencar on 16/01/25.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

[[ stitchable ]]
half4 neuron(float2 pos,
              half4 baseColor,
              float2 resolution,
              float  time)
{

    float2 uv = (pos - 0.5 * resolution) / resolution.y;
    float zoomFactor = 1.5;

    uv *= zoomFactor;

    float3 col = float3(0.0);

    float2 n = float2(0.0);
    float2 N = float2(0.0);
    float2 p = uv + sin(time * 0.1) / 10.0;
    float  S = 10.0;

    float c = cos(1.0);
    float s = sin(1.0);
    float2x2 m = float2x2(c,  s,
                          -s, c);

    for (int j = 0; j < 30; j++)
    {
        p = m * p;
        n = m * n;

        float2 q = p * S + float2(j) + n + float2(time);
        n += sin(q);
        N += cos(q) / S;

        S *= 1.2;
    }

    col = float3(1.0, 2.0, 4.0)
        * pow( (N.x + N.y + 0.2) + 0.005 / length(N), 2.1 );


    half4 finalColor = half4( half(col.x),
                              half(col.y),
                              half(col.z),
                              half(1.0) );
    return finalColor;
}
