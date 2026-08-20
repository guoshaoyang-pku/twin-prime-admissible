import Sound
import lean_certs.cert_27_110

open CertVerify

theorem H27_gt_110 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 27) (d := 110) (c := cert_27_110) (by native_decide)
