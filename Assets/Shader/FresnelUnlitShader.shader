Shader "Unlit/FresnelUnlitShader"
{
    Properties
    {
        _MainColor("MainColor", Color) = (1,1,1,1)
        _SubColor("SubColor", Color) = (1,1,1,1)
        _FresnelMultiplier ("Rim Multiplier", Float) = 1.5
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

            fixed4 _MainColor;
            fixed4 _SubColor;
            float _FresnelMultiplier;
            
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
                float3 normal : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv =v.uv;
                o.normal = normalize(UnityObjectToWorldNormal(v.normal));
                o.viewDir = normalize(ObjSpaceViewDir(v.vertex));
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float t = 1 - abs(dot(i.normal,i.viewDir));
                return lerp(_MainColor,_SubColor,pow(t,_FresnelMultiplier));
            }
            ENDCG
        }
    }
}