import Sound
import lean_certs.cert_33_78

open CertVerify

theorem H33_gt_78 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 33) (d := 78) (c := cert_33_78) (by native_decide)
