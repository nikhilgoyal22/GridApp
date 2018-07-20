function drawgrid(n){
  var tableMarkup = "";
  for (x = 0; x < n; x++) {
    tableMarkup += "<tr>";
    for (y = 0; y < n; y++) {
      tableMarkup += "<td></td>";
    }
    tableMarkup += "</tr>"; 
  }

  $("#drawing-table").html(tableMarkup)
};

function cleargrid(n){
  for (x = 0; x < n; x++) {
    for (y = 0; y < n; y++) {
      el = $(`#drawing-table tr:eq(${x}) td:eq(${y})`)
      el.css('backgroundColor', '')
    }
  }

};

function drawpalette(colors){
  var tableMarkup = "";
  for (y = 0; y < colors.length; y++) {
    tableMarkup += `<tr><td style="background-color: ${colors[y]}"></td></tr>`;
  }
  $("#palette-table").html(tableMarkup)
};

function setCell(cell){
  el = $(`#drawing-table tr:eq(${cell['row']}) td:eq(${cell['column']})`)
  el.css('backgroundColor', cell['color'])
  timestamp = new Date(cell['updated_at']).toLocaleString()
  el.html(`<span><p>${cell['username']}</p><p>${timestamp}</p></span>`)
};

function errorFunction(jqXHR, textStatus, errorThrown) {
  console.log("something went wrong");
}

function reqData(url, method='GET', data={}){
  return {
    url: '/api/' + url,
    method: method,
    data: data,
    cache: false
  }
}

function getUser(){
  $.ajax(reqData('get_user')).done(function(data, textStatus, jqXHR) {
    $(".header-right").html(`<span>Username: ${data['username']}</span>`)
  }).fail(errorFunction)
}

function updateGrid(){
  $.ajax(reqData('get_cell_data')).done(function(data, textStatus, jqXHR) {
    if(data.length == 0) {cleargrid(20)}
    $.each(data, function( i, cell ) {
      setCell(cell);
    });
  }).fail(errorFunction)
}

function setLeaderboard(){
  $.ajax(reqData('leaderboard')).done(function(data, textStatus, jqXHR) {
    var tableMarkup = ""
    if(data.length > 0)
      tableMarkup = '<tr><th>Username</th><th>Cells Colored</th><th>Most Used Color</th></tr>'
    $.each(data, function( i, leader ) {
      tableMarkup += `<tr>
        <td>${leader['username']}</td>
        <td>${leader['total_count']}</td>
        <td style="background-color: ${leader['color']}">${leader['color_count']}</td>
      </tr>`;
    });
    $("#lb-table").html(tableMarkup)
  }).fail(errorFunction)
}

function initializeGrid(){
  colors = ['red', 'green', 'blue', 'pink', 'orange', 'yellow', 'brown'];
  
  drawgrid(20);
  drawpalette(colors);
  getUser();
  updateGrid();
  setLeaderboard();
}

$(function() {
  
  selectedColor = '';
  
  initializeGrid();
  
  $("#drawing-table td").click(function() {
    var column = parseInt($(this).index());
    var row = parseInt($(this).parent().index());
    $(this).css('backgroundColor', selectedColor);

    if(selectedColor.length > 0) {
      data = {row : row, column : column, color : selectedColor}
      $.ajax(reqData('set_cell_data', 'POST', data)).done(function(data, textStatus, jqXHR) {
        console.log('cell data persisted');
      }).fail(errorFunction)
    }
    //$("#result").html( "Row_num =" + row + "  ,  Column_num ="+ column );
  });
  
  $("#palette-table td").click(function() {
    selectedColor = $(this).css('backgroundColor');
    console.log(selectedColor);
  });

  $("#refresh-lb").click(function() {
    setLeaderboard();
  });

  setInterval(updateGrid, 5000);
});