Shader "Custom/DefaultGlow"
{
	Properties
	{
		_Color ( "Color", Color ) = ( 1, 1, 1, 1 )
		
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

		sampler2D _BumpMap; // Need this to get normals

		struct Input
		{
			float3 viewDir;
		};

		fixed4 _RimColor;
		float _RimPower;

		half _Glossiness;
		half _Metallic;
		
		fixed4 _Color;

		void surf( Input IN, inout SurfaceOutputStandard o )
		{
			o.Albedo = _Color.rgb;
			o.Alpha = _Color.a;

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