# KIWL 全站 SEO 金字塔关键词结构

> 站点：https://www.cupmakingmachines.com  
> 品牌词（全站通用）：KIWL, KIWL Machinery, cupmakingmachines.com

## 金字塔层级

```
                    [T1 首页/核心页]
              Paper Cup Machine | Paper Bowl Machine | Salad Bowl Machine
                              |
              ┌───────────────┼───────────────┐
         [T2 品类页]    [T2 品类页]    [T2 品类页]
    Paper Cup Machine  Paper Bowl Machine  Paper Cup Sleeve Machine ...
              |               |
    ┌─────────┼─────────┐     |
 [T3 子品类]  [T3]      [T3]  [T3 子品类]
 High Speed   Automatic Disposable  High Speed Paper Bowl ...
              |
         [T4 产品型号页]
    XSL-16TS, XSL-350T, XSL-2000S, 具体机型 ...
              |
         [T5 新闻/长尾内容]
    How paper cup machines work, industry trends, buying guides ...
```

## T1 — 核心词（首页、About、Products、Contact）

| 页面 | 主关键词 | 辅关键词 |
|------|----------|----------|
| index.html | Paper Cup Machine | Paper Bowl Machine, Salad Bowl Machine, China paper cup machine manufacturer |
| about.html | KIWL Machinery | paper cup machine factory, Jiangsu manufacturer |
| products.html | Paper Cup Making Machines | full servo, high speed, automatic |
| contact.html | Contact KIWL | paper cup machine quote, factory visit |

## T2 — 品类词（分类着陆页）

| 页面 | 主关键词 | 向上链接（内链锚文本） |
|------|----------|------------------------|
| paper-cup-machine.html | Paper Cup Machine | ← 首页 |
| paper-bowl-machine.html | Paper Bowl Machine | ← 首页 |
| salad-bowl-machine.html | Salad Bowl Machine | ← 首页 |
| paper-cup-sleeve-machine.html | Paper Cup Sleeve Machine | ← 首页 |
| paper-cup-packing-machine.html | Paper Cup Packing Machine | ← 首页 |

## T3 — 子品类词（功能/类型细分）

| 页面模式 | 主关键词 | 父级品类 |
|----------|----------|----------|
| high-speed-*-machine.html | High Speed * Machine | Paper Cup/Bowl Machine |
| automatic-*-machine.html | Automatic * Machine | Paper Cup/Bowl Machine |
| disposable-*-machine.html | Disposable * Machine | Paper Cup/Bowl Machine |
| full-automatic-*-machine.html | Full Automatic * Machine | Paper Cup/Bowl Machine |

## T4 — 产品型号词（具体 SKU/机型）

| 示例页面 | 主关键词 | 父级 |
|----------|----------|------|
| xsl-16ts-xsl-320tpaper-cup-machine.html | XSL-16TS Paper Cup Machine | Paper Cup Machine |
| xsl-350t-high-speed-paper-cup-machine.html | XSL-350T High Speed Paper Cup Machine | High Speed Paper Cup Machine |
| xsl-2000s-*-salad-bowl-machine.html | XSL-2000S Square Paper Bowl Machine | Salad Bowl Machine |

## T5 — 长尾/资讯词（News 文章）

每篇文章以文章标题为主关键词，辅以：
- paper cup machine
- paper bowl machine
- 相关品类词（自动从 URL 推断）

## Google 算法合规要点（已实施）

1. **唯一 Title / Description** — 每页独立 meta，避免批量重复模板
2. **Canonical + hreflang** — 英文/阿拉伯语互指，canonical 与 og:url 一致
3. **结构化数据** — BreadcrumbList、Organization、Product/NewsArticle；移除无效 $0 价格
4. **sitemap.xml** — 全站 EN+AR URL 索引
5. **robots.txt** — 允许抓取并指向 sitemap
6. **移除无效 SearchAction** — 无 search.html 时不声明站内搜索 schema
7. **绝对 URL** — og:image、schema logo/image 使用完整 HTTPS 地址

## 维护

运行优化脚本（修改后或新增页面时）：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/seo-pyramid.ps1
```
