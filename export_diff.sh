#!/bin/sh

# 出力先フォルダを指定（任意のパスに変更）
DEST_DIR="$HOME/Downloads/git_archives"

# 出力先フォルダが存在しない場合は作成
mkdir -p "$DEST_DIR"

# 選択されたコミットリストを取得
COMMITS="$@"

# 変更されたファイルのリストを取得（コミットに含まれているファイルのみ）
FILES=""
for COMMIT in $COMMITS; do
    PARENT=$(git rev-parse $COMMIT^)  # 直前のコミットを取得
    if [ -n "$PARENT" ]; then
        FILES+=" $(git diff --name-only --diff-filter=ACMRT $PARENT $COMMIT)"
    fi
done

# ファイルリストを整形
FILES=$(echo "$FILES" | tr ' ' '\n' | sort -u | tr '\n' ' ')

# ファイルが空の場合、処理を中断
if [ -z "$FILES" ]; then
    echo "No changed files to archive."
    exit 1
fi

# 選択したコミットの最新状態でアーカイブを作成
git archive --format=zip --prefix=archive/ -o "$DEST_DIR/archive.zip" HEAD -- $FILES

echo "Archive created at $DEST_DIR/archive.zip"
