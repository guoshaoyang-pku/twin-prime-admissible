/* admissible_par.c — 并行 UNSAT 证明：固定第一个包含的 pool 元素为 pool[i0]，
 * 搜索"包含 pool[i0] 且不包含 pool[0..i0-1]"的子空间。
 * 所有 i0 的子空间覆盖全部搜索空间（完备划分），全部 UNSAT ⟹ d UNSAT。
 * 用法: admissible_par k d i0
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MAXPOOL 1024
#define MAXNP 16

static int K, np, D;
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
    if (t == 0) { found = 1; return; }
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

/* 搜索子空间：包含 pool[i0]，不包含 pool[0..i0-1] */
static int search_sub(int i0) {
    unsigned long long m[MAXNP];
    for (int j = 0; j < np; j++) {
        m[j] = (1ULL << (0 % P[j])) | (1ULL << (D % P[j]));
        if (__builtin_popcountll(m[j]) >= P[j]) return 0;
    }
    cnt = 2;
    sol[0] = 0;
    sol[1] = D;
    found = 0;
    /* 强制包含 pool[i0] */
    int ok = 1;
    for (int j = 0; j < np && ok; j++) {
        unsigned long long r = 1ULL << (pool[i0] % P[j]);
        if (m[j] & r) continue;
        if (__builtin_popcountll(m[j]) + 1 >= P[j]) { ok = 0; break; }
        m[j] |= r;
    }
    if (!ok) return 0;
    sol[cnt] = pool[i0];
    cnt++;
    dfs(i0 + 1, K - 3, m);
    return found;
}

int main(int argc, char **argv) {
    if (argc < 4) { fprintf(stderr, "usage: %s k d i0\n", argv[0]); return 1; }
    K = atoi(argv[1]);
    D = atoi(argv[2]);
    int i0 = atoi(argv[3]);
    gen_primes(K);
    poolsz = 0;
    for (int v = 2; v <= D - 2; v += 2) pool[poolsz++] = v;
    build_sf();
    clock_t t0 = clock();
    int r = search_sub(i0);
    double t = (double)(clock() - t0) / CLOCKS_PER_SEC;
    if (r) {
        printf("k=%d d=%d i0=%d SAT witness: %d", K, D, i0, sol[0]);
        for (int i = 1; i < cnt; i++) printf(",%d", sol[i]);
        printf(" [%.1fs]\n", t);
    } else {
        printf("k=%d d=%d i0=%d UNSAT [%.1fs]\n", K, D, i0, t);
    }
    return 0;
}
