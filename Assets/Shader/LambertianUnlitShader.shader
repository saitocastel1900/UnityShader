Shader "Unlit/LambertianUnlitShader"
{
   Properties
    {
        _MainColor("Main Color", Color) = (1,1,1,1)
        _lightInt("lightInt",Range(0,1)) = 0.5
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
            #include "Lighting.cginc"

            half4 _MainColor;
            float _lightInt;
            
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
                float3 light = normalize(_WorldSpaceLightPos0.xyz);
                float3 normal = normalize(i.worldNormal);

                fixed4 diffuseColor = max(0,dot(light, normal)) * _lightInt ;
                
                return _MainColor * diffuseColor * _LightColor0+float4(i.ambient,0);
            }
            ENDCG
        }
    }
}
