# dh_pose

**One capability bit from GBT V8, packaged standalone.** No. 29 of 341,
`creation` domain (Creation).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 数字人动作控制（主人令 2026-10-13「触手化作骨架操控数字人的所有动作」+「连带手指脚趾都要绑骨」）：`status` 读现状 · `semantics` 读 42 条「意图→骨/轴/符号」语义表 · `compile` 把人话（抬臂/屈指/转身…）编译成骨角度 JSON · `pose` 编译+渲染一张（经 `blender` 位，写盘门在它那层）。轴系来自**旋转轴探针实测**（自转＝局部 Y；v1 用骨末端位移当探针时 Y 恒 0，是量错了地方）；指/趾骨已绑：65 骨中指骨 40 有 30 带权重、趾骨 4 有 2 带权重，其余 13 根全是末端骨。status/semantics/compile 纯读；pose 会写盘。

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-dh-pose.git
cd gbt-dh-pose
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_dh_pose info                  # capability card
python -m gbt_dh_pose spec --json           # machine-readable contract
python -m gbt_dh_pose check --payload '{}'
python -m gbt_dh_pose run   --payload '{}'
```

Real `info` output from this machine:

```text
dh_pose  (creation)  v1.0.0
----------------------------------------
数字人动作控制（主人令 2026-10-13「触手化作骨架操控数字人的所有动作」+「连带手指脚趾都要绑骨」）：`status` 读现状 · `semantics` 读 42 条「意图→骨/轴/符号」语义表 · `compile` 把人话（抬臂/屈指/转身…）编译成骨角度 JSON · `pose` 编译+渲染一张（经 `blender` 位，写盘门在它那层）。轴系来自**旋转轴探针实测**（自转＝局部 Y；v1 用骨末端位移当探针时 Y 恒 0，是量错了地方）；指/趾骨已绑：65 骨中指骨 40 有 30 带权重、趾骨 4 有 2 带权重，其余 13 根全是末端骨。status/semantics/compile 纯读；pose 会写盘。

gated      : True   <- needs explicit consent
external   : False
multi-op   : True
params     : (none)
values     : status, semantics, compile
```

Wire a real implementation:

```python
from gbt_dh_pose import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（3 个）**：`status`、`semantics`、`compile`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Gated: this bit is marked `safe: false` in the registry — it can change state that no inverse action restores.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.12s
```

## Provenance

| field | value |
|---|---|
| capability | `dh_pose` |
| domain | `creation` |
| handler | `dh_pose` |
| safe | `False` (gated = `True`) |
| external | `False` |
| atlas page | [creation/dh_pose](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/creation/dh_pose.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
