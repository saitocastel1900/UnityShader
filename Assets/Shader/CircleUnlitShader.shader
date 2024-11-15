Shader "Unlit/CircleUnlitShader"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1,1,1,1)
        _LineColor ("Line Color", Color) = (1,1,1,1)
        _Multiplier ("Multiplier", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            half4 _MainColor;
            half4 _LineColor;
            half _Multiplier;

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float lenght = distance(i.uv,(0.5,0.5));
                return lerp(_MainColor,_LineColor,frac((lenght+_Time.x) * _Multiplier));
            }
            ENDCG
        }
    }
}
