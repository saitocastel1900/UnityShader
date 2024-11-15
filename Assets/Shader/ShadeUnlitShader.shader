Shader "Unlit/ShadeUnlitShader"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1,1,1,1)
        _DiffuseShader ("Diffuse Shader", Range(0,1)) = 0.5
    }
    SubShader
    {
        Pass
        {
            Tags
            {
                "LightMode"="UniversalForward"
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include  "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldNormal : NORMAL;
                SHADOW_COORDS(1)
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                TRANSFER_SHADOW(o)
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 color = fixed4(1, 1, 1, 1);
                color = color * SHADOW_ATTENUATION(i);
                return color;
            }
            ENDCG
        }
        Pass
        {
            Tags
            {
                "LightMode"="ShadowCaster"
            }
            LOD 100

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster

            #include "UnityCG.cginc"

            struct v2f
            {
                V2F_SHADOW_CASTER;
            };

            v2f vert(appdata_base v)
            {
                v2f o;

                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
}