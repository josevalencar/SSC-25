//
//  Brian.metal
//  Brian
//
//  Created by José Vitor Alencar on 21/01/25.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

[[ stitchable ]]
half4 brian(float2 pos,
            half4 baseColor,
            float2 resolution,
            float  time)
{
    float2 uv = (pos - 0.5 * resolution) / resolution.x;
    
    float3 ro = float3(0.0, 0.0, -50.0);

    {
        float c = cos(time);
        float s = sin(time);
        float x = c * ro.x - s * ro.z;
        float z = s * ro.x + c * ro.z;
        ro.x = x;
        ro.z = z;
    }

    float3 cf = normalize(-ro);
    float3 cs = normalize(cross(cf, float3(0, 1, 0)));
    float3 cu = normalize(cross(cf, cs));

    float3 uuv = ro + cf * 3.0 + uv.x * cs + uv.y * cu;
    float3 rd  = normalize(uuv - ro);

    float3 col = float3(0.0);
    float  t   = 0.0;

    for (int i = 0; i < 64; i++)
    {
        float3 p = ro + rd * t;

        float3 pm = p;
        for (int j = 0; j < 8; j++)
        {
            float ta = time * 0.2;

            {
                float rc = cos(ta);
                float rs = sin(ta);
                float px = rc * pm.x - rs * pm.z;
                float pz = rs * pm.x + rc * pm.z;
                pm.x = px;
                pm.z = pz;
            }

            {
                float rc = cos(ta * 1.89);
                float rs = sin(ta * 1.89);
                float px = rc * pm.x - rs * pm.y;
                float py = rs * pm.x + rc * pm.y;
                pm.x = px;
                pm.y = py;
            }

            pm.xz = abs(pm.xz);
            pm.xz -= 0.5;
        }
        
        float d = (dot(sign(pm), pm) / 5.0) * 0.5;
        
        if (d < 0.02)  break;
        if (d > 100.0) break;
        
        float distFactor = length(p) * 0.1;
        
        if (distFactor > 1.0) distFactor = 1.0;
        
        float3 fromColor = float3(0.2, 0.7, 0.9);
        float3 toColor   = float3(1.0, 0.0, 1.0);
        float3 pal       = fromColor * (1.0 - distFactor) + toColor * distFactor;

        col += pal / (400.0 * d);

        t += d;
    }

    float4 finalColor = float4(col, 1.0);

    return half4(finalColor);
}
