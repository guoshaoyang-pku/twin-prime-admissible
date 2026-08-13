/* admissible_d.c — 测试单个 (k, d)：判断 [0,d] 内是否存在包含 0 和 d 的可容许 k 元组
 * 用法: ./admissible_d k d   → 输出 SAT(附见证) 或 UNSAT
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MAXPOOL 1024
#define MAXNP 16

static int K, np;
static int P[MAXNP];
static int pool[MAXPOOL];
static int poolsz;
static int sol[MAXPOOL];
static int cnt, found;
static unsigned char sf[MAXPOOL][MAXNP][48];

static void gen_primes(int k) {
    np = 0;
    for (int x = 2; x <= k; x++) {
        int isp = 1;
        for (int i = 0; i < np; i++)
            if (x % P[i] == 0) { isp = 0; break; }
        if (isp) P[np++] = x;
    }
}

static void build_sf(void) {
    for (int j = 0; j < np; j++)
        for (int r = 0; r < P[j]; r++) sf[poolsz][j][r] = 0;
    for (int q = poolsz - 1; q >= 0; q--) {
        for (int j = 0; j < np; j++) {
            for (int r = 0; r < P[j]; r++) sf[q][j][r] = sf[q + 1][j][r];
            sf[q][j][pool[q] % P[j]]++;
        }
    }
}

static void dfs(int pos, int t, unsigned long long *m) {
    if (found) return;
    if (poolsz - pos < t) return;
    for (int j = 0; j < np; j++) {
        int budget = P[j] - 1 - __builtin_popcountll(m[j]);
        if (budget < 0) return;
        unsigned long long mm = m[j];
        int covered_pos = 0;
        while (mm) {
            int r = __builtin_ctzll(mm);
            covered_pos += sf[pos][j][r];
            mm &= mm - 1;
        }
        int fresh[48], nf = 0;
        for (int r = 0; r < P[j]; r++) {
            if (!(m[j] >> r & 1ULL) && sf[pos][j][r] > 0) fresh[nf++] = sf[pos][j][r];
        }
        for (int a = 0; a < nf && a < budget; a++) {
            int best = a;
            for (int b = a + 1; b < nf; b++)
                if (fresh[b] > fresh[best]) best = b;
            int tmp = fresh[a]; fresh[a] = fresh[best]; fresh[best] = tmp;
            covered_pos += fresh[a];
        }
        if (covered_pos < t) return;
    }
    if (t == 0) {
        found = 1;
        return;
    }
    for (int i = pos; i < poolsz; i++) {
        unsigned long long mm[MAXNP];
        memcpy(mm, m, sizeof(mm));
        int ok = 1;
        for (int j = 0; j < np && ok; j++) {
            unsigned long long r = 1ULL << (pool[i] % P[j]);
            if (mm[j] & r) continue;
            if (__builtin_popcountll(mm[j]) + 1 >= P[j]) { ok = 0; break; }
            mm[j] |= r;
        }
        if (ok) {
            sol[cnt] = pool[i];
            cnt++;
            dfs(i + 1, t - 1, mm);
            if (found) return;
            cnt--;
        }
    }
}

static int search_d(int d) {
    poolsz = 0;
    for (int v = 2; v <= d - 2; v += 2) pool[poolsz++] = v;
    build_sf();
    unsigned long long m[MAXNP];
    for (int j = 0; j < np; j++) {
        m[j] = (1ULL << (0 % P[j])) | (1ULL << (d % P[j]));
        if (__builtin_popcountll(m[j]) >= P[j]) return 0;
    }
    cnt = 2;
    sol[0] = 0;
    sol[1] = d;
    found = 0;
    dfs(0, K - 2, m);
    return found;
}

int main(int argc, char **argv) {
    if (argc < 3) { fprintf(stderr, "usage: %s k d\n", argv[0]); return 1; }
    K = atoi(argv[1]);
    int d = atoi(argv[2]);
    gen_primes(K);
    clock_t t0 = clock();
    int r = search_d(d);
    double t = (double)(clock() - t0) / CLOCKS_PER_SEC;
    if (r) {
        printf("k=%d d=%d SAT witness: %d", K, d, sol[0]);
        for (int i = 1; i < cnt; i++) printf(",%d", sol[i]);
        printf(" [%.1fs]\n", t);
    } else {
        printf("k=%d d=%d UNSAT [%.1fs]\n", K, d, t);
    }
    return 0;
}
