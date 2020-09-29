Shader "Custom/Tilling"{

    Properties{
        _Color("Base Color", Color) = (1,1,1,1)
        _MainTex("Base(RGB)", 2D) = "white"{}
        _DetailTex("DetailTex", 2D) = "white"{}
        _DetailU("DetailU", float) = 1.0
        _DetailV("DetailV", float) = 1.0
    }


    SubShader{
        
        Tags{
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
        }

        Blend SrcAlpha OneMinusSrcAlpha


        Pass{
            Name "Tilling"
            Cull off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float4 _Color;
            sampler2D _MainTex;
            sampler2D _DetailTex;
            float _DetailU;
            float _DetailV;

            struct v2f{
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };

            float4 _DetailTex_ST;
            v2f vert(appdata_base v){
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy;

                return o;
            }

            half4 frag(v2f i) : COLOR{
                half4 color = tex2D(_MainTex, i.uv) * _Color;
                half4 d = tex2D(_DetailTex, i.uv * float2(_DetailU, _DetailV));
                return color * d;
            }
            

            ENDCG

        }
    }
    FallBack "DIFFUSE"
}
