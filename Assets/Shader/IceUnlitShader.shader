Shader "Unlit/IceUnlitShader"
{
    Properties
    {
        _Color("Color",Color) = (1,1,1,1)
        _AlphaMultiplier ("Alpha Multiplier", Float) = 1.5
    }
    SubShader
    {
        Pass
        {
            ZWrite ON
            ColorMask 0
        }
        Pass
        {
            Tags
            {
                "LightMode" = "UniversalForward"
                "RenderType"="Transparent"
                "Queue"="Transparent"

            }
            Blend SrcAlpha OneMinusSrcAlpha

            ZWrite OFF
            Ztest LEqual
            LOD 100

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _AlphaMultiplier;
            half4 _Color;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float alpha = 1 - abs(dot(i.viewDir, i.worldNormal));
                alpha *= _AlphaMultiplier;

                return lerp(_Color,fixed4(1,1,1,1),alpha);
            }
            ENDCG
        }
    }
}