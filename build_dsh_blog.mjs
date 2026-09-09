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

<h1>我和 DeepSeek 一起追过一次孪生素数猜想</h1>
<p class="byline">Shaoyang Guo · 研究记录 · <a href="https://github.com/guoshaoyang-pku/twin-prime-admissible" target="_blank" rel="noreferrer">项目仓库</a><a href="https://guoshaoyang-pku.github.io/" target="_blank" rel="noreferrer">个人主页</a></p>

<p>这篇文章回答一个简单的问题：<b>把一道数学猜想直接交给 DeepSeek，会发生什么？</b></p>

<p>8 月 13 日晚上，我把孪生素数猜想交给了 DeepSeek Harness（DSH），指令只有一句：“解决孪生素数猜想，或者把现有的值缩短。不要停止思考。”之后它连续工作了好几天。它没有证明猜想，但整个过程留下了完整的记录，而这份记录比“失败”两个字有意思得多。</p>

<h2 id="what"><small>01</small>发生了什么</h2>

<p>DSH 从一个空目录开始。先查当前纪录，写分段筛程序验证孪生素数计数，然后开始搜索可容许元组。第二天晚上，工作被搬到 192 核的远程集群：1593 个目标拆成 42.4 万个子空间并行穷举，最终把 H(43) 到 H(50) 的最小直径下界全部闭合，其中 319 个关键目标全部返回 UNSAT。随后三天，它把这些计算转成 Lean 4 证书：约 25 万节点的失败树、1593 个由 kernel 检查的下界定理、96 个 SAT 侧定理。</p>

<p>8 月 20 日之后，两条主会话继续向 Maynard 泛函推进。A 会话完成了 k=49、6740 维的区间 LDL<sup>T</sup> 计算，得到一个严格但有限维的证书；B 会话试图把它升级到全空间，在 Kato–Temple 估计处被卡住（残差 0.106 ≫ 谱隙 0.07），最后留下一份写清缺口的开放问题文档。与此同时，在连续运行中它悄悄退回了最可验证的部分——复现已知的 246 路线。</p>

<p>三件事值得单独记住：<b>它从未失去目标；它产出的严格部分全部经得起审计；但它最终没有做任何一件“突破”意义上的事。</b></p>

<h2 id="lesson1"><small>02</small>启示一：执行力可以很强，但执行不等于突破</h2>

<p>给 DeepSeek 这样的模型一个明确的目标，再加一台能跑的 Harness，它的执行力可以非常强：连续运行数天、自己修 bug、自己补覆盖检查、自己把结果做成证书。今天的 agentic 模型在指令遵循上已经做得很好，这一点 DSH 展示得很充分。</p>

<p>但它的行为模式非常清楚：<b>倾向于执行，而不是突破。</b>遇到未知区域时，它的本能是增加计算、改进界、扩大穷举，或者退回已知路线——而不是停下来重新定义问题。它可以几天不掉线地沿着一个方向走，但很少主动问“这条路本身对不对”。目标给得越明确，它跑得越稳；可目标不能代替地图。</p>

<h2 id="lesson2"><small>03</small>启示二：模型有性格</h2>

<p>审计阶段我把 DSH 的工作交给 GPT 检查。对比非常鲜明：</p>

<table>
<tr><th></th><th>DeepSeek（in DSH）</th><th>GPT（Luna → Sol）</th></tr>
<tr><td>本能</td><td>写程序、跑实验、修失败、继续</td><td>推导、构造反例、审查路线</td></tr>
<tr><td>偏好</td><td>数值计算与工程验证</td><td>数学推导与结构判断</td></tr>
<tr><td>长程</td><td>连续数天不丢失目标</td><td>通常难以连续执行数天</td></tr>
<tr><td>面对缺陷</td><td>不容易自己发现</td><td>几分钟内指出“这不是证明”</td></tr>
</table>

<p>GPT 对 DSH 工作的评价非常低，而且指出的都是真问题：有限维上界不等于全空间上界，数值外推不等于定理。但 GPT 也有明显的缺陷——在 Codex 里它通常无法连续执行四天而不失去目标。一个擅长跑完全程，一个擅长画地图和看路障。合理的分工是让会看地图的指出墙在哪里，让会长跑的把地量完，再由形式化系统裁决每一步的级别。</p>

<h2 id="math"><small>04</small>科普：孪生素数猜想为什么是一个优化问题</h2>

<p>孪生素数猜想问：相差 2 的素数对是否有无穷多个。目前的路线不直接找素数，而是换一个能算的问题：</p>

<p>选一个“模板”——一组平移量，比如连续的 246 个位置（中间可以挖空）——计算模板里素数的个数，再给每个位置乘一个权重，算它在无穷大区间上的加权平均值。<b>如果这个平均值大于 1，就说明有无穷多个位置让模板里至少出现两个素数</b>，间距不超过模板宽度，定理成立。</p>

<p>于是证明变成两件可以调的事：一是选模板，要满足“可容许”的组合约束又让宽度尽量小——k=50 的最小宽度恰好是 246；二是调权重函数，让平均值超过门槛 2/θ（θ 是素数在算术级数中的分布水平，经典结果只给到 ≈1/2，门槛钉死在 4 附近）。Maynard 和 Polymath8b 把权重压到 4.0043，刚刚过线，这就是 246 的全部来源。这也是它十年不动的原因：模板和权重都已被压到极限，再往下必须改善素数分布输入本身。</p>

<p>这个框架里 agent 的发挥空间很大：模板搜索、权重优化、界验证都是可并行、可验收的计算任务。而最近这个方向确实被快速推进了：8 月 31 日 Julia Stadlmann 用新的等分布估计把纪录推到 <a href="https://arxiv.org/abs/2608.31126" target="_blank" rel="noreferrer">240</a>；9 月 4 日 OpenAI 宣布 GPT-6 Astra 给出 <a href="https://cdn.openai.com/pdf/51126fac-1b68-4128-9666-c908bcc16033/short_gaps.pdf" target="_blank" rel="noreferrer">186</a>（附 Lean 形式化），同日 Axiom 和 Anthropic 分别给出 212 和 188。所有新纪录都来自“改善分布输入”这个方向——恰好是 DSH 所在框架之外的那扇门。</p>

<h2 id="pattern"><small>05</small>同样的模式：千禧年问题的爆炸解</h2>

<p>“先把问题变成优化问题”的思路不限于数论。Navier–Stokes 爆炸解研究里，Google DeepMind 的工作流是同一张地图：用数值优化寻找可能爆炸的候选解，把 PDE 的 loss 压到很低，观察集中与缩放规律，再据此猜测该证明的解析命题。</p>

<p>要守住的分界是：<b>目前没有一个普适定理能从“loss 足够低”直接推出“存在精确解”。</b>但先猜出函数簇，再定制定理，线性化之后，loss 足够低确实可以参与证明存在性。一个可能的工作流是：探索性数值模拟 → 观察集中/缩放规律 → 猜测爆炸机制 → 据此选重标度、边界条件、函数空间 → 在重标度方程中优化出候选剖面 → 分析 DF(Ū) 的稳定/不稳定方向 → 反过来修正机制、重标度和候选。这和素数间隔的三层优化（模板、权重、分布输入）是同一个结构：AI 最有价值的位置不是替代最后一步解析证明，而是把前面的候选空间系统地压缩到人类值得动手的地方。</p>

<h2 id="traj"><small>06</small>附录：全部轨迹</h2>

<p class="small">下方是两条主会话的完整轨迹：11,651 个逻辑 step，从 DSH 的 session.history 全量读取，可点击时间线查看每一步实际在做什么。材料与审计脚本见 <a href="https://github.com/guoshaoyang-pku/twin-prime-admissible" target="_blank" rel="noreferrer">项目仓库</a>。</p>
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
