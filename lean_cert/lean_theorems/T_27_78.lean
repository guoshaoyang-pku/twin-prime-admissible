import Sound
import lean_certs.cert_27_78

open CertVerify

theorem H27_gt_78 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 27) (d := 78) (c := cert_27_78) (by native_decide)
