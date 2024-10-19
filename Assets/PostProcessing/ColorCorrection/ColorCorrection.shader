Shader "Hidden/ColorCorrection"
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

            sampler2D _MainTex;
            float _Contrast, _Brightness, _Saturation, _Gamma, _MaxWhite;

            float luminance(float3 color) {
                return dot(color, float3(0.299f, 0.587f, 0.114f));
            }

            float3 reinhard(float3 color, float max_white)
            {

                // reinhard algorithm
                //                c * (1 + c / maxWhite^2 )
                //color     =  --------------------------------
                //                          1 + c

                //its better to do it with gray than rgb
                //C_out = C_in * (L_out / L_in)

                float l_in = luminance(color);
                float whitePower = max_white * max_white;
                float l_out = l_in * (1.0f + (l_in / float3(whitePower.xxx))) / (1.0f + l_in);
                
                float3 C_out = color * (l_out / l_in);
                return C_out;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);

                //to convert from gamma to linear col^2.2  in inverse use col ^ (1/2.2)

                //contrast is increasing the light of light pixel and decreasing light of dark pixel
                //brightness increase of decrease light of all pixels thats why range from -1 to 1;
                col = _Contrast* (col - 0.5f) + 0.5f + _Brightness;
                col = max(col, 0);

                float4 grayColor = luminance(col);
                col = lerp(grayColor, col, _Saturation);
                col = max(col, 0);

                //ToneMapping
                col = saturate(float4(reinhard(col.rgb, _MaxWhite), 1));

                //gamma correction increase dark color leaving lightcolors
                col = saturate(pow(col, _Gamma));
                return col;
            }
            ENDCG
        }
    }
}
