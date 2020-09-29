// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Simple"{

    Properties{
        _Color("Base Color", Color) = (1,1,1,1)
        _MainTex("Base(RGB)", 2D) = "white"{}
    }


    SubShader{
        
        Tags{
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
        }

        Blend SrcAlpha OneMinusSrcAlpha


        Pass{
            Name "Simple"
            Cull off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float4 _Color;
            sampler2D _MainTex;
            

            struct v2f{
                float4 pos : POSITION;
                float4 uv : TEXCOORD0;
                float4 col : COLOR;
            };

            v2f vert(appdata_base v){
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex); // Change the axis from itself to the world space
                o.uv = v.texcoord;
                o.col.xyz = v.normal * 0.5 + 0.5; // normal取值范围是(-1,1)，将其矫正到(0,1)之间
                o.col.w = 1.0;

                return o;
            }

            half4 frag(v2f i) : COLOR{
                // half4 color = tex2D(_MainTex, i.uv.xy) * _Color;
                // half4 color = i.col; 
                half4 color = tex2D(_MainTex, i.uv.xy) * i.col * _Color;
                return color;
            }
            

            ENDCG

        }
    }
    FallBack "DIFFUSE"
}
