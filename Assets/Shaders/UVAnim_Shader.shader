Shader "Custom/UVAnim_Shader"
{
    Properties
    {
        _Color("Base Color", Color) = (1,1,1,1)
        _MainTex("Base(RGB)", 2D) = "white" {}
    }
    
    SubShader
    {
        tags{"Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True"}
        Blend SrcAlpha OneMinusSrcAlpha
        Cull off

        Pass
        {
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            float4 _Color;
            sampler2D _MainTex;
            
            struct v2f
            {
                float4 pos:POSITION;
                float2 uv:TEXCOORD0;
            };
            
            float2 moveUV(float2 vertUV)
            {
                float textureNum = 12.0;
                float timePerFrame = 100;
                
                float index = frac(_Time.x / textureNum * timePerFrame);
                float2 uvScale = float2(1 / textureNum, 1);
                
                if(index <= uvScale.x)
                return vertUV * uvScale;
                else if(index <= 2 * uvScale.x)	
                return vertUV * uvScale + float2(uvScale.x, 0.0);
                else if(index <= 3 * uvScale.x)
                return vertUV * uvScale + float2(2 * uvScale.x, 0.0);
                else if(index <= 4 * uvScale.x)	
                return vertUV * uvScale + float2(3 * uvScale.x, 0.0);
                else if(index <= 5 * uvScale.x)
                return vertUV * uvScale + float2(4 * uvScale.x, 0.0);
                else if(index <= 6 * uvScale.x)
                return vertUV * uvScale + float2(5 * uvScale.x, 0.0);
                else if(index <= 7 * uvScale.x)	
                return vertUV * uvScale + float2(6 * uvScale.x, 0.0);
                else if(index <= 8 * uvScale.x)
                return vertUV * uvScale + float2(7 * uvScale.x, 0.0);
                else if(index <= 9 * uvScale.x)	
                return vertUV * uvScale + float2(8 * uvScale.x, 0.0);
                else if(index <= 10 * uvScale.x)
                return vertUV * uvScale + float2(9 * uvScale.x, 0.0);
                else if(index <= 11 * uvScale.x)
                return vertUV * uvScale + float2(10 * uvScale.x, 0.0);
                else
                return vertUV * uvScale + float2(11 * uvScale.x, 0.0);
            }
            
            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = moveUV(v.texcoord.xy);
                //o.uv = v.texcoord.xy * float2(1.0 / 12.0, 1.0);
                return o;
            }
            
            half4 frag(v2f i):COLOR
            {	
                half4 c = tex2D(_MainTex , i.uv) * _Color;
                return c;
            }
            
            ENDCG
        }
    }
}