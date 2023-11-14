function count (){ 
  const bookText = document.getElementById('book_text');

  bookText.addEventListener("keyup", () => {
   let titleLength = bookText.value.length
   let countText = document.getElementById('count_text')
   countText.innerHTML = `${titleLength}文字`
  });
}
window.addEventListener('load', count);
