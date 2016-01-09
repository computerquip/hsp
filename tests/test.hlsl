struct vs_input
{
    float3 osPosition;
    float2 texCoord;
};

struct vs_output
{
    float4 color;
    float2 texCoord;
};

struct ps_input
{
    float4 color;
    float2 texCoord;
};

struct ps_output
{
    float4 color;
    float  depth;
};

sampler2D   baseTexture;

[clipplanes()] void BasicVS(int input)
{
	/* Assignment operator */
	a = b;
	a += b;
	a -= b;
	a *= b;
	a /= b;
	a %= b;
	a ^= b;
	a &= b;
	a |= b;
	a <<= b;
	a >>= b;

	/* Comparison operator */
	a == b;
	a != b;
	a < b;
	a > b;
	a <= b;
	a >= b;

	a = b + c - (a ^= (b));

	a && b;
	a || b;

	a + b;
	a - b;
	a * b;
	a / b;
	a % b;
	a & b;
	a | b;
	a ^ b;
	a << b;
	a >> b;

	f();
	(int)a;
/*
	~a;
	!a;
	a[b];
	a.b;

	+a;
	-a;

	++a;
	--a;
*/
	a++;
	a--;
}

typedef int BOBOBOB;
