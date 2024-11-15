Shader "Unlit/RandomVertexMoveUnlitShader"
{
    Properties
    {
        _Scale("Scale",Range(0,0.5))=0.025
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _Scale;

            float rand(float2 co)
            {
                return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
            }

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

            v2f vert(appdata v)
            {
                v2f o;
                float random = rand(v.vertex.xy);
                float4 vert = float4(v.vertex.xyzw + v.vertex.xyzw * sin(_Time.w * random) * _Scale);
                o.vertex = UnityObjectToClipPos(vert);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float r = rand(i.vertex.xy + 0.1);
                float g = rand(i.vertex.xy + 0.2);
                float b = rand(i.vertex.xy + 0.3);
                return float4(r, g, b, 1);
            }
            ENDCG
        }
    }
}