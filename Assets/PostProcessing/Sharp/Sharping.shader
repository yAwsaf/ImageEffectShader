Shader "Hidden/Sharping"
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
            int _Amount;

            fixed4 frag(v2f i) : SV_Target
            {
                float neighborFactor = _Amount * -1;
                float centerFactor = _Amount * 4 + 1;

                float4 allNeighbor =
                    (
                    tex2D(_MainTex, i.uv + _MainTex_TexelSize * float2(0,1))+  //up
                    tex2D(_MainTex, i.uv + _MainTex_TexelSize * float2(0, -1))+ //down
                    tex2D(_MainTex, i.uv + _MainTex_TexelSize * float2(1, 0))+ //right
                    tex2D(_MainTex, i.uv + _MainTex_TexelSize * float2(-1, 0)) //left
                    )
                    * neighborFactor
                    ;
                float4 Center = tex2D(_MainTex, i.uv) * centerFactor;

                float4 finalColor = saturate(Center + allNeighbor);
                return finalColor;
            }
            ENDCG
        }
    }
}
