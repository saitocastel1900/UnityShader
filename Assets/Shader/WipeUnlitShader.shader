Shader "Unlit/WipeUnlitShader"
{
    Properties
    {
        _Radius("Radius", Range(0, 1)) = 0.5
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
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _Radius;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            fixed4 frag(v2f_img i) : COLOR
            {
                i.uv -= fixed2(0.5, 0.5);
                i.uv.x *= 16 / 9.0;
                if (distance(i.uv,fixed2(0, 0)) < _Radius)
                {
                    discard;
                }

                return fixed4(0, 0, 0, 0);
            }
            ENDCG
        }
    }
}