struct vs_input
{
    float3 osPosition           : POSITION;
    float2 texCoord             : TEXCOORD0;
    float4 color                : COLOR0;
};

struct vs_output
{
    float4 color                : COLOR0;
    float2 texCoord             : TEXCOORD0;
};

struct ps_input
{
    float4 color                : COLOR0;
    float2 texCoord             : TEXCOORD0;
};

struct ps_output
{
    float4 color                : COLOR0;
    float  depth                : DEPTH;
};

sampler2D   baseTexture;

vs_output BasicVS(vs_input input)
{
    vs_output output;
    output.texCoord          = input.texCoord;
    output.color             = input.color;
    return output;
}

ps_output SolidPS(ps_input input)
{
    ps_output output;
    output.color = input.color;
    return output;
}

ps_output TexturePS(ps_input input)
{
    ps_output output;
    output.color = input.color * tex2D(baseTexture, input.texCoord);
    return output;
}