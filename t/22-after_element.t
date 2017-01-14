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
            action => 'well',
            args   => {
                data => '...',
                after_element => [
                    {
                        action => 'glyphicon',
                        tag => 'div',
                        switch => 'search',
                    }
                ],
            },
            expected => '<div class="well">...</div><div class="glyphicon glyphicon-search" aria-hidden="true"></div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'well',
            args   => {
                data => '...',
                after_element => [
                    {
                        action => 'glyphicon',
                        tag => 'div',
                        switch => 'search',
                    },
                    {
                        action => 'glyphicon',
                        tag => 'div',
                        switch => 'trash',
                    }
                ],
            },
            expected => '<div class="well">...</div><div class="glyphicon glyphicon-search" aria-hidden="true"></div><div class="glyphicon glyphicon-trash" aria-hidden="true"></div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'well',
            args   => {
                data => '...',
                after_element => [
                    {
                        action => 'glyphicon',
                        tag => 'div',
                        switch => 'search',
                        after_element => [
                            {
                                action => 'glyphicon',
                                tag => 'div',
                                switch => 'home',
                            }
                        ]
                    },
                    {
                        action => 'glyphicon',
                        tag => 'div',
                        switch => 'trash',
                    }
                ],
            },
            expected => '<div class="well">...</div><div class="glyphicon glyphicon-search" aria-hidden="true"></div><div class="glyphicon glyphicon-home" aria-hidden="true"></div><div class="glyphicon glyphicon-trash" aria-hidden="true"></div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'well',
            args   => {
                data => '...',
                after_element => [
                    {
                        tag => 'div',
                        class => 'glyphicon glyphicon-search',
                        aria_hidden => 'true',
                    }
                ],
            },
            expected => '<div class="well">...</div><div class="glyphicon glyphicon-search" aria-hidden="true"></div>'
        }
    );

    dead_test(
        {
            class  => $class,
            action => 'well',
            args   => {
                data => '...',
                after_element => [
                    {
                        class => 'glyphicon glyphicon-search',
                        aria_hidden => 'true',
                    }
                ],
            },
            expected => qr/no instructions to build the element:/,
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

sub dead_test {
    my $args = shift;

    my $action = $args->{action};
    eval { $args->{class}->$action( $args->{args} // {} ) };
    my $error = $@;
    return like($error, $args->{expected}, "got expected $args->{expected}"); 
}

done_testing();
