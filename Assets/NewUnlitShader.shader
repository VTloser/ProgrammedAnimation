Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Off("Off", Vector) = (1.0, 1.0, 1.0, 1.0)
        _Scale("Scale", Vector) = (1.0, 1.0, 1.0, 1.0)

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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Off;
            float4 _Scale;

            v2f vert (appdata v)
            {
                v2f o;
                float4x4 m = float4x4(
                    _Scale.x, 0, 0, _Off.x, //第一行
                    0, _Scale.y, 0, _Off.y, //第二行
                    0, 0, _Scale.z, _Off.z, //第三行
                    0, 0, 0, 0
                    );


                o.vertex = UnityObjectToClipPos(mul(m , v.vertex) );
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
