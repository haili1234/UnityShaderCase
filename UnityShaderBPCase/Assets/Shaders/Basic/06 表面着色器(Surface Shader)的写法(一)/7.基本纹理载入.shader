﻿Shader "BP/Custom/7.基本纹理载入"
{
    //--------------------------------【属性】----------------------------------------
    Properties
    {
        _MainTex ("【主纹理】Texture", 2D) = "white" {}
    }

    //--------------------------------【子着色器】----------------------------------
    SubShader
    {
        //-----------子着色器标签----------
        Tags
        {
            "RenderType" = "Opaque"
        }

        //-------------------开始CG着色器编程语言段----------------- 
        CGPROGRAM

		//【1】光照模式声明：使用兰伯特光照模式
		#pragma surface surf Lambert

		//【2】输入结构  
		struct Input 
		{
			//纹理的uv值
			float2 uv_MainTex;
		};

		//变量声明
		sampler2D _MainTex;

		//【3】表面着色函数的编写
		void surf (Input IN, inout SurfaceOutput o) 
		{
			//从纹理获取rgb颜色值
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
		}

		//-------------------结束CG着色器编程语言段------------------  
		ENDCG
    }

    //“备胎”为普通漫反射  
    Fallback "Diffuse"
}