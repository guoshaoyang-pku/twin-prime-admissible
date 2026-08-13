/* admissible.c — 计算可容许 k 元组的最小直径 d_min(k)
 *
 * 定义：{0..d} 中选 k 个数，若对每个素数 p <= k，所选数模 p 的剩余类
 * 没有覆盖全部 p 个剩余类，则称该 k 元组可容许 (admissible)。
 * （对 p > k，k 个数不可能覆盖 p 个剩余类，自动可容许。）
 *
 * 方法：d 从 2 递增（步长 2：k>=2 时元组必为全奇或全偶，直径必为偶数），
 * 对每个 d 用带剪枝的 DFS 搜索包含 0 和 d 的可容许 k 元组。
 * 归约成立：任何 k 元组平移后最小元为 0；若其最大元 < d，则它是更小
 * 直径的解（而更小 d 已被证伪）。故"第一个有解的 d"即最小直径。
 *
 * 剪枝（对每个素数 j）：
 *   budget_j = P[j]-1 - |m[j]|   —— 还可新增的剩余类数；
 *   若剩余位置中"已覆盖剩余类"的位置数 U 加上"出现频次最高的
 *   budget_j 个新剩余类"的位置数之和仍 < t，则不可行。
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

/* sf[q][j][r] = pool 中下标 >= q 且模 P[j] 余 r 的位置个数（<= 255） */
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
    /* 频数剪枝 */
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
        /* 新剩余类按出现频次从高到低取，最多取 budget 个 */
        int fresh[48], nf = 0;
        for (int r = 0; r < P[j]; r++) {
            if (!(m[j] >> r & 1ULL) && sf[pos][j][r] > 0) fresh[nf++] = sf[pos][j][r];
        }
        /* 简单选择排序取前 min(budget, nf) 大 */
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
            if (mm[j] & r) continue;                          /* 重复使用已覆盖剩余类，安全 */
            if (__builtin_popcountll(mm[j]) + 1 >= P[j]) { ok = 0; break; } /* 将覆盖全部剩余类 */
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

/* 搜索 [0,d] 内包含 0 和 d 的可容许 k 元组；返回 1 表示存在 */
static int search_d(int d) {
    poolsz = 0;
    for (int v = 2; v <= d - 2; v += 2) pool[poolsz++] = v; /* 全偶：模 2 留 1 个剩余类 */
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
    int k1 = argc > 1 ? atoi(argv[1]) : 2;
    int k2 = argc > 2 ? atoi(argv[2]) : 46;
    int verbose = argc > 3 ? atoi(argv[3]) : 0;
    for (int k = k1; k <= k2; k++) {
        clock_t t0 = clock();
        K = k;
        gen_primes(k);
        int d = 2;
        while (1) {
            if (d < k - 1) { d += 2; continue; } /* 位置不够 */
            if (verbose) fprintf(stderr, "[k=%d testing d=%d]\n", k, d);
            if (search_d(d)) break;
            d += 2;
        }
        double t = (double)(clock() - t0) / CLOCKS_PER_SEC;
        printf("k=%2d  d_min=%d  witness: %d", k, d, sol[0]);
        for (int i = 1; i < cnt; i++) printf(",%d", sol[i]);
        printf("   [%.2fs]\n", t);
        fflush(stdout);
    }
    return 0;
}
