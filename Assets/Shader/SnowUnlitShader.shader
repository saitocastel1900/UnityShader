Shader "Unlit/SnowUnlitShader"
{
    Properties
    {
        _MainColor("Main Color", Color) = (1,1,1,1)
        _SnowColor("Snow Color", Color) = (1,1,1,1)
        _SnowScale("Snow Scale", Range(0, 5)) = 0.5
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

            half4 _MainColor;
            half4 _SnowColor;
            half _SnowScale;
            
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
                float3 normal : NORMAL;
            };
            
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target{
                float snow = dot(i.normal,fixed3(0,1,0));
                half4 color = lerp(_MainColor, _SnowColor, snow * _SnowScale);
                return color;
            }
            ENDCG
        }
    }
}