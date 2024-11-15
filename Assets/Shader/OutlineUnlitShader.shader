Shader "Unlit/NormalOutLine"
{
    Properties
    {
        _BaseColor("BaseColor", Color) = (1, 1, 1, 1)
        _OutlineColor("Color", Color) = (1, 1, 1, 1)
        _OutlineWidth("Width", float) = 1
    }
    SubShader
    {
        Pass
        {
            Tags
            {
                "RenderType"="Opaque"
                "Queue"="Geometry"
                "RenderPipeline"="UniversalPipeline"
            }
            
            Cull Front
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            half _OutlineWidth;
            half4 _OutlineColor;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex + v.normal * _OutlineWidth / 100);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return _OutlineColor;
            }
            ENDCG
        }

        Pass
        {
            Tags
            {
                "LightMode"="UniversalForward"
                "RenderPipeline"="UniversalPipeline"
            }
            LOD 100
            Cull Back

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            fixed4 _BaseColor;

            struct appdata
            {
                float3 normal : NORMAL;
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return _BaseColor;
            }
            ENDCG
        }
    }
}