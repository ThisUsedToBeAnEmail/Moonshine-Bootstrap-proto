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
            class    => $class,
            action   => 'jumbotron',
            args     => {},
            expected => '<div class="jumbotron"></div>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'jumbotron',
            args   => { full_width => 1 },
            expected =>
              '<div class="jumbotron"><div class="container"></div></div>'
        }
    );

    # all the could.......TODOs
    component_test(
        {
            class  => $class,
            action => 'jumbotron',
            args   => {
                items => [
                    {
                        action => 'h1',
                        data   => 'Hello, world!',
                    },
                    {
                        action => 'p',
                        data   => 'yoooo',
                    },
                    {
                        action => 'button',
                        tag    => 'a',
                        sizing => 'lg',
                        href   => '#',
                        role   => 'button',
                        data   => 'Learn more',
                        switch => 'primary'
                    },
                ],
            },
            expected =>
'<div class="jumbotron"><h1>Hello, world!</h1><p>yoooo</p><a class="btn btn-primary btn-lg" href="#" type="button" role="button">Learn more</a></div>',
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
