Shader "Unlit/MyFirstShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MyFloat("My Float", float) = 2.0
        _ColorA("ColorA", Color) = (0,0,0,1)
        _ColorB("ColorB", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
            ZTest Greater

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            //#define HALF_TAU UNITY_TWO_PI * 0.5
            #define TAU 6.283185307179586

            struct appdata //mesh data
            {
                float4 vertex : POSITION; // vertex position
                float4 normal : NORMAL;
                //float4 tangent : TANGENT;
                //float4 color : COLOR;
                float2 uv : TEXCOORD0; // uv0 coordiantes
                // float uv1 : TEXCOORD1 //uv1 cooordiantes
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
            };
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _MyFloat;
            float4 _ColorA;
            float4 _ColorB;

            v2f vert (appdata v)
            {
                v2f o;
                //v.vertex.y += sin(_Time.y * 10 + v.vertex.x *4) * 0.3;
                //v.vertex.xyz += 0.2 * v.normal;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv; // TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = mul( (float3x3) unity_ObjectToWorld , v.normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float t = cos(i.uv.x * TAU * 10) * 0.5 + 0.5;
                float4 outColor = lerp(_ColorA, _ColorB, t);
                return outColor;

                //return float4(i.normal,1);
                // return float4(i.uv.xxx ,1);
                // sample the texture
                //fixed4 col = tex2D(_MainTex, i.uv);
                //return col;
            }
            ENDCG
        }
    }
}
