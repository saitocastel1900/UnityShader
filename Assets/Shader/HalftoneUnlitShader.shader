Shader "Unlit/HalftoneUnlitShader"
{
    Properties
    {
        _HalftoneScale("HlaftoneScale",Range(0.001,0.1))=0.02
        _ShaderColor("ShaderColor",Color) = (1,1,1,1)
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
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            float _HalftoneScale;
            float3 _ShaderColor;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 norma : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 screenPos: TEXCOORD1;
                float3 normal : NORMAL;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.screenPos = ComputeScreenPos(o.vertex);
                o.normal = UnityObjectToWorldNormal(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                //これでスクリーン座標を求めているみたい
                float2 screenPos = i.screenPos.xy / i.screenPos.w;

                //アスペクト比
                float aspect = _ScreenParams.x / _ScreenParams.y;

                //マス目の大きさ（矩形）
                float2 cellSize = float2(_HalftoneScale,_HalftoneScale * aspect);

                float2 cellCenter;
                //スクリーン座標をセルの大きさで除算することで、セルの中心点をスクリーン座標基準ではなく、セル基準で考えている
                cellCenter.x = floor(screenPos.x / cellSize.x) * cellSize.x + cellSize.x / 2;
                cellCenter.y = floor(screenPos.y / cellSize.y) * cellSize.y + cellSize.y / 2;

                float2 diff = (screenPos - cellCenter) / cellSize;

                float3 normal = normalize(i.normal);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                
                float threshold = 1 - dot(normal,lightDir);
                float col =   lerp(1,_ShaderColor,step(length(diff),threshold));

                return fixed4(col,col,col,1);
            }
            ENDCG
        }
    }
}