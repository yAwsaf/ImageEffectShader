Shader "Hidden/SobelEdgeDetection"
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
            float4 _MainTex_TexelSize;
            float _ThreathHold;
            // 1 0 -1

            fixed4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);
                float Gx =
                    (
                    tex2D(_MainTex, i.uv + _MainTex_TexelSize * (1,-1)) + 
                    (2 * tex2D(_MainTex, i.uv + _MainTex_TexelSize * (0, -1))) + 
                    tex2D(_MainTex, i.uv + _MainTex_TexelSize * (-1, -1))  
                    ) - 
                    (
                    tex2D(_MainTex, i.uv + _MainTex_TexelSize * (1, 1)) +
                    (2 * tex2D(_MainTex, i.uv + _MainTex_TexelSize * (0, 1))) +
                    tex2D(_MainTex, i.uv + _MainTex_TexelSize * (-1, 1)) 
                    );
                float Gy =
                    (
                    tex2D(_MainTex, i.uv + _MainTex_TexelSize * (1, -1)) +
                    (2 * tex2D(_MainTex, i.uv + _MainTex_TexelSize * (1, 0))) +
                    tex2D(_MainTex, i.uv + _MainTex_TexelSize * (1, 1))
                    ) -
                    (
                    tex2D(_MainTex, i.uv + _MainTex_TexelSize * (-1, -1)) +
                    (2 * tex2D(_MainTex, i.uv + _MainTex_TexelSize * (-1, 0))) +
                    tex2D(_MainTex, i.uv + _MainTex_TexelSize * (-1, 1))
                    );
                float G = dot(Gx, Gx) + dot(Gy, Gy);
                float4 FinalColor = G > _ThreathHold * _ThreathHold ? float4(0, 0, 0, 1) : float4(1, 1, 1, 1);
                return FinalColor * col;
            }
            ENDCG
        }
    }
}
