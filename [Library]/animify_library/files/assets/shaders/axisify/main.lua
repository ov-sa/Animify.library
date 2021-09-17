----------------------------------------------------------------
--[[ Resource: Animify Library
     Shaders: axisify: main.lua
     Server: -
     Author: OvileAmriam
     Developer: Aviril
     DOC: 08/09/2021 (OvileAmriam)
     Desc: Axisifier ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local shaderReference = "Axisifier"
local imports = {
    data = "",
    {filePath = "files/assets/shaders/mta-helper.fx"}
}


----------------
--[[ Shader ]]--
----------------

for i, j in ipairs(imports) do
    local fileData = getFileData(j.filePath)
    if fileData then
        imports.data = imports.data.."\n"..fileData
    end
end

AVAILABLE_SHADERS[shaderReference] = [[
/*---------------
-->> Imports <<--
-----------------*/

]]..imports.data..[[

/*-----------------
-->> Variables <<--
-------------------*/

float axisAlpha = 1;
float4 axisColor = float4(1, 1, 1, 1);

struct VSInput {
    float3 Position : POSITION0;
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
    float2 TexCoord1 : TEXCOORD1;
};

struct PSInput {
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float4 Specular : COLOR1;
    float2 TexCoord : TEXCOORD0;
    float3 Normal : TEXCOORD1;
    float4 WorldPos : TEXCOORD2;
};


/*----------------
-->> Samplers <<--
------------------*/

sampler MainSampler = sampler_state {
    Texture = (gTexture0);
};


/*----------------
-->> Handlers <<--
------------------*/

PSInput VertexShaderFunction(VSInput VS) {
    PSInput PS = (PSInput)0;
    PS.TexCoord = VS.TexCoord;
    float4 worldPos = mul(float4(VS.Position. xyz, 1), gWorld);
    PS.WorldPos.xyz = worldPos.xyz;
    float4 viewPos = mul(worldPos, gView);
    PS.WorldPos.w = viewPos.z / viewPos.w;
    PS.Position = mul(viewPos, gProjection);
    PS.Diffuse = axisColor;
    PS.Diffuse.a = axisAlpha;
    return PS; 
} 

float4 PixelShaderFunction(PSInput PS) : COLOR0 {
    float4 texel = tex2D(MainSampler, PS.TexCoord);
    float4 finalColor = texel * PS.Diffuse;
    return finalColor; 
}


/*------------------
-->> Techniques <<--
--------------------*/

technique axisify {
    pass P0 {
        VertexShader = compile vs_3_0 VertexShaderFunction();
        PixelShader = compile ps_3_0 PixelShaderFunction();
    }
}

technique fallback {
    pass P0 {}
}
]]