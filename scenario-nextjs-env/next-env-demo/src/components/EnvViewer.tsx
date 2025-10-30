'use client';

import { useEffect, useState } from "react";

export default function EnvViewer() {
  const [serverMessage, setServerMessage] = useState<string | null>(null);

  useEffect(() => {
    fetch("/api/server-vars")
      .then((res) => res.json())
      .then((data) => setServerMessage(data.secretMessage));
  }, []);

  return (
    <div>
      <p>
        <strong>Client-side (CLIENT_MESSAGE):</strong>{" "}
        この演習の名前は<span>{process.env.CLIENT_MESSAGE ?? "(not available)"}</span>です
      </p>
      <p>
        <strong>Client-side (CLIENT_MESSAGE):</strong>{" "}
          <span>この演習の名前は{process.env.NEXT_PUBLIC_CLIENT_MESSAGE ?? "(not available)"}</span>です
      </p>
      <p>
        <strong>Server-side (SECRET_MESSAGE):</strong>{" "}
        <span>この演習の名前は{serverMessage ?? "(loading...)"}</span>です
      </p>
    </div>
  );
}
