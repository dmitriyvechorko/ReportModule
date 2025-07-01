// Инициализируем переменные
let filterTimeout;
const exportModal = document.getElementById("exportModal");
const previewModal = document.getElementById("previewModal");

document.getElementById("previewImage");
// ==== Фильтрация ====
function handleFilterChange() {
    clearTimeout(filterTimeout);
    filterTimeout = setTimeout(fetchProducts, 300); // Задержка 300мс после последнего ввода
}

document.getElementById('filterName').addEventListener('input', handleFilterChange);
document.getElementById('filterType').addEventListener('input', handleFilterChange);
document.getElementById('filterImport').addEventListener('change', handleFilterChange);

// ==== Загрузка продуктов ====
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

// ==== Модальное окно "Экспорт" ====
function openExportModal() {
    exportModal.style.display = "block";
}

function closeExportModal() {
    exportModal.style.display = "none";
}

// ==== Функции для увеличенного предпросмотра ====
function openPreview(imgSrc) {
    const previewImage = document.getElementById('previewImage');
    previewImage.src = imgSrc;

    const previewModal = document.getElementById('previewModal');
    previewModal.style.display = 'flex';
    document.body.style.overflow = 'hidden';
}

function closePreview() {
    const previewImage = document.getElementById('previewImage');
    previewImage.src = '';

    const previewModal = document.getElementById('previewModal');
    previewModal.style.display = 'none';
    document.body.style.overflow = 'auto';
}

// Инициализация превью при загрузке DOM
document.addEventListener('DOMContentLoaded', function () {
    const previews = document.querySelectorAll('.template-preview');

    previews.forEach(preview => {
        preview.addEventListener('click', function () {
            const imgElement = this.querySelector('img');
            const imgSrc = imgElement.getAttribute('data-src'); // читаем data-src
            if (imgSrc) {
                openPreview(imgSrc);
            }
        });
    });

    // Закрытие по клику вне картинки
    previewModal.addEventListener('click', function (event) {
        if (event.target === previewModal) {
            closePreview();
        }
    });

    // Закрытие по ESC
    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape' && previewModal.style.display === 'flex') {
            closePreview();
        }
    });

    // Кнопка закрытия
    document.querySelector('.close')?.addEventListener('click', closePreview);
});

// ==== Генерация отчёта ====
async function generateReport(template) {
    const name = document.getElementById("filterName").value.trim();
    const type = document.getElementById("filterType").value.trim();
    const isImport = document.getElementById("filterImport").value;

    const params = new URLSearchParams();
    if (name) params.append("name", name);
    if (type) params.append("type", type);
    if (isImport !== "") params.append("isImport", isImport);
    if (template) params.append("template", template);

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

// ==== Загрузка при старте ====
window.onload = fetchProducts;