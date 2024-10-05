Shader "Unlit/StripeScroll"
{
    Properties
    {
        _MainColor ("MainColor", Color) = (1,1,1,1)
        _SubColor ("SubColor", Color) = (1,1,1,1)
        _SliceSpace ("SliceSpace", Range(0,30)) = 15
        _FillRatio("FillRatio",Range(0,1)) = 1
         _Step("Step",Range(0,1)) = 1
    }
    SubShader
    {
        Pass
        {
            Tags { "RenderType"="Opaque" }
            LOD 100
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            fixed4 _MainColor; 
            fixed4 _SubColor;
            fixed _SliceSpace;
            fixed _FillRatio;
             fixed _Step;
            
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
                o.uv.y = v.uv.y +_Time.x;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float interpolation = step(frac(i.uv.y * _SliceSpace)-_FillRatio,_Step) ;
                return lerp(_MainColor,_SubColor,interpolation);
            }
            ENDCG
        }
    }
}
