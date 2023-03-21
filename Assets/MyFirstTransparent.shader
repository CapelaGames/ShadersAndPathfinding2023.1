Shader "Unlit/MyFirstTransparent"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent"
               "Queue"="Transparent"}

        Pass
        {
            

            //ZWrite Off

            //Blend, how the previous render pass (DST) interacts with the current render pass (SRC)
        
            //Blend SrcAlpha OneMinusSrcAlpha // Traditional transparency
            //Blend One OneMinusSrcAlpha // Premultiplied transparency
           // Blend One One //Additive
            // Blend OneMinusDstColor One // Soft additive
            //Blend DstColor Zero // Multiplicative
            Blend DstColor SrcColor // 2x multiplicative 


            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float xOffset = cos(i.uv.x * UNITY_TWO_PI * 8) * 0.01;
                float t = cos((i.uv.y + xOffset - _Time.y + 0.1) * UNITY_TWO_PI * 5) * 0.5 + 0.5;

                t *= 1 -  i.uv.y;

                return t;


            }
            ENDCG
        }
    }
}
