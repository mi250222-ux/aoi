"""
BASi (ALS) のテキストファイルからデータを抽出し、CSV形式に変換するプログラム
"""
import csv
from pathlib import Path
import argparse

def convert_als_txt_to_csv(txt_path_str):
    """
    指定されたBASi (ALS) の .txt ファイルを解析し、データ部分のみをCSVとして保存します。
    """
    # =================================================================
    # --- 設定項目 ---
    # ここでテキストファイルの解析方法を変更できます。
    
    # 1. データヘッダーに含まれるキーワード
    #    このリストにある全ての単語が含まれる行をデータ開始の目印にします。
    DATA_HEADER_KEYWORDS = ["Potential/V", "Current/A"]

    # 2. ヘッダー行の何行後からデータを読み始めるか
    #    通常はヘッダーの次の行は空行なので、2行後からデータを読みます。
    LINES_TO_SKIP_AFTER_HEADER = 2
    # =================================================================

    # (A) 入力ファイルパスをPathオブジェクトに変換
    txt_path = Path(txt_path_str) 
    if not txt_path.is_file():
        print(f"エラー: ファイルが見つかりません: {txt_path}") # ← エラー表示で使用
        return

    # (B) 出力するCSVのファイル名を生成
    #     (例: "data.txt" -> "data.csv")
    csv_path = txt_path.with_suffix('.csv') 
    
    print(f"読み込み元: {txt_path}") # ← ログ表示で使用
    print(f"出力先: {csv_path}")   # ← ログ表示で使用

    try:
        # (C) 実際にテキストファイルを開く
        with open(txt_path, 'r', encoding='utf-8', errors='ignore') as f: 
            lines = f.readlines()
    except Exception as e:
        print(f"ファイルの読み込み中にエラーが発生しました: {e}")
        return

    # データが開始される行を探します
    data_start_index = -1
    found_header_line = ""
    for i, line in enumerate(lines):
        # 設定されたキーワードが全て含まれる行をヘッダーとみなす
        if all(keyword in line for keyword in DATA_HEADER_KEYWORDS):
            found_header_line = line.strip()
            data_start_index = i + LINES_TO_SKIP_AFTER_HEADER
            print(f"[{i+1}行目] にデータヘッダーを検出しました: '{found_header_line}'")
            print(f"-> {data_start_index + 1}行目からデータ解析を開始します。")
            break

    if data_start_index == -1:
        print(f"エラー: データヘッダー '{' '.join(DATA_HEADER_KEYWORDS)}' が見つかりませんでした。")
        return

    # データ行を抽出して解析
    extracted_data = []
    for line in lines[data_start_index:]:
        parts = line.strip().split()
        if len(parts) >= 2: # 少なくとも2列あることを確認
            try:
                # 2つの列をfloat型に変換
                potential = float(parts[0])
                current = float(parts[1])
                extracted_data.append([potential, current])
            except ValueError:
                # 数値に変換できない行はスキップ
                print(f"警告: 数値に変換できない行をスキップしました: {line.strip()}")
                continue
    
    if not extracted_data:
        print("抽出できるデータが見つかりませんでした。")
        return

    # (D) 最終的にCSVファイルを開いて書き込む
    with open(csv_path, 'w', newline='', encoding='utf-8') as csv_file:
        try:
            writer = csv.writer(csv_file)
            # ヘッダーを書き込む
            writer.writerow(['Potential/V', 'Current/A'])
            # データ行を書き込む
            writer.writerows(extracted_data)
            print(f"正常に完了: {len(extracted_data)}行のデータを {csv_path} に保存しました。")
        except IOError as e:
            print(f"CSVファイルの書き込み中にエラーが発生しました: {e}")


if __name__ == "__main__":
    # ヘルプメッセージに具体的な使い方を追加
    usage_example = r"""
使用例:
  # 基本的な使い方
  python Convert_Txt_To_Csv.py "C:\path\to\your\data.txt"

"""

    parser = argparse.ArgumentParser(
        description="BASi (ALS) の .txt ファイルからデータ部分を抽出し、CSVに変換します。",
        epilog=usage_example,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument(
        "txt_file",
        nargs='?', # 引数をオプション（任意）にする
        default=None,
        help="入力する .txt ファイルのパス",
    )
    args = parser.parse_args()

    # 引数が指定されなかった場合は、使い方を表示して終了
    if args.txt_file is None:
        parser.print_help()
    else:
        convert_als_txt_to_csv(args.txt_file)
