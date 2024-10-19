Shader "Hidden/Hatching"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _HatchingTex("HatchingTex",2D) = "white" {}
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

            Texture2D _MainTex, _HachingTexute1, _HachingTexute2, _HachingTexute3;
            SamplerState point_clamp_sampler, point_repeat_sampler;
            SamplerState sampler_StippleTexture;
            float _ThreathHold, _Value, _GrayFactor;

            fixed4 frag (v2f i) : SV_Target
            {
                float4 col = _MainTex.Sample(point_clamp_sampler, i.uv);

                float grayColor = dot(col.rgb, float3(0.299, 0.587, 0.114));

                float4 HachingColor;
                if (grayColor <= 0.25f)
                {
                    HachingColor = _HachingTexute1.Sample(point_repeat_sampler, i.uv*3 );
                }
                else if (grayColor <= 0.5f)
                {
                    HachingColor = _HachingTexute2.Sample(point_repeat_sampler, i.uv*3 );
                }
                else
                {
                    HachingColor = _HachingTexute3.Sample(point_repeat_sampler, i.uv*3 );
                }
                //grayColor = grayColor > 0.01f ? float4(1,1,1,1) : float4(0, 0, 0, 1);;
                float hach = HachingColor <= _ThreathHold ? _Value : 0;

                float4 finalColor = hach < grayColor ? float4(1,1,1,1) : float4(0, 0, 0, 1);
                //return HachingColor * grayColor ;
                return finalColor * ((grayColor)*_GrayFactor);
            }
            ENDCG
        }
    }
}
