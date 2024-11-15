Shader "Unlit/DissolveUnlitShader"
{
    Properties
    {
        _MainColor("Main Color",Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white"{}
        _DisolveColor("Color",Color) = (1,1,1,1)
        _DisolveTex ("Disolve Texture", 2D) = "white"{}
        _power("Power",Range(0,20)) = 0.5
        _clipTime("Clip Time",Range(0,1)) = 0
        _delayClipTime("Delay Clip Time",Range(0,1)) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
            "RenderPipeline"="UniversalPipeline"
        }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            half4 _MainColor;
            half4 _DisolveColor;
            sampler2D _MainTex;
            sampler2D _DisolveTex;
            half _power;
            half _clipTime;
            half _delayClipTime;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
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
                fixed4 dissovleColor = tex2D(_DisolveTex, i.uv);
                fixed2 dissovleSmooth = smoothstep(dissovleColor, _clipTime , _clipTime+_clipTime) * _power;
                fixed dissovleStep = step(_clipTime, dissovleColor);
                fixed4 mainColor = tex2D(_MainTex, dissovleSmooth) * dissovleStep;
                
                return fixed4(mainColor.rgb,dissovleStep); ;
            }
            ENDCG
        }
    }
}