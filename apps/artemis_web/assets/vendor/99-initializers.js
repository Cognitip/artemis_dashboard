function initializeMarkdownTextarea() {
  $('textarea.markdown').each(function() {
    var easyMDE = new EasyMDE({
      element: this,
      spellChecker: false,
      showIcons: ['strikethrough', 'code', 'table', 'redo', 'heading', 'undo', 'heading-1', 'heading-2', 'heading-3', 'heading-4', 'heading-5', 'clean-block', 'horizontal-rule'],
      status: false
    });
  })
}

// Select2
//
// The Select2 library adds enhanced functionality to the default `select` tags.
//
// To use, add the `enhanced` class to any existing `select` tag.
//
// Additional configuration options for Select2 can be configured by adding additional classes.
//
// For example, to add a search bar add the `search` class:
//
//   <%= select f, :example, [1, 2], class: "enhanced search" %>
//
function initializeSelect2() {

  $('select.enhanced').each(function() {
    var item = $(this)
    var classes = item.attr('class').split(' ')
    var options = {}

    // Options
    var hasCreate = classes.includes('creatable') || classes.includes('tags')
    var hasSearch = classes.includes('search')

    options.minimumResultsForSearch = hasSearch ? 0 : Infinity
    options.tags = hasCreate

    // Initialize
    item.select2(options)
  })
}

function initializeSearchSubmit() {
  // Semantic UI supports inline icons for inputs. For search forms, make the
  // inline search icon double as a submit button.
  $('form.ui').each(function() {
    var form = $(this)
    var containers = form.find('.ui.icon.input')

    containers.each(function() {
      var container = $(this)
      var icon = container.find('i.search')

      icon.click(function(event) {
        form.submit()
      })
    })
  })
}

function initializeSidebars() {
  $('.open-sidebar-current-user').click(function(event) {
    if (event) {
      event.preventDefault()
    }

    $('#sidebar-current-user')
      .sidebar('setting', 'dimPage', false)
      .sidebar('setting', 'transition', 'overlay')
      .sidebar('toggle')
  })

  $('.close-sidebar-current-user').click(function(event) {
    if (event) {
      event.preventDefault()
    }

    $('#sidebar-current-user').sidebar('hide')
  })
}

function initializeWikiSidenav() {
  var links = []
  var sidenav = $('.sidenav')
  var headings = $('#wiki-page h1, #wiki-page h2, #wiki-page h3, #wiki-page h4, #wiki-page h5')

  headings.each(function() {
    var label = $(this).html()
    var tag = 'tag-' + this.nodeName
    var position = $(this).offset().top
    var link = $('<li class="' + tag + '"><a href="#sidebar-link">' + label + '</a></li>')

    link.click(function(event) {
      event.preventDefault()

      $([document.documentElement, document.body]).animate({
        scrollTop: position - 14
      }, 200);
    })

    links.push(link)
  })

  var nav = links.length > 1 ? $('<ul></ul>').append(links) : null

  $('#wiki-page aside nav.page-sections').append(nav)

	$('#wiki-page .ui.sticky').sticky({
	  offset: 28,
	  bottomOffset: 0,
    context: '#wiki-page'
  })
}

$(document).ready(function() {
  initializeMarkdownTextarea()
  initializeSelect2()
  initializeSidebars()
  initializeSearchSubmit()
  initializeWikiSidenav()
})
