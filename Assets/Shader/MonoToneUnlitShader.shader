Shader "Unlit/MonoToneUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            
            fixed4 frag (v2f_img i) : COLOR
            {
                fixed4 color = tex2D(_MainTex,i.uv);
                float grayColor = color.r * 0.3 + color.g * 0.6 + color.b * 0.1;
                return fixed4(grayColor, grayColor, grayColor, color.a);
            }
            ENDCG
        }
    }
}
