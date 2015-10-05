Shader "Custom/MaskedGlow"
{
	Properties
	{
		_Color ( "Color", Color ) = ( 1, 1, 1, 1 )
		_Color2 ( "Color2", Color ) = ( 1, 1, 1, 1 )
		_Color3 ( "Color3", Color ) = ( 1, 1, 1, 1 )
		
		_ColorMask ( "Color Mask", 2D ) = "white" {}
		
		_RimColor ( "Rim Color", Color ) = ( 1, 1, 1, 1 )
		_RimPower ( "Rim Power", float ) = 1
		
		_Glossiness ( "Glossiness", Range( 0, 1 ) ) = 0
		_Metallic ( "Metallic", Range( 0, 1 ) ) = 0
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard addshadow

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0
		#include "BooShaderUtils.cginc"

		sampler2D _ColorMask;

		struct Input
		{
			float2 uv_ColorMask;
			float3 viewDir;
			float3 norm;
		};

		fixed4 _RimColor;
		float _RimPower;

		half _Glossiness;
		half _Metallic;
		
		fixed4 _Color;
		fixed4 _Color2;
		fixed4 _Color3;
		
		void surf( Input IN, inout SurfaceOutputStandard o )
		{
			float4 c = tex2D( _ColorMask, IN.uv_ColorMask );
			if ( c.r > 0.9 )
			{
				c = _Color;
			}
			else if ( c.g > 0.9 )
			{
				c = _Color2;
			}
			else if ( c.b > 0.9 )
			{
				c = _Color3;
			}
			// Could add another check for the alpha channel here

			o.Albedo = c.rgb;
			o.Alpha = c.a;

			half rim = 1.0 - saturate( dot ( normalize( IN.viewDir ), o.Normal ) );
			o.Emission = _RimColor.rgb * pow ( rim, _RimPower );
			
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
