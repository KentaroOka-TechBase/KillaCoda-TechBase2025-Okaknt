# 🎉 完了！

これにて演習は完了です。　うまく文字列を表示できたでしょうか？<br>

以下は、解答の一例です。<br>
.env.localの
```bash
CLIENT_MESSAGE
```
を
```bash
NEXT_PUBLIC_CLIENT_MESSAGE_2 
```
などの、NEXT_PUBLIC_が頭についた状態で任意の値に書き換えます。

その後、EnvViewer.tsxの18行目
```bash
<span>この演習の名前は{process.env.CLIENT_MESSAGE ?? "(not available)"}です</span>
```
を
```bash
<span>この演習の名前は{process.env.NEXT_PUBLIC_CLIENT_MESSAGE_2 ?? "(not available)"}です</span>
```
のように、env.localで新たに名前を付けた環境変数名を設定することで、ブラウザ上に文字列が正しく表示されるようになります。

簡易的な解説は、Forms上で行います。<br>
Formsに戻って、解答を送信してください。<br>
解答送信後は、このKillerCodaを開いているブラウザを閉じて演習を終了してください。<br>