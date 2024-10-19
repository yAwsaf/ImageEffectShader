Shader "Hidden/Dithering"
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
            float4 _MainTex_TexelSize;

            float _Spread;
            int _RedColorCount, _GreenColorCount, _BlueColorCount, _BayerLevel;


            static const int bayer2[2 * 2] = {
                0, 2,
                3, 1
            };

            static const int bayer4[4 * 4] = {
                0, 8, 2, 10,
                12, 4, 14, 6,
                3, 11, 1, 9,
                15, 7, 13, 5
            };

            static const int bayer8[8 * 8] = {
                0, 32, 8, 40, 2, 34, 10, 42,
                48, 16, 56, 24, 50, 18, 58, 26,
                12, 44,  4, 36, 14, 46,  6, 38,
                60, 28, 52, 20, 62, 30, 54, 22,
                3, 35, 11, 43,  1, 33,  9, 41,
                51, 19, 59, 27, 49, 17, 57, 25,
                15, 47,  7, 39, 13, 45,  5, 37,
                63, 31, 55, 23, 61, 29, 53, 21
            };

            float luminance(float3 color) {
                return dot(color, float3(0.299f, 0.587f, 0.114f));
            }

            float GetBayer2(int x, int y) {
                return float(bayer2[(x % 2) + (y % 2) * 2]) * (1.0f / 4.0f) - 0.5f;
            }

            float GetBayer4(int x, int y) {
                return float(bayer4[(x % 4) + (y % 4) * 4]) * (1.0f / 16.0f) - 0.5f;
            }

            float GetBayer8(int x, int y) {
                return float(bayer8[(x % 8) + (y % 8) * 8]) * (1.0f / 64.0f) - 0.5f;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                //int indexX = ( (i.uv.x / _MainTex_TexelSize.x) % 2 * _BayerLevel);
                //int indexY = ((i.uv.y / _MainTex_TexelSize.y) % 2 * _BayerLevel);
                int x = i.uv.x * _MainTex_TexelSize.z;
                int y = i.uv.y * _MainTex_TexelSize.w;

                float bayerValues[3] = { 0, 0, 0 };
                bayerValues[0] = GetBayer2(x, y);
                bayerValues[1] = GetBayer4(x, y);
                bayerValues[2] = GetBayer8(x, y);

                float4 col = _MainTex.Sample(point_clamp_sampler, i.uv) ;
                float3 dithering = col.xyz + bayerValues[_BayerLevel-1] * _Spread;

                dithering.r = floor((_RedColorCount - 1.0f) * dithering.r + 0.5) / (_RedColorCount - 1.0f);
                dithering.g = floor((_GreenColorCount - 1.0f) * dithering.g + 0.5) / (_GreenColorCount - 1.0f);
                dithering.b = floor((_BlueColorCount - 1.0f) * dithering.b + 0.5) / (_BlueColorCount - 1.0f);

                return float4(dithering.xyz,1);
            }
            ENDCG
        }
    }
}
