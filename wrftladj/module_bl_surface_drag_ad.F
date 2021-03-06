!        Generated by TAPENADE     (INRIA, Tropics team)
!  Tapenade 3.7 (r4786) - 21 Feb 2013 15:53
!
!  Differentiation of surface_drag in reverse (adjoint) mode (with options r8):
!   gradient     of useful results: v_phy rublten z rvblten u_phy
!   with respect to varying inputs: v_phy rublten z rvblten u_phy
!-------------------------------------------------------------------
!WRF:MODEL_LAYER:PHYSICS
MODULE a_module_bl_surface_drag
CONTAINS
SUBROUTINE SURFACE_DRAG_B(rublten, rubltenb, rvblten, rvbltenb, u_phy, &
&  u_phyb, v_phy, v_phyb, xland, z, zb, ht, kpbl2d, ids, ide, jds, jde, &
&  kds, kde, ims, ime, jms, jme, kms, kme, its, ite, jts, jte, kts, kte)
  IMPLICIT NONE
  INTEGER, INTENT(IN) :: ids, ide, jds, jde, kds, kde, ims, ime, jms, &
&  jme, kms, kme, its, ite, jts, jte, kts, kte
  INTEGER, DIMENSION(ims:ime, jms:jme), INTENT(OUT) :: kpbl2d
  REAL, DIMENSION(ims:ime, kms:kme, jms:jme), INTENT(INOUT) :: rublten, &
&  rvblten
  REAL, DIMENSION(ims:ime, kms:kme, jms:jme), INTENT(INOUT) :: rubltenb
  REAL, DIMENSION(ims:ime, kms:kme, jms:jme), INTENT(IN) :: u_phy, v_phy&
&  , z
  REAL, DIMENSION(ims:ime, kms:kme, jms:jme) :: u_phyb, v_phyb, zb
  REAL, DIMENSION(ims:ime, jms:jme), INTENT(IN) :: xland, ht
! Local
  REAL :: v0, tao_xz, tao_yz, cd, zh, zwt
  REAL :: v0b, tao_xzb, tao_yzb, cdb, zhb, zwtb
  INTEGER :: i, j, i_start, i_end, i_endu, j_start, j_end, j_endv, k
  INTEGER :: branch
  REAL, DIMENSION(ims:ime, kms:kme, jms:jme), INTENT(INOUT) :: rvbltenb
  REAL :: tempb2
  REAL :: tempb1
  REAL :: tempb0
  REAL :: tempb
  REAL :: abs1
  REAL :: abs0
! End declarations.
!-----------------------------------------------------------------------
  i_start = its
  IF (ite .GT. ide - 1) THEN
    i_end = ide - 1
  ELSE
    i_end = ite
  END IF
  i_endu = ite
  j_start = jts
  IF (jte .GT. jde - 1) THEN
    j_end = jde - 1
  ELSE
    j_end = jte
  END IF
  j_endv = jte
  DO j=j_start,j_end
    DO i=i_start,i_endu
      CALL PUSHREAL8(v0)
      v0 = SQRT(u_phy(i, kts, j)**2 + v_phy(i, kts, j)**2)
      IF (xland(i, j) - xland(i-1, j) .GE. 0.) THEN
        abs0 = xland(i, j) - xland(i-1, j)
      ELSE
        abs0 = -(xland(i, j)-xland(i-1, j))
      END IF
      IF (abs0 .LT. 1.0e-10) THEN
        IF (xland(i, j) .LT. 1.5) THEN
          CALL PUSHREAL8(cd)
! land
          cd = 0.01
          CALL PUSHCONTROL2B(0)
        ELSE
          CALL PUSHREAL8(cd)
! water
          cd = 0.001
          IF (cd .LT. 1.e-4*v0) THEN
            cd = 1.e-4*v0
            CALL PUSHCONTROL1B(0)
          ELSE
            CALL PUSHCONTROL1B(1)
            cd = cd
          END IF
          IF (cd .GT. 0.003) THEN
            cd = 0.003
            CALL PUSHCONTROL2B(3)
          ELSE
            CALL PUSHCONTROL2B(2)
            cd = cd
          END IF
        END IF
      ELSE
        CALL PUSHREAL8(cd)
! coast
        cd = 0.003
        CALL PUSHCONTROL2B(1)
      END IF
      CALL PUSHREAL8(tao_xz)
      tao_xz = cd*v0*u_phy(i, kts, j)
      DO k=kts,kte
        zh = z(i, k, j) - ht(i, j)
        IF (zh .LT. 1000.) THEN
          CALL PUSHCONTROL1B(1)
        ELSE
          CALL PUSHCONTROL1B(0)
        END IF
      END DO
    END DO
  END DO
!
  DO j=j_start,j_endv
    DO i=i_start,i_end
      CALL PUSHREAL8(v0)
      v0 = SQRT(u_phy(i, kts, j)**2 + v_phy(i, kts, j)**2)
      IF (xland(i, j) - xland(i, j-1) .GE. 0.) THEN
        abs1 = xland(i, j) - xland(i, j-1)
      ELSE
        abs1 = -(xland(i, j)-xland(i, j-1))
      END IF
      IF (abs1 .LT. 1.0e-10) THEN
        IF (xland(i, j) .LT. 1.5) THEN
          CALL PUSHREAL8(cd)
! land
          cd = 0.01
          CALL PUSHCONTROL2B(0)
        ELSE
          CALL PUSHREAL8(cd)
! water
          cd = 0.001
          IF (cd .LT. 1.e-4*v0) THEN
            cd = 1.e-4*v0
            CALL PUSHCONTROL1B(0)
          ELSE
            CALL PUSHCONTROL1B(1)
            cd = cd
          END IF
          IF (cd .GT. 0.003) THEN
            cd = 0.003
            CALL PUSHCONTROL2B(3)
          ELSE
            CALL PUSHCONTROL2B(2)
            cd = cd
          END IF
        END IF
      ELSE
        CALL PUSHREAL8(cd)
! coast
        cd = 0.003
        CALL PUSHCONTROL2B(1)
      END IF
      CALL PUSHREAL8(tao_yz)
      tao_yz = cd*v0*v_phy(i, kts, j)
      DO k=kts,kte
        zh = z(i, k, j) - ht(i, j)
        IF (zh .LT. 1000.) THEN
          CALL PUSHCONTROL1B(1)
        ELSE
          CALL PUSHCONTROL1B(0)
        END IF
      END DO
    END DO
  END DO
  DO j=j_endv,j_start,-1
    DO i=i_end,i_start,-1
      tao_yzb = 0.0_8
      DO k=kte,kts,-1
        CALL POPCONTROL1B(branch)
        IF (branch .EQ. 0) THEN
          zhb = 0.0_8
        ELSE
          zh = z(i, k, j) - ht(i, j)
          zwt = 2.*(1000.-zh)/1000.
          zwtb = -(tao_yz*0.5*rvbltenb(i, k, j)/1000.)
          tao_yzb = tao_yzb - 0.5*zwt*rvbltenb(i, k, j)/1000.
          zhb = -(2.*zwtb/1000.)
        END IF
        zb(i, k, j) = zb(i, k, j) + zhb
      END DO
      CALL POPREAL8(tao_yz)
      tempb2 = v_phy(i, kts, j)*tao_yzb
      cdb = v0*tempb2
      v0b = cd*tempb2
      v_phyb(i, kts, j) = v_phyb(i, kts, j) + cd*v0*tao_yzb
      CALL POPCONTROL2B(branch)
      IF (branch .LT. 2) THEN
        IF (branch .EQ. 0) THEN
          CALL POPREAL8(cd)
        ELSE
          CALL POPREAL8(cd)
        END IF
      ELSE
        IF (branch .NE. 2) cdb = 0.0_8
        CALL POPCONTROL1B(branch)
        IF (branch .EQ. 0) v0b = v0b + 1.e-4*cdb
        CALL POPREAL8(cd)
      END IF
      CALL POPREAL8(v0)
      IF (u_phy(i, kts, j)**2 + v_phy(i, kts, j)**2 .EQ. 0.0_8) THEN
        tempb1 = 0.0
      ELSE
        tempb1 = v0b/(2.0*SQRT(u_phy(i, kts, j)**2+v_phy(i, kts, j)**2))
      END IF
      u_phyb(i, kts, j) = u_phyb(i, kts, j) + 2*u_phy(i, kts, j)*tempb1
      v_phyb(i, kts, j) = v_phyb(i, kts, j) + 2*v_phy(i, kts, j)*tempb1
    END DO
  END DO
  DO j=j_end,j_start,-1
    DO i=i_endu,i_start,-1
      tao_xzb = 0.0_8
      DO k=kte,kts,-1
        CALL POPCONTROL1B(branch)
        IF (branch .EQ. 0) THEN
          zhb = 0.0_8
        ELSE
          zh = z(i, k, j) - ht(i, j)
          zwt = 2.*(1000.-zh)/1000.
          zwtb = -(tao_xz*0.5*rubltenb(i, k, j)/1000.)
          tao_xzb = tao_xzb - 0.5*zwt*rubltenb(i, k, j)/1000.
          zhb = -(2.*zwtb/1000.)
        END IF
        zb(i, k, j) = zb(i, k, j) + zhb
      END DO
      CALL POPREAL8(tao_xz)
      tempb0 = u_phy(i, kts, j)*tao_xzb
      cdb = v0*tempb0
      v0b = cd*tempb0
      u_phyb(i, kts, j) = u_phyb(i, kts, j) + cd*v0*tao_xzb
      CALL POPCONTROL2B(branch)
      IF (branch .LT. 2) THEN
        IF (branch .EQ. 0) THEN
          CALL POPREAL8(cd)
        ELSE
          CALL POPREAL8(cd)
        END IF
      ELSE
        IF (branch .NE. 2) cdb = 0.0_8
        CALL POPCONTROL1B(branch)
        IF (branch .EQ. 0) v0b = v0b + 1.e-4*cdb
        CALL POPREAL8(cd)
      END IF
      CALL POPREAL8(v0)
      IF (u_phy(i, kts, j)**2 + v_phy(i, kts, j)**2 .EQ. 0.0_8) THEN
        tempb = 0.0
      ELSE
        tempb = v0b/(2.0*SQRT(u_phy(i, kts, j)**2+v_phy(i, kts, j)**2))
      END IF
      u_phyb(i, kts, j) = u_phyb(i, kts, j) + 2*u_phy(i, kts, j)*tempb
      v_phyb(i, kts, j) = v_phyb(i, kts, j) + 2*v_phy(i, kts, j)*tempb
    END DO
  END DO
END SUBROUTINE SURFACE_DRAG_B

!        Generated by TAPENADE     (INRIA, Tropics team)
!  Tapenade 3.6 (r4343) - 10 Feb 2012 10:52
!
!  Differentiation of surface_drag_init in reverse (adjoint) mode:
!   gradient     of useful results: rublten rqvblten rvblten rthblten
!   with respect to varying inputs: rublten rqvblten rvblten rthblten
SUBROUTINE SURFACE_DRAG_INIT_B(rublten, rubltenb, rvblten, rvbltenb, &
&  rthblten, rthbltenb, rqvblten, rqvbltenb, restart, ids, ide, jds, jde&
&  , kds, kde, ims, ime, jms, jme, kms, kme, its, ite, jts, jte, kts, kte&
&)
  IMPLICIT NONE
!-------------------------------------------------------------------
  LOGICAL, INTENT(IN) :: restart
  INTEGER, INTENT(IN) :: ids, ide, jds, jde, kds, kde, ims, ime, jms, &
&  jme, kms, kme, its, ite, jts, jte, kts, kte
  REAL, DIMENSION(ims:ime, kms:kme, jms:jme) :: rublten, rvblten, &
&  rthblten, rqvblten
  REAL, DIMENSION(ims:ime, kms:kme, jms:jme) :: rubltenb, rvbltenb, &
&  rthbltenb, rqvbltenb
  INTEGER :: i, j, k, itf, jtf, ktf
  INTRINSIC MIN0
  IF (jte .GT. jde - 1) THEN
    jtf = jde - 1
  ELSE
    jtf = jte
  END IF
  IF (kte .GT. kde - 1) THEN
    ktf = kde - 1
  ELSE
    ktf = kte
  END IF
  IF (ite .GT. ide - 1) THEN
    itf = ide - 1
  ELSE
    itf = ite
  END IF
  IF (.NOT.restart) THEN
    DO j=jtf,jts,-1
      DO k=ktf,kts,-1
        DO i=itf,its,-1
          rqvbltenb(i, k, j) = 0.0
          rthbltenb(i, k, j) = 0.0
          rvbltenb(i, k, j) = 0.0
          rubltenb(i, k, j) = 0.0
        END DO
      END DO
    END DO
  END IF
END SUBROUTINE SURFACE_DRAG_INIT_B

END MODULE a_module_bl_surface_drag
