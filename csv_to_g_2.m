% filepath: /Users/taitai0123/aoi/csv_to_g.m
% テキストファイルからデータ抽出→CSV変換→グラフ作成まで一括実行

% --- 設定 ---
txt_filename = 'data.txt'; % 入力するテキストファイル名
py_script = 'Convert_Txt_To_Csv.py'; % Pythonスクリプト名
csv_filename = [erase(txt_filename, '.txt'), '.csv']; % 出力CSV名
% --- 設定ここまで ---

% 1. PythonスクリプトをMATLABから呼び出してCSV変換
try
    command = sprintf('python3 "%s" "%s"', py_script, txt_filename);
    status = system(command);
    if status ~= 0
        error('Pythonスクリプトの実行に失敗しました。');
    end
catch ME
    fprintf('Pythonスクリプト実行エラー: %s\n', ME.message);
    return;
end

% 2. CSVファイルをMATLABで読み込む
try
    data = readtable(csv_filename);
catch ME
    fprintf('CSVファイル "%s" の読み込みに失敗しました。\n', csv_filename);
    return;
end

% 3. データ抽出
potential = data.('Potential_V');
current = data.('Current_A');
[~, name, ~] = fileparts(csv_filename);

% 4. グラフ作成（Arialフォント）
figure;
plot(potential, current, 'b-', 'LineWidth', 1.5);
xlabel('Potential (V)');
ylabel('Current (A)');
axis tight;
lgd1 = legend(name, 'Location', 'best', 'Interpreter', 'none');
set(gca, 'FontName', 'Arial');
set(lgd1, 'FontName', 'Arial');

% 5. グラフ作成（Times New Romanフォント）
figure;
plot(potential, current, 'b-', 'LineWidth', 1.5);
xlabel('Potential (V)');
ylabel('Current (A)');
axis tight;
lgd2 = legend(name, 'Location', 'best', 'Interpreter', 'none');
set(gca, 'FontName', 'Times New Roman');
set(lgd2, 'FontName', 'Times New Roman');

fprintf('テキスト→CSV→グラフ化まで完了しました。\n');