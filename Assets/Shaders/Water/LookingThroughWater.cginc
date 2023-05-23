#if !defined(LOOKING_THROUGH_WATER_INCLUDED)
#define LOOKING_THROUGH_WATER_INCLUDED

//Filled out by unity
sampler2D _CameraDepthTexture;
float4 _CameraDepthTexture_TexelSize;

//Filled by GrabPass
sampler2D _WaterBackground;

//Filled by Properties
float3 _WaterFogColor;
float _WaterFogDensity;

float3 ColourBelowWater(float4 screenPos)
{
    //just do this to get the correct screen position
    float2 uv = screenPos.xy / screenPos.w;

    //In some platforms the V in UV is flipped
    #if UNITY_UV_STARTS_AT_TOP
        if(_CameraDepthTexture_TexelSize.y < 0){
            uv.y = 1 - uv.y;
        }
    #endif
    
    //Depth relative to the screen
    float backgroundDepth =  LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture,uv));
    //how far away the surface of the water is
    float surfaceDepth = UNITY_Z_0_FAR_FROM_CLIPSPACE(screenPos.z);
    //depth from water to stuff under water
    float depthDifference = backgroundDepth - surfaceDepth;
    
    float3 backgroundColour = tex2D(_WaterBackground, uv).rgb;
    float fogFactor = exp2(-_WaterFogDensity * depthDifference);
    return  lerp(_WaterFogColor, backgroundColour, fogFactor);
}


#endif