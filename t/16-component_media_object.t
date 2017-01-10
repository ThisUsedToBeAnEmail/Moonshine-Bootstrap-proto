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
            action => 'media_link_img',
            args   => {
                href => '#',
                img  => { src => 'url', alt => 'alt text' },
            },
            expected =>
'<a href="#"><img alt="alt text" class="media-object" src="url"></img></a>'
        }
    );

    component_test(
        {
            class  => $class,
            action => 'media_object',
            args   => {
                y     => 'top',
                x     => 'left',
                items => [
                    {
                        action => 'media_link_img',
                        href   => "#",
                        img    => { src => 'url', alt => 'alt text' },
                    }
                ],
            },
            expected =>
'<div class="media-left media-top"><a href="#"><img alt="alt text" class="media-object" src="url"></img></a></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'media_object',
            args   => {
                body  => 1,
                items => [
                    {
                        action => 'h4',
                        class  => 'media-heading',
                        data   => "Middle aligned media",
                    }
                ],
            },
            expected =>
'<div class="media-body"><h4 class="media-heading">Middle aligned media</h4></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'media',
            args   => {
                items => [
                    {
                        action => 'media_object',
                        x      => 'left',
                        y      => 'middle',
                        items  => [
                            {
                                action => 'media_link_img',
                                href   => "#",
                                img    => { src => 'url', alt => 'alt text' },
                            }
                        ],
                    },
                    {
                        action => 'media_object',
                        body   => 1,
                        items  => [
                            {
                                action => 'h4',
                                class  => 'media-heading',
                                data   => "Middle aligned media",
                            }
                        ],
                    }
                ],
            },
            expected =>
'<div class="media"><div class="media-left media-middle"><a href="#"><img alt="alt text" class="media-object" src="url"></img></a></div><div class="media-body"><h4 class="media-heading">Middle aligned media</h4></div></div>'
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
