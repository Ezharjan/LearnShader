Shader "Custom/LightMap"{

    Properties{
        _Color("Base Color", Color) = (1,1,1,1)
        _MainTex("Base(RGB)", 2D) = "white"{}
        _LightMap("Light Map", 2D) = "white"{}
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
            sampler2D _LightMap;

            struct v2f{
                float4 pos : POSITION;
                float4 uv : TEXCOORD0;
                float2 uvLM : TEXCOORD1;
            };

            v2f vert(appdata_full v){
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex); // Change the axis from itself to the world space
                o.uv = v.texcoord;
                o.uvLM = v.texcoord1.xy; // use appdata_full to get texcoord1 of v

                return o;
            }

            half4 frag(v2f i) : COLOR{
                half4 color = tex2D(_MainTex, i.uv.xy) * _Color;
                // half4 lightMap = tex2D(_LightMap, i.uvLM);
                half3 lightMap = DecodeLightmap(tex2D(_LightMap, i.uvLM));
                // half3 lightMap = 8.0 * (tex2D(_LightMap, i.uvLM)).a * (tex2D(_LightMap, i.uvLM)).rgb; // equals to the line above
                color.rgb *= lightMap;

                // return color * lightMap; // mix the two together
                return color; 
            }
            

            ENDCG

        }
    }
    FallBack "DIFFUSE"
}
