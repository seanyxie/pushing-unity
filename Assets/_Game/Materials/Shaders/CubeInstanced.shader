Shader "Tarodev/CubeInstanced2"
{
    Properties
    {
        _FarColor("Far color", Color) = (.2, .2, .2, 1)
    }
    SubShader
    {
        Pass
        {
            Tags
            {
                "RenderType"="Opaque"
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            #include "AutoLight.cginc"

            float4 _FarColor;

            StructuredBuffer<float4> position_buffer_1;
            StructuredBuffer<float4> position_buffer_2;
            float4 color_buffer[32];

            struct v2_f
            {
                float4 vertex : SV_POSITION;
                float3 ambient : TEXCOORD1;
                float3 diffuse : TEXCOORD2;
                float3 color : TEXCOORD3;
                
            };

            v2_f vert(appdata_base v, const uint instance_id : SV_InstanceID)
            {
                float4 start = position_buffer_1[instance_id];
                float4 end = position_buffer_2[instance_id];

                const float t = (sin(_Time.y + start.w) + 1) / 2;

                const float3 world_start = start.xyz + v.vertex.xyz;
                const float3 world_end = end.xyz + v.vertex.xyz;

                const float3 pos = lerp(world_start, world_end, t);
                const float3 color = lerp(color_buffer[end.w], _FarColor, t);

                v2_f o;
                o.vertex = mul(UNITY_MATRIX_VP, float4(pos, 1.0f));
                o.ambient = ShadeSH9(float4(v.normal, 1.0f));
                o.diffuse = (saturate(dot(v.normal, _WorldSpaceLightPos0.xyz)) * _LightColor0.rgb);
                o.color = color;


                return o;
            }

            fixed4 frag(const v2_f i) : SV_Target
            {
                const float3 lighting = i.diffuse * SHADOW_ATTENUATION(i) + i.ambient;
                return fixed4(i.color * lighting, 1);;
            }
            ENDCG
        }
    }
}

//
//{
//    Properties
//    {
//        _FarColor("Far color", Color) = (.2, .2, .2, 1)
//    }
//    SubShader
//    {
//        Pass
//        {
//            Tags
//            {
//                "RenderType"="Opaque"
//            }
//
//            CGPROGRAM
//            #pragma vertex vert
//            #pragma fragment frag
//            #pragma multi_compile_instancing
//
//            #include "UnityCG.cginc"
//            #include "UnityLightingCommon.cginc"
//            #include "AutoLight.cginc"
//
//            float4 _FarColor;
//
//            StructuredBuffer<float4> position_buffer_1;
//            StructuredBuffer<float4> position_buffer_2;
//            float4 color_buffer[32];
//
//            struct v2_f
//            {
//                float4 vertex : SV_POSITION;
//                float3 ambient : TEXCOORD1;
//                float3 diffuse : TEXCOORD2;
//                float3 color : TEXCOORD3;
//            };
//
//            v2_f vert(appdata_base v, const uint instance_id : SV_InstanceID)
//            {
//                float4 start = position_buffer_1[instance_id];
//                float4 end = position_buffer_2[instance_id];
//
//                const float t = (sin(_Time.y + start.w) + 1) / 2;
//
//                const float3 world_start = start.xyz + v.vertex.xyz;
//                const float3 world_end = end.xyz + v.vertex.xyz;
//
//                const float3 pos = lerp(world_start, world_end, t);
//                const float3 color = lerp(color_buffer[end.w], _FarColor, t);
//
//                v2_f o;
//                o.vertex = mul(UNITY_MATRIX_VP, float4(pos, 1.0f));
//                o.ambient = ShadeSH9(float4(v.normal, 1.0f));
//                o.diffuse = (saturate(dot(v.normal, _WorldSpaceLightPos0.xyz)) * _LightColor0.rgb);
//                o.color = color;
//
//
//                return o;
//            }
//
//            fixed4 frag(const v2_f i) : SV_Target
//            {
//                const float3 lighting = i.diffuse * SHADOW_ATTENUATION(i) + i.ambient;
//                return fixed4(i.color * lighting, 1);;
//            }
//            ENDCG
//        }
//    }
//}