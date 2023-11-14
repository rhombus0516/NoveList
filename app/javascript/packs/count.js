$(document).on('turbolinks:load', function () {
  console.log(1)
  function count() {
  console.log(2)
  const bookText = document.getElementById('book_text');
  bookText.addEventListener("keyup", () => {
    let bookLength = bookText.value.length;
    let countText = document.getElementById('count_text');
    countText.innerHTML = `${bookLength}文字`;
  });
}

window.addEventListener('turbolinks:load', count);
});