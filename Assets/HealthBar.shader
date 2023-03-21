Shader "Unlit/HealthBar"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Health ("Health", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            //float _Health;

           UNITY_INSTANCING_BUFFER_START(Props)
                UNITY_DEFINE_INSTANCED_PROP(float, _Health) // Make _Health an instanced property (i.e. an array)
           UNITY_INSTANCING_BUFFER_END(Props)

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                float health = UNITY_ACCESS_INSTANCED_PROP(Props, _Health);
                float3 healthbarColor = lerp( float3(1,0,0), 
                                                float3(0,1,0), 
                    health);
                float3 bgColor = (0.1).xxx;

                float healthbarMask = health > i.uv.x;
               // float healthbarMask = _Health > floor(i.uv.x * 8)/8;

                //Mathf.Lerp() // Clamped
                //lerp()       // unclamped

                //Clamp01() --> Saturate()

                float3 outColor = lerp(bgColor, healthbarColor,
                    healthbarMask);

                return float4(outColor,1);
            }
            ENDCG
        }
    }
}
