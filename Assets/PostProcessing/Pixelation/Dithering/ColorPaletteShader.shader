Shader "Hidden/ColorPaletteShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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

            Texture2D _MainTex;
            SamplerState point_clamp_sampler;
            Texture2D _ColorPalette;
            int _Inverse;

            float luminance(float3 color) 
            {
                return dot(color, float3(0.299f, 0.587f, 0.114f));
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 col = _MainTex.Sample(point_clamp_sampler, i.uv);
                float grayColor = luminance(col.rgb);
                float yUV = _Inverse == 0 ? grayColor : 1 - grayColor;
                float3 colorPalette = _ColorPalette.Sample(point_clamp_sampler, float2(0.5f, yUV));
                return float4(colorPalette,1);
            }
            ENDCG
        }
    }
}
