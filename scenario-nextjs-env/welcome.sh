# セットアップ完了フラグを待つ
while [ ! -f /root/.setup-done ]; do
  sleep 1
done

# tail を停止
kill "$TAIL_PID" || true
echo
echo "Setup completed successfully!"

# もしアプリ起動フラグがあれば案内
if [ -f /opt/.appready ]; then
  echo "App is ready at http://localhost:3000"
else
  echo "You can now run: cd /root/next-env-demo && npm run dev"
fi
