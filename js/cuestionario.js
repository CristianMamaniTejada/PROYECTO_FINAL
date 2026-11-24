const formulario = document.getElementById("cuestionario");
const resultado = document.getElementById("resultado");
const nombre = document.getElementById("resultado-nombre");
const texto = document.getElementById("resultado-texto");
const enlace = document.getElementById("resultado-enlace");

const recomendaciones = {
escribir: {
gratis: ["ChatGPT", "Usa el plan gratis con GPT-6.2 Sol: ordena ideas, resume y corrige tu redacción.", "https://chatgpt.com"],
pago: ["Claude", "Con Claude Fable 5.2 tienes el modelo número 1 para textos largos y bien razonados.", "https://claude.ai"]
},
estudiar: {
gratis: ["Perplexity", "Responde con fuentes que puedes revisar. Ideal para trabajos de investigación.", "https://www.perplexity.ai"],
pago: ["Gemini", "Gemini 4 Neon lee tus PDF, fotos y videos de clase y te los explica.", "https://gemini.google.com"]
},
programar: {
gratis: ["GitHub Copilot", "Gratis para estudiantes verificados. Te ayuda dentro de tu editor de código.", "https://github.com/features/copilot"],
pago: ["Claude", "Claude Fable 5.2 es el más fuerte hoy para proyectos de código completos.", "https://claude.ai"]
},
crear: {
gratis: ["Meta AI", "Crea imágenes gratis desde el chat. Para voz prueba ElevenLabs y para música Suno.", "https://www.meta.ai"],
pago: ["Midjourney", "Imágenes de alta calidad para exposiciones y proyectos.", "https://www.midjourney.com"]
}
};

const consejos = {
nuevo: " Empieza con preguntas cortas y pide que te explique paso a paso.",
medio: " Dale contexto: tu curso, tu tema y qué necesitas entregar.",
avanzado: " Compara su respuesta con otra IA antes de confiar en ella."
};

formulario.addEventListener("submit", function (evento) {
evento.preventDefault();
const datos = new FormData(formulario);
const objetivo = datos.get("objetivo");
const nivel = datos.get("nivel");
const presupuesto = datos.get("presupuesto");
const lugar = datos.get("lugar");

let eleccion = recomendaciones[objetivo][presupuesto];

if (lugar === "local") {
eleccion = ["DeepSeek V4.1 Flash o Qwen", "Modelos abiertos que puedes instalar con LM Studio. Funcionan sin internet y tus datos no salen de tu computadora.", "https://lmstudio.ai"];
}

nombre.textContent = eleccion[0];
texto.textContent = eleccion[1] + consejos[nivel];
enlace.href = eleccion[2];
resultado.hidden = false;
resultado.scrollIntoView({ behavior: "smooth" });
});
