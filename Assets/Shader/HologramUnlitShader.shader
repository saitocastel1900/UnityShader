Shader "Unlit/HologramUnlitShader"
{
    Properties
    {
        _MainColor("MainColor", Color) = (1,1,1,1)
        _SubColor("SubColor", Color) = (1,1,1,1)
        _StripeColor("StripeColor", Color) = (1,1,1,1)
        _StripeMultiply("StripeMultiply",Range(0,100)) = 15
        _FillRatio("FillRatio",Range(1,10)) = 1
        _FresnelMultiplier ("Rim Multiplier", Range(0,100)) = 1.5
        _Rotation("Rotation", Vector) = (1,1,1)
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            fixed4 _MainColor;
            fixed4 _SubColor;
            fixed4 _StripeColor;
            float _StripeMultiply;
            float _FillRatio;
            float _FresnelMultiplier;
            float3 _Rotation;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 localPos : TEXCOORD1;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD2;
                float3 viewDir : TEXCOORD3;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.localPos = v.vertex.xyz + _Time.x;
                o.uv = v.uv;
                o.normal = normalize(UnityObjectToWorldNormal(v.normal));
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float interpolation = frac(dot(i.localPos ,normalize(_Rotation)) * _StripeMultiply);
                float fresnel = pow(1 - abs(dot(i.normal, i.viewDir)), _FresnelMultiplier);
                
                float color = pow(1 - fresnel, 20);
                float a = pow(fresnel, 0.2);

                return lerp(_MainColor, _SubColor, fresnel) + _StripeColor * pow(interpolation, _FillRatio);
            }
            ENDCG
        }
    }
}