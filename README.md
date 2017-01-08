# NAME

Moonshine::Bootstrap  

# VERSION

Version 0.01

# Bootstraps Components

## Glyphicon 

    $self->glyphicon({ class => 'search' });

### options

- tag

    default span

- class

    is required

- aria\_hidden

    default true

### Sample Output

    <span class="glyphicon glyphicon-search" aria-hidden="true"></span>

## Buttons

    $self->button( class => 'success', data => 'Left' );

### Options

- sizing 

    Buttons can have different sizes.

        sizing => 'lg',

        <button class="btn btn-success btn-lg" ...>

- switch

    default/success/danger...

- type

    defaults to button

- data

### Sample Output

    <button type="button" class="btn btn-success">Left</button>

## Button Groups

    $self->button_group(group => [{ }, { }, { }]);

### Options

- group

    Array of Hashes - each hash get sent to \*\*button\*\*

    unless dropdown => 1 is set, then the args gets sent to dropdown.

- sizing 

    SCALAR that appends btn-group-%s - lg, sm, xs

- nested

    ArrayRef of Hashes, that can build nested button\_groups

          nested => [ 
              {
                   index => 3,
                  dropdown => 1,
              },
              ...
          ],

         <div class="btn-group" role="group">
          <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            Dropdown
            <span class="caret"></span>
          </button>
          <ul class="dropdown-menu">
            <li><a href="#">Dropdown link</a></li>
            <li><a href="#">Dropdown link</a></li>
          </ul>
        </div>

- vertical

    Make a set of buttons appear vertically stacked rather than horizontally.

        vertical => 1

        <div class="btn-group btn-group-vertical" ...>
            ...
        </div>

- justified

    Make a group of buttons stretch at equal sizes to span the entire width of its parent.

        justified => 1

        <div class="btn-group btn-group-justified" ...>
             ...
        </div>

### Sample Output

    <div class="btn-group" role="group" aria-label="...">
          <button type="button" class="btn btn-default">Left</button>
          <button type="button" class="btn btn-default">Middle</button>
          <button type="button" class="btn btn-default">Right</button>
    </div>

## Button toolbar

    $self->button_toolbar(
        toolbar => [ 
            { 
                group => [ 
                    {
                       data => 'one',
                    }
                ] 
            }, 
            {
                group => [
                    {
                        data => 'two',
                    }
                ]
            }
        ]
    );

### Options

- role
- class
- toolbar

### Sample Output

    <div class="btn-toolbar" role="toolbar">
        <div class="btn-group" role="group">
              <button type="button" class="btn btn-default">one</button>
        </div> 
        <div class="btn-group" role="group">
              <button type="button" class="btn btn-default">one</button>
        </div>
    </div>

## Dropdown

    $self->dropdown({
        mid => 'somethingUnique',
        button => {},
        ul => {},
        dropup => 1,
    });

### options

- mid

    Id that is used to link the button and hidden list

- button

    Used to create the button, check dropdown\_button for options.

- ul

    Hidden list, that will be shown on click, check dropdown\_ul for options.

- dropup

    Change position of dropdown menu via base\_element div class - dropdown, dropup, 

### Sample Output

    <div class="dropdown">
      <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
        Dropdown
        <span class="caret"></span>
      </button>
      <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
        <li><a href="#">Action</a></li>
        <li><a href="#">Another action</a></li>
        <li><a href="#">Something else here</a></li>
        <li role="separator" class="divider"></li>
        <li><a href="#">Separated link</a></li>
      </ul>
    </div>

## dropdown\_button

    $self->dropdown_button({ class => "..." });

### Options

- class 

    defaults to 'default',

- id

    dropdown\_button \*\*requires\*\* an Id

- data\_toggle

    defaults to dropdown

- aria\_haspopup

    defaults to true

- aria\_expanded 

    defaults to true

- data

    is \*\*required\*\*

- split

    Create split dropdown button

        $self->dropdown_button({ split => 1 });

         <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
            Dropdown
            <span class="caret"></span>
        </button> 

### Sample Output

    <button class="btn btn-default">Dropdown</button>
    <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
        <span class="caret"></span>
    </button> 

## dropdown\_ul 

    $self->dropdown_ul(
        class => 'extra-css',
        alignment => 'right',
        separators => [4],
        headers => [
            {
                index => 4,
                data => 'Title',
            }
        ]
        children => [
            {
                heading => 1,
                data => 'Title',
            }
            {
                link => '#',
                data => 'Action',
            },
            {
                link => '#',
                data => 'Another',
            },
            {
                link => '#',
                data => 'Something else here',
            },
            {
                separator => 1
            },
            {
                link => '#',
                data => 'Separated link',
            }
        ],
    );

### Options

- class 

    defaults to dropdown-menu

- aira\_lebelledby

    Required

- children

    Arrayref that gets used to build linked\_li's 

- Separators 

    Add a divider to separate series of links in a dropdown menu

           <ul class="dropdown-menu" aria-labelledby="dropdownMenuDivider">
             ...
             <li role="separator" class="divider"></li>
             ...
           </ul> 
        

- alignment

    Change alignment of dropdown menu 

           <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="dLabel">
               ...
           </ul>
        

### Sample Output

    <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
        <li><a href="#">Action</a></li>
        <li><a href="#">Another action</a></li>
        <li><a href="#">Something else here</a></li>
        <li role="separator" class="divider"></li>
        <li><a href="#">Separated link</a></li>
    </ul>

## header\_li

    $self->separator_li;

### options

- role
- class

### Sample Output

    <li role="separator" class="divider"></li>

## dropdown\_header\_li

    $self->dropdown_header_li( data => 'Dropdown header' );

### Options

- class
- data

### Sample Output

    <li class="dropdown-header">Dropdown header</li>

## linked\_li  

    $self->linked_li( link => 'http://some.url', data => 'Action' )

### Options

- Disabled

        $self->linked_li( disabled => 1, ... )

        <li class="disabled"><a href="#">Disabled link</a></li>

- link

        $self->linked_li( link => "#", ... )

        <a href="#">

- data

        $self->linked_li( data => [1, 2, 3], ... )

        123

### Sample Output

    <li><a href="http://some.url">Action</a></li>

## caret

    $self->caret

- tag
- class

### Sample Output

    <span class="caret"></span>

## Input Groups

    $self->input_group({
        mid => 'basic-addon1',
        placeholder => 'Username',
        left => {
            data => '@'
        }
    });

### options

- label

        $self->input_group({ label => { data => 'some text' } });

        <label>some text .... </label

- mid

    Used to map addon and input.

- lid

    Used to map label to input.

        <label for="lid">
        <input id="lid">

- placeholder
- left
- right
- sizing

### Sample Output

    <div class="input-group">
        <span class="input-group-addon" id="basic-addon1">@</span>
        <input type="text" class="form-control" placeholder="Username" aria-describedby="basic-addon1">
    </div>

## input

    $self->input();

### 

- class

    default form-control

- type

    default text

### Renders

    <input type="text" class="form-control">

## input addon

    $self->input_addon();

### Options

- checkbox
- radio
- button
- dropdown
- class

### Renders

    <span class="input-group-addon" ...>@</span>

## navs

    $self->navs();

### options

- class
- switch

    tabs or pills

- items
- stacked

    Pills are also vertically stackable. Just add 

        stacked => 1

- justified

    "Easily make tabs or pills equal widths of their parent at screen wider than 768pm". On smaller screens,
    nav links become stacked.

        justified => 1

### renders

    <ul class="nav nav-tabs">
        <li role="presentation" class="active"><a href="#">Home</a></li>
        <li role="presentation"><a href="#">Profile</a></li>
        <li role="presentation"><a href="#">Messages</a></li>
    </ul>

## nav\_item

    $self->nav_item;

### options

- class
- role 
- link
- active
- data
- disable
- dropdown

### renders

    <li role="presentation" class="active"><a href="#">Home</a></li>

## navbar

    $self->navbar();

### options

- navs

    nav\_type

### renders

    <nav class="navbar navbar-default">
          <div class="container-fluid">
            <div class="navbar-header">
                  <a class="navbar-brand" href="#">
                    <img alt="Brand" src="...">
                  </a>
            </div>
          </div>
    </nav>

## navbar\_header

    $self->navbar_header({});

### Options

### Renders

    <div class="navbar-header">
      <a class="navbar-brand" href="#">
        <img alt="Brand" src="...">
      </a>
    </div>

## navbar\_button 

### options

- type

    defaults button

- switch

    default/success....

### Renders

    <button type="button" class="btn btn-default">Submit</button>

## navbar\_text 

### options

- tag

    Defaults &lt;p>

### Renders

    <p class="navbar-text">Navbar text</p>

## navbar\_form

    $self->navbar_form({});

### Options

- fields

    ArrayRef

- button

    Defaults to Submit

### Renders

    <form class="navbar-form navbar-left" role="search">
        <div class="form-group">
            <input type="text" class="form-control" placeholder="Search">
        </div>
        <button type="submit" class="btn btn-default">Submit</button>
    </form>

## form\_group

    $self->form_group()

### Options

- class
- fields

        fields => [
            {
                field_type => 'text',
            }
        ]

### Renders

    <div class="form-group">
        <input type="text" class="form-control" placeholder="Search">
    </div>
    

## submit\_button 

### options

- type

    defaults submit

- switch

    default/success....

### Renders

    <button type="submit" class="btn btn-default">Submit</button>

## link\_image 

### options

- href

    required

- img

    required

        { alt => '', src => '' }

### renders

    <a class="navbar-brand" href="..."><img alt="some-text" src="..."></img></a>

## img

    $self->img({ alt => '', src => '' });

### Options

- alt 

    Required

- src

    Required

### Renders

    <img alt=".." src="..">

# AUTHOR

LNATION, `<thisusedtobeanemail at gmail.com>`

# BUGS

Please report any bugs or feature requests to `bug-moonshine-world at rt.cpan.org`, or through
the web interface at [http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Moonshine-World](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Moonshine-World).  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

# ACKNOWLEDGEMENTS

# LICENSE AND COPYRIGHT

Copyright 2017 LNATION.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

[http://www.perlfoundation.org/artistic\_license\_2\_0](http://www.perlfoundation.org/artistic_license_2_0)

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
