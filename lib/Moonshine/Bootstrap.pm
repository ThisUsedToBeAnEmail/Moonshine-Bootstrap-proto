package Moonshine::Bootstrap;

use 5.006;
use strict;
use warnings;

use Moonshine::Element;
use Params::Validate qw(:all);
use Ref::Util qw(:all);

use feature qw/switch/;
no if $] >= 5.017011, warnings => 'experimental::smartmatch';

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
    my %field_list = map { $_ => 0 } @{$fields}, qw/data tag/;
    {
        no strict 'refs';
        *{"element_attributes"} = sub { %field_list };
    };

    my @lazy_components =
      qw/li ul a th td tr p div span b i u dl dt em h1 h2 h3 h4 h5 h6 ol label form small/;
    for my $component (@lazy_components) {
        {
            no strict 'refs';
            *{"$component"} = sub {
                my $self = shift;

                my ( $base_args, $build_args ) = validate_base_and_build(
                    {
                        params => $_[0] // {},
                        spec => {
                            tag  => { default => $component },
                            data => 0,
                        }
                    }
                );

                return Moonshine::Element->new($base_args);
              }
        };
    }
}

sub validate_base_and_build {
    my %args = validate_with(
        params => $_[0],
        spec   => {
            params => { type => HASHREF },
            spec   => { type => HASHREF },
        }
    );

    my %html_spec   = __PACKAGE__->element_attributes;
    my %html_params = ();

    my %modifier_spec   = __PACKAGE__->modifier_spec;
    my %modifier_params = ();

    my %combine = ( %{ $args{params} }, %{ $args{'spec'} } );

    for my $key ( keys %combine ) {
        my $spec = $args{spec}->{$key};
        if ( is_hashref($spec) ) {
            defined $spec->{build} and next;
            if ( exists $spec->{base} ) {
                my $param = delete $args{params}->{$key};
                my $spec  = delete $args{spec}->{$key};
                $html_params{$key} = $param if $param;
                $html_spec{$key}   = $spec  if $spec;
                next;
            }
        }

        if ( exists $html_spec{$key} ) {
            if ( defined $spec ) {
                $html_spec{$key} = delete $args{spec}->{$key};
            }
            if ( exists $args{params}->{$key} ) {
                $html_params{$key} = delete $args{params}->{$key};
            }
            next;
        }
        elsif ( exists $modifier_spec{$key} ) {
            if ( defined $spec ) {
                $modifier_spec{$key} = delete $args{spec}->{$key};
            }
            if ( exists $args{params}->{$key} ) {
                $modifier_params{$key} = delete $args{params}->{$key};
            }
            next;
        }
    }

    my %base = validate_with(
        params => \%html_params,
        spec   => \%html_spec,
    );

    my %build = validate_with(
        params => $args{params},
        spec   => $args{spec},
    );

    my %modifier = validate_with(
        params => \%modifier_params,
        spec   => \%modifier_spec,
    );

    if ( my $switch = join_class( $modifier{switch_base}, $modifier{switch} ) )
    {
        $base{class} = prepend_str( $switch, $base{class} );
    }

    if ( my $class_base = $modifier{class_base} ) {
        $base{class} = prepend_str( $class_base, $base{class} );
    }

    if ( my $sizing = join_class( $modifier{sizing_base}, $modifier{sizing} ) )
    {
        $base{class} = append_str( $sizing, $base{class} );
    }

    if ( my $alignment =
        join_class( $modifier{alignment_base}, $modifier{alignment} ) )
    {
        $base{class} = append_str( $alignment, $base{class} );
    }

    for (qw/active justified disable/) {
        if ( defined $modifier{$_} ) {
            $base{class} =
              append_str( $modifier{ $_ . '_base' }, $base{class} );
        }
    }

# TODOs children, before, after... and probably some more bootstrap class things :D

    return \%base, \%build, \%modifier;
}

sub modifier_spec {
    return (
        switch         => 0,
        switch_base    => 0,
        class_base     => 0,
        sizing         => 0,
        sizing_base    => 0,
        alignment      => 0,
        alignment_base => 0,
        active         => 0,
        active_base    => { default => 'active' },
        disable        => 0,
        disable_base   => { default => 'disabled' },
        justified      => 0,
        justified_base => 0,
    );
}

sub join_class {
    defined $_[0] && defined $_[1] and return sprintf '%s%s', $_[0], $_[1];
    return undef;
}

sub prepend_str {
    return defined $_[1] ? sprintf '%s %s', $_[0], $_[1] : $_[0];
}

sub append_str {
    return defined $_[1] ? sprintf '%s %s', $_[1], $_[0] : $_[0];
}

=head1 Bootstraps Components

=head2 Glyphicon 

    $self->glyphicon({ class => 'search' });

=head3 options

=over

=item tag

default span

=item class

is required

=item aria_hidden

default true

=back

=head3 Sample Output

    <span class="glyphicon glyphicon-search" aria-hidden="true"></span>

=cut

sub glyphicon {
    my ($self) = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                tag         => { default => 'span' },
                switch      => 1,
                switch_base => { default => 'glyphicon glyphicon-' },
                aria_hidden => { default => 'true' },
            }
        }
    );

    return Moonshine::Element->new($base_args);
}

=head2 Buttons
    
    $self->button( class => 'success', data => 'Left' );

=head3 Options

=over

=item sizing 

Buttons can have different sizes.

    sizing => 'lg',

    <button class="btn btn-success btn-lg" ...>

=item switch

default/success/danger...

=item type

defaults to button

=item data

=back

=head3 Sample Output

    <button type="button" class="btn btn-success">Left</button>

=cut

sub button {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                tag         => { default => 'button' },
                switch      => { default => 'default' },
                switch_base => { default => 'btn btn-' },
                type        => { default => 'button' },
                sizing_base => { default => 'btn-' },
            }
        }
    );

    return Moonshine::Element->new($base_args);
}

=head2 Button Groups

    $self->button_group(group => [{ }, { }, { }]);

=head3 Options

=over

=item group

Array of Hashes - each hash get sent to **button**

unless dropdown => 1 is set, then the args gets sent to dropdown.

=item sizing 

SCALAR that appends btn-group-%s - lg, sm, xs

=item nested

ArrayRef of Hashes, that can build nested button_groups

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

=item vertical

Make a set of buttons appear vertically stacked rather than horizontally.

    vertical => 1

    <div class="btn-group btn-group-vertical" ...>
        ...
    </div>

=item justified

Make a group of buttons stretch at equal sizes to span the entire width of its parent.

    justified => 1

    <div class="btn-group btn-group-justified" ...>
         ...
    </div>

=back

=head3 Sample Output

    <div class="btn-group" role="group" aria-label="...">
          <button type="button" class="btn btn-default">Left</button>
          <button type="button" class="btn btn-default">Middle</button>
          <button type="button" class="btn btn-default">Right</button>
    </div>

=cut

sub button_group {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                role           => { default => 'group' },
                class_base     => { default => 'btn-group' },
                sizing_base    => { default => 'btn-group-' },
                vertical       => 0,
                justified_base => { default => 'btn-group-justified' },
                nested         => {
                    type     => ARRAYREF,
                    optional => 1,
                },
                group => {
                    type => ARRAYREF,
                },
            }
        }
    );

    if ( my $vertical = $build_args->{vertical} ) {
        $base_args->{class} =
          append_str( 'btn-group-vertical', $base_args->{class} );
    }

    my $button_group = $self->div($base_args);

    my %drop_down_args = ( class => 'btn-group', role => 'group' );
    for ( @{ $build_args->{group} } ) {
        if ( exists $_->{group} ) {
            $button_group->add_child( $self->button_group($_) );
        }
        elsif ( delete $_->{dropdown} ) {
            $button_group->add_child(
                $self->dropdown( { %{$_}, %drop_down_args } ) );
        }
        else {
            $button_group->add_child( $self->button($_) );
        }
    }

    for ( @{ $build_args->{nested} } ) {
        my $index = delete $_->{index};
        my $nested_button_group =
          delete $_->{dropdown}
          ? $self->dropdown( { %{$_}, %drop_down_args } )
          : $self->button_group($_);

        if ($index) {
            splice @{ $button_group->{children} }, $index - 1, 0,
              $nested_button_group;
        }
        else {
            push @{ $button_group->{children} }, $nested_button_group;
        }
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

=head3 Options

=over

=item role

=item class

=item toolbar

=back

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
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                role       => { default => 'toolbar' },
                class_base => { default => 'btn-toolbar' },
                toolbar    => {
                    type => ARRAYREF,
                },
            },
        }
    );

    my $button_toolbar = $self->div($base_args);

    for ( @{ $build_args->{toolbar} } ) {
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
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
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
        }
    );

    my $class = $build_args->{dropup} ? 'dropup' : 'dropdown';
    $base_args->{class} = append_str( $class, $base_args->{class} );

    my $div = $self->div($base_args);
    $div->add_child(
        $self->dropdown_button(
            { %{ $build_args->{button} }, id => $build_args->{mid} }
        )
    );
    $div->add_child(
        $self->dropdown_ul(
            {

                %{ $build_args->{ul} },
                aria_labelledby => $build_args->{mid}

            }
        )
    );

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

=item split

Create split dropdown button

    $self->dropdown_button({ split => 1 });

     <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
        Dropdown
        <span class="caret"></span>
    </button> 

=back

=head3 Sample Output

    <button class="btn btn-default">Dropdown</button>
    <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
        <span class="caret"></span>
    </button> 

=cut

sub dropdown_button {
    my ($self) = shift;

    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                switch     => { default => 'default', base => 1 },
                class_base => { default => 'dropdown-toggle' },
                id         => 1,
                split      => 0,
                data_toggle   => { default => 'dropdown' },
                aria_haspopup => { default => 'true' },
                aria_expanded => { default => 'true' },
                data          => 1,
            }
        }
    );

    $build_args->{data} = delete $base_args->{data}
      if $build_args->{split};

    my $button = $self->button($base_args);

    $button->add_before_element(
        $self->button(
            { data => $build_args->{data}, class => $base_args->{class} }
        )
    ) if $build_args->{split};

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

=head3 Options

=over

=item class 

defaults to dropdown-menu

=item aira_lebelledby

Required

=item children

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

    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base      => { default => 'dropdown-menu' },
                aria_labelledby => 0,
                alignment_base  => {
                    default => 'dropdown-menu-',
                },
                separators => {
                    type     => ARRAYREF,
                    optional => 1,
                },
                headers => {
                    type     => ARRAYREF,
                    optional => 1,
                },
                children => {
                    type => ARRAYREF,
                }
            }
        }
    );

    my $ul = $self->ul($base_args);

    for ( @{ $build_args->{children} } ) {
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

    if ( $build_args->{headers} ) {
        for ( @{ $build_args->{headers} } ) {
            my $index = delete $_->{index} or die "no index";
            splice @{ $ul->{children} }, $index - 1, 0,
              $self->dropdown_header_li($_);
        }
    }

    if ( my $separators = $build_args->{separators} ) {
        my $separator = $self->separator_li;
        for ( @{$separators} ) {
            splice @{ $ul->{children} }, $_ - 1, 0, $separator;
        }
    }

    return $ul;
}

=head2 header_li

    $self->separator_li;

=head3 options

=over

=item role

=item class

=back

=head3 Sample Output

    <li role="separator" class="divider"></li>

=cut

sub separator_li {
    my $self = shift;

    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                role  => { default => 'separator' },
                class => { default => 'divider' },
            }
        }
    );

    return $self->li($base_args);
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

    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'dropdown-header' },
                data       => 1,
            }
        }
    );

    return $self->li($base_args);
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

    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                link    => 1,
                data    => { build => 1 },
            }
        }
    );

    my $li = $self->li($base_args);

    $li->add_child(
        $self->a(
            { href => $build_args->{link}, data => $build_args->{data} }
        )
    );
    return $li;
}

=head2 linked_li_span 

    $self->linked_li_span({ link => { href => 'http://some.url' }, span => { data => 'Action'} )

=head3 Options

=over

=item Disabled

    $self->linked_li( disabled => 1, ... )

    <li class="disabled"><a href="#"><span aria-hidden="true">Disabled link</span></a></li>

=item link

    $self->linked_li({ link => { href => "#" , ... } })

    <a href="#">

=item span

    $self->linked_li({ span => { data => [1, 2, 3] }, ... })

    123

=back

=head3 Sample Output

    <li><a href="http://some.url"><span aria-hidden="true">Action</span></a></li>

=cut

sub linked_li_span {
    my $self = shift;

    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                link => { type => HASHREF },
                span => { type => HASHREF, build => 1 },
            }
        }
    );

    $build_args->{data} = delete $base_args->{data};

    my $li = $self->li($base_args);

    my $a = $li->add_child( $self->a( $build_args->{link} ) );
    $a->add_child( $self->span( $build_args->{span} ) );

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
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                tag   => { default => 'span' },
                class => { default => 'caret' },
            }
        }
    );

    return Moonshine::Element->new($base_args);
}

=head2 Input Groups
    
    $self->input_group({
        mid => 'basic-addon1',
        placeholder => 'Username',
        left => {
            data => '@'
        }
    });

=head3 options

=over

=item label

    $self->input_group({ label => { data => 'some text' } });

    <label>some text .... </label

=item mid

Used to map addon and input.

=item lid

Used to map label to input.

    <label for="lid">
    <input id="lid">

=item placeholder

=item left

=item right

=item sizing

=back

=head3 Sample Output

    <div class="input-group">
        <span class="input-group-addon" id="basic-addon1">@</span>
        <input type="text" class="form-control" placeholder="Username" aria-describedby="basic-addon1">
    </div>

=cut

sub input_group {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                mid         => 1,
                lid         => 0,
                sizing_base => { default => 'input-group-' },
                class_base  => { default => 'input-group' },
                label       => {
                    type     => HASHREF,
                    optional => 1,
                    build    => 1,
                },
                left => {
                    type     => HASHREF,
                    optional => 1,
                },
                right => {
                    type     => HASHREF,
                    optional => 1,
                },
                input => {
                    type     => HASHREF,
                    optional => 1,
                    default  => {},
                }
            }
        }
    );

    my $input_group = $self->div($base_args);

    my $label;
    if ( $build_args->{label} ) {
        $label =
          $input_group->add_before_element(
            $self->label( $build_args->{label} ) );
    }

    if ( $build_args->{left} ) {
        $build_args->{left}->{id} = $build_args->{mid};
        $input_group->add_child(
            $self->input_group_addon( $build_args->{left} ) );
    }

    if ( my $lid = $build_args->{lid} ) {
        $build_args->{input}->{id} = $lid;
        $label->for($lid);
    }

    $build_args->{input}->{aria_describedby} = $build_args->{mid};
    $input_group->add_child( $self->input( $build_args->{input} ) );

    if ( $build_args->{right} ) {
        $build_args->{right}->{id} = $build_args->{mid};
        $input_group->add_child(
            $self->input_group_addon( $build_args->{right} ) );
    }

    return $input_group;
}

=head2 input

    $self->input();

=head3

=over

=item class

default form-control

=item type

default text

=back

=head3 Renders

    <input type="text" class="form-control">

=cut

sub input {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                tag        => { default => 'input' },
                class_base => { default => 'form-control' },
                type       => { default => 'text' },
            }
        }
    );

    return Moonshine::Element->new($base_args);
}

=head2 input addon

    $self->input_addon();

=head3 Options

=over

=item checkbox

=item radio

=item button

=item dropdown

=item class

=back

=head3 Renders

    <span class="input-group-addon" ...>@</span>

=cut

sub input_group_addon {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                checkbox => 0,
                radio    => 0,
                button   => {
                    type     => HASHREF,
                    optional => 1,
                },
                dropdown => {
                    type     => HASHREF,
                    optional => 1,
                },
                class => { default => 'input-group-addon' },
            }
        }
    );

    my $group_addon = $self->span($base_args);

    if ( my $button = $build_args->{button} ) {
        $group_addon->class("input-group-btn");
        $group_addon->add_child( $self->button($button) );
    }

    if ( my $dropdown = $build_args->{dropdown} ) {
        $group_addon->class("input-group-btn");
        $group_addon->tag('div');
        $group_addon->add_child(
            $self->dropdown_button(
                { %{ $dropdown->{button} }, id => $dropdown->{mid} }
            )
        );
        $group_addon->add_child(
            $self->dropdown_ul(
                { %{ $dropdown->{ul} }, aria_labelledby => $dropdown->{mid} }
            )
        );
    }

    if ( $build_args->{checkbox} ) {
        $group_addon->add_child( $self->input( { type => 'checkbox' } ) );
    }

    if ( $build_args->{radio} ) {
        $group_addon->add_child( $self->input( { type => 'radio' } ) );
    }

    return $group_addon;
}

=head2 navs

    $self->navs();

=head3 options

=over

=item class

=item switch

tabs or pills

=item items

=item stacked

Pills are also vertically stackable. Just add 
    
    stacked => 1

=item justified

"Easily make tabs or pills equal widths of their parent at screen wider than 768pm". On smaller screens,
nav links become stacked.

    justified => 1

=back

=head3 renders

    <ul class="nav nav-tabs">
        <li role="presentation" class="active"><a href="#">Home</a></li>
        <li role="presentation"><a href="#">Profile</a></li>
        <li role="presentation"><a href="#">Messages</a></li>
    </ul>

=cut

sub nav {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base  => { default => 'nav' },
                switch_base => { default => 'nav-' },
                items       => {
                    type => ARRAYREF,
                },
                stacked        => 0,
                justified      => 0,
                justified_base => { default => 'nav-justified' },
            }
        }
    );

    if ( $build_args->{stacked} ) {
        $base_args->{class} = append_str( 'nav-stacked', $base_args->{class} );
    }

    my $ul = $self->ul($base_args);

    for ( @{ $build_args->{items} } ) {
        $ul->add_child( $self->nav_item($_) );
    }

    return $ul;
}

=head2 nav_item

    $self->nav_item;

=head3 options

=over

=item class

=item role 

=item link

=item active

=item data

=item disable

=item dropdown

=back

=head3 renders

    <li role="presentation" class="active"><a href="#">Home</a></li>

=cut

sub nav_item {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                role    => { default => "presentation" },
                link    => { default => '#', base => 1 },
                disable => { base    => 1, optional => 1 },
                dropdown => {
                    build    => 1,
                    type     => HASHREF,
                    optional => 1,
                }
            }
        }
    );

    my $li = $self->linked_li($base_args);

    if ( my $dropdown = $build_args->{dropdown} ) {
        my $a = $li->children->[0];
        $a->set(
            {
                class         => 'dropdown-toggle',
                role          => 'button',
                aria_haspopup => 'true',
                aria_expanded => 'false',
                data_toggle   => 'dropdown'
            }
        );
        $li->add_child( $self->dropdown_ul($dropdown) );
    }

    return $li;
}

=head2 navbar

    $self->navbar();

=head3 options

=over 

=item navs

nav_type

=back

=head3 renders

    <nav class="navbar navbar-default">
          <div class="container-fluid">
            <div class="navbar-header">
                  <a class="navbar-brand" href="#">
                    <img alt="Brand" src="...">
                  </a>
            </div>
          </div>
    </nav>

=cut

sub navbar {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                tag         => { default => 'nav' },
                mid         => 0,
                class_base  => { default => 'navbar' },
                switch      => { default => 'default' },
                switch_base => { default => 'navbar-' },
                navs        => {
                    type => ARRAYREF,
                },
                fixed  => { type => SCALAR, optional => 1 },
                static => { type => SCALAR, optional => 1 },
            },
        }
    );

    if ( my $fixed = $build_args->{fixed} ) {
        $base_args->{class} .= sprintf ' navbar-fixed-%s', $fixed;
    }

    if ( my $static = $build_args->{static} ) {
        $base_args->{class} .= sprintf ' navbar-static-%s', $static;
    }

    my $nav = Moonshine::Element->new($base_args);
    my $container =
      $nav->add_child( $self->div( { class => 'container-fluid' } ) );

    for my $nav ( @{ $build_args->{navs} } ) {
        given ( delete $nav->{nav_type} ) {
            when ('header') {
                $nav->{mid} = $build_args->{mid} if $build_args->{mid};
                $container->add_child( $self->navbar_header($nav) );
            }
            when ('collapse') {
                $nav->{id} = $build_args->{mid} if $build_args->{mid};
                $container->add_child( $self->navbar_collapse($nav) );
            }
            when ('nav') {
                $container->add_child( $self->nav($nav) );
            }
            when ('button') {
                $container->add_child( $self->navbar_button($nav) );
            }
            when ('form') {
                $container->add_child( $self->navbar_form($nav) );
            }
            when ('text') {
                $container->add_child( $self->navbar_text($nav) );
            }
            when ('text_link') {
                $container->add_child( $self->navbar_text_link($nav) );
            }
        }
    }

    return $nav;
}

=head2 navbar_collapse

    $self->navbar_collapse({ navs => [ ] });

=head3 options

=over 

=item navs

nav_type

=back

=head3 renders


    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
    
        ...

    </nav>

=cut

sub navbar_collapse {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                id         => 1,
                class_base => { default => 'collapse navbar-collapse' },
                navs       => {
                    type => ARRAYREF,
                },
            },
        }
    );

    my $collapse = $self->div($base_args);

    for my $nav ( @{ $build_args->{navs} } ) {
        given ( delete $nav->{nav_type} ) {
            when ('nav') {
                $collapse->add_child( $self->navbar_nav($nav) );
            }
            when ('button') {
                $collapse->add_child( $self->navbar_button($nav) );
            }
            when ('form') {
                $collapse->add_child( $self->navbar_form($nav) );
            }
            when ('text') {
                $collapse->add_child( $self->navbar_text($nav) );
            }
            when ('text_link') {
                $collapse->add_child( $self->navbar_text_link($nav) );
            }
        }
    }

    return $collapse;
}

=head2 navbar_header

    $self->navbar_header({});

=head3 Options

=head3 Renders

    <div class="navbar-header">
      <a class="navbar-brand" href="#">
        <img alt="Brand" src="...">
      </a>
    </div>

=cut

sub navbar_header {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'navbar-header' },
                headers    => {
                    type  => ARRAYREF,
                    build => 1,
                },
                mid => { default => 'please-set-me', optional => 1 },
            },
        }
    );

    my $navbar_header = $self->div($base_args);

    for my $header ( @{ $build_args->{headers} } ) {
        given ( delete $header->{header_type} ) {
            when ('link_image') {
                $header->{class} = 'navbar-brand';
                $navbar_header->add_child( $self->link_image($header) );
            }
            when ('toggle') {
                $header->{data_target} = $build_args->{mid};
                $navbar_header->add_child( $self->navbar_toggle($header) );
            }
            when ('brand') {
                $navbar_header->add_child( $self->navbar_brand($header) );
            }
        }
    }

    return $navbar_header;
}

=head2 navbar_brand

    $self->navbar_brand({ data => 'HEY' });

=head3 options

=head3 Renders

    <a class="navbar-brand">HEY</a>

=cut

sub navbar_brand {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'navbar-brand' },
                data       => 1,
            },
        }
    );

    return $self->a($base_args);
}

=head2 navbar_toggle

=head3 options

=head3 Renders

    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
    </button>

=cut

sub navbar_toggle {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                tag           => { default => 'button' },
                type          => { default => 'button' },
                class_base    => { default => 'navbar-toggle collapsed' },
                data_toggle   => { default => 'collapse' },
                aria_expanded => { default => 'false' },
                i             => { default => 'icon-bar' },
                sr_text       => { default => 'Toggle navigation' },
                data_target   => 1,
            },
        }
    );

    $base_args->{data_target} = sprintf "#%s", $base_args->{data_target};

    my $toggle = Moonshine::Element->new($base_args);

    $toggle->add_child(
        $self->span( { class => 'sr-only', data => $build_args->{sr_text} } ) );
    for (qw/1 2 3/) {
        $toggle->add_child( $self->span( { class => $build_args->{i} } ) );
    }
    return $toggle;
}

=head2 navbar_button 

=head3 options

=over

=item type

defaults button

=item switch

default/success....

=back

=head3 Renders

    <button type="button" class="btn btn-default">Submit</button>

=cut

sub navbar_button {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                type           => { default => 'button' },
                switch         => { default => 'default', base => 1 },
                class_base     => { default => 'navbar-btn' },
                data           => { default => 'Submit' },
                alignment_base => { default => 'navbar-' },
            },
        }
    );

    my $navbar_button = $self->button($base_args);
    return $navbar_button;
}

=head2 navbar_text 

=head3 options

=over

=item tag

Defaults <p>

=back

=head3 Renders
    
    <p class="navbar-text">Navbar text</p>

=cut

sub navbar_text {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                tag            => { default => 'p', },
                data           => 1,
                alignment_base => { default => 'navbar-' },
                class_base     => { default => 'navbar-text' },
            },
        }
    );

    my $navbar_text = Moonshine::Element->new($base_args);
    return $navbar_text;
}

=head2 navbar_text_link 

=head3 options

=over

=item link 

Hash Reference Used to build the <a>.

=back

=head3 Renders
    
    <p class="navbar-text">Navbar text<a href="#" class="navbar-link">more text</a></p>

=cut

sub navbar_text_link {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                tag       => { default => 'p', },
                link      => { type    => HASHREF },
                alignment => { base    => 1, optional => 1 },
                data => 1,
            },
        }
    );

    my $navbar_text = $self->navbar_text($base_args);
    $navbar_text->add_child(
        $self->a( { %{ $build_args->{link} }, class => 'navbar-link' } ) );
    return $navbar_text;
}

=head2 navbar_nav

=head3 options

=over

=item link 

Hash Reference Used to build the <a>.

=back

=head3 Renders
    
    <ul class="nav navbar-nav navbar-right">

    </ul>

=cut

sub navbar_nav {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base     => { default => 'navbar-nav' },
                alignment_base => { default => 'navbar-' },
                switch         => {
                    base     => 1,
                    type     => SCALAR,
                    optional => 1,
                },
                items => {
                    type => ARRAYREF,
                    base => 1,
                },
                stacked   => { base => 1, optional => 1 },
                justified => { base => 1, optional => 1 },
            },
        }
    );

    return $self->nav($base_args);
}

=head2 navbar_form

    $self->navbar_form({});

=head3 Options

=over

=item fields

ArrayRef

=item button

Defaults to Submit

=back

=head3 Renders

    <form class="navbar-form navbar-left" role="search">
        <div class="form-group">
            <input type="text" class="form-control" placeholder="Search">
        </div>
        <button type="submit" class="btn btn-default">Submit</button>
    </form>

=cut

sub navbar_form {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                alignment_base => { default => 'navbar-' },
                class_base     => { default => 'navbar-form' },
                role           => 0,
                fields         => {
                    type  => ARRAYREF,
                    build => 1,
                }
            },
        }
    );

    my $form = $self->form($base_args);

    for my $field ( @{ $build_args->{fields} } ) {
        given ( delete $field->{field_type} ) {
            when ('submit_button') {
                $form->add_child( $self->submit_button($field) );
            }
            when ('field_group') {
                $form->add_child( $self->form_group($field) );
            }
        }
    }

    return $form;
}

=head2 form_group

    $self->form_group()

=head3 Options

=over

=item class

=item fields

    fields => [
        {
            field_type => 'text',
        }
    ]

=back

=head3 Renders

    <div class="form-group">
        <input type="text" class="form-control" placeholder="Search">
    </div>
    
=cut

sub form_group {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'form-group' },
                fields     => {
                    type  => ARRAYREF,
                    build => 1,
                }
            },
        }
    );

    my $form_group = $self->div($base_args);

    for my $field ( @{ $build_args->{fields} } ) {
        given ( delete $field->{field_type} ) {
            when ('text') {
                $form_group->add_child( $self->input($field) );
            }
        }
    }

    return $form_group;
}

=head2 submit_button 

=head3 options

=over

=item type

defaults submit

=item switch

default/success....

=back

=head3 Renders

    <button type="submit" class="btn btn-default">Submit</button>

=cut

sub submit_button {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                type   => { default => 'submit' },
                switch => { default => 'default', base => 1 },
                data   => { default => 'Submit' }
            },
        }
    );

    my $submit_button = $self->button($base_args);
    return $submit_button;
}

=head2 link_image 

=head3 options

=over

=item href

required

=item img

required

    { alt => '', src => '' }

=back

=head3 renders

    <a class="navbar-brand" href="..."><img alt="some-text" src="..."></img></a>

=cut

sub link_image {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                img => {
                    build => 1,
                    type  => HASHREF,
                },
                href => 1,
            },
        }
    );

    my $a = $self->a($base_args);
    $a->add_child( $self->img( $build_args->{img} ) );
    return $a;
}

=head2 img

    $self->img({ alt => '', src => '' });

=head3 Options

=over

=item alt 

Required

=item src

Required

=back

=head3 Renders
    
    <img alt=".." src="..">

=cut

sub img {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                tag => { default => 'img' },
                alt => 1,
                src => 1,
            },
        }
    );

    my $a = Moonshine::Element->new($base_args);
}

=head2 breadcrumbs

=head3 options

=head3 Renders

    <ol class="breadcrumb">
      <li><a href="#">Home</a></li>
      <li><a href="#">Library</a></li>
      <li class="active">Data</li>
    </ol>

=cut

sub breadcrumbs {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'breadcrumb' },
                items      => { type    => ARRAYREF },
            },
        }
    );

    my $ol = $self->ol($base_args);

    for ( @{ $build_args->{items} } ) {
        if ( $_->{active} ) {
            $ol->add_child( $self->li($_) );
        }
        else {
            $ol->add_child( $self->linked_li($_) );
        }
    }

    return $ol;
}

=head2 pagination

=head3 options

=over

=item count
 
=item paging 

=item sizing

=item previous

=item next

=item count

=item items

=back

=head3 Renders

    <ul class="pagination">
        <li>
            <a href="#" arilabel="Previous">
                <span aria-hidden="true">&laquo;</span>
            </a>
        </li>
        <li><a href="#">1</a></li>
        <li><a href="#">2</a></li>
        <li><a href="#">3</a></li>
        <li>
            <a href="#" aria-label="Next">
                <span aria-hidden="true">&raquo;</span>
            </a>
        </li>
    </ul>

=cut

sub pagination {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base  => { default => 'pagination' },
                items       => { type    => ARRAYREF, optional => 1 },
                sizing_base => { default => 'pagination-' },
                count    => 0,
                previous => {
                    default => {
                        span => { data => '&laquo;', aria_hidden => 'true' },
                        link => { href => "#", aria_label => 'Previous' },
                    },
                    type => HASHREF
                },
                next => {
                    default => {
                        span => { data => '&raquo;', aria_hidden => 'true' },
                        link => { href => "#",       aria_label  => "Next" }
                    },
                    type  => HASHREF,
                    build => 1,
                },
                nav => 0,
                nav_args => { default => { tag => 'nav' } },
            },
        }
    );

    my $ul = $self->ul($base_args);

    $ul->add_child( $self->linked_li_span( $build_args->{previous} ) );

    if ( defined $build_args->{items} ) {
        for ( @{ $build_args->{items} } ) {
            if ( $_->{active} ) {
                $ul->add_child( $self->li($_) );
            }
            else {
                $ul->add_child( $self->linked_li($_) );
            }
        }
    }
    elsif ( defined $build_args->{count} ) {
        for ( 1 .. $build_args->{count} ) {
            $ul->add_child( $self->linked_li( { data => $_, link => '#' } ) );
        }
    }

    $ul->add_child( $self->linked_li_span( $build_args->{next} ) );

    if ( defined $build_args->{nav} ) {
        my $nav = Moonshine::Element->new( $build_args->{nav_args} );
        $nav->add_child($ul);
        return $nav;
    }

    return $ul;
}

=head2 pager

    $self->pager({ });

=head3 Options

=over

=item count
 
=item paging 

=item sizing

=item previous

=item next

=item count

=item items

=item disable

=item aligned

=back

=head3 Renders

    <ul class="pager">
        <li><a href="#">Previous</a></li>
        <li><a href="#">Next</a></li>
    </ul>

=cut

sub pager {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'pager', base => 1 },
                items    => { type     => ARRAYREF, optional => 1, base => 1, },
                sizing   => { optional => 1,        base     => 1 },
                count    => { optional => 1,        base     => 1 },
                previous => {
                    default => {
                        span => { data => 'Previous' },
                        link => { href => '#' },
                    },
                    type => HASHREF,
                    base => 1,
                },
                next => {
                    default => {
                        span => { data => 'Next' },
                        link => { href => "#" }
                    },
                    type => HASHREF,
                    base => 1,
                },
                aligned => 0,
                disable => { build => 1, optional => 1 },
                nav      => { optional => 1, base => 1 },
                nav_args => { optional => 1, base => 1 },
            },
        }
    );

    if ( $build_args->{aligned} ) {
        $base_args->{previous}->{class} .= 'previous';
        $base_args->{next}->{class}     .= 'next';
    }

    given ( $build_args->{disable} ) {
        my $dis = 'disabled';
        when ('previous') {
            $base_args->{previous}->{class} =
              append_str( $dis, $base_args->{previous}->{class} );
        }
        when ('next') {
            $base_args->{next}->{class} =
              append_str( $dis, $base_args->{next}->{class} );
        }
        when ('both') {
            $base_args->{next}->{class} =
              append_str( $dis, $base_args->{next}->{class} );
            $base_args->{previous}->{class} =
              append_str( $dis, $base_args->{previous}->{class} );
        }
    }

    my $pager = $self->pagination($base_args);
    return $pager;
}

=head2 text_label

    $self->text_label({ data => '', switch => '' });

=head3 Options

=over

=item data 

Required

=item switch

Optional - default is default

=back

=head3 Renders
    
    <span class="label label-default">Default</span>

=cut

sub text_label {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                switch_base => { default => 'label-' },
                switch      => { default => 'default' },
                data        => 1,
                class_base  => { default => 'label' },
            },
        }
    );

    my $span = $self->span($base_args);
    return $span;
}

=head2 badge

    $self->badge({ data => '42', wrapper => { tag => 'button' });

=head3 Options

=over

=item data 

Required

=item wrapper

Optional

=back

=head3 Renders
    
    <button ...<span class="badge">42</span></button>

=cut

sub badge {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                data    => 1,
                wrapper => { type => HASHREF, optional => 1 },
                class_base => { default => 'badge' },
            },
        }
    );

    my $span = $self->span($base_args);

    if ( defined $build_args->{wrapper} ) {
        my $wrapper = Moonshine::Element->new( $build_args->{wrapper} );
        $wrapper->add_child($span);
        return $wrapper;
    }

    return $span;
}

=head2 jumbotron

=head3 Options

=head2 items

=head2 full_width

=head3 Renders

    <div class="jumbotron">
        ...
    </div>

=cut

sub jumbotron {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                full_width => 0,
                items      => { type => ARRAYREF, optional => 1 },
                class_base => { default => 'jumbotron' },
            },
        }
    );

    my $div = $self->div($base_args);
    if ( defined $build_args->{full_width} ) {
        $div->add_child( $self->div( { class => 'container' } ) );
    }

    if ( defined $build_args->{items} ) {
        for ( @{ $build_args->{items} } ) {
            my $action = delete $_->{action} or die "a misserable death";
            $div->add_child( $self->$action($_) );
        }
    }
    return $div;
}

=head2 page_header

    $self->page_header({});

=head3 Options

=head2 header

=head2 header_tag

=head2 small

=head3 Renders

    <div class="page-header">
        <h2>Example page header <small>Subtest for header</small></h2>
    </div>

=cut

sub page_header {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'page-header' },
                header_tag => { default => 'h1' },
                header     => 0,
                small      => 0,
            },
        }
    );

    my $div = $self->div($base_args);

    my $action = $build_args->{header_tag};
    my $header = $div->add_child( $self->$action( $build_args->{header} ) );

    if ( my $data = $build_args->{small} ) {
        $header->add_child( $self->small( { data => $data } ) );
    }

    return $div;
}

=head2 thumbnail

TODO's - grids, items??

    $self->thumbnail({ tag => '' });

=head3 Options

=head2 tag

default div

=head3 Renders

    <div class="thumbnail"></div>

=cut

sub thumbnail {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'thumbnail' },
                tag        => { default => 'div' },
            },
        }
    );

    my $thumbnail = Moonshine::Element->new($base_args);
    return $thumbnail;
}

=head2 caption

TODO's - grids, items??

    $self->caption({ tag => '' });

=head3 Options

=head2 tag

default div

=head3 Renders

    <div class="caption"></div>

=cut

sub caption {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'caption' },
                tag        => { default => 'div' },
            },
        }
    );

    my $caption = Moonshine::Element->new($base_args);
    return $caption;
}

=head2 alert

    $self->alert({ data => '', switch => '' });

=head3 Options

=over

=item data 

Optional

=item switch

Optional - default is success

=back

=head3 Renders
    
    <div class="alert alert-success"></div>

=cut

sub alert {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                switch      => { default  => 'success' },
                switch_base => { default  => 'alert alert-' },
                link        => { optional => 1, type => HASHREF },
            },
        }
    );

    my $div = $self->div($base_args);

    if ( my $link = $build_args->{link} ) {
        $link->{class} = append_str( 'alert-link', $link->{class} );
        $div->add_child( $self->a($link) );
    }

    return $div;
}

=head2 progress

    $self->progress({ bar => {  } });

=head3 Options

=over

=item bar 

Optional

=back

=head3 Renders
    
    <div class="progress"></div>

=cut

sub progress {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default  => 'progress' },
                bar        => { optional => 1, type => HASHREF },
                stacked    => { optional => 1, type => ARRAYREF },
            },
        }
    );

    my $div = $self->div($base_args);

    if ( my $bar = $build_args->{bar} ) {
        $div->add_child( $self->progress_bar($bar) );
    }

    if ( defined $build_args->{stacked} ) {
        for ( @{ $build_args->{stacked} } ) {
            $div->add_child( $self->progress_bar($_) );
        }
    }

    return $div;
}

=head2 progress_bar

    $self->progress_bar();

=head3 Options

=over

=item progress-bar

=item progressbar

=item aria_valuenow

=item aria_valuemax

=item aria_valuemin

=back

=head3 Renders
    
    <div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
        60%
    </div>

=cut

sub progress_bar {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base    => { default => 'progress-bar' },
                role          => { default => 'progressbar' },
                aria_valuenow => 1,
                aria_valuemin => { default => "0" },
                aria_valuemax => { default => 100 },
                style         => { default => ['min-width:3em;'] },
                switch_base   => { default => 'progress-bar-' },
                striped       => 0,
                show          => 0,
                animated      => 0,
            },
        }
    );

    if ( defined $build_args->{striped} ) {
        $base_args->{class} =
          append_str( 'progress-bar-striped', $base_args->{class} );
    }

    my $percent = $base_args->{aria_valuenow} . "%";

    push @{ $base_args->{style} }, sprintf 'width:%s;', $percent;

    my $div = $self->div($base_args);

    if ( $build_args->{show} ) {
        $div->data($percent);
    }
    else {
        $div->add_child(
            $self->span( { class => 'sr-only', data => $percent } ) );
    }

    return $div;
}

=head2 media

    $self->media({ });

=head3 options

=over

=item media

=back

=head3 renders

    <div class="media">
        <div class="media-left media-top"><a href="#"><img class="media-object" src="url" alt="alt text"></img></a></div>
    </div>

=cut

sub media {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                tag        => { default => 'div' },
                class_base => { default => 'media' },
                items      => { type    => ARRAYREF, optional => 1 }
            },
        }
    );

    my $div = Moonshine::Element->new($base_args);

    for ( @{ $build_args->{items} } ) {
        my $action = delete $_->{action} or die '\o/';
        $div->add_child( $self->$action($_) );
    }

    return $div;
}

=head2 media_object 

    $self->media_object({ });

=head3 options

=over

=back

=head3 renders

    <div class="media-left media-top"><a href="#"><img class="media-object" src="url" alt="alt text"></img></a></div>'

=cut

sub media_object {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                x     => 0,
                y     => 0,
                body  => 0,
                items => { type => ARRAYREF }
            },
        }
    );

    my $m     = 'media';
    my @class = ();
    $build_args->{body} and push @class, sprintf '%s-body', $m;
    $build_args->{x} and push @class, sprintf '%s-%s', $m, $build_args->{x};
    $build_args->{y} and push @class, sprintf '%s-%s', $m, $build_args->{y};
    $base_args->{class} = \@class;

    my $media_object = $self->div($base_args);

    for ( @{ $build_args->{items} } ) {
        my $action = delete $_->{action} or die "a horrible death";
        $media_object->add_child( $self->$action($_) );
    }

    return $media_object;
}

=head2 media_link_img 

    $self->media_link_img({ });

=head3 options

=over

=item href

required

=item img

required

    { alt => '', src => '' }

=back

=head3 renders

    <a href="#"><img class="media-object" src="url" alt="alt text"></img></a>

=cut

sub media_link_img {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                img => {
                    base => 1,
                    type => HASHREF,
                },
                href => 1,
            },
        }
    );

    $base_args->{img}->{class} = 'media-object';
    my $link = $self->link_image($base_args);
    return $link;
}

=head2 media_list

=head3 options

=over

=item

=back

=head3 render

    <ul class="media-list">
        <li class="media">
            ...
        </li>
    </ul>

=cut

sub media_list {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'media-list' },
                items      => { type    => ARRAYREF, optional => 1 }
            },
        }
    );

    my $ul = $self->ul($base_args);

    for ( @{ $build_args->{items} } ) {
        $ul->add_child( $self->media( { tag => 'li', %{$_} } ) );
    }

    return $ul;
}

=head2 list_group

=head3 options

=over

=item

=back

=head3 render

    <ul class="list-group">
        <li class="list-group-item">Some text</li>
        ....
    </ul>

=cut

sub list_group {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'list-group' },
                tag        => { default => 'ul' },
                items      => { type    => ARRAYREF, optional => 1 }
            },
        }
    );

    my $list = Moonshine::Element->new($base_args);

    for ( @{ $build_args->{items} } ) {
        $list->add_child( $self->list_group_item($_) );
    }

    return $list;
}

=head2 list_group_item

=head3 options

=over

=item

=back

=head3 render

    <ul class="list-group">
        <li class="list-group-item">Some text</li>
        ....
    </ul>

=cut

sub list_group_item {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'list-group-item' },
                tag        => { default => 'li' },
                items      => { type    => ARRAYREF, optional => 1 },
                switch_base => { default => 'list-group-item-' },
                badge => { type => HASHREF, optional => 1 },
            },
        }
    );

    my $item = Moonshine::Element->new($base_args);

    if ( my $badge = $build_args->{badge} ) {
        $item->add_child( $self->badge($badge) );
    }

    return $item;
}

=head2 linked_group

=head3 options

=over

=item

=back

=head3 render

    <div class="list-group">
        <a class="list-group-item" href="#">Some text</a>
        ....
    </div>

=cut

sub linked_group {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'list-group' },
                tag        => { default => 'div' },
                items      => { type    => ARRAYREF, optional => 1 }
            },
        }
    );

    my $list = Moonshine::Element->new($base_args);

    for ( @{ $build_args->{items} } ) {
        $list->add_child( $self->linked_group_item($_) );
    }

    return $list;
}

=head2 linked_group_item

=head3 options

=over

=item

=back

=head3 render

    <div class="list-group">
        <a class="list-group-item" href="#">Some text</a>
        ....
    </div>

=cut

sub linked_group_item {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                tag        => { default => 'a' },
                items      => { type    => ARRAYREF, optional => 1 },
                class_base => { default => 'list-group-item' },
                badge  => { type => HASHREF, optional => 1 },
                button => 0,
                switch_base => { default => 'list-group-item-' },
            },
        }
    );

    if ( defined $build_args->{button} ) {
        $base_args->{tag}  = 'button';
        $base_args->{type} = 'button';
    }

    my $item = Moonshine::Element->new($base_args);

    if ( my $badge = $build_args->{badge} ) {
        $item->add_child( $self->badge($badge) );
    }

    if ( defined $build_args->{items} ) {
        for ( @{ $build_args->{items} } ) {
            my $action = delete $_->{action} or die "RAWWRRR";
            $item->add_child( $self->$action($_) );
        }
    }

    return $item;
}

=head2 list_group_item_heading

=head3 options

=head3 renders
    
    <h4 class="list-group-item-heading">ABC</h4>

=cut

sub linked_group_item_heading {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'list-group-item-heading' },
                tag        => { default => 'h4' },
            },
        }
    );

    my $element = Moonshine::Element->new($base_args);
    return $element;
}

=head2 list_group_item_text
    
    $self->list_group_item_text();
        
=head3 options

=head3 renders
    
    <p class="list-group-item-text">...</h4>

=cut

sub linked_group_item_text {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'list-group-item-text' },
                tag        => { default => 'p' },
            },
        }
    );

    my $element = Moonshine::Element->new($base_args);
    return $element;
}

=head2 panel

    $self->panel({ });

=head3 options

=head3 renders
    
    <div class="panel panel-default">
        ...
    </div>

=cut

sub panel {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                tag         => { default  => 'div' },
                switch      => { default  => 'default' },
                switch_base => { default  => 'panel panel-' },
                body        => { optional => 1, type => HASHREF },
                header      => { optional => 1, type => HASHREF },
                footer      => { optional => 1, type => HASHREF },
            },
        }
    );

    my $panel = Moonshine::Element->new($base_args);

    $build_args->{header}
      and $panel->add_child( $self->panel_header( $build_args->{header} ) );

    $build_args->{body}
      and $panel->add_child( $self->panel_body( $build_args->{body} ) );

    $build_args->{footer}
      and $panel->add_child( $self->panel_body( $build_args->{footer} ) );

    return $panel;
}

=head2 panel_body

    $self->panel_body({ });

=head3 options

=head3 renders
    
    <div class="panel-body">
        Basic panel example
    </div>

=cut

sub panel_body {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'panel-body' },
                tag        => { default => 'div' },
            },
        }
    );

    my $body = Moonshine::Element->new($base_args);

    return $body;
}

=head2 panel_header

    $self->panel_header({ });

=head3 options

=head3 renders
    
    <div class="panel-heading">
        Basic panel example
    </div>

=cut

sub panel_header {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'panel-heading' },
                tag        => { default => 'div' },
                title      => { build   => 1, optional => 1 },
            },
        }
    );

    my $header = Moonshine::Element->new($base_args);

    if ( defined $build_args->{title} ) {
        $header->add_child(
            $self->panel_title(
                ref $build_args->{title} eq 'HASH' ? $build_args->{title} : {}
            )
        );
    }

    return $header;
}

=head2 panel_title

    $self->panel_title({ });

=head3 options

=head3 renders
    
    <h3 class="panel-title">
        Basic panel example
    </h3>

=cut

sub panel_title {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'panel-title' },
                tag        => { default => 'h3' },
                title      => 0,
            },
        }
    );

    my $title = Moonshine::Element->new($base_args);

    return $title;
}

=head2 panel_footer

    $self->panel_footer({ });

=head3 options

=head3 renders
    
    <div class="panel-footer">
        Basic panel example
    </div>

=cut

sub panel_footer {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                class_base => { default => 'panel-footer' },
                tag        => { default => 'div' },
                title      => 0,
            },
        }
    );

    my $footer = Moonshine::Element->new($base_args);

    return $footer;
}

=head2 responsive_embed

    $self->responsive_embed({ });

=head3 options

=head3 renders
    
    <div class="embed-responsive embed-responsive-16by9">
        <iframe class="embed-responsive-item" src="#"></iframe>
    </div>

=cut

sub responsive_embed {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                tag    => { default => 'div' },
                iframe => 0,
                ratio  => 0,
            },
        }
    );

    my $class = sprintf 'embed-responsive embed-responsive-%s',
      $build_args->{ratio};
    $base_args->{class} .= append_str( $class, $base_args->{class} );

    my $responsive = Moonshine::Element->new($base_args);

    $responsive->add_child( $self->responsive_iframe( $build_args->{iframe} ) );

    return $responsive;
}

sub responsive_iframe {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                tag        => { default => 'iframe' },
                iframe     => 0,
                ratio      => 0,
                class_base => { default => 'embed-responsive-item' },
            },
        }
    );

    my $responsive = Moonshine::Element->new($base_args);

    return $responsive;
}

=head2 well

    $self->well({ switch => '' });

=head3 options

=head3 render

    <div class="well well-lg"></div>

=cut

sub well {
    my $self = shift;
    my ( $base_args, $build_args ) = validate_base_and_build(
        {
            params => $_[0] // {},
            spec => {
                tag         => { default => 'div' },
                switch_base => { default => 'well-' },
                class_base  => { default => 'well' },
            },
        }
    );

    my $well = Moonshine::Element->new($base_args);

    return $well;
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
