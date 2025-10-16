"use client";

import { useEffect, useState } from "react";

export default function EnvViewer() {
  const [serverMessage, setServerMessage] = useState<string | null>(null);

  useEffect(() => {
    // API経由でサーバー側の値を取得
    fetch("/api/server-vars")
      .then((res) => res.json())
      .then((data) => setServerMessage(data.secretMessage));
  }, []);

  return (
    <div>
      <p>
        <strong>Client-side (NEXT_PUBLIC_MESSAGE):</strong>{" "}
        {process.env.NEXT_PUBLIC_MESSAGE ?? "(not available)"}
      </p>
      <p>
        <strong>Server-side (SECRET_MESSAGE):</strong>{" "}
        {serverMessage ?? "(loading...)"}
      </p>
    </div>
  );
}
