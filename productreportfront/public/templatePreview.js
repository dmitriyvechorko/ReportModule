document.addEventListener('DOMContentLoaded', function() {
    // Инициализация предпросмотра шаблонов
    const previewModal = document.getElementById('previewModal');
    const previewImage = document.getElementById('previewImage');
    const closeBtn = document.querySelector('.close');

    // Обработчики для всех элементов предпросмотра
    document.querySelectorAll('.template-preview').forEach(preview => {
        preview.addEventListener('click', function() {
            const imgSrc = this.querySelector('img').src;
            openPreview(imgSrc);
        });
    });

    // Функция открытия предпросмотра
    function openPreview(imgSrc) {
        previewImage.src = imgSrc;
        previewModal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    // Функция закрытия предпросмотра
    function closePreview() {
        previewModal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }

    // Закрытие по клику на крестик
    closeBtn.addEventListener('click', closePreview);

    // Закрытие по клику вне изображения
    previewModal.addEventListener('click', function(event) {
        if (event.target === previewModal) {
            closePreview();
        }
    });

    // Закрытие по ESC
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closePreview();
        }
    });
});