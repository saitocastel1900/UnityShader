Shader "Unlit/TransparentUnlitShader"
{
    Properties
    {
        _Color("Color",Color)=(1,1,1,1)
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

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            half4 _Color;

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
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}