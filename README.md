# NAME

Moonshine::Bootstrap  

# VERSION

Version 0.01

# Bootstraps Components

## Glyphicon 

    $self->glyphicon({ class => 'search' });

### options

### Sample Output

        <span class="glyphicon glyphicon-search" aria-hidden="true"></span>

## Buttons

        $self->button( class => 'success', data => 'Left' );

### Sample Output

        <button type="button" class="btn btn-success">Left</button>

## Button Groups

    $self->button_group(group => [{ }, { }, { }]);

### Options

- group

    Array of Hashes - each hash get sent to \*\*button\*\*

- sizing 

    SCALAR that appends btn-group-%s - lg, sm, xs

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

### Sample Output

    <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
        Dropdown
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
        list => [
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

- list

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

# POD ERRORS

Hey! **The above document had some coding errors, which are explained below:**

- Around line 134:

    You forgot a '=back' before '=head3'

- Around line 343:

    You forgot a '=back' before '=head3'
