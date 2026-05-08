program KK_driver
  implicit none
  !
  ! Simple program to compute Re[eps] from Im[eps] using the Kramers-Kronig transform.
  ! Reads output of e.g. epsTOT.dat from pw2gw.x from PWscf
  ! User supplies interactively the filename and a broadening (applied to eps1 and eps2).
  ! Input file must be two column (eV, eps2)
  ! To run via command line: echo "eps2.dat\n 0.5" | ./KK_driver.x
  !
  ! C.Hogan 2026 using antique F77 KK routine..!
  !
  integer, parameter  :: SP = selected_real_kind(14,200)
  integer, parameter  :: schlen=100, lchlen=300
  real(SP), parameter :: HA2EV     =27.2113834_SP        ! HA  = HA2EV eV
  real(SP), parameter :: pi=3.141592653589793238462643383279502884197_SP
  real(SP) :: bbroad 
  real(SP) :: bshift  = 0.0
  integer, parameter             :: un = 56
  !
  real(SP), allocatable:: e1(:),e2(:),hw(:)
  complex(SP), allocatable :: eps_b(:)
  character(lchlen) :: errmsg, bfile 
  logical                        :: ldum
  integer                        :: i, nw
  real(SP)                 :: ahalb, deb, fz, dum
  complex(SP)              :: eps, omega
  logical                  :: lerr2

! Read filename from standard input
  write(*,*) "=== Program Kramers-Kronig ==="
  write(*,*) "This simple program reads a two-column file (eV,eps2)"
  write(*,*) "and generates a file spectrum.dat (eV,eps1,eps2)." 

! Test for existence of output file
  inquire ( file = "spectrum.dat", exist = ldum) 
  if(ldum) then
    write(*,*) "WARNING: File spectrum.dat already exists and will be overwritten."
    endif
  write(*,*) 
  write(*,'(A)', advance='no') " => Filename containing epsilon2 data? (e.g. epsTOT.dat) : "
  read(*,'(A)') bfile
  write(*,'(A)', advance='no') " => Broadening (in eV)? (e.g. 0.1) : "
  read(*,*) bbroad
  bbroad = bbroad/HA2EV
  write(*,*) "-> Reading ",trim(bfile)," ..."
  write(*,'(a,f5.3,a)') " -> A broadening of ",bbroad*HA2EV," eV is applied to the output."

! Test for existence of input file
  inquire ( file = bfile, exist = ldum) 
  if(.not.ldum) then
    errmsg='Unable to find file '//trim(bfile)
    stop
  endif

! Open bulk file
  open ( un, file = trim(bfile), err=998)
  nw = 0

! Read number of lines
  do while(.true.)
    read(un,*,end=99)
    nw = nw + 1
  enddo
99  rewind(un)
  write(*,*) "-> File ",trim(bfile)," contains ",nw," records..."

!   Allocate internal storage arrays
    allocate( e2(nw), e1(nw), hw(nw), eps_b(nw) )

!   Read data

    do i = 1,nw
      read(un,*,err=999, end=999) hw(i),e2(i)
      hw(i) = hw(i)/HA2EV  ! convert hw to HARTREE
    enddo
    close(un)
    write(*,'(a,i5,a,f5.2,a,f5.2,a)') " -> Successfully read ",nw," lines of data in range [",&
&       hw(1)*HA2EV," - ",hw(nw)*HA2EV,"] eV ..."

!   Check the order of the columns
    if(any(e2.lt.0.0_SP)) then
       write(*,*) 'WARNING: epsilon2 has negative absorption! '//&
&                   'Check the column order/metallicity.'
    endif

    write(*,*) "-> Running Kramers Kronig transform..."
      !
      !  Do Kramig-Kroners transform to obtain e1
      !
      fz = 0.0
      deb = hw(2) - hw(1)
      ahalb=hw(1)-deb/2.0_SP
      eps_b(:) = 0
      do i = 1, nw
        omega = CMPLX(hw(i),bbroad) 
        call epsKK(omega,e2,hw,nw,ahalb,fz,eps,nw,lerr2)
        if (lerr2) then
          errmsg='Problem doing Kramers Kronig of resonant part.'
        endif
        eps_b(i) = eps_b(i) + eps
        omega = CMPLX(-hw(i),-bbroad) 
        call epsKK(omega,e2,hw,nw,ahalb,fz,eps,nw,lerr2)
        if (lerr2) then
          errmsg='Problem doing Kramers Kronig of anti-resonant part.'
        endif
        eps_b(i) = eps_b(i) + eps
      enddo
      write(*,*) "-> Kramers-Kronig transform complete..."
      !
      ! Add the missing 1 to real part.
      !
      forall(i=1:nw) eps_b(i) = eps_b(i)+1.0_SP
    !
    !  Dump the calculated epsilon to file
    !
    ! 
    open(unit=81,file = "spectrum.dat")
    do i = 1, nw
      write(81,102) hw(i)*HA2EV, real(eps_b(i)), AIMAG(eps_b(i))
    enddo
      write(*,*) "-> Written (hw,eps1,eps2) data to spectrum.dat."
102   format(f8.3,2f15.8)
    close(81)


    stop

103 format(a,i4,a,f5.2,a,f5.2,a,i5,a,f5.2,a,f5.2,a)
998 stop "Error opening file"
999 stop "Error reading file"

contains  

  subroutine epsKK(x,am,xp,n,a,fz,fc,nmax,lerr)
    implicit none
    logical,     intent(out) :: lerr
    integer,     intent(in)  :: n, nmax
    real(SP),    intent(in)  :: a, fz, xp(nmax), am(nmax)
    complex(SP), intent(in)  :: x
    complex(SP), intent(out) :: fc
!   Work space
    integer :: m, j
    real(SP) :: ev, e
    complex(SP) :: b, c, d, f, h

    lerr = .false.

    m = n - 1
    f = x - a
    ev = xp(1) - a
    if (ABS(ev).LT.1.E-10) then
       lerr = .true.
       return
    endif

    b = log(1.0_SP - ev/f)
    fc = fz * (-1.0_SP + log((xp(1) - x)/(a-x)) * (xp(1) - x)/ev)

    do j = 1, m
       e = xp(j+1) - xp(j)
       d = xp(j+1) - x
       h = x - xp(j)
       c = log(1.0_SP-e/h)
       fc = fc + am(j)*( c*d/e + b*f/ev )
       b = c
       f = h
       ev = e
    enddo
    fc = fc + am(n) * (1.0_SP + b*f/ev)
    fc = fc/pi
    return
  end subroutine epsKK

  subroutine clean_bulkeps
    implicit none
    if(allocated(e1)) deallocate(e1)
    if(allocated(e2)) deallocate(e2)
    if(allocated(hw)) deallocate(hw)
    return
  end subroutine clean_bulkeps

  subroutine shift_bulkeps
    implicit none
    integer                  :: i
    do i = 1, nw
      hw(i) = hw(i) + bshift
    enddo
    return
  end subroutine shift_bulkeps

end program
