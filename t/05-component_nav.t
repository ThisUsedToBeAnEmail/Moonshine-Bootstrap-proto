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
            action => 'nav',
            args   => {
                switch  => 'tabs',
                items => [
                    {
                        data   => 'Home',
                        active => 1,
                    },
                    {
                        data => 'Profile',
                    },
                    {
                        data => 'Messages',
                    }
                ],
            },
            expected =>
'<ul class="nav nav-tabs"><li class="active" role="presentation"><a href="#">Home</a></li><li role="presentation"><a href="#">Profile</a></li><li role="presentation"><a href="#">Messages</a></li></ul>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'nav',
            args   => {
                switch  => 'pills',
                items => [
                    {
                        data   => 'Home',
                        active => 1,
                    },
                    {
                        data => 'Profile',
                    },
                    {
                        data => 'Messages',
                    }
                ],
            },
            expected =>
'<ul class="nav nav-pills"><li class="active" role="presentation"><a href="#">Home</a></li><li role="presentation"><a href="#">Profile</a></li><li role="presentation"><a href="#">Messages</a></li></ul>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'nav',
            args   => {
                switch    => 'pills',
                stacked => 1,
                items   => [
                    {
                        data   => 'Home',
                        active => 1,
                    },
                    {
                        data => 'Profile',
                    },
                    {
                        data => 'Messages',
                    }
                ],
            },
            expected =>
'<ul class="nav nav-pills nav-stacked"><li class="active" role="presentation"><a href="#">Home</a></li><li role="presentation"><a href="#">Profile</a></li><li role="presentation"><a href="#">Messages</a></li></ul>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'nav',
            args   => {
                switch    => 'pills',
                justified => 1,
                items     => [
                    {
                        data   => 'Home',
                        active => 1,
                    },
                    {
                        data => 'Profile',
                    },
                    {
                        data => 'Messages',
                    }
                ],
            },
            expected =>
'<ul class="nav nav-pills nav-justified"><li class="active" role="presentation"><a href="#">Home</a></li><li role="presentation"><a href="#">Profile</a></li><li role="presentation"><a href="#">Messages</a></li></ul>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'nav',
            args   => {
                switch    => 'pills',
                justified => 1,
                items     => [
                    {
                        data   => 'Home',
                        active => 1,
                    },
                    {
                        data    => 'Profile',
                        disable => 1,
                    },
                    {
                        data => 'Messages',
                    }
                ],
            },
            expected =>
'<ul class="nav nav-pills nav-justified"><li class="active" role="presentation"><a href="#">Home</a></li><li class="disabled" role="presentation"><a href="#">Profile</a></li><li role="presentation"><a href="#">Messages</a></li></ul>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'nav',
            args   => {
                switch    => 'pills',
                justified => 1,
                items     => [
                    {
                        data   => 'Home',
                        active => 1,
                    },
                    {
                        data    => 'Profile',
                        disable => 1,
                    },
                    {
                        data     => 'Messages',
                        dropdown => {
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
                    }
                ],
            },
            expected =>
'<ul class="nav nav-pills nav-justified"><li class="active" role="presentation"><a href="#">Home</a></li><li class="disabled" role="presentation"><a href="#">Profile</a></li><li role="presentation"><a class="dropdown-toggle" href="#" aria-expanded="false" aria-haspopup="true" role="button" data-toggle="dropdown">Messages</a><ul class="dropdown-menu"><li><a href="http://some.url">URL</a></li><li><a href="http://second.url">Second</a></li></ul></li></ul>'
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
