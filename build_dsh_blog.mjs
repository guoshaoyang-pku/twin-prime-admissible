import fs from 'node:fs'

const dataPath = process.argv[2] || '/tmp/dsh-trajectory-data.json'
const outputPath = process.argv[3] || 'docs/deepseek-harness-246-trajectory.html'
const payload = fs.readFileSync(dataPath, 'utf8').replace(/</g, '\\u003c')

const html = `<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="我和 DeepSeek Harness 一起学习、尝试孪生素数猜想：它自动 fallback 到复现 246；随后人类与 AI 把纪录推进到 240 与 186。本文科普为什么孪生素数猜想是三层优化问题，并完整可视化与审计 DSH 的研究轨迹。">
  <title>我和 DeepSeek 一起追过一次孪生素数猜想</title>
  <style>
    :root {
      --bg: #0b1118;
      --panel: #111b26;
      --panel-2: #172534;
      --ink: #e9f1f6;
      --muted: #9aabba;
      --line: #263949;
      --teal: #35d0ba;
      --orange: #ffb86b;
      --purple: #a998ff;
      --pink: #f38bb5;
      --red: #ff6e7d;
      --yellow: #f4d36d;
      --shadow: 0 18px 60px rgba(0,0,0,.26);
    }
    * { box-sizing: border-box; }
    html { scroll-behavior: smooth; }
    body {
      margin: 0;
      background: radial-gradient(circle at 10% -10%, #1c3540 0, transparent 34rem), var(--bg);
      color: var(--ink);
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", sans-serif;
      line-height: 1.75;
    }
    a { color: var(--teal); }
    main { max-width: 1220px; margin: 0 auto; padding: 48px 24px 90px; }
    header { max-width: 920px; padding-bottom: 32px; }
    .eyebrow { color: var(--teal); font: 700 12px/1.2 ui-monospace, SFMono-Regular, Menlo, monospace; letter-spacing: .14em; text-transform: uppercase; }
    h1 { max-width: 1000px; margin: 14px 0 20px; font-size: clamp(34px, 6vw, 68px); line-height: 1.06; letter-spacing: -.055em; }
    h2 { margin: 64px 0 18px; font-size: clamp(24px, 3vw, 36px); line-height: 1.2; letter-spacing: -.03em; }
    h3 { margin: 24px 0 10px; font-size: 19px; line-height: 1.35; }
    p { margin: 12px 0; }
    .dek { max-width: 850px; color: var(--muted); font-size: 19px; }
    .meta { margin-top: 18px; color: var(--muted); font-size: 13px; }
    .hero-note, .callout, .panel, .metric, .step-card, .source-box { border: 1px solid var(--line); background: rgba(17,27,38,.92); border-radius: 16px; box-shadow: var(--shadow); }
    .hero-note { margin: 28px 0; padding: 20px 22px; border-left: 4px solid var(--teal); }
    .callout { padding: 18px 20px; border-color: #735d2f; background: #221f18; color: #f4ddb0; }
    .callout strong { color: var(--yellow); }
    .metrics { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; margin: 26px 0; }
    .metric { padding: 18px; }
    .metric strong { display: block; color: var(--teal); font: 700 clamp(24px, 4vw, 38px)/1.1 ui-monospace, SFMono-Regular, Menlo, monospace; }
    .metric:nth-child(2) strong { color: var(--orange); }
    .metric:nth-child(3) strong { color: var(--purple); }
    .metric:nth-child(4) strong { color: var(--pink); }
    .metric span { display: block; margin-top: 8px; color: var(--muted); font-size: 13px; }
    .two-col { display: grid; grid-template-columns: 1.1fr .9fr; gap: 18px; align-items: start; }
    .panel { padding: 22px; }
    .panel h3:first-child { margin-top: 0; }
    .panel p:last-child { margin-bottom: 0; }
    table { width: 100%; border-collapse: collapse; margin: 18px 0; font-size: 14px; }
    th, td { padding: 11px 12px; text-align: left; vertical-align: top; border-bottom: 1px solid var(--line); }
    th { color: var(--teal); font-weight: 700; background: rgba(53,208,186,.07); }
    tr:last-child td { border-bottom: 0; }
    code, pre, .mono { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; }
    code { padding: .14em .34em; border-radius: 5px; color: #d3e5ef; background: #1c2a38; }
    pre { margin: 18px 0; padding: 17px; overflow: auto; border: 1px solid var(--line); border-radius: 12px; background: #081018; color: #cde1e8; line-height: 1.55; font-size: 13px; }
    .small { color: var(--muted); font-size: 13px; }
    .legend { display: flex; flex-wrap: wrap; gap: 8px 16px; margin: 12px 0 4px; color: var(--muted); font-size: 12px; }
    .legend span { display: inline-flex; align-items: center; gap: 6px; }
    .dot { display: inline-block; width: 9px; height: 9px; border-radius: 50%; }
    .viz-shell { margin-top: 22px; padding: 18px; border: 1px solid var(--line); border-radius: 18px; background: #0c151e; box-shadow: var(--shadow); }
    .viz-toolbar { display: grid; grid-template-columns: 170px 170px minmax(180px, 1fr) auto; gap: 10px; align-items: center; margin-bottom: 14px; }
    select, input { width: 100%; min-height: 40px; border: 1px solid var(--line); border-radius: 9px; padding: 8px 10px; color: var(--ink); background: var(--panel); font: inherit; }
    button { border: 1px solid var(--line); border-radius: 9px; padding: 8px 12px; color: var(--ink); background: var(--panel-2); cursor: pointer; font: inherit; }
    button:hover, button:focus-visible { border-color: var(--teal); outline: none; }
    .viz-count { color: var(--muted); font-size: 12px; text-align: right; white-space: nowrap; }
    .timeline-wrap { position: relative; overflow: hidden; border: 1px solid var(--line); border-radius: 12px; background: #081018; }
    #timeline { display: block; width: 100%; height: 260px; cursor: crosshair; }
    .timeline-label { position: absolute; left: 12px; z-index: 2; color: var(--muted); font: 700 11px ui-monospace, SFMono-Regular, Menlo, monospace; pointer-events: none; }
    .timeline-label.a { top: 58px; color: var(--teal); }
    .timeline-label.b { top: 174px; color: var(--orange); }
    .tooltip { position: fixed; z-index: 20; display: none; max-width: 380px; padding: 10px 12px; border: 1px solid var(--line); border-radius: 8px; background: #0a121a; color: var(--ink); box-shadow: var(--shadow); pointer-events: none; font-size: 12px; }
    .detail { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-top: 14px; }
    .detail-box { min-width: 0; padding: 14px; border: 1px solid var(--line); border-radius: 11px; background: var(--panel); }
    .detail-box h4 { margin: 0 0 8px; color: var(--muted); font-size: 12px; text-transform: uppercase; letter-spacing: .09em; }
    .detail-box pre { max-height: 260px; margin: 0; white-space: pre-wrap; word-break: break-word; }
    .action-row { display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 8px; }
    .badge { display: inline-block; padding: 3px 7px; border-radius: 999px; color: #071117; font: 700 11px ui-monospace, SFMono-Regular, Menlo, monospace; }
    .badge.compute { background: var(--teal); }
    .badge.code { background: var(--yellow); }
    .badge.research { background: var(--purple); }
    .badge.wait { background: var(--pink); }
    .badge.tool { background: #b6c5cf; }
    .badge.error { background: var(--red); color: #fff; }
    .histogram { display: grid; gap: 10px; margin-top: 14px; }
    .bar-row { display: grid; grid-template-columns: 108px 1fr 64px; gap: 9px; align-items: center; font-size: 12px; }
    .bar-label { overflow: hidden; color: var(--muted); text-overflow: ellipsis; white-space: nowrap; }
    .bar-track { height: 11px; overflow: hidden; border-radius: 999px; background: #22313d; }
    .bar-fill { height: 100%; border-radius: inherit; background: linear-gradient(90deg, var(--teal), var(--purple)); }
    .bar-value { color: var(--ink); text-align: right; font-family: ui-monospace, SFMono-Regular, Menlo, monospace; }
    .step-list { display: grid; gap: 8px; margin-top: 18px; }
    .step-card { padding: 13px 15px; box-shadow: none; }
    .step-card.selected { border-color: var(--teal); box-shadow: 0 0 0 1px var(--teal); }
    .step-head { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; cursor: pointer; }
    .step-head strong { color: var(--ink); font-size: 13px; }
    .step-head .spacer { flex: 1; }
    .step-head time, .seq { color: var(--muted); font: 11px ui-monospace, SFMono-Regular, Menlo, monospace; }
    .step-preview { margin-top: 7px; color: var(--muted); font-size: 13px; white-space: pre-wrap; overflow-wrap: anywhere; }
    .step-body { display: none; margin-top: 12px; padding-top: 12px; border-top: 1px solid var(--line); }
    .step-card.open .step-body { display: block; }
    .step-body pre { margin: 8px 0 0; max-height: 230px; white-space: pre-wrap; word-break: break-word; }
    .list-footer { display: flex; justify-content: space-between; gap: 12px; align-items: center; margin-top: 12px; color: var(--muted); font-size: 12px; }
    .pill-row { display: flex; flex-wrap: wrap; gap: 8px; }
    .pill { padding: 7px 10px; border: 1px solid var(--line); border-radius: 999px; color: var(--muted); background: var(--panel); font-size: 12px; }
    .pill strong { color: var(--ink); }
    .score { display: grid; gap: 10px; margin-top: 16px; }
    .score-row { display: grid; grid-template-columns: 160px 1fr 70px; gap: 10px; align-items: center; font-size: 13px; }
    .score-track { height: 9px; border-radius: 99px; background: #263845; }
    .score-fill { height: 100%; border-radius: inherit; }
    footer { margin-top: 68px; padding-top: 18px; border-top: 1px solid var(--line); color: var(--muted); font-size: 13px; }
    @media (max-width: 850px) {
      main { padding: 32px 16px 64px; }
      .metrics, .two-col { grid-template-columns: 1fr 1fr; }
      .viz-toolbar { grid-template-columns: 1fr 1fr; }
      .viz-count { text-align: left; }
    }
    @media (max-width: 580px) {
      .metrics, .two-col, .detail { grid-template-columns: 1fr; }
      .metrics { gap: 8px; }
      .metric { padding: 14px; }
      .metric strong { font-size: 26px; }
      .viz-toolbar { grid-template-columns: 1fr; }
      .bar-row { grid-template-columns: 88px 1fr 56px; }
      .score-row { grid-template-columns: 125px 1fr 58px; }
      th, td { padding: 8px 6px; font-size: 12px; }
    }
  </style>
</head>
<body>
<main>
  <header>
    <div class="eyebrow">一段研究记录</div>
    <h1>我和 DeepSeek 一起追过一次孪生素数猜想</h1>
    <p class="dek">8 月 13 日，我把一个几乎不可能完成的任务交给了 DeepSeek：“解决孪生素数猜想，或者把 246 往下推。”接下来的几天，它没有找到新定理，却一直在工作：写程序、跑计算、修错误、把有限的结论做成证书。后来我才意识到，这不只是一次失败的证明尝试，而是一场关于模型性格、长期执行和数学研究方式的实验。</p>
    <div class="meta">作者：Shaoyang Guo · 轨迹快照：2026-08-29 · 终稿：2026-09-06（北京时间） · <a href="https://github.com/guoshaoyang-pku/twin-prime-admissible" target="_blank" rel="noreferrer">项目仓库</a> · <a href="https://github.com/AxiomMath/PrimeGapsLib" target="_blank" rel="noreferrer">Axiom 对照仓库</a></div>
  </header>

  <div class="hero-note">
    <strong>先说结果：</strong> DeepSeek 没有证明孪生素数猜想，也没有把 246 推得更低。它最后回到了已知的 246 路线。但这几天并没有白费：它完成了大量可复现的组合搜索和 Lean 证书，把许多候选路线推到边界；它还让我看清了一件事——一个模型可以非常擅长“持续做事”，却并不擅长在未知处改变问题本身。
  </div>

  <section>
    <h2>一、事情是怎么开始的</h2>
    <p>8 月 13 日晚上，我没有给它一篇详细的研究计划，只给了一个目标：“请解决孪生素数猜想，或者把现有的值缩短。不要停止思考。”</p>
    <p>它从一个空目录开始。先查当前纪录，写程序数孪生素数，再开始搜索可容许元组。第二天，它已经得到了一些边界结果：哪些直径不可能，哪些直径可以找到见证。到了 8 月 14 日晚上，工作被搬到远程机器上，192 个核心开始同时运行。</p>
    <p>接下来的几天很像一间不关灯的实验室。任务被拆成数十万个小块；有的进程失败，调度器会出错，磁盘空间会不够。DeepSeek 就修脚本、重启任务、补验证、再继续。它没有停下来等一个新提示。</p>
    <p>最后，这一阶段留下了 42.4 万个子空间的 UNSAT 搜索结果、约 25 万节点的证书树，以及可以由 Lean kernel 检查的下界定理。它没有找到孪生素数，但把问题的一大片有限区域彻底检查了一遍。</p>
  </section>

  <section>
    <h2>二、为什么这个问题适合交给机器</h2>
    <p>孪生素数猜想问的是：是否有无穷多对相差 2 的素数（11 与 13、17 与 19、29 与 31……）。一百多年没人能证。2013 年张益唐换了个问法：不追“差 2”，改证“存在无穷多对间距不超过某个有限值 H 的素数对”——于是全世界的战场变成了把 H 从 7000 万往下压。</p>
    <p>这个战场为什么本质上是<strong>优化问题</strong>？直观地说，我们知道素数由解析公式控制，但在巨大范围内不能逐个算出它们。于是先选一个“模板”：一组平移量，让模板尽可能窄；再给模板中每个位置加权，计算它在无穷大区间上的平均贡献；最后证明这个加权平均超过阈值。平均值若大于 1，就意味着有无穷多个平移位置让模板中至少出现两个素数。整条 Maynard 路线正是三层互相耦合的优化：</p>
    <div class="two-col">
      <div class="panel">
        <h3>第一层：组合优化——选模板</h3>
        <p>取 k 个非负整数 h<sub>1</sub> &lt; h<sub>2</sub> &lt; … &lt; h<sub>k</sub> 作为“模板”，要求<strong>可容许</strong>：对每个素数 p，这 k 个数 mod p 不能覆盖全部剩余类。反例正是孪生素数对本身：{0, 2} mod 2 覆盖了 {0, 1} 两类——无论 n 是奇是偶，n 与 n+2 总有一个是偶数，筛法必然筛掉一个。而三元组 {0, 2, 6} 就是可容许的。</p>
        <p>可容许是筛法工作的入场券，于是第一个优化问题出现：在可容许的前提下<strong>最小化直径</strong> H(k) = h<sub>k</sub> − h<sub>1</sub>。模板越窄，纪录越好压。我们用 DFS + SAT 独立严格验证了 H(46)=216、H(48)=236、H(49)=240、H(50)=246。</p>
      </div>
      <div class="panel">
        <h3>第二层：变分优化——调权重</h3>
        <p>光有模板不够：筛法本身只能给出“平均而言素数稀疏”，要证明的是某个<strong>加权平均可以超过阈值</strong>。做法是在 (k−1) 维单纯形上放一个非负权重函数 F，把“素数出现的加权平均次数”最大化，得到变分常数 M<sub>k</sub>。这就是“把很多素数进行配对”的严格版本：不是直接找到一对，而是让一个模板在平均意义上反复产生至少两个素数。</p>
        <p>Maynard 证明：只要 M<sub>k</sub> &gt; 2m/θ，就有无穷多个 n 使模板中至少 m+1 个位置同时是素数。要证“两个素数”（m=1）就要 M<sub>k</sub> &gt; 2/θ。第二个优化问题：<strong>把 M<sub>k</sub> 做大</strong>——这是他 2013 年的核心贡献。</p>
      </div>
    </div>
    <div class="panel">
      <h3>第三层：解析优化——素数分布得有多均匀</h3>
      <p>阈值的分母 θ 是“素数在算术级数中的分布水平”。Bombieri–Vinogradov 定理给 θ = 1/2，于是阈值钉死在 2/θ = 4。Polymath8b 把三层一起拧紧：k=50 的模板（直径 246）+ 精心优化的权重算出 M<sub>50</sub> = 4.0043 &gt; 4——<strong>246 定理诞生</strong>。注意 4.0043 离 4 只有 0.1%：在 θ=1/2 的房间里，这条路几乎已经拧到了头。</p>
    </div>
    <pre>纪录 H = min over k { H(k) : M_k &gt; 2m/θ }
  ├── H(k) ：组合层，越小越好（打包问题）
  ├── M_k  ：变分层，越大越好（权重设计）
  └── θ    ：解析层，越大阈值越低（素数分布输入）</pre>
    <h3>246 → 更小的数字：这条路后来怎样继续</h3>
    <table>
      <thead><tr><th>上界</th><th>谁</th><th>关键改进在哪一层</th></tr></thead>
      <tbody>
        <tr><td>70,000,000</td><td>张益唐（2013）</td><td>变分层首次跑通（GPY 方法），θ = 1/2</td></tr>
        <tr><td>600</td><td>Maynard（2013）</td><td>变分层重做：多维筛权重，任意大 k 时 M<sub>k</sub> 随 log k 增长</td></tr>
        <tr><td>246</td><td>Polymath8b（2014）</td><td>三层同拧：k=50、M<sub>50</sub>=4.0043 &gt; 4、θ = 1/2</td></tr>
        <tr><td>240</td><td>Stadlmann（2026-08-31，人类）</td><td>解析层：BV + 光滑模上的新等分布估计；240 = H(49)</td></tr>
        <tr><td>212 / 188</td><td>Axiom / Anthropic（2026-09-04）</td><td>同一框架内继续拧紧并 Lean 形式化</td></tr>
        <tr><td><strong>186</strong></td><td>GPT-6 Astra（2026-09-04）</td><td>解析层 θ ≈ 0.525（阈值降到 ≈3.81）+ 新因子分解条件扩大权重支撑；k=40，直径 186；Lean 形式化</td></tr>
      </tbody>
    </table>
    <p>这也解释了为什么 246 长时间没有变化。并不是没人会继续调参数，而是这套方法里的门槛已经贴近 4。要继续往下，必须改善素数在算术级数中的分布估计，或者找到新的权重结构。后来出现的 240、212、188、186，正是从这些方向推进。新闻标题很容易把它们写成“AI 突然解决了问题”，但真正发生的事情更像是：有人换了一扇门，有人找到了旧论文里尚未充分利用的入口。</p>
    <p>当然，这条路线之外还有更深的墙：奇偶性障碍（parity problem）表明纯筛法不可能把 H 压到 6 以下，孪生素数猜想本身仍需要别的思想。但在墙到达之前，它确实是一个可以逐项计分的优化问题——这也正是它适合交给机器的原因。</p>
  </section>

  <section>
    <h2>三、一个人类故事：把猜想交出去以后</h2>
    <p>这件事开始得并不庄严。没有研究计划书，没有预先写好的路线图。8 月 13 日晚上，我只给了 DeepSeek Harness 一句话：<strong>“请解决孪生素数猜想，或者把现有的值缩短。不要停止思考直到解决为止。”</strong></p>
    <p>这句话后来变成了一场很长的实验。DeepSeek 没有突然发明一个新筛法，也没有在某个深夜从黑箱里拿出孪生素数猜想的证明。它做的是另一件更朴素、也更容易被低估的事：把一个模糊到几乎不可能完成的目标，拆成一串可以编译、可以运行、可以交叉验证、可以写进 Lean 的小目标。</p>
    <p>最初几小时，它从一个空的工作目录开始。它查找当前纪录，写出分段筛程序，验证孪生素数计数；随后开始搜索可容许元组。几乎没有戏剧性的“灵感时刻”，只有不断增加的文件、任务、日志和进程。它先得到 k=46 的边界判定，再得到 k=50、直径 246 的可容许见证。第二天晚上，问题被搬到远程机器上，进入 192 个核心共同工作的阶段。</p>
    <p>那时，研究已经不再像一篇论文，更像一间夜里不关灯的实验室：1593 个目标、42.4 万个子空间、45.6 万行任务、1.7 GB 结果。进程会失败，调度器会把层级匹配错，磁盘配额会逼近上限；模型就修脚本、重启守护进程、补覆盖检查，然后继续。到 8 月 18–20 日，这条“工程路线”留下了约 25 万节点的失败树、1593 个 Lean 下界定理，以及 SAT 侧的 96 个可容许性定理。</p>
    <p>这也是故事第一次反转的地方：一个本来被要求“解决猜想”的 agent，最可靠的贡献不是解决猜想，而是把问题中某一大片有限、离散、可验证的区域封存成了证书。它没有跨过数学的墙；它把墙砌成了可以测量的砖。</p>
    <p>8 月 20 日之后，本页展示的两条主轨迹才真正开始。它们尝试更深入的 Maynard 泛函、有限维矩阵、区间 LDL<sup>T</sup>、Kato–Temple 后验估计和乘子路线。A 轨迹最终完成了 k=49、D=33 的 6740 维区间计算；B 轨迹则把全空间升级所需的残差缺口明确写成了开放问题。与此同时，长时间运行的模型逐渐回到它熟悉的工程节奏：搜索、计算、比较、修复、再计算。它最后自动 fallback 到了已知的 246 路线。</p>
    <p>如果只看最终数字，这像是失败。如果把整个轨迹放回时间里，它更像一次测量：我们知道它在哪里努力过，哪些候选路线被排除，哪些“证明”其实只有有限维意义，哪些地方还缺一个真正的解析定理。</p>
  </section>

  <section>
    <div class="metrics">
      <div class="metric"><strong>2</strong><span>主会话</span></div>
      <div class="metric"><strong>11,651</strong><span>逻辑 steps（已可视化全部）</span></div>
      <div class="metric"><strong>4.83M</strong><span>原始事件（含流式 chunk）</span></div>
      <div class="metric"><strong>≈12k</strong><span>工具动作与结果轨迹</span></div>
    </div>
    <p class="small">“全部”在本页指全部逻辑 step：每个 step 的模型摘要、工具调用、结果摘要、时间、turn、局部序号和原始事件序号范围都保留。高频的 assistant/chunk 流被合并，因为逐 token 展开会掩盖研究动作本身；页面不会伪装成原始 API JSON 导出。</p>
  </section>

  <section>
    <h2>四、后来它去了哪里</h2>
    <p>8 月 20 日以后，故事进入了第二幕。两条长时间运行的主会话开始尝试 Maynard 泛函、高维矩阵和谱估计。</p>
    <p><strong>A 轨迹</strong>比较像一个数值实验室。它不断增大有限维空间，最后完成了 k=49、D=33 的 6740 维区间 LDL<sup>T</sup> 计算，所有主元下界都为正。这是一个有价值的有限维证书，但它仍然不是全空间结论。</p>
    <p><strong>B 轨迹</strong>试图把这个有限维结果升级成全空间的严格上界。它走到了 Kato–Temple 后验估计，但完整残差约为 0.106，而可用谱隙约为 0.07，条件没有闭合。最后它没有把这一步包装成证明，而是留下了一个明确的开放问题。</p>
    <p>两条轨迹合计有 11,651 个逻辑 step、约 483 万个原始事件。页面下方保留了完整的 step 级轨迹；但真正重要的不是数字本身，而是你可以看到一个 agent 如何在几天里不断尝试、修复、回退和重新选择方向。</p>
  </section>

  <section>
    <h2>五、这不是一个“证明已经完成”的故事</h2>
    <p>这里最容易产生误解。我们确实完成了几件严格的事情，但它们属于不同层次：</p>
    <table>
      <thead><tr><th>阶段</th><th>产物</th><th>严格性</th></tr></thead>
      <tbody>
        <tr><td>严格计算</td><td>可容许元组的最小直径表；H(43..50) 的 SAT/UNSAT 闭合；Lean kernel 检查的下界证书。</td><td>可以复现，也可以逐步检查。</td></tr>
        <tr><td>有限维数值证书</td><td>k=49、D=33 上 6740 维区间 LDL<sup>T</sup> 的所有主元下界为正。</td><td>严格有限维结论，不自动延伸到全空间。</td></tr>
        <tr><td>全空间结论</td><td>试图证明 M<sub>49,1/25</sub> &lt; 4。</td><td>尚未完成；Kato–Temple 路线被审计为 blocked。</td></tr>
        <tr><td>孪生素数猜想</td><td>证明相差 2 的素数对无穷多。</td><td>仍然没有解决。</td></tr>
      </tbody>
    </table>
    <p class="small">这些时间线来自 DSH session 档案、远程计算日志和仓库文件。8 月 20 日的仓库是一次干净初始提交，所以仓库 git log 并不能代表研究真正的起点。</p>
  </section>

  <section>
    <h2>六、可视化全部 trajectory</h2>
    <p>下面的横向轨道包含两条会话的每一个逻辑 step。颜色代表该 step 的主要动作类型；可以按会话、动作、关键词筛选，也可以直接点击轨道上的点查看模型摘要、工具参数、结果和序号范围。密集区域不是被省略，而是每个点都绘制在同一条轨道上。</p>
    <div class="viz-shell">
      <div class="viz-toolbar">
        <select id="sessionFilter" aria-label="筛选会话"><option value="all">全部会话</option><option value="A">A · 主线</option><option value="B">B · 高精度支线</option></select>
        <select id="kindFilter" aria-label="筛选动作"><option value="all">全部动作</option><option value="compute">compute · 计算</option><option value="code">code · 改码</option><option value="research">research · 调研</option><option value="wait">wait · 等待</option><option value="tool">tool · 其他工具</option></select>
        <input id="queryFilter" type="search" placeholder="搜索命令、文件名、M_49、D=31、STRICT…" aria-label="搜索轨迹">
        <div class="viz-count" id="vizCount"></div>
      </div>
      <div class="legend">
        <span><i class="dot" style="background:var(--teal)"></i>compute</span>
        <span><i class="dot" style="background:var(--yellow)"></i>code</span>
        <span><i class="dot" style="background:var(--purple)"></i>research</span>
        <span><i class="dot" style="background:var(--pink)"></i>wait</span>
        <span><i class="dot" style="background:#b6c5cf"></i>tool</span>
        <span><i class="dot" style="background:var(--red)"></i>error/result error</span>
      </div>
      <div class="timeline-wrap">
        <span class="timeline-label a">A · main</span>
        <span class="timeline-label b">B · main (1)</span>
        <canvas id="timeline" height="260"></canvas>
      </div>
      <div class="detail" id="detail">
        <div class="detail-box"><h4>Selected step</h4><div class="small">点击轨迹上的点，或点击下方列表中的 step。</div></div>
        <div class="detail-box"><h4>How to read</h4><div class="small">横轴是每条会话自己的逻辑顺序；纵向两条 lane 分别是 A/B。透明点仍然是完整轨迹，只是没有匹配当前筛选条件。</div></div>
      </div>
      <div class="histogram" id="histogram"></div>
      <div class="step-list" id="stepList"></div>
      <div class="list-footer"><span id="listCount"></span><button id="showMore" type="button">再显示 200 个 step</button></div>
    </div>
  </section>

  <section>
    <h2>七、DSH 做得好的地方</h2>
    <div class="two-col">
      <div class="panel">
        <h3>把一个不可解目标拆成可检验对象</h3>
        <p>它没有真的“解决孪生素数猜想”，而是把问题拆成可容许元组的 <code>H(k)</code>、Maynard 泛函 <code>M_k</code>、有限多项式族和区间矩阵判定。这个拆分与第二节的三层优化完全对应，也让失败可以定位到层。</p>
        <h3>反例驱动地修正实现</h3>
        <p>轨迹中出现过剪枝完备性问题和 <code>int/int</code> 混入浮点导致假正特征值。模型通过小规模反例和精确有理数对称性检查修复了它们，而不是把第一版结果直接包装成结论。</p>
      </div>
      <div class="panel">
        <h3>形成 proof-carrying computation 的雏形</h3>
        <p>可容许元组侧在 8 月 18–20 日就产出了 1593 个 Lean kernel 检查的下界定理；数值侧使用区间算术和对称选主元 LDLᵀ。D=33 的最终运行得到“全部 6740 个主元下界 &gt; 0”的严格有限维结论。这说明它不是普通双精度实验。</p>
        <h3>被审计之后能立刻修正</h3>
        <p>9 月 1–3 日的审计中，它自己生成的高维 sanity 检查用了 48 维拒绝采样（命中率约 1/48!，几乎必然零样本），被人类抓住后立即改为指数/Dirichlet 采样，并通过了 k=2 手算级与 k=3 数值级复核。一个“被指出 bug 会修、被指出 overclaim 会收”的 agent，比一个“永远自信”的 agent 有用得多。</p>
      </div>
    </div>
  </section>

  <section>
    <h2>八、它为什么没有在有限时间内收敛成完整证明</h2>
    <div class="score">
      <div class="score-row"><span>研究分解</span><div class="score-track"><div class="score-fill" style="width:92%;background:var(--teal)"></div></div><strong>强</strong></div>
      <div class="score-row"><span>程序与数值实验</span><div class="score-track"><div class="score-fill" style="width:86%;background:var(--orange)"></div></div><strong>较强</strong></div>
      <div class="score-row"><span>有限证书严谨性</span><div class="score-track"><div class="score-fill" style="width:68%;background:var(--purple)"></div></div><strong>有成果</strong></div>
      <div class="score-row"><span>完整 Lean 连接</span><div class="score-track"><div class="score-fill" style="width:18%;background:var(--pink)"></div></div><strong>缺口大</strong></div>
    </div>
    <div class="two-col">
      <div class="panel">
        <h3>算力瓶颈是真实的，但只影响局部任务</h3>
        <p>数千维的高精度区间 LDLᵀ 是 CPU-bound，某些主元位置会极慢；D=33 的完整运行花了约两天半。更强机器、并行分块、缓存和更好的线性代数实现都能改善这一段。</p>
        <p>但把 k=49 的有限维计算跑完，仍然不是 186 或 212 所需的解析层突破——算力买不到 θ。</p>
      </div>
      <div class="panel">
        <h3>真正的瓶颈是证明对象不一致 + 墙确实存在</h3>
        <p>主线大量工作在尝试证明某些 k&lt;50 的受限空间里 M &lt; 4，这对“能否改进 246”是有信息量的负结果，但不是任何正向定理。9 月的审计进一步确认了墙的真实性：下界方向，嵌套 Ritz 外推给出全空间数值地板 ≈3.9936，单调收敛且饱和；上界方向，Kato–Temple 后验估计需要完整残差远小于谱隙，而实测残差 ≈0.106 ≫ 0.07——标准后验路线在这套权重上无法闭合。</p>
        <p>换句话说：DSH 不是差一点就证明出什么，而是把“这个房间里没有更多东西可拿”这件事本身做实了。</p>
      </div>
    </div>
  </section>

  <section>
    <h2>九、模型性格：执行、推导与长程记忆</h2>
    <p>这次实验最值得带走的，不是“哪个模型更聪明”，而是不同模型把“研究”理解成了不同的动作。</p>
    <div class="two-col">
      <div class="panel">
        <h3>DeepSeek：把目标当成一条施工线</h3>
        <p>给一个小模型一个足够明确、足够持久的目标，再给它能运行的 Harness，它的执行力可以非常强。它会持续写程序、跑实验、检查输出、修复失败、启动下一轮；它不需要每十分钟得到一次新的鼓励，也不会因为一个局部困难立刻结束会话。今天的 agentic 模型在偏好对齐、指令遵循和工具调用上已经很强，而 DSH 把这种能力拉长到了几天。</p>
        <p>但它的偏好也很明显：它倾向于<strong>执行而不是突破</strong>。遇到未知区域时，它更自然的动作是增加采样、改进界、扩大计算、复现已知路线，而不是停下来重新定义证明对象。它喜欢数值计算和工程验证，喜欢一个能被脚本验收的目标；它不太会主动问“也许我们应该换一个数学问题”。</p>
      </div>
      <div class="panel">
        <h3>GPT Luna 到 Sol：先问路线是否成立</h3>
        <p>相比之下，GPT 系列更喜欢数学推导、反例和结构分析。它能很快看出 DSH 的证明缺陷：有限维上界不是全空间上界，数值外推不是定理，Kato–Temple 需要的残差并没有闭合。这样的审查非常有价值，也解释了为什么 GPT 对 DSH 的早期工作评价会很低——它看到的是“你还没有证明你以为自己证明的东西”。</p>
        <p>但 GPT 的缺点恰好相反：在 Codex 一类环境里，它通常难以连续执行四天而不失去目标。它更容易在路线不清时停下来，或者给出一份漂亮的分析而不是把几百个任务真的跑完。GPT 擅长地图和路线判断，DSH 擅长沿着一条路线把路面铺到尽头。</p>
      </div>
    </div>
    <p>因此，比较这两类模型不应该只看“谁最后说对了”。一个合理的组合是：让 GPT 或人类数学家负责提出候选机制、识别墙和设定停止条件；让 DSH 负责长时间执行、生成数据和证书；再由独立的形式化系统与审查模型检查它是否把“实验事实”偷偷升级成了“数学定理”。</p>
  </section>

  <section>
    <h2>十、从素数间隔到千禧年问题：先把优化做绝，再定制证明</h2>
    <p>孪生素数猜想给出的启示，也许不只属于数论。许多困难的数学问题，真正适合 AI 的第一步并不是让模型直接“证明”，而是把证明之前的搜索空间变成一个可度量的优化问题。</p>
    <p>在有界素数间隔问题里，我们不能直接计算无穷远处每一个素数，但可以选择模板、挖掉不可能的位置，再给每个位置一个权重。模板的组合质量、权重函数的变分质量、以及素数在算术级数中的分布质量，分别对应三层优化。只有先把每一层的目标函数、约束和阈值写清楚，agent 才知道什么叫进步：直径变小、M<sub>k</sub> 变大、θ 变大，或者一个候选路线被严格排除。</p>
    <p>这和千禧年问题中的 Navier–Stokes 爆炸研究有相似之处。Google DeepMind 曾展示过一类非常有吸引力的工作流：用数值优化寻找可能爆炸的候选解，把 PDE 的 loss 压到很低，观察集中、缩放和边界层的形状，然后反过来猜测真正应该证明的解析命题。</p>
    <div class="callout">
      <strong>但必须保持一个严格的分界：</strong> loss 足够低并没有一个普适定理自动推出“存在精确解”。数值解是线索，不是证明；它告诉我们应该在哪个函数簇、哪个重标度、哪个边界条件、哪个线性化算子附近寻找定理。最后仍然需要解析证明，尤其是存在性、稳定性、谱隙、误差控制和极限过程。
    </div>
    <p>一个可能的通用工作流是：</p>
    <ol>
      <li>探索性数值模拟：寻找低 loss 的候选族，而不是宣称已经得到解。</li>
      <li>观察集中、缩放和对称性规律：记录哪些量在训练或网格加密中稳定。</li>
      <li>猜测爆炸机制：确定可能的自相似剖面、临界指数和守恒量。</li>
      <li>选择重标度、边界条件和函数空间：把计算对象翻译成定理对象。</li>
      <li>在重标度方程中优化候选剖面：用 agent 大规模搜索参数和函数簇。</li>
      <li>分析 <code>DF(Ū)</code> 的稳定/不稳定方向：把低 loss 变成可控制的误差与谱条件。</li>
      <li>反过来修正机制、重标度和候选：让数值实验与解析结构相互校准。</li>
    </ol>
    <p>这不是“用数值优化替代数学证明”，而是把数学证明的前置探索变成一个机器可以参与、可以记录、可以复盘的过程。孪生素数实验中，DSH 没有找到新的数学门；但它展示了 agent 可以如何把门前的地形测完。</p>
  </section>

  <section>
    <h2>十一、尾声：我们真正学到的是什么</h2>
    <p>9 月 4 日的新闻发布后，我们手里这些东西的意义变得清晰了。注意：严格结论中<strong>最早取得的是 8 月 18–20 日的 H(k) 下界 Lean 证书化</strong>，它比 Axiom 的 246 形式化新闻还早：</p>
    <table>
      <thead><tr><th>结论</th><th>等级</th><th>状态与新闻之后的意义</th></tr></thead>
      <tbody>
        <tr><td>H(43..50) 最小直径 = 200/210/212/216/226/236/240/246（SAT + UNSAT 闭合）</td><td><strong>A · 严格</strong></td><td>8 月 18–20 日已得：42.4 万子空间穷举 + 1593 个 Lean kernel 检查下界定理 + 三实现交叉验证。与权威数据一致；<strong>完好无损</strong>：Stadlmann 的 240 = H(49)，新纪录与我们的表完全相容。</td></tr>
        <tr><td>k=49、V<sub>33</sub>（6740 维）上 M &lt; 4</td><td><strong>A · 有限维</strong></td><td>9 月 1–3 日完成：区间 LDLᵀ，全部主元 &gt; 0（最小 ≈1.13e-60）。刻画 θ=1/2 房间内的有限维事实。</td></tr>
        <tr><td>全空间 M<sub>49,1/25</sub> 极限 ≈ 3.9936</td><td>B · 数值</td><td>嵌套 Ritz 外推，非定理。是“纯 BV + 标准权重”房间的数值地板：3.99 &lt; 4。</td></tr>
        <tr><td>Kato–Temple 全空间升级</td><td>C · blocked</td><td>完整残差 ≈0.106 ≫ 谱隙 ≈0.07；已写成 <code>OPEN_PROBLEM.md</code>。</td></tr>
        <tr><td>改进 246 / 证明孪生素数猜想</td><td>—</td><td>未解决。246 已被外部推进至 240（人类）与 186（GPT-6）。</td></tr>
        <tr><td>“Maynard 筛法的极限就是 246”</td><td>—</td><td>我们从未把它当成定理，只是数值上逼近过这个边界；9 月 4 日它被事实否定。</td></tr>
      </tbody>
    </table>
    <p>回头看，GPT-6 论文把突破归功于 Polymath8b 在 §9 里<strong>九年前就标注过</strong>、但当时“积分难以计算”的未利用方向——更强的光滑模等分布输入。DSH 撞的墙和 GPT-6 开的门，是同一张地图上的同一面墙和同一扇门。这让我们的负结果有了正面价值：它是旧框架边界的独立数值刻画，可以作为后来者引用的界标。</p>
    <div class="two-col">
      <div class="panel">
        <h3>同一天，四种研究范式同场竞技</h3>
        <p><strong>Stadlmann（纯人类）240</strong>：解析层的深度洞察。<strong>GPT-6 Astra 186</strong>：在大搜索空间里找到人类没试过的组合 + Lean 形式化。<strong>Axiom 212 / Anthropic 188</strong>：形式化流水线。<strong>DSH</strong>：工程验证型 agent——不擅长开新路线（它会 fallback 到已知路线），但可以几天几夜不停执行，把一条路线推到可复现证书的边界，并且被审计后能立刻修正。</p>
        <p>负责任的 AI 数学研究需要三者协同：<strong>生成</strong>（提出并搜索路线）、<strong>执行</strong>（长时间跑通并留证）、<strong>验证</strong>（kernel 级检查）。缺任何一环，要么是伪证明，要么是无法复现的宣称。</p>
      </div>
      <div class="panel">
        <h3>给读者的 takeaway</h3>
        <p><strong>第一，目标越清楚，执行越强。</strong> 给 DeepSeek 这样的模型一个明确、可持续、可验收的目标，它可以成为非常可靠的长程执行者；但不要因此期待它自然地产生突破性路线。</p>
        <p><strong>第二，模型有性格。</strong> DSH 偏好计算、验证和工程闭环；GPT Luna 到 Sol 偏好推导、反例和路线判断。前者可能几天不掉线，后者可能几分钟就指出缺口。一个好的研究系统不应让其中一个模型单独承担所有角色。</p>
        <p><strong>第三，先把问题变成优化问题。</strong> 素数间隔、候选爆炸解以及许多未来的数学问题，都可以先经历“搜索—观测—猜测—定制定理—解析证明”的循环。AI 最有价值的地方，可能不是直接替代最后一步，而是把前面的候选空间系统地压缩到人类值得证明的地方。</p>
        <p>差别不只在算力，而在<strong>地图感</strong>：知道哪面墙是死的，哪扇门只是没锁。DSH 的几天没有白跑——它用数百万个事件把一面墙的厚度量了出来。下一次，先给 agent 一张好地图，再给它一条足够长的时间线。</p>
      </div>
    </div>
  </section>

  <section>
    <h2>十二、复现和审计入口</h2>
    <div class="source-box" style="padding:20px">
      <p><strong>本项目：</strong> <a href="https://github.com/guoshaoyang-pku/twin-prime-admissible" target="_blank" rel="noreferrer">twin-prime-admissible</a>（可容许元组见证 + 直径搜索 + 本页轨迹数据）</p>
      <p><strong>新闻之后的新论文：</strong> <a href="https://arxiv.org/abs/2608.31126" target="_blank" rel="noreferrer">Stadlmann, Bounded gaps between primes (240)</a> · <a href="https://cdn.openai.com/pdf/51126fac-1b68-4128-9666-c908bcc16033/short_gaps.pdf" target="_blank" rel="noreferrer">OpenAI, Improved Short Gaps Between Primes (186)</a></p>
      <p><strong>Axiom 对照：</strong> <a href="https://github.com/AxiomMath/PrimeGapsLib" target="_blank" rel="noreferrer">PrimeGapsLib</a> · <a href="https://primegaps.axiommath.ai/paper/" target="_blank" rel="noreferrer">246 形式化论文</a></p>
      <p><strong>轨迹定义：</strong> 页面从 DeepSeek Harness 的 <code>session.history</code> 全量分页读取两条主会话，保留每个逻辑 step 的 turn/step、时间、工具调用、结果、模型摘要和 source sequence 范围；凭证样式字符串被脱敏，assistant 流式 chunk 被聚合。</p>
      <p class="small">这是一个带快照时间的研究日志，不是供应商原始 API 导出。结论等级仍须区分：Lean kernel 检查、区间算术严格有限维结果、可复现计算、启发式解释。</p>
    </div>
  </section>

  <footer>
    <p>Shaoyang Guo · AI-assisted mathematics research log · <a href="https://guoshaoyang-pku.github.io/" target="_blank" rel="noreferrer">个人主页</a></p>
  </footer>
</main>
<div class="tooltip" id="tooltip"></div>
<script>
const DATA = ${payload};
const COLORS = {compute:'#35d0ba', code:'#f4d36d', research:'#a998ff', wait:'#f38bb5', tool:'#b6c5cf', error:'#ff6e7d', model:'#8fa5b5'};
const KIND_LABELS = {compute:'计算', code:'改码', research:'调研', wait:'等待', tool:'工具', error:'错误', model:'模型'};
const sessions = DATA.sessions;
const allSteps = sessions.flatMap(session => session.steps.map((step, index) => ({...step, sessionMeta:session, localIndex:index, id: session.key + ':' + step.turn + ':' + step.step})));
let state = {session:'all', kind:'all', query:'', selected:null, limit:200};
const $ = id => document.getElementById(id);
const escapeHtml = value => String(value ?? '').replace(/[&<>"']/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));
const formatTime = value => value ? new Date(value).toLocaleString('zh-CN', {hour12:false, month:'2-digit', day:'2-digit', hour:'2-digit', minute:'2-digit', second:'2-digit'}) : '—';
const short = (value, n=220) => { const text=String(value ?? ''); return text.length > n ? text.slice(0,n)+'…' : text; };
const stepKind = step => step.kinds?.find(kind => COLORS[kind]) || 'model';
const stepSearch = step => [step.model, ...(step.actions||[]).map(action => action.name+' '+action.text), ...(step.results||[]).map(result => result.text)].join(' ').toLowerCase();
const matches = step => {
  if (state.session !== 'all' && step.session !== state.session) return false;
  if (state.kind !== 'all' && !(step.kinds||[]).includes(state.kind)) return false;
  return !state.query || stepSearch(step).includes(state.query.toLowerCase());
};
const filtered = () => allSteps.filter(matches);
const badge = kind => '<span class="badge '+escapeHtml(kind)+'">'+escapeHtml(KIND_LABELS[kind] || kind)+'</span>';
function drawTimeline() {
  const canvas=$('timeline');
  const rect=canvas.getBoundingClientRect();
  const ratio=window.devicePixelRatio||1;
  const width=Math.max(320, rect.width);
  canvas.width=Math.floor(width*ratio);
  canvas.height=Math.floor(260*ratio);
  const ctx=canvas.getContext('2d');
  ctx.scale(ratio, ratio);
  ctx.clearRect(0,0,width,260);
  ctx.fillStyle='#0b141d';
  ctx.fillRect(0,0,width,260);
  ctx.strokeStyle='#203341';
  ctx.lineWidth=1;
  [88,204].forEach(y => { ctx.beginPath(); ctx.moveTo(0,y); ctx.lineTo(width,y); ctx.stroke(); });
  ctx.strokeStyle='#162733';
  for(let i=1;i<10;i++){ const x=width*i/10; ctx.beginPath(); ctx.moveTo(x,28); ctx.lineTo(x,240); ctx.stroke(); }
  const visible=new Set(filtered().map(step=>step.id));
  sessions.forEach((session, lane) => {
    const y=88+lane*116;
    const count=session.steps.length;
    session.steps.forEach((step,index) => {
      const x=count<2 ? width/2 : 8+(width-16)*index/(count-1);
      const kind=stepKind(step);
      const selected=state.selected?.id===session.key+':'+step.turn+':'+step.step;
      const on=visible.has(session.key+':'+step.turn+':'+step.step);
      ctx.globalAlpha=selected ? 1 : on ? .92 : .13;
      ctx.fillStyle=COLORS[kind]||COLORS.model;
      ctx.beginPath();
      ctx.arc(x,y,selected?5:2.1,0,Math.PI*2);
      ctx.fill();
      if(selected){ ctx.strokeStyle='#fff'; ctx.lineWidth=1.5; ctx.stroke(); }
    });
  });
  ctx.globalAlpha=1;
  ctx.fillStyle='#708796';
  ctx.font='11px ui-monospace, monospace';
  ctx.fillText('step 1',8,246);
  ctx.fillText('step '+Math.max(...sessions.map(session=>session.steps.length)),width-92,246);
  $('vizCount').textContent=filtered().length.toLocaleString()+' / '+allSteps.length.toLocaleString()+' matched';
}
function renderHistogram() {
  const counts={};
  filtered().forEach(step => (step.kinds||['model']).forEach(kind => counts[kind]=(counts[kind]||0)+1));
  const rows=Object.entries(counts).sort((a,b)=>b[1]-a[1]);
  const max=rows[0]?.[1]||1;
  $('histogram').innerHTML=rows.map(([kind,count]) => '<div class="bar-row"><span class="bar-label">'+escapeHtml(KIND_LABELS[kind]||kind)+'</span><div class="bar-track"><div class="bar-fill" style="width:'+Math.round(100*count/max)+'%;background:'+COLORS[kind]+'"></div></div><span class="bar-value">'+count.toLocaleString()+'</span></div>').join('');
}
function renderDetail(step) {
  if(!step){ $('detail').innerHTML='<div class="detail-box"><h4>Selected step</h4><div class="small">点击轨迹上的点，或点击下方列表中的 step。</div></div><div class="detail-box"><h4>How to read</h4><div class="small">横轴是每条会话自己的逻辑顺序；纵向两条 lane 分别是 A/B。透明点仍然是完整轨迹，只是没有匹配当前筛选条件。</div></div>'; return; }
  const actions=(step.actions||[]).map(action => '<div class="action-row">'+badge(action.kind)+' <code>'+escapeHtml(action.name)+'</code></div><pre>'+escapeHtml(action.text)+'</pre>').join('');
  const results=(step.results||[]).map(result => '<div class="action-row">'+badge(result.error?'error':'tool')+' <span class="small">'+(result.error?'error result':'result')+'</span></div><pre>'+escapeHtml(result.text)+'</pre>').join('');
  $('detail').innerHTML='<div class="detail-box"><h4>'+escapeHtml(step.sessionMeta.title)+' · turn '+step.turn+' · step '+step.step+'</h4><div class="pill-row"><span class="pill"><strong>kind</strong> '+escapeHtml(step.kinds.join(', ')||'model')+'</span><span class="pill"><strong>time</strong> '+formatTime(step.start||step.end)+'</span><span class="pill"><strong>duration</strong> '+(step.durationMs ? (step.durationMs/1000).toFixed(1)+'s' : '—')+'</span></div><pre>'+escapeHtml(step.model||'No model summary')+'</pre></div><div class="detail-box"><h4>Tool calls and results · seq '+step.firstSeq+'–'+step.lastSeq+'</h4>'+actions+(results||'<div class="small">No result recorded in this step.</div>')+'</div>';
}
function renderList() {
  const rows=filtered();
  const shown=rows.slice(0,state.limit);
  $('stepList').innerHTML=shown.map(step => {
    const selected=state.selected?.id===step.id;
    const preview=short((step.actions?.[0]?.name ? step.actions[0].name+': ' : '')+(step.actions?.[0]?.text||step.model||'').replace(/\\s+/g,' '),260);
    const actions=(step.actions||[]).map(action => '<div><div class="action-row">'+badge(action.kind)+' <code>'+escapeHtml(action.name)+'</code></div><pre>'+escapeHtml(action.text)+'</pre></div>').join('');
    const results=(step.results||[]).map(result => '<div><div class="action-row">'+badge(result.error?'error':'tool')+' <span class="small">result</span></div><pre>'+escapeHtml(result.text)+'</pre></div>').join('');
    return '<article class="step-card '+(selected?'selected ':'')+'" data-id="'+escapeHtml(step.id)+'"><div class="step-head"><span class="mono" style="color:'+(step.session==='A'?'var(--teal)':'var(--orange)')+'">'+step.session+'</span><strong>turn '+step.turn+' · step '+step.step+'</strong>'+badge(stepKind(step))+'<span class="spacer"></span><span class="seq">seq '+step.firstSeq+'–'+step.lastSeq+'</span><time>'+formatTime(step.start||step.end)+'</time></div><div class="step-preview">'+escapeHtml(preview)+'</div><div class="step-body"><div class="small">'+escapeHtml(step.model||'')+'</div>'+actions+results+'</div></article>';
  }).join('');
  $('listCount').textContent='显示 '+shown.length.toLocaleString()+' / '+rows.length.toLocaleString()+' 个匹配 step；轨迹画布始终绘制全部 '+allSteps.length.toLocaleString()+' 个 step。';
  $('showMore').style.display=shown.length<rows.length?'inline-block':'none';
}
function render() { drawTimeline(); renderHistogram(); renderDetail(state.selected); renderList(); }
function selectStep(step) {
  state.selected = step?.id ? step : allSteps.find(row => row.session === step?.sessionMeta?.key && row.turn === step.turn && row.step === step.step) || step;
  render();
}
function nearestStep(event) {
  const canvas=$('timeline');
  const rect=canvas.getBoundingClientRect();
  const x=Math.max(0,Math.min(rect.width,event.clientX-rect.left));
  const lane=event.clientY-rect.top < 145 ? 0 : 1;
  const session=sessions[lane];
  const index=Math.round((x-8)/(rect.width-16)*Math.max(0,session.steps.length-1));
  const raw = session.steps[Math.max(0,Math.min(session.steps.length-1,index))];
  return allSteps.find(row => row.session === session.key && row.turn === raw.turn && row.step === raw.step) || raw;
}
$('sessionFilter').addEventListener('change', event => { state.session=event.target.value; state.limit=200; render(); });
$('kindFilter').addEventListener('change', event => { state.kind=event.target.value; state.limit=200; render(); });
$('queryFilter').addEventListener('input', event => { state.query=event.target.value.trim(); state.limit=200; render(); });
$('timeline').addEventListener('click', event => selectStep(nearestStep(event)));
$('timeline').addEventListener('mousemove', event => {
  const step=nearestStep(event);
  const tip=$('tooltip');
  tip.style.display='block';
  tip.style.left=(event.clientX+14)+'px';
  tip.style.top=(event.clientY+14)+'px';
  tip.innerHTML='<strong>'+escapeHtml(step.session)+' · turn '+step.turn+' · step '+step.step+'</strong><br>'+escapeHtml(stepKind(step))+' · '+escapeHtml(short(step.actions?.[0]?.name||step.model,90));
});
$('timeline').addEventListener('mouseleave', () => $('tooltip').style.display='none');
$('stepList').addEventListener('click', event => {
  const card=event.target.closest('.step-card');
  if(!card) return;
  const step=allSteps.find(row=>row.id===card.dataset.id);
  if(step){ state.selected=step; card.classList.toggle('open'); renderDetail(step); drawTimeline(); document.querySelectorAll('.step-card').forEach(row=>row.classList.toggle('selected',row===card)); }
});
$('showMore').addEventListener('click', () => { state.limit+=200; renderList(); });
window.addEventListener('resize', drawTimeline);
render();
</script>
</body>
</html>`

fs.writeFileSync(outputPath, html)
