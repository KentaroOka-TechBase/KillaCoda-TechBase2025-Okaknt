export async function GET() {
  return Response.json({
    secretMessage: process.env.SECRET_MESSAGE ?? "(not found)",
  });
}
