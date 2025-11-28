% CSVファイルからサイクリックボルタンメトリーデータを読み込み、グラフを作成するスクリプト

% --- 設定 ---
% 読み込むCSVファイルの名前を指定してください
filename = '2 1nM.csv';
% --- 設定はここまで ---

% 1. データの読み込み
try
    % readtableを使用してCSVファイルを読み込みます
    % ヘッダーが自動的に変数名として認識されます
    data = readtable(filename);
catch ME
    fprintf('エラー: ファイル "%s" が見つからないか、読み込めません。\n', filename);
    fprintf('MATLABの現在の作業ディレクトリにファイルが存在することを確認してください。\n');
    rethrow(ME);
end

% 2. データの抽出
% ヘッダー名を使って列を抽出します
potential = data.('Potential_V'); % X軸 (MATLABが'/'を'_'に置き換えるため)
current = data.('Current_A');   % Y軸

% ファイル名から拡張子を除いた部分を取得
[~, name, ~] = fileparts(filename);

% --- グラフ1: Arialフォント ---
figure; % 新しい図ウィンドウを作成
plot(potential, current, 'b-', 'LineWidth', 1.5); % 電位(X軸) vs 電流(Y軸)

% グラフの装飾
xlabel('Potential (V)'); % X軸ラベル
ylabel('Current (A)');   % Y軸ラベル
axis tight; % 軸をデータ範囲に自動で合わせる

% ファイル名から凡例を自動生成して追加
lgd1 = legend(name, 'Location', 'best', 'Interpreter', 'none');

% グラフ全体のフォントを 'Arial' に設定
set(gca, 'FontName', 'Arial');
set(lgd1, 'FontName', 'Arial'); % 凡例のフォントも設定

% --- グラフ2: Times New Romanフォント ---
figure; % 2つ目の新しい図ウィンドウを作成
plot(potential, current, 'b-', 'LineWidth', 1.5); % 電位(X軸) vs 電流(Y軸)

% グラフの装飾
xlabel('Potential (V)'); % X軸ラベル
ylabel('Current (A)');   % Y軸ラベル
axis tight; % 軸をデータ範囲に自動で合わせる

% ファイル名から凡例を自動生成して追加
lgd2 = legend(name, 'Location', 'best', 'Interpreter', 'none');

% グラフ全体のフォントを 'Times New Roman' に設定
set(gca, 'FontName', 'Times New Roman');
set(lgd2, 'FontName', 'Times New Roman'); % 凡例のフォントも設定

fprintf('2つのグラフが作成されました (Arial, Times New Roman)。\n');
