package Moonshine::Bootstrap;

use 5.006;
use strict;
use warnings;

use Moonshine::Element;
use Params::Validate qw(:all);

=head1 NAME

Moonshine::Bootstrap  

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

our @ISA;
{ @ISA = "UNIVERSAL::Object" };

BEGIN {
    my $fields = $Moonshine::Element::HAS{"attribute_list"}->();
    my %param_spec = map { $_ => 0 } @{$fields};
    {
        no strict 'refs';
        *{"optional_attributes"} = sub { \%param_spec }
    };

    my @lazy_components =
      qw/li ul a th td tr p div span b i u dl dt em h1 h2 h3 h4 h5 h6 ol/;
    for my $component (@lazy_components) {
        {
            no strict 'refs';
            *{"$component"} = sub {
                my $self = shift;

                my %element_args = validate_with(
                    params => \@_,
                    spec   => $self->_setup_validation_spec(
                        {
                            tag    => { default => $component },
                            data   => 0,
                            sizing => 0,
                        }
                    )
                );

                return Moonshine::Element->new(%element_args);
              }
        };
    }
}

sub _setup_validation_spec {
    my ( $self, $args ) = @_;
    my $base_spec = $self->optional_attributes;
    my %merged = ( %{$base_spec}, %{$args} );
    return \%merged;
}

=head1 Bootstraps Components

=head2 Glyphicon 

    $self->glyphicon({ class => 'search' });

=head3 options

=head3 Sample Output

    <span class="glyphicon glyphicon-search" aria-hidden="true"></span>

=cut

sub glyphicon {
    my ($self) = shift;
    my %element_args = validate_with(
        params => \@_,
        spec   => $self->_setup_validation_spec(
            {
                tag         => { default => 'span' },
                class       => 1,
                aria_hidden => { default => 'true' },
            }
        ),
    );

    $element_args{class} = sprintf "glyphicon glyphicon-%s",
      $element_args{class};
    return Moonshine::Element->new( \%element_args );
}

=head2 Buttons
    
    $self->button( class => 'success', data => 'Left' );

=head3 Sample Output

      <button type="button" class="btn btn-success">Left</button>

=cut

sub button {
    my $self         = shift;
    my %element_args = validate_with(
        params => \@_,
        spec   => $self->_setup_validation_spec(
            {
                tag   => { default => 'button' },
                class => { default => 'default' },
                type  => { default => 'button' },
                data  => 1,
            }
        ),
    );

    $element_args{class} = sprintf "btn btn-%s", $element_args{class};
    return Moonshine::Element->new( \%element_args );
}

=head2 Button Groups

    $self->button_group(group => [{ }, { }, { }]);

=head3 Options

=over

=item group

Array of Hashes - each hash get sent to **button**

=item sizing 

SCALAR that appends btn-group-%s - lg, sm, xs

=head3 Sample Output

    <div class="btn-group" role="group" aria-label="...">
          <button type="button" class="btn btn-default">Left</button>
          <button type="button" class="btn btn-default">Middle</button>
          <button type="button" class="btn btn-default">Right</button>
    </div>

=cut

sub button_group {
    my $self         = shift;
    my %element_args = validate_with(
        params => \@_,
        spec   => $self->_setup_validation_spec(
            {
                role   => { default => 'group' },
                class  => { default => 'btn-group' },
                sizing => 0,
                group  => {
                    type => ARRAYREF,
                },
            }
        ),
    );

    if ( my $group_sizing = $element_args{sizing} ) {
        $element_args{class} = sprintf '%s btn-group-%s', $element_args{class},
          $group_sizing;
    }

    my $groups       = delete $element_args{group};
    my $button_group = $self->div(%element_args);

    for ( @{$groups} ) {
        $button_group->add_child( $self->button($_) );
    }

    return $button_group;
}

=head2 Button toolbar

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

=head3 Sample Output
    
    <div class="btn-toolbar" role="toolbar">
        <div class="btn-group" role="group">
              <button type="button" class="btn btn-default">one</button>
        </div> 
        <div class="btn-group" role="group">
              <button type="button" class="btn btn-default">one</button>
        </div>
    </div>

=cut

sub button_toolbar {
    my $self         = shift;
    my %element_args = validate_with(
        params => \@_,
        spec   => $self->_setup_validation_spec(
            {
                role    => { default => 'toolbar' },
                class   => { default => 'btn-toolbar' },
                toolbar => {
                    type => ARRAYREF,
                },
            }
        ),
    );

    my $toolbars       = delete $element_args{toolbar};
    my $button_toolbar = $self->div(%element_args);

    for ( @{$toolbars} ) {
        $button_toolbar->add_child( $self->button_group($_) );
    }

    return $button_toolbar;
}

=head2 Dropdown
    
    $self->dropdown({
        mid => 'somethingUnique',
        button => {},
        ul => {},
        dropup => 1,
    });

=head3 options

=over

=item mid

Id that is used to link the button and hidden list

=item button

Used to create the button, check dropdown_button for options.

=item ul

Hidden list, that will be shown on click, check dropdown_ul for options.

=item dropup

Change position of dropdown menu via base_element div class - dropdown, dropup, 

=back

=head3 Sample Output

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

=cut

sub dropdown {
    my $self         = shift;
    my %element_args = validate_with(
        params => \@_,
        spec   => $self->_setup_validation_spec(
            {
                class  => { default => '' },
                dropup => 0,
                button => {
                    type => HASHREF,
                },
                ul => {
                    type => HASHREF,
                },
                mid => {
                    type => SCALAR,
                }
            }
        ),
    );

    my $class = delete $element_args{dropup} ? 'dropup' : 'dropdown';
    $element_args{class} .= $class;

    my $button = delete $element_args{button};
    my $ul     = delete $element_args{ul};
    my $id     = delete $element_args{mid};

    my $div = $self->div(%element_args);
    $div->add_child( $self->dropdown_button( ( %{$button}, id => $id ) ) );
    $div->add_child( $self->dropdown_ul( ( %{$ul}, aria_labelledby => $id ) ) );

    return $div;
}

=head2 dropdown_button

    $self->dropdown_button({ class => "..." });

=head3 Options

=over

=item class 

defaults to 'default',

=item id

dropdown_button **requires** an Id

=item data_toggle

defaults to dropdown

=item aria_haspopup

defaults to true

=item aria_expanded 

defaults to true

=item data

is **required**

=head3 Sample Output

    <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
        Dropdown
        <span class="caret"></span>
    </button> 

=cut

sub dropdown_button {
    my ($self) = shift;

    my %element_args = validate_with(
        params => \@_,
        spec   => $self->_setup_validation_spec(
            {
                class         => { default => 'default' },
                id            => 1,
                data_toggle   => { default => 'dropdown' },
                aria_haspopup => { default => 'true' },
                aria_expanded => { default => 'true' },
                data          => 1,
            }
        ),
    );

    $element_args{class} .= ' dropdown-toggle';

    my $button = $self->button(%element_args);
    $button->add_child( $self->caret );
    return $button;
}

=head2 dropdown_ul 

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

=head3 Options

=over

=item class 

defaults to dropdown-menu

=item aira_lebelledby

Required

=item list

Arrayref that gets used to build linked_li's 

=item Separators 

Add a divider to separate series of links in a dropdown menu

    <ul class="dropdown-menu" aria-labelledby="dropdownMenuDivider">
      ...
      <li role="separator" class="divider"></li>
      ...
    </ul> 
 
=item alignment

Change alignment of dropdown menu 
    
    <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="dLabel">
        ...
    </ul>
 
=back

=head3 Sample Output

    <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
        <li><a href="#">Action</a></li>
        <li><a href="#">Another action</a></li>
        <li><a href="#">Something else here</a></li>
        <li role="separator" class="divider"></li>
        <li><a href="#">Separated link</a></li>
    </ul>

=cut

sub dropdown_ul {
    my $self = shift;

    my %element_args = validate_with(
        params => \@_,
        spec   => $self->_setup_validation_spec(
            {
                class           => { default => 'dropdown-menu' },
                aria_labelledby => 1,
                alignment       => {
                    type     => SCALAR,
                    optional => 1,
                },
                separators => {
                    type     => ARRAYREF,
                    optional => 1,
                },
                headers => {
                    type     => ARRAYREF,
                    optional => 1,
                },
                list => {
                    type => ARRAYREF,
                }
            }
        ),
    );

    my $list       = delete $element_args{list};
    my $separators = delete $element_args{separators};
    my $headers    = delete $element_args{headers};
    if ( my $alignment = delete $element_args{alignment} ) {
        $element_args{class} .= sprintf " dropdown-menu-%s", $alignment;
    }

    my $ul = $self->ul(%element_args);

    for ( @{$list} ) {
        if ( delete $_->{header} ) {
            $ul->add_child( $self->dropdown_header_li($_) );
        }
        elsif ( delete $_->{separator} ) {
            $ul->add_child( $self->separator_li );
        }
        else {
            $ul->add_child( $self->linked_li($_) );
        }
    }

    if ($headers) {
        for ( @{$headers} ) {
            my $index = delete $_->{index} or die "no index";
            splice @{ $ul->{children} }, $index - 1, 0,
              $self->dropdown_header_li($_);
        }
    }

    if ($separators) {
        my $separator = $self->separator_li;
        for ( @{$separators} ) {
            splice @{ $ul->{children} }, $_ - 1, 0, $separator;
        }
    }

    return $ul;
}

=head2 header_li

    $self->separator_li;

=head3 Sample Output

    <li role="separator" class="divider"></li>

=cut

sub separator_li {
    my $self = shift;

    my %element_args = validate_with(
        params => \@_,
        spec   => $self->_setup_validation_spec(
            {
                role  => { default => 'separator' },
                class => { default => 'divider' },
            }
        ),
    );

    return $self->li(%element_args);
}

=head2 dropdown_header_li

    $self->dropdown_header_li( data => 'Dropdown header' );

=head3 Options

=over

=item class

=item data

=back

=head3 Sample Output

    <li class="dropdown-header">Dropdown header</li>

=cut

sub dropdown_header_li {
    my $self = shift;

    my %element_args = validate_with(
        params => \@_,
        spec   => $self->_setup_validation_spec(
            {
                class => { default => 'dropdown-header' },
                data  => 1,
            }
        ),
    );

    return $self->li(%element_args);
}

=head2 linked_li  

    $self->linked_li( link => 'http://some.url', data => 'Action' )

=head3 Options

=over

=item Disabled

    $self->linked_li( disabled => 1, ... )

    <li class="disabled"><a href="#">Disabled link</a></li>

=item link

    $self->linked_li( link => "#", ... )

    <a href="#">

=item data

    $self->linked_li( data => [1, 2, 3], ... )

    123

=back

=head3 Sample Output

    <li><a href="http://some.url">Action</a></li>

=cut

sub linked_li {
    my $self = shift;

    my %element_args = validate_with(
        params => \@_,
        spec   => $self->_setup_validation_spec(
            {
                link     => 1,
                data     => 1,
                disabled => 0,
            }
        ),
    );

    my $a_args = {
        href => delete $element_args{link},
        data => delete $element_args{data},
    };

    my $disabled = delete $element_args{disabled};

    my $li = $self->li(%element_args);

    if ($disabled) {
        $li->class('disabled');
    }

    $li->add_child( $self->a($a_args) );
    return $li;
}

=head2 caret

    $self->caret

=over

=item tag

=item class

=back

=head3 Sample Output

    <span class="caret"></span>

=cut

sub caret {
    my $self         = shift;
    my %element_args = validate_with(
        params => \@_,
        spec   => $self->_setup_validation_spec(
            {
                tag   => { default => 'span' },
                class => { default => 'caret' },
            }
        ),
    );

    return Moonshine::Element->new(%element_args);
}

1;

__END__

=head1 AUTHOR

LNATION, C<< <thisusedtobeanemail at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moonshine-world at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Moonshine-World>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2017 LNATION.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

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


=cut

1;
