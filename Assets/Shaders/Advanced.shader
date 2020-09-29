// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Advanced"{

    Properties{
        _Color("Base Color", Color) = (1,1,1,1)
        _MainTex("Base(RGB)", 2D) = "white"{}
        _RotateSpeed("RotateSpeed", Range(1,100)) = 30
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
            float _RotateSpeed;            

            struct v2f{
                float4 pos : POSITION;
                float4 uv : TEXCOORD0;
            };

            v2f vert(appdata_base v){
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex); // Change the axis from itself to the world space
                o.uv = v.texcoord;

                return o;
            }

            half4 frag(v2f i) : COLOR{
                float2 uv = i.uv.xy - float2(0.5, 0.5); // Make the rotationer at the center
                
                float2 rotate = float2(cos(_RotateSpeed * _Time.x), sin(_RotateSpeed * _Time.x));
                uv = float2(uv.x * rotate.x - uv.y * rotate.y, uv.x * rotate.y + uv.y * rotate.x);
                
                uv += float2(0.5, 0.5); // Revert the rotation center
                
                half4 color = tex2D(_MainTex,uv) * _Color;
                return color;
            }
            

            ENDCG

        }
    }
    FallBack "DIFFUSE"
}
