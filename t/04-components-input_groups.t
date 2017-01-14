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
            action => 'input_group',
            args   => {
                mid   => 'basic-addon1',
                input => {
                    placeholder => 'Username',
                },
                left => {
                    data => q(@),
                },
            },
            expected =>
'<div class="input-group"><span class="input-group-addon" id="basic-addon1">@</span><input class="form-control" placeholder="Username" type="text" aria-describedby="basic-addon1"></input></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'input_group',
            args   => {
                mid   => 'basic-addon1',
                input => {
                    placeholder => 'Username',
                },
                right => {
                    data => q(@),
                },
            },
            expected =>
'<div class="input-group"><input class="form-control" placeholder="Username" type="text" aria-describedby="basic-addon1"></input><span class="input-group-addon" id="basic-addon1">@</span></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'input_group',
            args   => {
                mid    => 'basic-addon1',
                sizing => 'lg',
                input  => {
                    placeholder => 'Username',
                },
                right => {
                    data => q(@),
                },
            },
            expected =>
'<div class="input-group input-group-lg"><input class="form-control" placeholder="Username" type="text" aria-describedby="basic-addon1"></input><span class="input-group-addon" id="basic-addon1">@</span></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'input_group',
            args   => {
                mid   => 'basic-addon1',
                input => {
                    placeholder => 'Username',
                },
                left => {
                    data => q(@),
                },
                right => {
                    data => q(@),
                },
            },
            expected =>
'<div class="input-group"><span class="input-group-addon" id="basic-addon1">@</span><input class="form-control" placeholder="Username" type="text" aria-describedby="basic-addon1"></input><span class="input-group-addon" id="basic-addon1">@</span></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'input_group',
            args   => {
                mid   => 'basic-addon1',
                lid   => 'basic-username',
                label => {
                    data => 'Some text',
                },
                input => {
                    placeholder => 'Username',
                },
                left => {
                    data => q(@),
                },
                right => {
                    data => q(@),
                },
            },
            expected =>
'<label for="basic-username">Some text</label><div class="input-group"><span class="input-group-addon" id="basic-addon1">@</span><input class="form-control" id="basic-username" placeholder="Username" type="text" aria-describedby="basic-addon1"></input><span class="input-group-addon" id="basic-addon1">@</span></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'input_group_addon',
            args   => {
                data => q(@),
                id   => 'basic-addon1',
            },
            expected =>
              '<span class="input-group-addon" id="basic-addon1">@</span>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'input_group_addon',
            args   => {
                checkbox => 1,
                id       => 'basic-addon1',
            },
            expected =>
'<span class="input-group-addon" id="basic-addon1"><input class="form-control" type="checkbox"></input></span>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'input_group_addon',
            args   => {
                radio => 1,
                id    => 'basic-addon1',
            },
            expected =>
'<span class="input-group-addon" id="basic-addon1"><input class="form-control" type="radio"></input></span>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'input_group_addon',
            args   => {
                id     => 'basic-addon1',
                button => {
                    data => 'Go!',
                }
            },
            expected =>
'<span class="input-group-btn" id="basic-addon1"><button class="btn btn-default" type="button">Go!</button></span>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'input_group_addon',
            args   => {
                id       => 'basic-addon1',
                dropdown => {
                    mid => 'dropdownMenu1',
                    ul  => {
                        items => [
                            {
                                link => 'http://some.url',
                                data => 'URL',
                            },
                            {
                                link => 'http://second.url',
                                data => 'Second',
                            }
                        ],
                    },
                    button => {
                        id   => 'dropdownMenu1',
                        data => 'Dropdown',
                    },
                }
            },
            expected =>
'<div class="input-group-btn" id="basic-addon1"><button class="btn btn-default dropdown-toggle" id="dropdownMenu1" type="button" aria-expanded="true" aria-haspopup="true" data-toggle="dropdown">Dropdown<span class="caret"></span></button><ul class="dropdown-menu" aria-labelledby="dropdownMenu1"><li><a href="http://some.url">URL</a></li><li><a href="http://second.url">Second</a></li></ul></div>'
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
