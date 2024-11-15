Shader "Unlit/RimUnlitShader"
{
    Properties
    {
        _RimColor("RimColor", Color) = (1,1,1,1)
        _RimMultiplier ("Rim Multiplier", Float) = 1.5
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

            fixed4 _RimColor;
            float _RimMultiplier;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float rim = 1 - abs(dot(i.viewDir, i.worldNormal));
                return _RimColor * pow(rim, _RimMultiplier);
            }
            ENDCG
        }
    }
}