# Plano Técnico — FeedPlan

## 1. Arquitetura de Pastas e Camadas

```
lib/
├── app/
│   ├── app.dart                  # Config do MaterialApp, tema, rotas
│   ├── router.dart               # GoRouter (ou Navigator 2.0)
│   └── theme.dart                # Tema customizado
│
├── core/
│   ├── constants/
│   │   └── app_constants.dart    # Dimensões de grid, formatos, etc.
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── utils/
│   │   ├── file_utils.dart       # Path helpers, sanitização
│   │   ├── media_utils.dart      # Extrair metadados de imagem/vídeo
│   │   └── permissions.dart      # Camada única de permissão
│   └── extensions/
│       └── context_extensions.dart
│
├── data/
│   ├── database/
│   │   ├── app_database.dart     # init Isar/Drift, migrations
│   │   └── schemas/              # Schemas gerados pelo Isar/Drift
│   ├── models/
│   │   ├── profile_model.dart
│   │   ├── carousel_model.dart
│   │   ├── media_item_model.dart
│   │   └── project_model.dart
│   └── repositories/
│       ├── profile_repository_impl.dart
│       ├── carousel_repository_impl.dart
│       ├── media_repository_impl.dart
│       └── project_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   ├── profile.dart
│   │   ├── carousel.dart
│   │   ├── media_item.dart
│   │   └── project.dart
│   ├── repositories/
│   │   ├── profile_repository.dart      (abstract)
│   │   ├── carousel_repository.dart     (abstract)
│   │   ├── media_repository.dart        (abstract)
│   │   └── project_repository.dart      (abstract)
│   └── usecases/
│       ├── carousel/
│       │   ├── create_carousel.dart
│       │   ├── reorder_media.dart
│       │   ├── crop_media.dart
│       │   └── export_carousel.dart
│       ├── profile/
│       │   ├── create_profile.dart
│       │   └── update_profile.dart
│       └── project/
│           ├── save_project.dart
│           └── load_project.dart
│
├── presentation/
│   ├── providers/                # Riverpod providers
│   │   ├── profile_provider.dart
│   │   ├── carousel_provider.dart
│   │   ├── grid_preview_provider.dart
│   │   └── export_provider.dart
│   ├── pages/
│   │   ├── home/
│   │   │   ├── home_page.dart
│   │   │   └── widgets/
│   │   │       ├── project_card.dart
│   │   │       └── empty_state.dart
│   │   ├── profile_setup/
│   │   │   ├── profile_setup_page.dart
│   │   │   └── widgets/
│   │   │       ├── avatar_picker.dart
│   │   │       └── profile_form.dart
│   │   ├── carousel_editor/
│   │   │   ├── carousel_editor_page.dart
│   │   │   └── widgets/
│   │   │       ├── media_list.dart         # Drag-and-drop reorderable
│   │   │       ├── media_tile.dart
│   │   │       ├── crop_overlay.dart
│   │   │       └── carousel_preview.dart
│   │   ├── grid_preview/
│   │   │   ├── grid_preview_page.dart
│   │   │   └── widgets/
│   │   │       ├── grid_tile.dart
│   │   │       └── post_highlight.dart
│   │   └── export/
│   │       └── export_page.dart
│   └── shared_widgets/
│       ├── aspect_ratio_selector.dart
│       ├── loading_overlay.dart
│       └── confirmation_dialog.dart
│
└── main.dart
```

### Camadas e responsabilidades

| Camada | Responsabilidade |
|---|---|
| **domain** | Entidades puras Dart + interfaces de repositório + casos de uso. Zero dependência Flutter. |
| **data** | Implementação dos repositórios (Isar/Drift), models com serialização, lógica de banco. |
| **presentation** | Widgets, páginas, providers Riverpod. Tudo que é Flutter. |
| **core** | Constantes, utilitários, extensões, tratamento de erro. |

## 2. Modelagem do Banco de Dados Local

### Escolha: **Isar** (versão 3.x) ou **Drift** (recomendado)

**Drift (preferido)** — SQLite tipado com code generation, maturidade, migrations explícitas, bom para consultas relacionais (profile → carrosséis → media items). Suporta Flutter nativo e web.

**Isar** — Alternativa NoSQL embarcada, rápida, mas ecossistema ainda instável (teve rewrites grandes entre versões). Se optar por simplicidade extrema, vale considerar.

### Entidades

```dart
// --- Profile (Perfil fake local) ---
// Um usuário pode ter vários perfis salvos.
Profile {
  id: String (UUID)
  name: String
  bio: String? (opcional)
  avatarPath: String? (caminho local da foto de perfil)
  createdAt: DateTime
  updatedAt: DateTime
}

// --- Project (Projeto salvo) ---
// Agrupa carrosséis planejados. Um profile tem N projects.
Project {
  id: String (UUID)
  profileId: String (FK -> Profile)
  title: String
  createdAt: DateTime
  updatedAt: DateTime
}

// --- Carousel (Post / Carrossel) ---
// Cada carrossel pertence a um projeto.
Carousel {
  id: String (UUID)
  projectId: String (FK -> Project)
  order: int (posição no grid)
  aspectRatio: String ("1:1" | "4:5" | "9:16" | "16:9")
  createdAt: DateTime
  updatedAt: DateTime
}

// --- MediaItem (cada slide do carrossel) ---
MediaItem {
  id: String (UUID)
  carouselId: String (FK -> Carousel)
  filePath: String (caminho local do arquivo original)
  thumbnailPath: String? (caminho do thumbnail gerado)
  mediaType: String ("image" | "video")
  orderIndex: int (posição dentro do carrossel)
  cropRect: String? // JSON: {x, y, width, height} normalizado 0-1
  videoTrimStart: double? (segundos)
  videoTrimEnd: double? (segundos)
  filterApplied: String? (opcional futuro)
  createdAt: DateTime
}
```

### Relacionamentos

```
Profile 1──N Project 1──N Carousel 1──N MediaItem
```

### Por que UUID em vez de auto-increment?
- Facilita futura sincronização entre dispositivos.
- Evita conflitos se o usuário migrar dados.

## 3. Pacotes Recomendados

| Pacote | Versão | Justificativa |
|---|---|---|
| **drift** | ^2.x | ORM SQLite tipado, code generation, migrations |
| **sqlite3_flutter_libs** | ^0.x | Libs nativas do SQLite para drift |
| **flutter_riverpod** | ^2.x | Gerenciamento de estado reativo, injection |
| **riverpod_annotation** | ^2.x | Code gen para providers |
| **go_router** | ^14.x | Roteamento declarativo, suporte a deep links |
| **image_picker** | ^1.x | Seleção de fotos/vídeos da galeria |
| **image_cropper** | ^?-* | Corte de imagem com UI nativa |
| **video_trimmer** | ^3.x | Trim básico de vídeo (cortar início/fim) |
| **reorderable_list_view** | ^2.x | Drag-and-drop para reordenar slides |
| **image_gallery_saver_plus** | ^2.x | Salvar mídia na galeria (fork maintainado do original) |
| **path_provider** | ^2.x | Diretórios do app (documentos, cache) |
| **uuid** | ^4.x | Geração de UUIDs para entidades |
| **permission_handler** | ^11.x | Permissões de galeria/câmera |
| **equatable** | ^2.x | Value equality para entidades |
| **freezed** | ^2.x (dev) | Code gen para data classes (imutabilidade) |
| **drift_dev** | ^2.x (dev) | Code gen do drift |
| **riverpod_generator** | ^2.x (dev) | Code gen do riverpod |
| **build_runner** | ^2.x (dev) | Executor de code gen |
| **flutter_launcher_icons** | ^0.14.x (dev) | Ícone do app |
| **flutter_native_splash** | ^2.x (dev) | Tela de splash |

### Pacotes opcionais (pós-MVP)
| Pacote | Para quê |
|---|---|
| **firebase_crashlytics** | Monitoramento de crashes |
| **sentry_flutter** | Alternativa ao Crashlytics |
| **drift_remote_sync** | Backup/sync entre dispositivos (usando SQLite remoto) |

## 4. Plano de Telas e Fluxo de Navegação

```
┌──────────────────────────────┐
│        Home (Dashboard)      │  ← Tela inicial
│  ┌───┐ ┌───┐ ┌───┐          │
│  │P 1│ │P 2│ │P 3│ ← Projetos│
│  └───┘ └───┘ └───┘          │
│  [+ Novo Projeto]            │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│   Profile Setup (1ª vez)     │  ← Cria/edita perfil fake
│  [Foto Perfil] [Nome] [Bio]  │
│  [Importar prints grid real] │
│  [Começar do zero]           │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│    Grid Preview (antes de    │  ← Grid 3 colunas com layout atual
│      editar carrossel)       │
│  ┌──┬──┬──┐                 │
│  │P1│P2│P3│                 │
│  ├──┼──┼──┤                 │
│  │P4│  │P6│ ← slot vazio    │
│  └──┴──┴──┘                 │
│  [+ Adicionar Post]          │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│   Carousel Editor            │  ← Coração do app
│  ┌────────────────────┐      │
│  │   Preview do slide  │     │
│  └────────────────────┘      │
│  [1] [2] [3] ← drag-reorder │
│  [+ Add mídia]              │
│  [Cortar] [Trim vídeo]      │
│  [Proporção: 1:1 │ 4:5]     │
│  [Prévia no Grid ►]          │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│   Grid Preview (atualizado)  │  ← Reflete o grid com novo post
│  Mostra highlight do post    │
│  novo no grid                │
│  [Voltar e ajustar]          │
│  [Exportar Carrossel ▼]      │
└──────────┬───────────────────┘
           │
           ▼
┌──────────────────────────────┐
│        Export Page           │
│  Progresso de exportação     │
│  [Exportar para Galeria]     │
│  ✓ Finalizado!               │
│  "01_post.jpg, 02_post.jpg"  │
│  [Ver na Galeria]            │
│  [Voltar ao Home]            │
└──────────────────────────────┘
```

### Bottom Navigation (após primeiro perfil criado)

| Aba | Tela |
|---|---|
| Início | Home (projetos) |
| Grid | Grid Preview do perfil ativo |
| Editor | Atalho para novo carrossel |

## 5. Ordem de Desenvolvimento (Sprints)

### Sprint 1 — Fundação (dias 1-5)
- [ ] Inicializar projeto Flutter, configurar estrutura de pastas
- [ ] Configurar drift (database, migrations, schemas)
- [ ] Implementar entidades e modelos de dados
- [ ] Criar repositórios base (CRUD de Profile, Project, Carousel, MediaItem)
- [ ] Configurar Riverpod + GoRouter
- [ ] Home page: listar projetos, criar novo projeto
- [ ] Profile Setup page: formulário de criação + salvamento

### Sprint 2 — Editor de Mídia (dias 6-12)
- [ ] Tela de Grid Preview vazia (apenas perfil)
- [ ] Tela do Carousel Editor (estrutura base)
- [ ] Importar mídia da galeria (image_picker)
- [ ] Reordenar slides (ReorderableListView)
- [ ] Corte de imagem (image_cropper)
- [ ] Preview de proporção (1:1, 4:5, 9:16, 16:9)
- [ ] Grid Preview atualizado com o novo post

### Sprint 3 — Vídeo e Exportação (dias 13-17)
- [ ] Importar vídeos da galeria
- [ ] Trim básico de vídeo (video_trimmer)
- [ ] Exportar carrossel para galeria (image_gallery_saver_plus)
- [ ] Nomenclatura numerada (01_*, 02_*)
- [ ] Tela de progresso e feedback de exportação
- [ ] Geração de thumbnails para prévia

### Sprint 4 — Polimento e MVP (dias 18-22)
- [ ] Editar projeto salvo (carregar e modificar)
- [ ] Excluir projetos
- [ ] Múltiplos perfis
- [ ] Empty states e fluxo de onboarding
- [ ] Tratamento de erros e edge cases
- [ ] Testes unitários nos use cases
- [ ] Testes de widget nas páginas principais
- [ ] Testar em dispositivo físico Android + iOS
- [ ] Ajustes de UI/UX finos

### Sprint 5 (pós-MVP)
- [ ] Backup/sync via iCloud/Drive (Drift remote link)
- [ ] Modo escuro
- [ ] Filtros de imagem básicos
- [ ] Widget de iOS/Android para compartilhamento rápido
- [ ] Analytics (Firebase ou PostHog)

## 6. Riscos Técnicos e Mitigações

| Risco | Probabilidade | Impacto | Mitigação |
|---|---|---|---|
| **Performance com vídeos longos** | Média | Alto | Gerar thumbnails em isolate (compute). Manter trim como metadata, não recodificar o vídeo (a menos que necessário). Usar `video_player` + `video_trimmer` que trabalham com referência ao arquivo original, sem cópia desnecessária. |
| **Permissões Android 13+ (API 33)** | Alta | Médio | Android 13 tem permissões granulares (`READ_MEDIA_IMAGES`, `READ_MEDIA_VIDEO`) em vez da `READ_EXTERNAL_STORAGE` geral. Usar `permission_handler` que já abstrai isso. Para gravar na galeria, usar `MediaStore` API (o `image_gallery_saver_plus` já faz isso). |
| **Permissões iOS (acesso limitado à galeria)** | Média | Médio | iOS 14+ permite acesso seletivo a fotos (`PHPhotoLibrary`). O `image_picker` já trata. Para escrita na galeria, `image_gallery_saver_plus` usa `PHPhotoLibrary`. Garantir que o info.plist tenha `NSPhotoLibraryUsageDescription` e `NSPhotoLibraryAddUsageDescription`. |
| **Consumo de disco (múltiplas imagens cortadas)** | Baixa | Médio | Salvar apenas o crop rect como metadata (0-1 normalizado) e aplicar o crop no momento da exportação. Não duplicar arquivos desnecessariamente. Oferecer opção de limpar cache. |
| **State management complexo (editor de carrossel)** | Média | Alto | Riverpod com `Notifier` para estado do carrossel atual. Manter estado imutável (freezed). Usar `Family` providers para carregar carrosséis específicos por ID. |
| **Drift migrations (schema muda no futuro)** | Média | Baixo | Drift exige migrations explícitas. Versionar o schema desde o início. Ter `onUpgrade` com `ALTER TABLE` ou recriação com fallback. |
| **Vídeo trim sem recodificação** | Alta | Médio | `video_trimmer` exporta vídeo cortado (recodifica). Para MVP é adequado, mas em versões futuras pode-se usar `ffmpeg_kit_flutter` para trim sem perda de qualidade (stream copy). |
| **Fragmentação de arquivos ao editar projetos antigos** | Baixa | Baixo | Manter referência ao arquivo original + crop rect. Se o arquivo original foi deletado, mostrar placeholder + aviso "mídia original não encontrada". |

## Considerações Adicionais

### Estado offline-first
Por ser 100% local, o app funciona sem internet. A única dependência de rede no futuro seria sync opcional.

### Tamanho do app
- SQLite (Drift) + code gen adicionam ~2-3MB ao APK/IPA.
- `video_trimmer` e `image_cropper` adicionam ~5-8MB cada (bibliotecas nativas).
- Estimar APK release: ~20-30MB, IPA: ~35-50MB.

### Alternativa mais enxuta (se tamanho for crítico)
Substituir `image_cropper` por crop implementado em Flutter puro com `InteractiveViewer` + `CustomPainter`. Substituir `video_trimmer` por implementação usando `ffmpeg_kit_flutter` que permite controle mais fino.

---

**Próximos passos sugeridos:**
1. Rodar `flutter pub add` com os pacotes da Sprint 1
2. Gerar a estrutura de pastas manualmente
3. Configurar Drift (database.dart + tabelas)
4. Implementar primeira tela (Home) funcional
