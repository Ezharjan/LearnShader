Shader "Custom/BasicShader"{

    Properties{
        //_Color: 内部需要注册的参数
        //Base Color: 给外部提供的接口名称
        //Color: 类型
        //等号右边表示该类型下的改参数默认值
        _Color("Base Color", Color) = (1,0,1,1)
        _MainTex("Base(RGB)", 2D) = "white"{}
    }


    //一个Shader至少要有一个SubShader
    SubShader{
        
        //全局标签，可选
        Tags{
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
        }

        //全局渲染设置，可选
        Blend SrcAlpha OneMinusSrcAlpha


        //一个SubShader至少有一个Pass
        Pass{
            //名称
            Name "Simple"

            //本Pass中使用的渲染设置
            Cull off

            //撰写CG/HLSL开始标头；如果是GLSL时改成 GLSLPROGRAM
            CGPROGRAM
            //需要使用的参数及其简写
            #pragma vertex vert
            #pragma fragment frag
            //使用到的库
            #include "UnityCG.cginc"

            //使用内部参数名及对应变量类型注册对外提供的接口参数
            float4 _Color;
            sampler2D _MainTex;

            //自定义结构体
            struct v2f{
                float4 pos : POSITION;
                float4 uv : TEXCOORD0;
            };

            //对需要使用的CG/HLSL参数vertex进行实现
            v2f vert(appdata_base v){
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex); // Change the axis from itself to the world space
                o.uv = v.texcoord;

                return o;
            }

            //对需要使用的CG/HLSL参数fragment进行实现
            half4 frag(v2f i) : COLOR{
                half4 color = tex2D(_MainTex, i.uv.xy) * _Color;
                return color;
            }
            

            //撰写CG/HLSL完毕标头；如果是GLSL时改成 ENDGLSL
            ENDCG

        }
    }

    //默认在任何一个SubShader都不起作用的时候执行
    FallBack "DIFFUSE"
}
