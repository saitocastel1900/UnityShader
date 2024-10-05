Shader "Unlit/Rotate"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RotateSpeed("RotateSpeed",Range(0,10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _RotateSpeed;

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
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half timer = _Time.x;

                half angleCos = cos(timer*_RotateSpeed);
                half angleSin = sin(timer*_RotateSpeed);

                /*       |cosΘ -sinΘ|
                R(Θ) = |sinΘ  cosΘ|  2次元回転行列の公式*/
                half2x2 rotateMatrix = half2x2(angleCos, -angleSin, angleSin, angleCos);

                half2 uv = i.uv - 0.5;

                i.uv = mul(rotateMatrix, uv) + 0.5;
                
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
