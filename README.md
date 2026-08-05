# muzhiki_core

Melos monorepo with shared Flutter packages for Muzhiki apps.

## Structure

```
muzhiki_core/
├── melos.yaml
├── packages/
│   ├── muzhiki_dependencies
│   ├── muzhiki_ui
│   ├── muzhiki_bridge
│   ├── muzhiki_support
│   ├── muzhiki_report_problem
│   └── flutter_appauth
└── apps/                  # local path-deps placeholders
    ├── mp_master
    ├── mp_business
    └── mp_client
```

## Setup

```bash
dart pub global activate melos
melos bootstrap
```

## Use from external apps (git)

```yaml
dependencies:
  muzhiki_dependencies:
    git:
      url: https://github.com/linarchingizov1-ux/muzhiki_core.git
      path: packages/muzhiki_dependencies
      ref: main
  muzhiki_support:
    git:
      url: https://github.com/linarchingizov1-ux/muzhiki_core.git
      path: packages/muzhiki_support
      ref: main
```

## Package graph

```
muzhiki_ui
    ↑
muzhiki_dependencies
    ↑
muzhiki_bridge / muzhiki_support / muzhiki_report_problem
```
