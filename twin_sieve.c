/* Segmented sieve counting twin primes up to N, with Hardy-Littlewood comparison.
 * Usage: ./twin_sieve [N]   (default N = 1e8)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>

static long long np;
static int *primes;

static void base_sieve(long long n) {
    long long r = (long long)sqrt((double)n) + 2;
    unsigned char *s = calloc((size_t)r + 1, 1);
    for (long long i = 2; i * i <= r; i++)
        if (!s[i])
            for (long long j = i * i; j <= r; j += i) s[j] = 1;
    np = 0;
    for (long long i = 2; i <= r; i++)
        if (!s[i]) np++;
    primes = malloc(sizeof(int) * (size_t)np);
    long long k = 0;
    for (long long i = 2; i <= r; i++)
        if (!s[i]) primes[k++] = (int)i;
    free(s);
}

int main(int argc, char **argv) {
    long long N = argc > 1 ? atoll(argv[1]) : 100000000LL;
    clock_t t0 = clock();
    base_sieve(N);

    const long long SEG = 1L << 19; /* odd slots per segment */
    unsigned char *flag = malloc((size_t)SEG);
    long long count = 0;
    long long prev = 2; /* last prime seen; 3-2=1 not counted */

    for (long long lo = 3; lo + 2 <= N; lo += 2 * SEG) {
        long long hi = lo + 2 * SEG;
        if (hi > N + 1) hi = N + 1;
        long long m = (hi - lo) / 2; /* odd numbers in [lo, hi) */
        memset(flag, 1, (size_t)m);
        for (long long k = 1; k < np; k++) { /* skip p = 2: even multiples are not stored */
            long long p = primes[k];
            if (p * p >= hi) break;
            long long v0 = ((lo + p - 1) / p) * p;
            if (v0 % 2 == 0) v0 += p;   /* first odd multiple of p in [lo, hi) */
            if (v0 < p * p) v0 = p * p; /* no need to mark below p^2 */
            for (long long v = v0; v < hi; v += 2 * p)
                flag[(v - lo) / 2] = 0;
        }
        for (long long i = 0; i < m; i++) {
            if (flag[i]) {
                long long v = lo + 2 * i;
                if (v - prev == 2) count++;
                prev = v;
            }
        }
    }

    double t = (double)(clock() - t0) / CLOCKS_PER_SEC;
    double C2 = 0.660161815846869573927812110014;
    double l = log((double)N);
    double hl = 2 * C2 * (double)N / (l * l);
    printf("N = %lld\n", N);
    printf("twin prime count pi2(N) = %lld\n", count);
    printf("Hardy-Littlewood estimate = %.1f\n", hl);
    printf("ratio count/estimate = %.6f\n", (double)count / hl);
    printf("time = %.2f s\n", t);
    free(flag);
    free(primes);
    return 0;
}
