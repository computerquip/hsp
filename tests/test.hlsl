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

void BasicVS(int input)
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

	/* post/prefix */
	++a;
	--a;
	a++;
	a--;

	/* Logical */
	!a;
	a && b;
	a || b;

	/* Member Access */
	a[b];
	*a;
	&a;
	a->b;
	a.b;

	/* Arithmetic */
	+a;
	-a;
	a + b;
	a - b;
	a * b;
	a / b;
	a % b;
	~a;
	a & b;
	a | b;
	a ^ b;
	a << b;
	a >> b;

	/* Other */
	f();
	a,b;
	(int)a;


}
