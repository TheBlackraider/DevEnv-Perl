
FROM blackraider/devenv-base 

MAINTAINER blackraider <er.blacky@gmail.com>

USER root

RUN pacman-key --refresh-keys

RUN pacman -Syu --noconfirm
RUN pacman-db-upgrade

RUN pacman -S --noconfirm perl perl-cpanplus perl-local-lib 

USER developer
WORKDIR /home/developer

RUN perl -MCPAN -Mlocal::lib -e 'CPAN::install(LWP)'
RUN echo eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)" >> ~/.zshrc
RUN source ~/.zshrc


RUN curl -L https://cpanmin.us | perl - App::cpanminus

RUN curl -L https://install.perlbrew.pl | sh
RUN echo source ~/perl5/perlbrew/etc/bashrc >> ~/.zshrc
RUN . ./.zshrc

RUN ~/perl5/perlbrew/bin/perlbrew install perl-5.24.0 
RUN ~/perl5/perlbrew/bin/perlbrew use perl-5.24.0

RUN mkdir -p /home/developer/projects/perl
RUN mkdir -p /home/developer/projects/mojolicious

RUN ~/perl5/bin/cpanm Task::Kensho Data::Dumper Data::Dump List::Util List::MoreUtils Scalar::Util File::Spec Path::Class File::Find File::Basename File::Slurp File::Temp File::HomeDir File::Wich File::Copy File::Path

VOLUME /home/developer/projects/perl

EXPOSE 3000 80 8080
