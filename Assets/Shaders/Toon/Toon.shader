Shader "Custom/Toon"
{
    Properties
    {
        [Header(Base Parameters)]
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Specular ("Specular Color" , Color ) = (1,1,1,1)
        [HDR] _Emission ("Emission", Color) = (0,0,0,1)
        
        [Header(Lighting Parameters)]
        _ShadowTint("Shadow Color", Color) = (0.5,0.5,0.5,1)
        [IntRange]_StepAmount ("Shadow Steps", Range(1,16)) = 2
        _StepWidth("Step Size", Range(0,1)) = 0.25
        _SpecularSize ("Specular Size", Range(0,1)) = 0.1
        _SpecularFalloff ("Specular Falloff", Range(0,2)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Geometry" }
        LOD 200

        CGPROGRAM
        // 
        #pragma surface surf Stepped fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
        half3 _Emission;
        fixed4 _Specular;

        float3 _ShadowTint;
        float _StepWidth;
        float _StepAmount;
        float _SpecularSize;
        float _SpecularFalloff;

        struct ToonSurfaceOutput
        {
            fixed3 Albedo;
            half3 Emission;
            fixed3 Specular;
            fixed Alpha;
            fixed3 Normal;
        };


        float4 LightingStepped(ToonSurfaceOutput s, float3 lightDir, half3 viewDir, float shadowAttenuation)
        {
            //How much does the normal point towards the light source
            float towardsLight = dot(s.Normal, lightDir);
            //stretch values so each whole value is one step
            towardsLight = towardsLight / _StepWidth;
            //makes steps harder
            float lightIntensity =  floor(towardsLight);

            float change = fwidth(towardsLight);
            float smoothing = smoothstep(0,change, frac(towardsLight));
            lightIntensity += smoothing;

            lightIntensity = lightIntensity / _StepAmount;
            lightIntensity = saturate(lightIntensity);

            
            #ifdef USING_DIRECTIONAL_LIGHT
                float attenuationChange = fwidth(shadowAttenuation) * 0.5;
                float shadow = smoothstep(0.5 - attenuationChange, 0.5 + attenuationChange, shadowAttenuation);
            #else
                float attenuationChange = fwidth(shadowAttenuation);
                float shadow = smoothstep(0, attenuationChange, shadowAttenuation);
            #endif

            lightIntensity *= shadow;

            float3 reflectionDirection = reflect(lightDir, s.Normal);
            float towardsReflection = dot(viewDir, -reflectionDirection);

            float specularFalloff = dot(viewDir, s.Normal);
            specularFalloff = pow(specularFalloff, _SpecularFalloff);
            towardsReflection *= specularFalloff;

            float specularChange = fwidth(towardsReflection);
            float specularIntensity = smoothstep(1 - _SpecularSize, 1 - _SpecularSize  + specularChange, towardsReflection);

            //factor shadows
            specularIntensity *= shadow;
            
            float4 color;
            //calculate final color
            color.rgb = s.Albedo * lightIntensity * _LightColor0.rgb;
            color.rgb = lerp(color.rgb, s.Specular * _LightColor0.rgb, saturate(specularIntensity));

            color.a = s.Alpha;
            return color;
        }
        
        void surf (Input IN, inout ToonSurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;

            o.Specular = _Specular;
            
            float3 shadowColor = c.rgb * _ShadowTint;
            o.Emission = _Emission + shadowColor;
        }
        ENDCG
    }
    FallBack "Standard"
}
