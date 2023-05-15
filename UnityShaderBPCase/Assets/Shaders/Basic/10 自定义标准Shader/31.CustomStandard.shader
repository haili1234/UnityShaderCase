
Shader "BP/Custom/31.CustomStandard"
{
	//------------------------------------������ֵ��------------------------------------
	Properties
	{
		//����ɫ
		_Color("Color", Color) = (1,1,1,1)
		//������
		_MainTex("Albedo", 2D) = "white" {}

		//Alpha�޳�ֵ
		_Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5
		//ƽ���������
		_Glossiness("Smoothness", Range(0.0, 1.0)) = 0.5

		//������
		[Gamma] _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
		//������������ͼ
		_MetallicGlossMap("Metallic", 2D) = "white" {}

		//��͹�ĳ߶�
		_BumpScale("Scale", Float) = 1.0
		//������ͼ
		_BumpMap("Normal Map", 2D) = "bump" {}

		//�߶����ų߶�
		_Parallax ("Height Scale", Range (0.005, 0.08)) = 0.02
		//�߶�����ͼ
		_ParallaxMap ("Height Map", 2D) = "black" {}

		//�ڵ�ǿ��
		_OcclusionStrength("Strength", Range(0.0, 1.0)) = 1.0
		//�ڵ�����ͼ
		_OcclusionMap("Occlusion", 2D) = "white" {}

		//�Է�����ɫ
		_EmissionColor("Color", Color) = (0,0,0)
		//�Է�������ͼ
		_EmissionMap("Emission", 2D) = "white" {}
		
		//ϸ����Ĥͼ
		_DetailMask("Detail Mask", 2D) = "white" {}

		//ϸ������ͼ
		_DetailAlbedoMap("Detail Albedo x2", 2D) = "grey" {}
		//ϸ�ڷ�����ͼ�߶�
		_DetailNormalMapScale("Scale", Float) = 1.0
		//ϸ�ڷ�����ͼ
		_DetailNormalMap("Normal Map", 2D) = "bump" {}

		//����������UV����
		[Enum(UV0,0,UV1,1)] _UVSec ("UV Set for secondary textures", Float) = 0

		//���״̬�Ķ���
		[HideInInspector] _Mode ("__mode", Float) = 0.0
		[HideInInspector] _SrcBlend ("__src", Float) = 1.0
		[HideInInspector] _DstBlend ("__dst", Float) = 0.0
		[HideInInspector] _ZWrite ("__zw", Float) = 1.0
	}

	//===========��ʼCG��ɫ�����Ա�дģ��===========
	CGINCLUDE
		//BRDF��ص�һ����
		#define UNITY_SETUP_BRDF_INPUT MetallicSetup
	//===========����CG��ɫ�����Ա�дģ��===========
	ENDCG


	//------------------------------------������ɫ��1��------------------------------------
	// ������ɫ������Shader Model 3.0
	//----------------------------------------------------------------------------------------
	SubShader
	{
		//��Ⱦ�������ã���͸��
		Tags { "RenderType"="Opaque" "PerformanceChecks"="False" }

		//ϸ�ڲ����Ϊ��300
		LOD 300
		
		//--------------------------------ͨ��1-------------------------------
		// ���������Ⱦͨ����Base forward pass��
		// ��������⣬�Է��⣬������ͼ�� ...
		Pass
		{
			//����ͨ������
			Name "FORWARD" 

			//��ͨ����ǩ�����ù���ģ��ΪForwardBase��������Ⱦ����ͨ��
			Tags { "LightMode" = "ForwardBase" }

			//��ϲ�����Դ��ϳ���Ŀ����
			Blend [_SrcBlend] [_DstBlend]
			// ����_ZWrite�������������д��ģʽ�������
			ZWrite [_ZWrite]

			//===========����CG��ɫ�����Ա�дģ��===========
			CGPROGRAM

			//��ɫ������Ŀ�꣺Model 3.0
			#pragma target 3.0

			//����ָ���ʹ��GLES��Ⱦ������
			#pragma exclude_renderers gles
			
			// ---------����ָ���ɫ�����������--------
			#pragma shader_feature _NORMALMAP
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _EMISSION
			#pragma shader_feature _METALLICGLOSSMAP 
			#pragma shader_feature ___ _DETAIL_MULX2
			#pragma shader_feature _PARALLAXMAP
			
			//--------��ɫ��������������ָ��------------
			//����ָ�����������Ⱦ����ͨ��������������Ⱦ�У�Ӧ�û������ա���������պͶ���/������͹��գ���������б��塣
			//��Щ�������ڴ�����ͬ�Ĺ�����ͼ���͡���Ҫ�����Դ����Ӱѡ��Ŀ������
			#pragma multi_compile_fwdbase
			//����ָ����뼸����ͬ������������ͬ���͵���Ч(�ر�/����/ָ��/����ָ��/)
			#pragma multi_compile_fog
			
			//����ָ���֪�����������Ƭ����ɫ����������
			#pragma vertex vertForwardBase
			#pragma fragment fragForwardBase

			//��������CGͷ�ļ�
			#include "UnityStandardCore.cginc"

			//===========����CG��ɫ�����Ա�дģ��===========
			ENDCG
		}
		//--------------------------------ͨ��2-------------------------------
		// ���򸽼���Ⱦͨ����Additive forward pass��
		// ��ÿ������һ��ͨ���ķ�ʽӦ�ø��ӵ������ع���
		Pass
		{
			//����ͨ������
			Name "FORWARD_DELTA"

			//��ͨ����ǩ�����ù���ģ��ΪForwardAdd��������Ⱦ����ͨ��
			Tags { "LightMode" = "ForwardAdd" }

			//��ϲ�����Դ��ϳ���1
			Blend [_SrcBlend] One

			//����ͨ���е���ЧӦ��Ϊ��ɫ
			Fog { Color (0,0,0,0) } 

			//�ر����д��ģʽ
			ZWrite Off
			//������Ȳ���ģʽ��С�ڵ���
			ZTest LEqual

			//===========����CG��ɫ�����Ա�дģ��===========
			CGPROGRAM

			//��ɫ������Ŀ�꣺Model 3.0
			#pragma target 3.0
			//����ָ���ʹ��GLES��Ⱦ������
			#pragma exclude_renderers gles

			// ---------����ָ���ɫ�����������--------
			#pragma shader_feature _NORMALMAP
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature ___ _DETAIL_MULX2
			#pragma shader_feature _PARALLAXMAP
			
			//--------ʹ��Unity���õ���ɫ��������������ָ��------------
			//����ָ�����������Ⱦ����ͨ����������б��壬��ͬʱΪ����ͨ���Ĵ��������˹���ʵʱ��Ӱ��������
			#pragma multi_compile_fwdadd_fullshadows
			//����ָ����뼸����ͬ������������ͬ���͵���Ч(�ر�/����/ָ��/����ָ��/)
			#pragma multi_compile_fog

			//����ָ���֪�����������Ƭ����ɫ����������
			#pragma vertex vertForwardAdd
			#pragma fragment fragForwardAdd

			//��������CGͷ�ļ�
			#include "UnityStandardCore.cginc"

			//===========����CG��ɫ�����Ա�дģ��===========
			ENDCG
		}

		// --------------------------------ͨ��3-------------------------------
		//  ��Ӱ��Ⱦͨ����Shadow Caster pass��
		//  ��������������Ⱦ����Ӱ��ͼ�����������
		Pass 
		{
			//����ͨ������
			Name "ShadowCaster"
			//��ͨ����ǩ�����ù���ģ��ΪShadowCaster��
			//�˹���ģ�ʹ����Ž�����������Ⱦ����Ӱ��ͼ�����������
			Tags { "LightMode" = "ShadowCaster" }

			//��������д��ģʽ
			ZWrite On 
			//������Ȳ���ģʽ��С�ڵ���
			ZTest LEqual

			//===========����CG��ɫ�����Ա�дģ��===========
			CGPROGRAM

			//��ɫ������Ŀ�꣺Model 3.0
			#pragma target 3.0

			//����ָ���ʹ��GLES��Ⱦ������
			#pragma exclude_renderers gles
			

			// ---------����ָ���ɫ�����������--------
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			
			//--------��ɫ��������������ָ��------------
			//������ӰͶ����صĶ���ɫ������ı���
			#pragma multi_compile_shadowcaster

			//����ָ���֪�����������Ƭ����ɫ����������
			#pragma vertex vertShadowCaster
			#pragma fragment fragShadowCaster
			
			//��������CGͷ�ļ�
			#include "UnityStandardShadow.cginc"

			//===========����CG��ɫ�����Ա�дģ��===========
			ENDCG
		}

		// --------------------------------ͨ��4-------------------------------
		//  �ӳ���Ⱦͨ����Deferred Render Pass��
		Pass
		{
			//����ͨ������
			Name "DEFERRED"
			//��ͨ����ǩ�����ù���ģ��ΪDeferred���ӳ���Ⱦͨ��
			Tags { "LightMode" = "Deferred" }

			CGPROGRAM
			#pragma target 3.0
			// TEMPORARY: GLES2.0 temporarily disabled to prevent errors spam on devices without textureCubeLodEXT
			#pragma exclude_renderers nomrt gles
			

			//---------����ָ���ɫ�������������shader_feature��--------
			#pragma shader_feature _NORMALMAP
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _EMISSION
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature ___ _DETAIL_MULX2
			#pragma shader_feature _PARALLAXMAP

			//---------����ָ���ɫ�������������multi_compile��--------
			#pragma multi_compile ___ UNITY_HDR_ON
			#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
			#pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
			#pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
			
			//����ָ���֪�����������Ƭ����ɫ����������
			#pragma vertex vertDeferred
			#pragma fragment fragDeferred

			//��������CGͷ�ļ�
			#include "UnityStandardCore.cginc"

			//===========����CG��ɫ�����Ա�дģ��===========
			ENDCG
		}

		// --------------------------------ͨ��5-------------------------------
		//Ԫͨ����Meta Pass��
		//Ϊȫ�ֹ��գ�GI����������ͼ�ȼ�����ȡ��ز������磨emission, albedo�Ȳ���ֵ��
		//��ͨ�������ڳ������Ⱦ������ʹ��
		Pass
		{
			//����ͨ������
			Name "META" 

			//��ͨ����ǩ�����ù���ģ��ΪMeta
			//����ֹ2015��10��22�գ�Unity 5.2.1�Ĺٷ��ĵ��в�û����¼�˹���ģ�ͣ�Ӧ����Unity�ٷ�����©��
			Tags { "LightMode"="Meta" }
			//�ر��޳�����
			Cull Off

			//===========����CG��ɫ�����Ա�дģ��===========
			CGPROGRAM

			//����ָ���֪�����������Ƭ����ɫ����������
			#pragma vertex vert_meta
			#pragma fragment frag_meta

			//---------����ָ���ɫ�����������--------
			#pragma shader_feature _EMISSION
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature ___ _DETAIL_MULX2

			//��������CGͷ�ļ�
			#include "UnityStandardMeta.cginc"

			//===========����CG��ɫ�����Ա�дģ��===========
			ENDCG
		}
	}

	//------------------------------------������ɫ��2��-----------------------------------
	// ������ɫ������Shader Model 2.0
	//----------------------------------------------------------------------------------------
	SubShader
	{
		//��Ⱦ�������ã���͸��
		Tags { "RenderType"="Opaque" "PerformanceChecks"="False" }
		//ϸ�ڲ����Ϊ��150
		LOD 150

		//--------------------------------ͨ��1-------------------------------
		// ���������Ⱦͨ����Base forward pass��
		// ��������⣬�Է��⣬������ͼ�� ...
		Pass
		{
			//����ͨ������
			Name "FORWARD" 
			//��ͨ����ǩ�����ù���ģ��ΪForwardBase��������Ⱦ����ͨ��
			Tags { "LightMode" = "ForwardBase" }
			//��ϲ�����Դ��ϳ���Ŀ���ϣ������Ϊ���ߵĻ��
			Blend [_SrcBlend] [_DstBlend]
			// ����_ZWrite�������������д��ģʽ�������
			ZWrite [_ZWrite]

			//===========����CG��ɫ�����Ա�дģ��===========
			CGPROGRAM
			//��ɫ������Ŀ�꣺Model 2.0
			#pragma target 2.0

			// ---------����ָ���ɫ�����������--------
			#pragma shader_feature _NORMALMAP
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _EMISSION 
			#pragma shader_feature _METALLICGLOSSMAP 
			#pragma shader_feature ___ _DETAIL_MULX2
			// SM2.0: NOT SUPPORTED shader_feature _PARALLAXMAP

			//�������±���ı��룬�򻯱������
			#pragma skip_variants SHADOWS_SOFT DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
			
			//--------��ɫ��������������ָ��------------
			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog

			//����ָ���֪�����������Ƭ����ɫ����������
			#pragma vertex vertForwardBase
			#pragma fragment fragForwardBase

			//��������CGͷ�ļ�
			#include "UnityStandardCore.cginc"

			//===========����CG��ɫ�����Ա�дģ��===========
			ENDCG
		}

		//--------------------------------ͨ��2-------------------------------
		// ���򸽼���Ⱦͨ����Additive forward pass��
		// ��ÿ������һ��ͨ���ķ�ʽӦ�ø��ӵ������ع���
		Pass
		{
			//����ͨ������
			Name "FORWARD_DELTA"

			//��ͨ����ǩ�����ù���ģ��ΪForwardAdd��������Ⱦ����ͨ��
			Tags { "LightMode" = "ForwardAdd" }

			//��ϲ�����Դ��ϳ���1
			Blend [_SrcBlend] One

			//����ͨ���е���ЧӦ��Ϊ��ɫ
			Fog { Color (0,0,0,0) } 

			//�ر����д��ģʽ
			ZWrite Off

			//������Ȳ���ģʽ��С�ڵ���
			ZTest LEqual

			//===========����CG��ɫ�����Ա�дģ��===========
			CGPROGRAM
			//��ɫ������Ŀ�꣺Model 2.0
			#pragma target 2.0

			// ---------����ָ���ɫ�����������--------
			#pragma shader_feature _NORMALMAP
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature ___ _DETAIL_MULX2

			//����һЩ����ı���
			// SM2.0: NOT SUPPORTED shader_feature _PARALLAXMAP
			#pragma skip_variants SHADOWS_SOFT

			//--------ʹ��Unity���õ���ɫ��������������ָ��------------
			//����ָ�����������Ⱦ����ͨ����������б��壬��ͬʱΪ����ͨ���Ĵ��������˹���ʵʱ��Ӱ��������
			#pragma multi_compile_fwdadd_fullshadows
			//����ָ����뼸����ͬ������������ͬ���͵���Ч(�ر�/����/ָ��/����ָ��/)
			#pragma multi_compile_fog

			//����ָ���֪�����������Ƭ����ɫ����������
			#pragma vertex vertForwardAdd
			#pragma fragment fragForwardAdd

			//��������CGͷ�ļ�
			#include "UnityStandardCore.cginc"

			//===========����CG��ɫ�����Ա�дģ��===========
			ENDCG
		}

		// --------------------------------ͨ��3-------------------------------
		//  ��Ӱ��Ⱦͨ����Shadow Caster pass��
		//  ��������������Ⱦ����Ӱ��ͼ�����������
		Pass 
		{
			//����ͨ������
			Name "ShadowCaster"

			//��ͨ����ǩ�����ù���ģ��ΪShadowCaster��
			//�˹���ģ�ʹ����Ž�����������Ⱦ����Ӱ��ͼ�����������
			Tags { "LightMode" = "ShadowCaster" }

			//��������д��ģʽ
			ZWrite On

			//������Ȳ���ģʽ��С�ڵ���
			ZTest LEqual

			//===========����CG��ɫ�����Ա�дģ��===========
			CGPROGRAM
			//��ɫ������Ŀ�꣺Model 2.0
			#pragma target 2.0

			//---------����ָ���ɫ�������������shader_feature��--------
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			
			//����ָ�����ĳЩ����ı���
			#pragma skip_variants SHADOWS_SOFT

			//��ݱ���ָ�������ӰͶ����صĶ���ɫ������ı���
			#pragma multi_compile_shadowcaster

			//����ָ���֪�����������Ƭ����ɫ����������
			#pragma vertex vertShadowCaster
			#pragma fragment fragShadowCaster

			//��������CGͷ�ļ�
			#include "UnityStandardShadow.cginc"

			//===========����CG��ɫ�����Ա�дģ��===========
			ENDCG
		}

		// --------------------------------ͨ��4-------------------------------
		//Ԫͨ����Meta Pass��
		//Ϊȫ�ֹ��գ�GI����������ͼ�ȼ�����ȡ��ز������磨emission, albedo�Ȳ���ֵ��
		//��ͨ�������ڳ������Ⱦ������ʹ��
		Pass
		{
			//����ͨ������
			Name "META" 

			//��ͨ����ǩ�����ù���ģ��ΪMeta
			//����ֹ2015��10��22�գ�Unity 5.2.1�Ĺٷ��ĵ��в�û����¼�˹���ģ�ͣ�Ӧ����Unity�ٷ�����©��
			Tags { "LightMode"="Meta" }
			//�ر��޳�����
			Cull Off

			//===========����CG��ɫ�����Ա�дģ��===========
			CGPROGRAM

			//����ָ���֪�����������Ƭ����ɫ����������
			#pragma vertex vert_meta
			#pragma fragment frag_meta

			//---------����ָ���ɫ�����������--------
			#pragma shader_feature _EMISSION
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature ___ _DETAIL_MULX2

			//��������CGͷ�ļ�
			#include "UnityStandardMeta.cginc"

			//===========����CG��ɫ�����Ա�дģ��===========
			ENDCG
		}
	}

	//����ShaderΪ�������Shader
	FallBack "VertexLit"
	//ʹ���ض����Զ���༭��UI����
	CustomEditor "StandardShaderGUI"
}
