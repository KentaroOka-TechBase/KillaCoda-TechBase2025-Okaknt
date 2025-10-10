import EnvViewer from "../components/EnvViewer";

export default function Page() {
  return (
    <main style={{ padding: "2rem", fontFamily: "sans-serif" }}>
      <h1>Next.js Environment Variable Demo</h1>
      <EnvViewer />
    </main>
  );
}
