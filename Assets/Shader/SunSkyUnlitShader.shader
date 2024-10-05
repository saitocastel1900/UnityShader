Shader "Unlit/SunSkyUnlitShader"
{
    Properties
    {
        _BackgroundColor("background Clolor",Color) = (0.05,0.9,1,1)
        _SunColor("Sun Clolor",Color) = (1,0.8,0.5,1)
        _SunDir("Sun Direction",Vector) = (0,0.5,1,0)
        _SunStrength("Sun Strength",Range(0,200)) = 30
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Background"
            "Queue"="Background"
            "PreviewType"="SkyBox" 
        }

        Pass
        {
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            fixed3 _BackgroundColor;
            fixed3 _SunColor;
            float3 _SunDir;
            float _SunStrength;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 uv : TEXCOORD0;
            };

            struct v2f
            {
                float3 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 dir = normalize(_SunDir);
                float angle = dot(dir, i.uv);
                fixed3 c = lerp(_BackgroundColor,_SunColor,pow(max(0, angle), _SunStrength));

                return fixed4(c, 1);
            }
            ENDCG
        }
    }
}