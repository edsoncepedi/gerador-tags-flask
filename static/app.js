// static/app.js
const textarea = document.getElementById("tagText");
const btnPrint = document.getElementById("btnPrint");
const btnClear = document.getElementById("btnClear");
const statusBox = document.getElementById("status");

function showStatus(msg, ok) {
  statusBox.textContent = msg;
  statusBox.className = "status " + (ok ? "ok" : "err");
  statusBox.style.display = "block";
}

function setLoading(isLoading) {
  btnPrint.disabled = isLoading;
  btnPrint.textContent = isLoading ? "Enviando..." : "Gerar Tag";
}

btnClear.addEventListener("click", () => {
  textarea.value = "";
  statusBox.style.display = "none";
  textarea.focus();
});

btnPrint.addEventListener("click", async () => {
  const text = (textarea.value || "").trim();
  if (!text) {
    showStatus("Digite algum conteúdo antes de gerar a tag.", false);
    return;
  }

  setLoading(true);
  statusBox.style.display = "none";

  try {
    const resp = await fetch("/api/print", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ text }),
    });

    const data = await resp.json().catch(() => ({}));

    if (!resp.ok || !data.ok) {
      showStatus(data.error || "Erro ao enviar para impressão.", false);
    } else {
      showStatus(data.message || "Enviado para impressão.", true);
    }
  } catch (e) {
    showStatus("Falha de rede ou servidor indisponível.", false);
  } finally {
    setLoading(false);
  }
});

// Atalho: Ctrl+Enter para imprimir
textarea.addEventListener("keydown", (e) => {
  if (e.ctrlKey && e.key === "Enter") {
    btnPrint.click();
  }
});