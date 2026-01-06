# 子供向け教育アプリ プロジェクト

遊びながら自然と賢くなる、子供向けアプリ群。

---

## プロジェクト構成

```text
教育/
├── README.md                    # このファイル
├── melos.yaml                   # Melos モノレポ設定
├── kids-educational-app-design/ # V0で生成したデザインシステム（参考）
├── packages/                    # Flutter共通パッケージ
│   ├── design_system/           # デザイントークン・テーマ
│   ├── core/                    # コアロジック
│   ├── ui_components/           # 共通UIコンポーネント
│   └── animations/              # リッチアニメーション（Rive）
└── apps/                        # アプリケーション
    ├── learning_app/            # 学習アプリ
    └── picture_book_app/        # 絵本アプリ
```

---

## アプリ一覧

| アプリ | タイプ | 利用シーン | 利用時間 |
| ------ | ------ | ---------- | -------- |
| 学習アプリ | 能動型 | 朝〜昼 | 3〜7分 |
| 絵本アプリ | 受動型 | 寝る前 | 10〜15分 |

---

## コンセプト

**「勉強」ではなく「遊び」として、子供が自然と賢くなるアプリ**

- 子供は勉強が嫌い → 勉強アプリと認識された瞬間に負け
- YouTube/TikTok に代わる存在 → 親が安心して与えられる
- 両アプリでキャラクター・世界観を共有

```text
従来: 問題 → 解答 → 正解/不正解
本アプリ: 遊び → 行動 → 世界が変わる（裏で学習評価）
```

---

## 対象ユーザー

| 項目 | 内容 |
| ---- | ---- |
| 対象年齢 | 3〜5歳（未就学児） |
| 主な利用者 | 子供本人 |
| 購買決定者 | 親 |

---

## 技術スタック

| 項目 | 決定 |
| ---- | ---- |
| フレームワーク | Flutter |
| プラットフォーム | Android / iOS |
| ネットワーク | 原則オフライン |
| 認証 | なし（端末内プロファイル） |
| リポジトリ構成 | モノレポ（Melos） |
| 状態管理 | Riverpod |
| ローカルDB | Hive |
| ルーティング | go_router |
| アプリ内AI | 生成AIなし、適応ロジックのみ |

### Flutter を選んだ理由

- UIとロジックを1コードで両OS対応
- 2Dアニメ、パララックス、パーティクル演出が強い
- Spine / Live2D との連携も可能
- 教育アプリとの相性が良い

### 避けるもの

- Unity（アプリサイズ、起動時間、統合コストが重い）
- アプリ内キャラクター生成
- アプリ内での生成AIリクエスト
- アカウント認証・Auth
- SNS共有
- 広告SDK

---

## 共通パッケージ

### design_system

デザイントークン、タイポグラフィ、テーマを定義。

```
packages/design_system/
└── lib/
    ├── design_system.dart
    └── src/
        ├── colors/app_colors.dart       # カラートークン
        ├── typography/app_typography.dart # タイポグラフィ（日本語対応）
        ├── spacing/app_spacing.dart      # スペーシング・Radius・Gap
        └── theme/app_theme.dart          # ThemeData統合
```

**フォント選定:**
- Display: M PLUS Rounded 1c（丸みがあって子供向け、日本語完全対応）
- Body: Noto Sans JP（可読性が高い、日本語完全対応）

### core

キャラクター、ストリーク、報酬など共通ロジック。

```
packages/core/
└── lib/
    ├── core.dart
    └── src/
        ├── character/       # キャラクター選択・成長・XP・レベル
        ├── parent_gate/     # 親ゲート（3秒ホールド + 算数問題）
        ├── storage/         # ローカルストレージ抽象化（Hive）
        ├── streak/          # 連続日数管理・月次回復
        ├── rewards/         # スタンプ帳・解放アイテム
        └── audio/           # BGM/SE/ナレーション管理
```

### ui_components

共通UIウィジェット集。

```
packages/ui_components/
└── lib/
    ├── ui_components.dart
    └── src/
        ├── buttons/         # ChoiceButton, PrimaryButton, IconActionButton
        ├── character/       # CharacterAvatar, CharacterSelector
        ├── progress/        # StarProgress, DotProgress, StepProgress
        ├── modals/          # RewardModal, ParentGateModal
        └── common/          # TapFeedback, FadeInWidget, BounceInWidget
```

### animations

リッチアニメーションシステム。子供向けUI/UXを「ゲームのように楽しい」体験にする。

```
packages/animations/
└── lib/
    ├── animations.dart
    └── src/
        ├── rive/           # Rive統合・State Machine制御
        ├── transitions/    # カスタムページ遷移（雲、虹ワイプなど）
        ├── effects/        # コンフェッティ・パーティクル
        ├── living_ui/      # 呼吸アニメ・目の追従
        ├── physics/        # 物理演算ボタン
        ├── backgrounds/    # インタラクティブ背景（空、雲、動物）
        ├── rewards/        # リワード演出（飛ぶシール）
        ├── micro/          # マイクロインタラクション（花成長、音階タップ）
        └── progress/       # あおむしプログレスなど
```

#### 技術選定: Rive

| 観点 | Rive | Spine | Live2D |
|------|------|-------|--------|
| Flutter対応 | ✅ 公式 | ✅ 公式 | ❌ なし |
| ファイルサイズ | 10-15x小さい | 中程度 | 大きい |
| State Machine | ✅ ビジュアル編集 | ❌ コード必要 | △ |
| キャラ + UI統一 | ✅ | △ | ❌ |

**結論**: Riveに統一（キャラクター + UI/UXエフェクト両方）

#### 提供コンポーネント

**ページ遷移:**
| コンポーネント | 用途 |
|---------------|------|
| `CloudTransitionPage` | 雲がもくもく画面遷移（学習アプリ） |
| `BookTurnTransitionPage` | 絵本ページめくり遷移（絵本アプリ） |
| `StarBurstTransitionPage` | 星バースト遷移（お祝い） |
| `RainbowWipeTransitionPage` | 虹が画面を横切る遷移 |
| `RainbowBurstTransitionPage` | 虹が中央から広がる遷移 |

**エフェクト:**
| コンポーネント | 用途 |
|---------------|------|
| `ConfettiEffect` | コンフェッティお祝い演出 |
| `ParticleTapEffect` | タップ時パーティクル（花・星・ハート等） |

**リビングUI:**
| コンポーネント | 用途 |
|---------------|------|
| `BreathingWidget` | 呼吸アニメーション（5段階: subtle〜dramatic） |
| `EyeFollower` | 目がきょろきょろ追従 |
| `IdleWiggleWidget` | 注目を引く揺れアニメーション |

**物理演算:**
| コンポーネント | 用途 |
|---------------|------|
| `SquishyButton` | 物理演算ぷるぷるボタン |
| `JellyContainer` | ゆらゆらコンテナ |

**インタラクティブ背景:**
| コンポーネント | 用途 |
|---------------|------|
| `AnimatedSkyBackground` | 動く空背景（雲、太陽、星、昼夜切替） |
| `PeekABooCreature` | ひょっこり顔を出す動物（ウサギ、リス、鳥など） |

**リワード演出:**
| コンポーネント | 用途 |
|---------------|------|
| `FlyingSticker` | シールが飛んでコレクションに入る演出 |
| `StickerCelebration` | 複数シールの連続飛行演出 |
| `AnimatedSticker` | 星・ハート・花・虹・王冠などのシール |

**マイクロインタラクション:**
| コンポーネント | 用途 |
|---------------|------|
| `SeedGrowthEffect` | タップで種→花が成長（正解演出） |
| `MusicalTapWidget` | 音階タップ（ドレミ視覚フィードバック） |
| `MusicalColorRow` | カラフル音階ボタン行 |
| `RichTouchFeedback` | 縮小＋グロー＋触覚フィードバック |
| `BouncyTapFeedback` | ポヨンと弾むタップ |
| `HapticHelper` | 触覚フィードバックパターン |

**プログレス:**
| コンポーネント | 用途 |
|---------------|------|
| `CaterpillarProgress` | あおむしが進む進捗バー |

#### 使用例

```dart
import 'package:animations/animations.dart';

// ページ遷移
GoRoute(
  path: '/lesson/:id',
  pageBuilder: (context, state) => CloudTransitionPage(
    child: LessonScreen(id: state.pathParameters['id']!),
  ),
)

// タップパーティクル
ParticleTapEffect(
  type: TapParticleType.flowers,
  onTap: () => handleTap(),
  child: PrimaryButton(text: 'タップ！'),
)

// コンフェッティ
ConfettiOverlay.show(context);

// 呼吸アニメーション
BreathingWidget(
  intensity: BreathingIntensity.subtle,
  child: CharacterAvatar(...),
)

// 目の追従
EyeFollower(
  eyeSize: 32,
  eyeSpacing: 24,
)

// ぷるぷるボタン
SquishyButton(
  onPressed: () => handlePress(),
  child: MyButtonContent(),
)
```

#### アニメーション用デザイントークン

```dart
// 追加されたトークン（AppSpacing）
static const Duration durationCelebration;  // 1200ms - お祝い
static const Duration durationTransition;   // 400ms - 画面遷移
static const Duration durationSpring;       // 600ms - 物理演算
static const Duration durationBounce;       // 450ms - バウンス
static const Duration durationBreathing;    // 3s - 呼吸
static const Duration durationIdle;         // 5s - アイドル

static const double touchTargetKids;        // 64px
static const double touchTargetKidsLarge;   // 80px
```

#### 必要なRiveアセット（要制作）

| アセット | ファイル名 | 優先度 |
|---------|-----------|-------|
| タップパーティクル | `tap_particles.riv` | P0 |
| ボタン変形 | `button_squish.riv` | P0 |
| コンフェッティ | `confetti.riv` | P0 |
| 雲遷移 | `cloud_transition.riv` | P1 |
| 目の追従 | `eye_follower.riv` | P1 |
| キャラクター | `character_{type}.riv` | P2 |

---

## アプリケーション

### learning_app（学習アプリ）

能動型の学習アプリ。自分で操作して世界が変わる体験。

```
apps/learning_app/
├── lib/
│   ├── main.dart
│   └── src/
│       ├── app.dart
│       ├── screens/         # HomeScreen, OnboardingScreen
│       ├── widgets/         # アプリ固有ウィジェット
│       └── providers/       # Riverpod プロバイダー
└── assets/
    ├── images/
    └── audio/
```

#### 学習コンテンツ

| 分野 | 内容 |
| ---- | ---- |
| 国語 | ひらがな認識（書き順より形の識別優先） |
| 算数 | 数量感覚（1〜10）→ 足し算の直感 → 文章題ミニ版 |
| 英語 | 音と単語（色、動物、挨拶）。読み書きは後回し |
| 思考 | パターン、分類、順序、間違い探し |
| 生活 | 時計の概念、曜日、季節 |

#### コンテンツ形式

- 3択問題
- ドラッグ&ドロップ
- なぞる

#### 「勉強に見えない」設計例

**数量感覚（算数）:**
- 画面にリンゴが落ちてくる
- キャラが「どっちが多い？」と聞く
- タップで選ぶ → 正解すると木が育つ、花が咲く
- 子供の認識: お世話・ゲーム / 実際: 数量比較、数認識

### picture_book_app（絵本アプリ）

受動型の読み聞かせアプリ。自分のキャラクターが語り部になる。

```
apps/picture_book_app/
├── lib/
│   ├── main.dart
│   └── src/
│       ├── app.dart
│       ├── screens/         # HomeScreen, OnboardingScreen
│       ├── widgets/         # アプリ固有ウィジェット
│       └── providers/       # Riverpod プロバイダー
└── assets/
    ├── images/
    ├── audio/
    └── stories/
```

#### 差別化ポイント

| YouTube/TikTok | 本アプリ |
| -------------- | -------- |
| 無限刺激 | 終わりがある |
| 思考ゼロ | 物語を追う |
| 消費 | 所有（自分のキャラ） |
| 親が不安 | 親が安心 |

#### 読み聞かせ体験

| 機能 | 内容 |
| ---- | ---- |
| プロナレーション | 声優・ナレーターによる高品質朗読 |
| テキスト同期 | カラオケ字幕形式で文字をハイライト |
| 環境音・BGM | 森のシーンで小鳥のさえずり、怖い場面でどきどきBGM |

#### 利用シーン別モード

| モード | 特徴 |
| ------ | ---- |
| 寝かしつけモード | 画面暗転、静かな音声、自動停止 |
| 通常モード | 明るい画面、インタラクション有効 |
| オフラインモード | 車移動中など |

---

## キャラクターシステム

両アプリで同じキャラクター・世界観を共有する。

### オンボーディングフロー

1. 好きな動物を選ぶ（6〜8種）
2. 色 or アクセサリを1つ選ぶ
3. 「今日から一緒にがんばろう」→ 1分以内に体験開始
4. 最初の体験は絶対に成功（100%達成できる難易度）

### キャラクター技術

| フェーズ | 技術 | 備考 |
| -------- | ---- | ---- |
| MVP | Rive + State Machine | UI/UXと統一、軽量 |
| 次フェーズ | Rive 高度化 | 複雑なインタラクション |
| 高品質路線 | Spine（必要時） | 複雑なスケルタルアニメ向け |

**注**: Live2Dは Flutter公式サポートがないため非推奨。Riveに統一することで、UIエフェクトとキャラクターを同じツールで制作可能。

### キャラクターの反応設計

発話はテンプレ + パラメータ差し込み。LLM不要。

| 状況 | 反応 |
| ---- | ---- |
| 正解・成功 | 褒める + 次へ |
| ミス・失敗 | 1ヒント + やり直し |
| 連続ミス | 難易度を落とす + "一緒にやろう"演出 |

---

## 親向け設計

### 親ゲート

- 方式: 長押し3秒 + 簡単計算（足し算）
- 対象: 課金、設定変更、外部通信、データ削除
- 実装: `packages/core/lib/src/parent_gate/` および `packages/ui_components/lib/src/modals/parent_gate_modal.dart`

### 親への訴求ポイント

- 通信しない（オフライン）
- 課金しない（または親ゲート下のみ）
- 会話は自由入力なし（安全）
- 1日上限がある（依存防止）
- 広告なし

### 親画面で見せる情報

- 今日やった内容
- 苦手・弱点
- 学習/読書の進捗

---

## ゲーミフィケーション

### デイリーループ

- デイリーミッション: 3〜5分
- 連続記録（ストリーク）: 失敗しても救済1回
- スタンプ帳: 30日で1枚完成

### 成長要素

- キャラ育成: 学習で経験値
- 着せ替え: 報酬は「毎日」と「復習」で出る
- コレクション: 動物図鑑、バッジ

### 依存防止

- 1日上限の報酬を設定
- 夜間は控えめ演出

---

## コンテンツパイプライン

### 全体フロー

```text
学習要件定義（人間が作成）
    ↓
AI教材生成（社内CI/サーバー側）
    ↓
自動検証・正規化
    ↓
アセット化（JSON / 画像 / 音声）
    ↓
アプリに同梱
    ↓
CIでビルド
    ↓
ストア公開
```

### 問題JSONスキーマ（学習アプリ）

```json
{
  "id": "math_add_1_003",
  "domain": "math",
  "unit": "addition",
  "level": 1,
  "question_type": "choice_3",
  "prompt": "りんごが 2こ と 1こ あります。ぜんぶで？",
  "choices": [2, 3, 4],
  "answer": 3,
  "hints": ["2と1を たすよ"],
  "tags": ["counting", "add_small"],
  "estimated_time_sec": 6
}
```

### 絵本JSONスキーマ（絵本アプリ）

```json
{
  "id": "story_friendship_001",
  "title": "なかよしの もり",
  "theme": ["friendship", "cooperation"],
  "age_range": [3, 5],
  "duration_min": 8,
  "pages": [
    {
      "page_number": 1,
      "text": "むかしむかし、あるところに もりが ありました。",
      "image": "page_001.png",
      "audio": "page_001.mp3",
      "bgm": "forest_ambient.mp3",
      "interactive_elements": [
        {
          "type": "tap",
          "target": "bird",
          "action": "play_sound",
          "sound": "bird_chirp.mp3"
        }
      ]
    }
  ],
  "narrator_voice": "gentle_female",
  "night_mode_available": true
}
```

### 自動検証ルール（共通）

- JSONスキーマ一致
- 語彙レベルチェック（5歳NGワード禁止）
- 問題文/本文の長さ制限
- 重複コンテンツの排除

**1つでも落ちたらCI失敗**

---

## 収益モデル

| モデル | 評価 | 備考 |
| ------ | ---- | ---- |
| 広告 | ❌ | 子供向けで論外 |
| サブスク | △ | 親の心理ハードル高い、オフラインと相性悪い |
| 買い切り | ◎ | ¥1,500-2,000、「教育アプリとして安全」が刺さる |
| DLC拡張 | ○ | 将来的に追加パック販売 |

初期は **買い切り一択**

---

## 開発フェーズ

### Phase 1: 基盤構築 ✅ 完了

| タスク | 状態 |
| ------ | ---- |
| リポジトリ構成決定（モノレポ） | ✅ 完了 |
| デザインシステム（V0生成） | ✅ 完了 |
| design_system パッケージ | ✅ 完了 |
| core パッケージ | ✅ 完了 |
| ui_components パッケージ | ✅ 完了 |
| animations パッケージ | ✅ 完了 |
| アプリプロジェクト雛形 | ✅ 完了 |
| Hive アダプター生成 | ⚠️ ローカル実行必要 |

### Phase 1.5: アニメーション基盤 ✅ 完了

| タスク | 状態 |
| ------ | ---- |
| animations パッケージ作成 | ✅ 完了 |
| Rive統合（KidsRiveController） | ✅ 完了 |
| ページ遷移アニメーション | ✅ 完了 |
| コンフェッティエフェクト | ✅ 完了 |
| タップパーティクル | ✅ 完了 |
| 呼吸アニメーション | ✅ 完了 |
| 目の追従 | ✅ 完了 |
| 物理演算ボタン | ✅ 完了 |
| デザイントークン拡張 | ✅ 完了 |
| Riveアセット制作 | 🔲 未着手（デザイナー待ち）|

### Phase 2: 仕様確定

| タスク | 状態 |
| ------ | ---- |
| 問題JSONスキーマ確定 | 🔲 未着手 |
| 絵本JSONスキーマ確定 | 🔲 未着手 |
| UI画面遷移設計 | 🔲 未着手 |
| 難易度調整ロジック設計 | 🔲 未着手 |

### Phase 3: MVP開発

| タスク | 状態 |
| ------ | ---- |
| 学習アプリ：クイズ画面 | 🔲 未着手 |
| 絵本アプリ：読書画面 | 🔲 未着手 |
| キャラアセット制作 | 🔲 未着手 |
| 音声アセット制作 | 🔲 未着手 |

---

## セットアップ

```bash
# Melos インストール
dart pub global activate melos

# 依存関係インストール（全パッケージ）
melos bootstrap

# Hiveアダプター生成（core）
melos generate
# または
cd packages/core && dart run build_runner build --delete-conflicting-outputs
```

---

## 開発コマンド（Melos）

```bash
# 全パッケージの静的解析
melos analyze

# 全パッケージのテスト実行
melos test

# コード生成（build_runner）
melos generate

# コードフォーマット
melos format

# 学習アプリ実行
melos run:learning

# 絵本アプリ実行
melos run:book

# APKビルド
melos build:learning:apk
melos build:book:apk
```

---

## 使い方

### design_system

```dart
import 'package:design_system/design_system.dart';

// テーマ適用
MaterialApp(
  theme: AppTheme.learningApp,        // 学習アプリ
  // theme: AppTheme.pictureBookApp,  // 絵本アプリ（ナイトモード）
)

// カラー使用
Container(color: AppColors.learningPrimary)

// タイポグラフィ使用
Text('こんにちは', style: AppTypography.headlineLarge)

// スペーシング使用
Column(children: [
  Text('A'),
  const VGap.md(),  // 16px
  Text('B'),
])
```

### core

```dart
import 'package:core/core.dart';

// 初期化
await HiveStorageService.initialize();
final storage = HiveStorageService();

// プロファイル作成
final profileRepo = ProfileRepository(storage);
final profile = await profileRepo.createProfile(name: 'たろう');

// キャラクター選択
final charRepo = CharacterRepository(storage);
final character = await charRepo.createCharacter(
  profileId: profile.id,
  type: CharacterType.fox,
  name: 'フォックン',
);

// ストリーク管理
final streakManager = StreakManager(storage);
final result = await streakManager.recordActivity(profile.id);
print('現在のストリーク: ${result.currentStreak}日');

// 親ゲート
final parentGate = ParentGateService();
final problem = parentGate.generateProblem();
print(problem.questionText); // "7 + 5 = ?"
if (parentGate.verifyAnswer(problem, 12)) {
  print('アンロック成功');
}
```

### ui_components

```dart
import 'package:ui_components/ui_components.dart';

// プライマリボタン
PrimaryButton(
  text: 'つぎへ',
  icon: Icons.arrow_forward_rounded,
  onTap: () {},
)

// クイズ選択ボタン
ChoiceButton(
  text: 'りんご',
  icon: '🍎',
  state: ChoiceButtonState.correct,
  onTap: () {},
)

// キャラクターアバター
CharacterAvatar(
  characterType: CharacterType.fox,
  emotion: CharacterEmotion.happy,
  size: CharacterAvatarSize.large,
)

// スター進捗
StarProgress(
  current: 2,
  total: 3,
)

// 報酬モーダル
await RewardModal.show(
  context,
  title: 'すごい！',
  message: 'スタンプゲット！',
  emoji: '🎉',
  starsEarned: 3,
);

// 親ゲートモーダル
final verified = await ParentGateModal.show(context);
if (verified) {
  // 親向け設定画面へ
}
```

---

## 調査結果サマリー

### 効果が実証された学習手法

| 手法 | エビデンス |
| ---- | ---------- |
| ゲームベース学習 | 認知・社会・情緒面に中〜大の効果 |
| 対話的読み聞かせ | 語彙スコア 26%→54% 向上 |
| 個別最適化学習 | 従来比30%の成績向上 |
| 分散学習 | 5-7歳で概念応用が有意に向上 |
| モンテッソーリ教育 | 学業達成で効果量 g=1.10 |

### 絵本に取り入れる教育哲学

| 哲学 | 特徴 |
| ---- | ---- |
| モンテッソーリ | 自主性、感覚体験、写実的な描写 |
| レッジョ・エミリア | 表現の多様性、環境描写の豊かさ |
| SEL | 感情理解、共感、協働 |

---

## 競合分析

### 学習アプリ（海外）

| サービス | 対象 | 価格 | 特徴 |
| -------- | ---- | ---- | ---- |
| ABCmouse | 2-8歳 | $7.95/月 | 7000+アクティビティ、100万+有料会員 |
| Khan Academy Kids | 2-7歳 | 無料 | 非営利、高品質、AI難易度調整 |
| Lingokids | 2-8歳 | ~$15/月 | 1.85億DL、Playlearning |
| HOMER | 2-8歳 | $9.99/月 | リテラシー特化 |

### 学習アプリ（国内）

| サービス | 対象 | 価格 | 特徴 |
| -------- | ---- | ---- | ---- |
| こどもちゃれんじ | 0-6歳 | ¥1,990~/月 | しまじろう、物理教材+アプリ |
| スマイルゼミ幼児 | 4-6歳 | ¥3,000~/月 | タブレット特化、AI丸付け |
| ごっこランド | 3-9歳 | 無料 | 職業体験、スポンサーモデル、800万DL |
| ワンダーボックス | 4-10歳 | ¥3,700~/月 | STEAM教育、Think!Think! |

### 絵本アプリ（海外）

| サービス | 価格 | 特徴 |
| -------- | ---- | ---- |
| Epic! | $9.99/月 | 40,000冊+、5000万ユーザー |
| Amazon Kids+ | ¥480/月 | 動画・ゲーム含む総合サービス |
| Vooks | $4.99/月 | 動画になる絵本、教師94%が効果実感 |

### 絵本アプリ（国内）

| サービス | 価格 | 特徴 |
| -------- | ---- | ---- |
| 絵本ナビプレミアム | ¥437/月 | 1000冊読み放題 |
| PIBO | ¥480/月 | 昔話中心、プロ朗読 |
| みいみ | ¥500/月 | 声優朗読、吹き替え機能、寝かしつけ特化 |

---

## 参考資料

### 学術研究

- Game-based Learning効果（Frontiers in Psychology, 2024）
- 対話的読み聞かせ語彙効果（International Journal of Educational Research, 2009）
- AI個別学習効果（Engageli, 2025）
- モンテッソーリ教育メタ分析（Contemporary Educational Psychology, 2023）

### 子供向けUXデザイン

- Debra Levin Gelman『Design for Kids』
- Nielsen Norman Group 子供向けUXガイドライン
- Smashing Magazine 子供向けアプリ設計パターン

### 国内事例

- みいみ（東京ガス・オトバンク）
- ごっこランド（KidsStar）
- 絵本ナビ
