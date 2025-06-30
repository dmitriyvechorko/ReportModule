async function fetchProducts() {
    const name = document.getElementById('filterName').value.trim();
    const type = document.getElementById('filterType').value.trim();
    const isImport = document.getElementById('filterImport').value;

    let url = 'http://localhost:8080/api/products';
    const params = new URLSearchParams();
    if (name) params.append('name', name);
    if (type) params.append('type', type);
    if (isImport !== '') params.append('isImport', isImport);

    const response = await fetch(url + '?' + params.toString());
    const data = await response.json();

    const tbody = document.querySelector('#productsTable tbody');
    tbody.innerHTML = '';

    data.forEach(product => {
        const row = document.createElement('tr');

        row.innerHTML = `
      <td>${product.productName}</td>
      <td>${product.productionType}</td>
      <td>${product.enterpriseName || '-'}</td>
      <td>${product.enterpriseAddress || '-'}</td>
    `;

        tbody.appendChild(row);
    });
}
function openExportModal() {
    document.getElementById("exportModal").style.display = "block";
}

function closeExportModal() {
    document.getElementById("exportModal").style.display = "none";
}

async function generateReport(template) {
    const name = document.getElementById("filterName").value.trim();
    const type = document.getElementById("filterType").value.trim();
    const isImport = document.getElementById("filterImport").value;

    const params = new URLSearchParams();
    if (name) params.append("name", name);
    if (type) params.append("type", type);
    if (isImport !== "") params.append("isImport", isImport);
    if (template) params.append("template", template); // <-- Добавлен параметр шаблона

    const response = await fetch(`http://localhost:8080/api/report/download?${params.toString()}`, {
        method: "GET",
        headers: {
            Accept: "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        }
    });

    const blob = await response.blob();
    const downloadUrl = window.URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = downloadUrl;
    a.download = `report_${template}_${new Date().toISOString().split("T")[0]}.docx`;
    document.body.appendChild(a);
    a.click();
    a.remove();

    closeExportModal();
}
// Вызов при загрузке
window.onload = fetchProducts;