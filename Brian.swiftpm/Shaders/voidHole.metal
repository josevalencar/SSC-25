//
//  File.metal
//  Brian
//
//  Created by José Vitor Alencar on 23/02/25.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

[[ stitchable ]]
half4 voidHole(float2 pos,
                half4 baseColor,
                float2 resolution,
                float time)
{
    constexpr float PI = 3.1416;
    constexpr float TAU = 6.2832;
    constexpr float LOOP_COUNT = 50.0;

    float T = time * 5.0;

    float2 U = (pos - 0.5 * resolution) / (resolution.y * 0.01);
    float3 camOrigin = float3(0, 20, -120);
    float3 rayDir = normalize(float3(U, resolution.y));
    float3 color = float3(0.0);

    float d = 0.0;
    float stepSize, r;

    float yawAngle = 0.0;
    float pitchAngle = 0.0;

    float cY = cos(yawAngle);
    float sY = sin(yawAngle);
    float2x2 yawMatrix = float2x2(cY, -sY, sY, cY);

    float cP = cos(pitchAngle);
    float sP = sin(pitchAngle);
    float2x2 pitchMatrix = float2x2(cP, -sP, sP, cP);

    for (float i = 0.0; i < LOOP_COUNT; i++)
    {
        float3 p = camOrigin + rayDir * d;
        p.yz = pitchMatrix * p.yz;
        p.xz = yawMatrix * p.xz;

        float mapDist = 1e20, scaleFactor = 5.0, warpSize = 40.0, cubeSize = 0.4;
        float3 u = p;
        u.yz = -u.zy;
        u.xy = float2(atan2(u.x, u.y), length(u.xy));
        u.x += T / 6.0;

        for (float j = 0.0; j < scaleFactor; j++)
        {
            float3 pLocal = u;
            float segmentY = round(max(pLocal.y - j, 0.0) / scaleFactor) * scaleFactor + j;
            pLocal.x *= segmentY;
            pLocal.x -= sqrt(segmentY * T * T * 2.0);
            pLocal.x -= round(pLocal.x / TAU) * TAU;
            pLocal.y -= segmentY;
            pLocal.z += sqrt(segmentY / warpSize) * warpSize;
            float radialWave = cos(segmentY * T / 50.0) * 0.5 + 0.5;
            pLocal.z += radialWave * 2.0;
            pLocal = abs(pLocal);

            mapDist = min(mapDist, max(pLocal.x, max(pLocal.y, pLocal.z)) - cubeSize * radialWave);
        }

        stepSize = mapDist * 0.7;
        r = (cos(round(length(p.xz)) * T / 50.0) * 0.7 - 1.8) / 2.0;

        float3 hue = cos((r + 0.5) * TAU + (float3(60.0, 0.0, -60.0) * (PI / 180.0))) * 0.5 + 0.5;

        color += min(mapDist, exp(-mapDist / 0.07)) * hue * (r + 2.4);

        if (mapDist < 1e-3 || d > 1e3) break;
        d += stepSize;
    }

    return half4(half3(exp(log(color) / 2.2)), half(1.0));
}
