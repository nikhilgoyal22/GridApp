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

function drawpalette(colors){
  var tableMarkup = "";

  tableMarkup += "<tr>";
  for (y = 0; y < colors.length; y++) {
    tableMarkup += `<td style="background-color: ${colors[y]}"></td>`;
  }
  tableMarkup += "</tr>";
  $("#palette-table").html(tableMarkup)
};

function setCell(cell){
  el = $(`#drawing-table tr:eq(${cell['row']}) td:eq(${cell['column']})`)
  el.css('backgroundColor', cell['color'])
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

function initializeGrid(){
  colors = ['red', 'green', 'blue'];
  
  drawgrid(20);
  drawpalette(colors);
  getUser();
}

$(function() {
  
  selectedColor = 'white';
  
  initializeGrid();
  
  $("#drawing-table td").click(function() {
    var column = parseInt($(this).index());
    var row = parseInt($(this).parent().index());
    $(this).css('backgroundColor', selectedColor);

    //$("#result").html( "Row_num =" + row + "  ,  Column_num ="+ column );
  });
  
  $("#palette-table td").click(function() {
    selectedColor = $(this).css('backgroundColor');
    console.log(selectedColor);
  });

});