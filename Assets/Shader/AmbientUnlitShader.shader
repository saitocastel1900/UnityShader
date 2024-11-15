Shader "Unlit/AmbientUnlitShader"
{
    Properties
    {
        _MainColor("Main Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags 
        {
             "LightMode"="UniversalForward" 
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            half4 _MainColor;
            
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
                float3 ambient : COLOR0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.ambient = ShadeSH9(half4(o.worldNormal,1));
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _MainColor * float4(i.ambient,0);
            }
            ENDCG
        }
    }
}
