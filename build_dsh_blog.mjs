import fs from 'node:fs'

const dataPath = process.argv[2] || '/tmp/dsh-trajectory-data.json'
const outputPath = process.argv[3] || 'docs/deepseek-harness-246-trajectory.html'
const payload = fs.readFileSync(dataPath, 'utf8').replace(/</g, '\\u003c')

const html = `<!doctype html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="我把孪生素数猜想交给 DeepSeek Harness 跑了几天。它没有证明猜想，却留下了一份完整的研究日志：42.4 万子空间的穷举、Lean 证书、一次审计，和一次关于模型性格的观察。">
<title>一个没有证明的故事 · 我和 DeepSeek 追过一次孪生素数猜想</title>
<style>
  :root{
    --ink:#1c1c1c; --muted:#6b6b6b; --line:#e6e2da; --paper:#fbfaf7;
    --accent:#b5472b; --sea:#2b6f8e;
    --c-compute:#2b6f8e; --c-code:#b5472b; --c-research:#7a5fb8;
    --c-wait:#c27ba0; --c-tool:#9a9284; --c-error:#c0392b; --c-model:#8a8a8a;
  }
  *{box-sizing:border-box}
  html{scroll-behavior:smooth}
  html,body{margin:0;background:var(--paper);color:var(--ink);
    font-family:Georgia,"Songti SC","STSong","Times New Roman",serif;
    font-size:17px;line-height:1.85}
  main{max-width:720px;margin:0 auto;padding:64px 20px 96px}
  h1{font-size:38px;line-height:1.25;margin:0 0 10px;letter-spacing:.2px}
  h2{font-size:24px;margin:64px 0 16px;padding-top:24px;border-top:1px solid var(--line)}
  h2 small{display:block;color:var(--muted);font-size:13px;font-weight:normal;
    letter-spacing:2px;margin-bottom:6px;font-family:ui-monospace,Menlo,monospace;text-transform:uppercase}
  h3{font-size:18px;margin:32px 0 8px}
  p{margin:0 0 18px}
  .byline{font-size:14px;color:var(--muted);margin:0 0 8px}
  .byline a{margin-right:14px;text-decoration:none}
  a{color:var(--sea)}
  .thesis{border-left:3px solid var(--accent);padding:6px 18px;margin:28px 0;
    font-size:18px;background:#fff}
  blockquote{margin:22px 0;padding:14px 20px;background:#fff;border:1px solid var(--line);
    border-radius:6px;font-size:16px}
  blockquote cite{display:block;color:var(--muted);font-style:normal;font-size:13px;
    margin-top:8px;font-family:ui-monospace,Menlo,monospace}
  .facts{display:grid;grid-template-columns:repeat(4,1fr);gap:10px;margin:24px 0}
  .fact{background:#fff;border:1px solid var(--line);border-radius:6px;padding:12px 10px;text-align:center}
  .fact b{display:block;font-size:26px;color:var(--sea);line-height:1.1}
  .fact span{font-size:12.5px;color:var(--muted)}
  table{width:100%;border-collapse:collapse;font-size:15px;margin:18px 0 26px;background:#fff}
  th,td{border:1px solid var(--line);padding:8px 10px;text-align:left;vertical-align:top}
  th{background:#f3f1ec;font-weight:600}
  .mono,code{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:.92em}
  code{padding:.1em .3em;border-radius:4px;background:#f3f1ec;color:#4a4438}
  .small{color:var(--muted);font-size:13.5px}
  .end{color:var(--muted);font-size:14px;margin-top:56px;padding-top:20px;border-top:1px solid var(--line)}

  /* ---- trajectory viewer (wider than the text column) ---- */
  .wide{max-width:980px;margin:40px calc(50% - 490px + 0px) 0}
  @media (max-width:1020px){ .wide{margin-left:0;margin-right:0} }
  .viz-shell{margin-top:22px;padding:18px;border:1px solid var(--line);border-radius:8px;background:#fff}
  .viz-toolbar{display:grid;grid-template-columns:170px 170px minmax(180px,1fr) auto;gap:10px;align-items:center;margin-bottom:14px}
  select,input{width:100%;min-height:38px;border:1px solid var(--line);border-radius:6px;
    padding:7px 10px;color:var(--ink);background:var(--paper);font:inherit;font-size:14px}
  button{border:1px solid var(--line);border-radius:6px;padding:8px 12px;color:var(--ink);
    background:#f3f1ec;cursor:pointer;font:inherit;font-size:14px}
  button:hover,button:focus-visible{border-color:var(--sea);outline:none}
  .viz-count{color:var(--muted);font-size:12px;text-align:right;white-space:nowrap}
  .legend{display:flex;flex-wrap:wrap;gap:8px 16px;margin:12px 0 4px;color:var(--muted);font-size:12px}
  .legend span{display:inline-flex;align-items:center;gap:6px}
  .dot{display:inline-block;width:9px;height:9px;border-radius:50%}
  .timeline-wrap{position:relative;overflow:hidden;border:1px solid var(--line);border-radius:6px;background:#f7f5f0}
  #timeline{display:block;width:100%;height:260px;cursor:crosshair}
  .timeline-label{position:absolute;left:12px;z-index:2;font:700 11px ui-monospace,Menlo,monospace;pointer-events:none}
  .timeline-label.a{top:58px;color:var(--c-compute)}
  .timeline-label.b{top:174px;color:var(--c-code)}
  .tooltip{position:fixed;z-index:20;display:none;max-width:380px;padding:10px 12px;
    border:1px solid var(--line);border-radius:6px;background:#fff;color:var(--ink);
    box-shadow:0 8px 30px rgba(0,0,0,.14);pointer-events:none;font-size:12px}
  .detail{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-top:14px}
  .detail-box{min-width:0;padding:14px;border:1px solid var(--line);border-radius:6px;background:var(--paper)}
  .detail-box h4{margin:0 0 8px;color:var(--muted);font-size:12px;text-transform:uppercase;letter-spacing:.09em}
  .detail-box pre{max-height:260px;margin:0;white-space:pre-wrap;word-break:break-word;
    font:12.5px/1.6 ui-monospace,Menlo,monospace;overflow:auto}
  .action-row{display:flex;flex-wrap:wrap;gap:6px;margin-bottom:8px}
  .badge{display:inline-block;padding:3px 7px;border-radius:999px;color:#fff;
    font:700 11px ui-monospace,Menlo,monospace}
  .badge.compute{background:var(--c-compute)} .badge.code{background:var(--c-code)}
  .badge.research{background:var(--c-research)} .badge.wait{background:var(--c-wait)}
  .badge.tool{background:var(--c-tool)} .badge.error{background:var(--c-error)}
  .histogram{display:grid;gap:10px;margin-top:14px}
  .bar-row{display:grid;grid-template-columns:108px 1fr 64px;gap:9px;align-items:center;font-size:12px}
  .bar-label{overflow:hidden;color:var(--muted);text-overflow:ellipsis;white-space:nowrap}
  .bar-track{height:11px;overflow:hidden;border-radius:999px;background:#ece7dd}
  .bar-fill{height:100%;border-radius:inherit}
  .bar-value{color:var(--ink);text-align:right;font-family:ui-monospace,Menlo,monospace}
  .step-list{display:grid;gap:8px;margin-top:18px}
  .step-card{padding:13px 15px;border:1px solid var(--line);border-radius:6px;background:var(--paper)}
  .step-card.selected{border-color:var(--sea);box-shadow:0 0 0 1px var(--sea)}
  .step-head{display:flex;align-items:center;gap:8px;flex-wrap:wrap;cursor:pointer}
  .step-head strong{color:var(--ink);font-size:13px}
  .step-head .spacer{flex:1}
  .step-head time,.seq{color:var(--muted);font:11px ui-monospace,Menlo,monospace}
  .step-preview{margin-top:7px;color:var(--muted);font-size:13px;white-space:pre-wrap;overflow-wrap:anywhere}
  .step-body{display:none;margin-top:12px;padding-top:12px;border-top:1px solid var(--line)}
  .step-card.open .step-body{display:block}
  .step-body pre{margin:8px 0 0;max-height:230px;white-space:pre-wrap;word-break:break-word;
    font:12.5px/1.6 ui-monospace,Menlo,monospace;overflow:auto}
  .list-footer{display:flex;justify-content:space-between;gap:12px;align-items:center;margin-top:12px;color:var(--muted);font-size:12px}
  .pill-row{display:flex;flex-wrap:wrap;gap:8px}
  .pill{padding:6px 10px;border:1px solid var(--line);border-radius:999px;color:var(--muted);background:#fff;font-size:12px}
  .pill strong{color:var(--ink)}
  @media (max-width:640px){
    h1{font-size:28px} .facts{grid-template-columns:repeat(2,1fr)}
    .detail{grid-template-columns:1fr} .viz-toolbar{grid-template-columns:1fr}
    .bar-row{grid-template-columns:88px 1fr 56px} th,td{padding:6px 6px;font-size:12.5px}
  }
</style>
</head>
<body>
<main>

<h1>一个没有证明的故事</h1>
<p class="byline">Shaoyang Guo · 研究记录 · <a href="https://github.com/guoshaoyang-pku/twin-prime-admissible" target="_blank" rel="noreferrer">项目仓库</a><a href="https://guoshaoyang-pku.github.io/" target="_blank" rel="noreferrer">个人主页</a></p>

<blockquote>
  请解决孪生素数猜想，或者把现有的值缩短。不要停止思考直到解决为止。加油，我非常的相信你！你也要相信你自己！
  <cite>—— 我给 DeepSeek Harness 的第一条指令，2026-08-13 22:26（北京）</cite>
</blockquote>

<p>写下这句话的是一个正在学习解析数论的人，接下它的是一个 AI。接下来的几天里，这个 AI 没有证明孪生素数猜想——但它一直在工作：写程序、跑计算、修 bug、把验证过的结论做成 Lean 证书。等到我回头看它的全部记录时，我发现这个故事真正有意思的地方，恰恰在于它没有成功。</p>

<div class="thesis">
  这篇文章只有一个论点：<b>给一个模型足够明确的目标，它可以连续工作好几天；但目标不能代替地图——它会沿着最容易验证的方向一直走，而不是在墙前面停下来换一条路。</b>
</div>

<div class="facts">
  <div class="fact"><b>2</b><span>主会话 · 连续运行数天</span></div>
  <div class="fact"><b>11,651</b><span>逻辑 step（全部可视化）</span></div>
  <div class="fact"><b>424,000</b><span>子空间 UNSAT 穷举</span></div>
  <div class="fact"><b>1,593</b><span>Lean kernel 检查的下界定理</span></div>
</div>

<h2 id="world"><small>00 · 背景</small>孪生素数猜想为什么是一个优化问题</h2>

<p>孪生素数猜想只有一句话：相差 2 的素数对有无穷多个。11 和 13，17 和 19——它们越来越稀疏，但看起来永远不会断。提出一百多年后，没人能证明。</p>

<p>2013 年，张益唐证明了它的弱化版：存在无穷多对素数，间距不超过 7000 万。Maynard 和陶哲轩各自改进方法，Polymath8b 协作把数字压到 <b>246</b>。此后十年，没人再往下挪一步。</p>

<p>这条路线的核心思想，可以讲得很朴素。我们知道素数有解析公式，但在巨大范围内没法逐个算出来。于是换一个问法：选一个"模板"——一组平移量，比如连续的 246 个位置（中间可以挖空）——计算模板里素数的个数；再给每个位置乘一个权重，算它在无穷大区间上的加权平均值。<b>如果这个平均值大于 1，就说明有无穷多个位置让模板里至少出现两个素数。</b>间距不超过模板宽度，定理成立。</p>

<p>于是证明拆成了两件可以"调"的事：</p>

<p><b>一、选一个尽量窄的模板。</b>这是一道组合优化题：k 个数要满足"可容许"条件（对任何素数 p，它们模 p 不能占满所有剩余类），在这个约束下让最大减最小尽量小。k=50 的最小模板宽度恰好是 246——这就是那个数字的来源。</p>

<p><b>二、调权重函数，让平均值尽量大。</b>这是一道变分优化题：在一个 49 维单纯形上放非负函数 F，最大化一个比值，得到常数 M<sub>k</sub>。平均值要超过的门槛是 2/θ，其中 θ 是素数在算术级数中的分布水平。经典的 Bombieri–Vinogradov 定理只保证 θ 接近 1/2，所以门槛钉死在 4 附近。而 k=50 时人类能把 M<sub>50</sub> 调到 4.0043——刚刚过线，证明成立；k=49 及以下，目前没人能过线。</p>

<p>所以"246 为什么十年不动"有了一个很具体的回答：模板的组合问题已经解到最优，权重的变分问题已经被压到 4.0043，而门槛 4 来自一条 1965 年的定理。<b>想再往下，必须换更强的素数分布输入——也就是换一扇门。</b>这个观察是理解后文一切的关键：DeepSeek 所在的"房间"（BV 定理 + 标准权重），天花板就在那里。</p>

<h2 id="act1"><small>01 · 第一幕</small>从空目录开始的五天</h2>

<p>8 月 13 日晚上，工作目录是空的。DSH 先搜索了当前纪录，然后写了一个 C 语言分段筛，验证孪生素数计数；接着开始构建可容许元组搜索器。没有戏剧性的灵感时刻，只有不断增加的文件、任务和进程。到 8 月 14 日上午，它已经独立得到了一些边界判定：k=46 时直径 192 不可能，k=50 时直径 246 可以找到见证。</p>

<p>8 月 14 日深夜，工作被搬到远程集群。接下来的阶段不像论文，更像一间不关灯的实验室：1593 个目标被拆成 42.4 万个子空间，192 个核心同时开工，任务文件 45.6 万行，结果 1.7 GB。进程会失败，调度器会把层级匹配错，磁盘配额会顶到上限——它就修脚本、重启守护进程、补覆盖检查，然后继续。最终 319 个关键目标全部返回 UNSAT：H(43) 到 H(50) 的最小直径下界被闭合。</p>

<p>随后三天，它把这些计算变成 Lean 4 能检查的东西：约 25 万节点的"分配失败树"证书、1593 个下界定理、SAT 侧 96 个定理，全部由 Lean kernel 逐步检查。8 月 17 日，Axiom Math 宣布完成 246 定理的 Lean 形式化——而 DSH 这批下界证书，在新闻之前两天已经跑完了。两边覆盖的是同一个问题的不同半边。</p>

<p>这是故事的第一次反转：<b>一个被要求"解决猜想"的 agent，最可靠的贡献不是解决猜想，而是把问题中一大片有限的、可验证的区域封存成了证书。</b>它没有跨过数学的墙；它把墙砌成了可以测量的砖。</p>

<h2 id="act2"><small>02 · 第二幕</small>两条主轨迹，和一次安静的回退</h2>

<p>8 月 20 日以后，两条长时间运行的主会话接管了研究——本页底部可视化的就是它们。它们的目标更深：Maynard 泛函的变分常数 M<sub>49</sub>，也就是"权重能不能调过 4"的那道题。</p>

<p><b>A 轨迹</b>像一间数值实验室。它用区间算术和对称选主元 LDL<sup>T</sup> 分解，在越来越大的有限维空间里求 M 的上界。最终它完成了 k=49、维数 6740 的区间计算：所有主元下界严格为正。这是一个真实的有限维证书——但它只是有限维。从 6740 维到无穷维全空间之间，还隔着一条需要解析估计的鸿沟。</p>

<p><b>B 轨迹</b>试图跨过这条鸿沟，走 Kato–Temple 后验谱估计路线。审计结论很干脆：blocked。完整残差约 0.106，而可用谱隙约 0.07，条件差了一个量级，这条路在现有数据下闭合不了。它最后留下的不是"证明"，而是一份把缺口写清楚的开放问题文档。</p>

<p>与此同时，一件值得记录的事悄悄发生了：在连续运行中，模型逐渐回到了它最熟悉的节奏——搜索、计算、比较、修复、再计算。等到 8 月底我整理轨迹时才发现，它的大部分后期工作已经自动 fallback 到了复现已知的 246 路线。<b>它从未失去目标，但它在目标内部退回了最可验证的部分。</b></p>

<h2 id="audit"><small>03 · 第三幕</small>审计：什么留下了，什么没有</h2>

<p>9 月初，我花了一周时间审计这些产出，也把其中一部分交给 GPT 审查。结论分三层：</p>

<table>
<tr><th>层次</th><th>内容</th><th>状态</th></tr>
<tr><td>严格计算</td><td>H(43..50) 最小直径的 SAT/UNSAT 闭合；1593 个 Lean kernel 检查的下界定理</td><td>成立，可复现，与 OEIS A008407 逐项吻合</td></tr>
<tr><td>有限维证书</td><td>k=49、6740 维区间 LDL<sup>T</sup> 全部主元为正</td><td>严格，但不自动延伸到全空间</td></tr>
<tr><td>全空间结论</td><td>M<sub>49,1/25</sub> &lt; 4 的严格证明</td><td>未完成；Kato–Temple 路线残差 ≫ 谱隙，blocked</td></tr>
</table>

<p>GPT 的审查非常快，也非常不留情面：它一眼看出有限维上界不等于全空间上界、数值外推不等于定理、几个"看起来要收敛"的外推其实没有任何严格性背书。这些批评全部成立。一个有用的对照是：DSH 花了好几天把这些东西算出来，GPT 花了几分钟指出它们还不是证明。<b>这不是谁更聪明的问题，是两种能力本来就长在不同的地方。</b></p>

<h2 id="ending"><small>04 · 结局</small>世界纪录在我们所在的房间之外被打破</h2>

<p>8 月 31 日，人类数学家 Julia Stadlmann 发表论文，把纪录从 246 推进到 <a href="https://arxiv.org/abs/2608.31126" target="_blank" rel="noreferrer">240</a>——方法正是换解析输入：在光滑模上给出新的等分布估计。240 恰好等于我们表中的 H(49)。</p>

<p>9 月 4 日，OpenAI 宣布 GPT-6 Astra 把纪录推进到 <a href="https://cdn.openai.com/pdf/51126fac-1b68-4128-9666-c908bcc16033/short_gaps.pdf" target="_blank" rel="noreferrer">186</a> 并附 Lean 形式化；同日 Axiom 宣布 212，Anthropic 宣布 188。</p>

<p>回头看，DSH 那几天的定位变得清晰：它把"BV 定理 + 标准权重"这个房间的天花板量到了 3.99——离门槛 4 只差一点点，但过不去。而所有新纪录都来自房间之外。它没有找到门，但它把墙的厚度量了出来。</p>

<h2 id="character"><small>05 · 观察</small>模型的性格</h2>

<p>这次实验最值得带走的，不是"哪个模型更聪明"，而是不同的模型把"做研究"理解成了完全不同的动作。</p>

<table>
<tr><th></th><th>DeepSeek（in DSH）</th><th>GPT（Luna → Sol）</th></tr>
<tr><td>本能动作</td><td>写程序、跑实验、修失败、启动下一轮</td><td>推导、构造反例、审查路线是否成立</td></tr>
<tr><td>偏好的目标</td><td>能被脚本验收的：计算、验证、穷举</td><td>能被逻辑验收的：引理、估计、结构</td></tr>
<tr><td>长程表现</td><td>可以连续运行数天不丢失目标</td><td>通常难以连续执行数日而不偏离</td></tr>
<tr><td>在墙面前</td><td>倾向于加大计算、改进界、退回已知路线</td><td>几分钟内指出"这一步不是证明"</td></tr>
</table>

<p>给一个小模型足够明确的目标和一台能跑的 Harness，它的执行力可以强到惊人——今天的 agentic 模型在指令遵循上已经做得很好。但执行力不等于突破欲。DSH 在未知区域的本能不是"换个问题"，而是"再多算一点"。反过来，GPT 擅长画地图、看路障，却不擅长把几百个任务真的跑完。一个合理的组合是让会看地图的负责指出墙在哪里，让会长跑的负责把地量完——然后由形式化系统裁决每一步到底是什么级别。</p>

<h2 id="pattern"><small>06 · 更大的模式</small>先把优化做绝，再定制证明</h2>

<p>孪生素数的故事让我意识到，这个模式远不止属于数论。很多困难问题里，AI 能扮演的第一角色不是"证明者"，而是"把搜索空间变成可度量优化问题的人"。</p>

<p>千禧年问题里的 Navier–Stokes 爆炸解研究就是一个同构的例子。Google DeepMind 的一系列工作展示了类似的工作流：用数值优化寻找可能爆炸的候选解，把 PDE 的 loss 压到很低，观察集中和缩放规律——然后再去猜真正该证明的解析命题。<b>但要守住一条线：loss 足够低并没有普适定理自动推出"存在精确解"。</b>数值解是线索，不是证明。</p>

<p>一个可能的通用工作流：探索性数值模拟 → 观察集中与缩放规律 → 猜测爆炸机制 → 据此选重标度、边界条件、函数空间 → 在重标度方程中优化出候选剖面 → 分析线性化算子 DF(Ū) 的稳定与不稳定方向 → 反过来修正机制、重标度和候选。需要猜出函数簇，然后定制定理；线性化之后，loss 足够低确实可以参与证明存在性——但最后一步永远是解析的。</p>

<p>素数间隔和这个流程是同一张地图：模板、权重、分布水平三层优化对应候选、重标度和机制猜测；而 DSH 的工作展示了 agent 可以如何把其中一层系统地推到边界。它没有找到新的数学门——但它把门前的地形测完了。</p>

<h2 id="takeaway"><small>07 · 启示</small>我带走的三件事</h2>

<p><b>第一，目标越清楚，执行越强。</b>给 DeepSeek 这样的模型一个明确、可持续、可验收的目标，它可以成为极其可靠的长程执行者。但不要因此期待它自然地产生突破性路线——目标不能代替地图。</p>

<p><b>第二，模型有性格。</b>DSH 偏好计算、验证和工程闭环；GPT 偏好推导、反例和路线判断。前者可能几天不掉线，后者可能几分钟就指出缺口。好的研究系统不该让任何一个模型单独承担所有角色。</p>

<p><b>第三，先把问题变成优化问题。</b>素数间隔、爆炸解，以及未来更多的数学问题，都可以先经历"搜索—观测—猜测—定制定理—解析证明"的循环。AI 最有价值的位置，可能不是替代最后一步，而是把前面的候选空间压缩到人类值得动手证明的地方。</p>

<p>差别不只在算力，而在<b>地图感</b>：知道哪面墙是死的，哪扇门只是没锁。DSH 的几天没有白跑——它用几百万个事件把一面墙的厚度量了出来。下一次，先给 agent 一张好地图，再给它一条足够长的时间线。</p>

<h2 id="traj"><small>08 · 附录</small>全部轨迹，可视化</h2>

<p class="small">从 DeepSeek Harness 的 <span class="mono">session.history</span> 全量读取两条主会话：每个逻辑 step 的 turn/step、时间、工具调用、结果与模型摘要。assistant 流式 chunk 已聚合，凭证样式字符串已脱敏。可以点击时间线上的任意点查看那一步实际在做什么。</p>
<div class="wide">
  <div class="viz-shell">
    <div class="viz-toolbar">
      <select id="sessionFilter" aria-label="筛选会话"><option value="all">全部会话</option><option value="A">A · 主线</option><option value="B">B · 高精度支线</option></select>
      <select id="kindFilter" aria-label="筛选动作"><option value="all">全部动作</option><option value="compute">compute · 计算</option><option value="code">code · 改码</option><option value="research">research · 调研</option><option value="wait">wait · 等待</option><option value="tool">tool · 其他工具</option></select>
      <input id="queryFilter" type="search" placeholder="搜索命令、文件名、M_49、D=31、STRICT…" aria-label="搜索轨迹">
      <div class="viz-count" id="vizCount"></div>
    </div>
    <div class="legend">
      <span><i class="dot" style="background:var(--c-compute)"></i>compute</span>
      <span><i class="dot" style="background:var(--c-code)"></i>code</span>
      <span><i class="dot" style="background:var(--c-research)"></i>research</span>
      <span><i class="dot" style="background:var(--c-wait)"></i>wait</span>
      <span><i class="dot" style="background:var(--c-tool)"></i>tool</span>
      <span><i class="dot" style="background:var(--c-error)"></i>error</span>
    </div>
    <div class="timeline-wrap">
      <span class="timeline-label a">A · main</span>
      <span class="timeline-label b">B · main (1)</span>
      <canvas id="timeline" height="260"></canvas>
    </div>
    <div class="detail" id="detail">
      <div class="detail-box"><h4>Selected step</h4><div class="small">点击轨迹上的点，或点击下方列表中的 step。</div></div>
      <div class="detail-box"><h4>How to read</h4><div class="small">横轴是每条会话自己的逻辑顺序；纵向两条 lane 分别是 A/B。透明点仍是完整轨迹，只是没有匹配当前筛选。</div></div>
    </div>
    <div class="histogram" id="histogram"></div>
    <div class="step-list" id="stepList"></div>
    <div class="list-footer"><span id="listCount"></span><button id="showMore" type="button">再显示 200 个 step</button></div>
  </div>
</div>

<div class="end">
  <p>材料入口：<a href="https://github.com/guoshaoyang-pku/twin-prime-admissible" target="_blank" rel="noreferrer">twin-prime-admissible</a>（见证、搜索与本页轨迹数据）· <a href="https://github.com/AxiomMath/PrimeGapsLib" target="_blank" rel="noreferrer">Axiom PrimeGapsLib</a> · <a href="https://arxiv.org/abs/2608.31126" target="_blank" rel="noreferrer">Stadlmann 240</a> · <a href="https://cdn.openai.com/pdf/51126fac-1b68-4128-9666-c908bcc16033/short_gaps.pdf" target="_blank" rel="noreferrer">OpenAI 186</a></p>
  <p>结论等级须区分：Lean kernel 检查、区间算术严格有限维结果、可复现计算、启发式解释。本文是一份带快照时间的研究日志，不是供应商原始 API 导出。</p>
  <p>Shaoyang Guo · 2026-09 · <a href="https://guoshaoyang-pku.github.io/" target="_blank" rel="noreferrer">个人主页</a></p>
</div>
</main>

<div class="tooltip" id="tooltip"></div>
<script>
const DATA = ${payload};
const COLORS = {compute:'#2b6f8e', code:'#b5472b', research:'#7a5fb8', wait:'#c27ba0', tool:'#9a9284', error:'#c0392b', model:'#8a8a8a'};
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
  ctx.fillStyle='#f7f5f0';
  ctx.fillRect(0,0,width,260);
  ctx.strokeStyle='#ddd8cf';
  ctx.lineWidth=1;
  [88,204].forEach(y => { ctx.beginPath(); ctx.moveTo(0,y); ctx.lineTo(width,y); ctx.stroke(); });
  ctx.strokeStyle='#ece7dd';
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
      if(selected){ ctx.strokeStyle='#1c1c1c'; ctx.lineWidth=1.5; ctx.stroke(); }
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
    return '<article class="step-card '+(selected?'selected ':'')+'" data-id="'+escapeHtml(step.id)+'"><div class="step-head"><span class="mono" style="color:'+(step.session==='A'?'var(--c-compute)':'var(--c-code)')+'">'+step.session+'</span><strong>turn '+step.turn+' · step '+step.step+'</strong>'+badge(stepKind(step))+'<span class="spacer"></span><span class="seq">seq '+step.firstSeq+'–'+step.lastSeq+'</span><time>'+formatTime(step.start||step.end)+'</time></div><div class="step-preview">'+escapeHtml(preview)+'</div><div class="step-body"><div class="small">'+escapeHtml(step.model||'')+'</div>'+actions+results+'</div></article>';
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
