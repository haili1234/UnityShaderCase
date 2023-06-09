﻿Shader "BP/Custom/22.RGB cube v2"
{
    //------------------------------------【属性值】------------------------------------
    Properties
    {
        //单项颜色调节变量
        _ColorValue("Color", Range(0.0, 1.0)) = 0.6
    }

    //------------------------------------【唯一的子着色器】------------------------------------
    SubShader
    {
        //--------------------------------唯一的通道-------------------------------
        Pass
        {
            //===========开启CG着色器语言编写模块============
            CGPROGRAM

			//编译指令:告知编译器顶点和片段着色函数的名称
			#pragma vertex vert
			#pragma fragment frag

			//顶点着色器输出结构
			struct vertexOutput
			{
				float4 positon : SV_POSITION;
				float4 color : TEXCOORD0;
			};

			//变量声明
			uniform float _ColorValue;

			//--------------------------------【顶点着色函数】-----------------------------
			// 输入：POSITION语义
			// 输出：顶点输出结构体
			//---------------------------------------------------------------------------------
			vertexOutput vert(float4 vertexPos : POSITION)
			{
				//实例化一个vertexOutput输出结构
				vertexOutput output;

				//坐标系变换:将三维空间中的坐标投影到二维窗口
				output.positon = UnityObjectToClipPos(vertexPos);
				//输出颜色为顶点位置加上一个颜色偏移量
				output.color = vertexPos + float4(_ColorValue, _ColorValue, _ColorValue, 0.0);

				//返回最终的值
				return output;
			}
			
			//--------------------------------【片段着色函数】-----------------------------
			// 输入：vertexOutput结构体
			// 输出：COLOR语义（颜色值）
			//---------------------------------------------------------------------------------
			float4 frag(vertexOutput input) : COLOR
			{
				//直接返回输入的颜色值
				return input.color;
			}

			//===========结束CG着色器语言编写模块===========
			ENDCG
        }
    }
}