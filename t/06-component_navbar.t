use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok('Moonshine::Bootstrap');
}

subtest "build" => sub {
    my $class = Moonshine::Bootstrap->new();

    component_test(
        {
            class  => $class,
            action => 'link_image',
            args   => {
                img => {
                    alt => 'Brand',
                    src => 'some.src',
                },
                href => 'some.url',
            },
            expected =>
'<a class="navbar-brand" href="some.url"><img alt="Brand" src="some.src"></img></a>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'navbar_header',
            args   => {
                headers => [
                    {
                        img => {
                            alt => 'Brand',
                            src => 'some.src',
                        },
                        href => 'some.url',
                    },
                ],
            },
            expected =>
'<div class="navbar-header"><a class="navbar-brand" href="some.url"><img alt="Brand" src="some.src"></img></a></div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'navbar_header',
            args   => {
                headers => [
                    {
                        img => {
                            alt => 'Brand',
                            src => 'some.src',
                        },
                        href => 'some.url',
                    },
                    {
                        img => {
                            alt => 'Brand',
                            src => 'some.src',
                        },
                        href => 'some.url',
                    },
                ],
            },
            expected =>
'<div class="navbar-header"><a class="navbar-brand" href="some.url"><img alt="Brand" src="some.src"></img></a><a class="navbar-brand" href="some.url"><img alt="Brand" src="some.src"></img></a></div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'navbar',
            args   => {
                items => [
                    {
                        headers => [
                            {
                                img => {
                                    alt => 'Brand',
                                    src => 'some.src',
                                },
                                href => 'some.url',
                            },
                        ],
                    },
                ],
            },
            expected =>
'<nav class="navbar navbar-default"><div class="container-fluid"><div class="navbar-header"><a class="navbar-brand" href="some.url"><img alt="Brand" src="some.src"></img></a></div></div></nav>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'submit_button',
            args   => {
                switch => 'success',
            },
            expected =>
              '<button class="btn btn-success" type="submit">Submit</button>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'navbar_form',
            args   => {
                switch => 'left',
                role   => 'search',
                fields => [
                    {
                        field_type => 'submit_button',
                    },
                ]
            },
            expected =>
'<form class="navbar-form navbar-left" role="search"><button class="btn btn-default" type="submit">Submit</button></form>'

        }
    );

    component_test(
        {
            class  => $class,
            action => 'form_group',
            args   => {
                fields => [
                    {
                        field_type  => 'text',
                        placeholder => 'Search'
                    },
                ]
            },
            expected =>
'<div class="form-group"><input class="form-control" placeholder="Search" type="text"></input></div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'navbar_form',
            args   => {
                role   => 'search',
                fields => [
                    {
                        field_type => 'field_group',
                        fields     => [
                            {
                                field_type  => 'text',
                                placeholder => 'Search'
                            },
                        ],
                    },
                    {
                        field_type => 'submit_button',
                    }
                ],
            },
            expected =>
'<form class="navbar-form navbar-left" role="search"><div class="form-group"><input class="form-control" placeholder="Search" type="text"></input></div><button class="btn btn-default" type="submit">Submit</button></form>',
        }
    );

};

sub component_test {
    my $args = shift;

    my $action = $args->{action};
    my $element = $args->{class}->$action( $args->{args} // {} );
    return is( $element->render, $args->{expected},
        "got expected $args->{expected}" );
}

done_testing();
